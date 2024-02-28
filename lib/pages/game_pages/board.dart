import 'dart:async';
import 'dart:math';

import 'package:carbozzo/pages/game_pages/piece.dart';
import 'package:carbozzo/pages/game_pages/pixel.dart';
import 'package:carbozzo/pages/game_pages/quiz_data.dart';
import 'package:carbozzo/pages/game_pages/values.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

List<List<Tetranimo?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Piece currentPiece = Piece(type: Tetranimo.L);
  int currentScore = 0;
  int pieceCollisionCount = 0;
  bool gameOver = false;
  bool showButtons = false;
  int currentQuestionIndex = 0;

  Timer? _gameLoopTimer; // Declare a Timer variable
  Timer?
      _buttonVisibilityTimer; // Declare a Timer variable for controlling button visibility

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    if (_gameLoopTimer == null || !_gameLoopTimer!.isActive) {
      const Duration frameRate = Duration(milliseconds: 500);
      _gameLoopTimer = Timer.periodic(frameRate, (timer) {
        setState(() {
          clearLines();
          checkLanding();
          if (gameOver) {
            timer.cancel();
            showGameOverDialog();
          }

          currentPiece.movePiece(Direction.down);

          // Increment collision count and check if it's a multiple of 5
          pieceCollisionCount++;
          if (pieceCollisionCount % 25 == 0) {
            showButtons = true;
          } else if (pieceCollisionCount % 45 == 0) {
            showButtons = false;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _gameLoopTimer?.cancel(); // Cancel the timer in dispose
    _buttonVisibilityTimer
        ?.cancel(); // Cancel the button visibility timer in dispose
    super.dispose();
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'GAME OVER',
          textAlign: TextAlign.center,
          style: GoogleFonts.pressStart2p(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your score is: \n\n$currentScore',
              textAlign: TextAlign.center,
              style: GoogleFonts.pressStart2p(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'PressStart2P',
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                resetGame();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                elevation: 6,
              ),
              child: Text(
                'Play Again',
                textAlign: TextAlign.center,
                style: GoogleFonts.pressStart2p(
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontFamily: 'PressStart2P',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetGame() {
    _gameLoopTimer?.cancel(); // Cancel the timer if it's active
    _buttonVisibilityTimer
        ?.cancel(); // Cancel the button visibility timer if it's active
    gameBoard = List.generate(
      colLength,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    );

    gameOver = false;
    currentScore = 0;

    createNewPiece();
    startGame();
  }

  bool checkCollision(Direction direction) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      // Calculate the next position based on the direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      // Check if the next position is out of bounds
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }

      // Check if the next position is already occupied on the game board
      if (row >= 0 && gameBoard[row][col] != null) {
        return true;
      }
    }

    return false;
  }

  void checkLanding() {
    if (checkCollision(Direction.down)) {
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      createNewPiece();
    }
  }

  void createNewPiece() {
    Random rand = Random();
    Tetranimo randomType =
        Tetranimo.values[rand.nextInt(Tetranimo.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();

    if (isGameOver()) {
      gameOver = true;
      startGame();
    }
  }

  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  void clearLines() {
    for (int row = colLength - 1; row >= 0; row--) {
      bool rowIsFull = true;
      for (int col = 0; col < rowLength; col++) {
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }
      if (rowIsFull) {
        for (int r = row; r > 0; r--) {
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }
        gameBoard[0] = List.generate(rowLength, (index) => null);

        currentScore++;
      }
    }
  }

  bool isGameOver() {
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
                itemCount: rowLength * colLength,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowLength,
                ),
                itemBuilder: (context, index) {
                  int row = (index / rowLength).floor();
                  int col = index % rowLength;

                  if (currentPiece.position.contains(index)) {
                    return Pixel(
                      color: currentPiece.color, // Color of the current piece
                    );
                  } else {
                    final Tetranimo? tetranimoType = gameBoard[row][col];
                    if (tetranimoType != null) {
                      return Pixel(
                        color: tetranimoColors[
                            tetranimoType], // Color based on the piece type
                      );
                    } else {
                      return Pixel(
                        color: Colors.white12,
                      );
                    }
                  }
                }),
          ),
          Visibility(
            visible: showButtons,
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    quizData[currentQuestionIndex].question,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.pressStart2p(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentScore += 5;
                          showButtons = false; // Hide buttons when pressed
                          currentQuestionIndex =
                              (currentQuestionIndex + 1) % quizData.length;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(6.0, 6.0),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            quizData[currentQuestionIndex].options[0],
                            style: GoogleFonts.pressStart2p(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 12, // Adjust font size as needed
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentScore = max(0, currentScore - 5);
                          showButtons = false; // Hide buttons when pressed
                          currentQuestionIndex =
                              (currentQuestionIndex + 1) % quizData.length;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(6.0, 6.0),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            quizData[currentQuestionIndex].options[1],
                            style: GoogleFonts.pressStart2p(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 12, // Change the font size as needed
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Text(
            'Score: $currentScore',
            style: GoogleFonts.pressStart2p(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 18, // Change the font size as needed
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: moveLeft,
                  child: Container(
                    height: 50,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(6.0, 6.0),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: rotatePiece,
                  child: Container(
                    height: 50,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(6.0, 6.0),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.rotate_right,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: moveRight,
                  child: Container(
                    height: 50,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(6.0, 6.0),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
