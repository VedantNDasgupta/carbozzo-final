import 'dart:async';
import 'dart:math';

import 'package:carbozzo/pages/game_pages/piece.dart';
import 'package:carbozzo/pages/game_pages/pixel.dart';
import 'package:carbozzo/pages/game_pages/values.dart';
import 'package:flutter/material.dart';

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
  bool gameOver = false;
  int piecesGenerated = 0;
  late Timer _gameLoopTimer;
  int frameRate = 300; // Initial frame rate

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    _gameLoopTimer = Timer.periodic(Duration(milliseconds: frameRate), (timer) {
      setState(() {
        clearLines();
        checkLanding();
        if (gameOver) {
          timer.cancel();
          showGameOverDialog();
        }

        currentPiece.movePiece(Direction.down);
        checkPopup(); // Check if a popup should be shown after every move
      });
    });
  }

  @override
  void dispose() {
    _gameLoopTimer.cancel();
    super.dispose();
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Your score is: $currentScore'),
        actions: [
          TextButton(
            onPressed: () {
              resetGame();
              Navigator.pop(context);
            },
            child: const Text('Play Again'),
          )
        ],
      ),
    );
  }

  void resetGame() {
    _gameLoopTimer.cancel();
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

      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }

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

    piecesGenerated++; // Increment the count of generated pieces

    if (isGameOver()) {
      gameOver = true;
      startGame();
    }

    checkPopup(); // Check if a popup should be shown after generating a new piece
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

  void checkPopup() {
    if (piecesGenerated > 0 && piecesGenerated % 5 == 0) {
      showPopup();
    }
  }

  void showPopup() {
    _gameLoopTimer.cancel(); // Pause the game loop timer
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (context) => AlertDialog(
        title: Text('Your question here'),
        content: Text('Your content here'),
        actions: [
          TextButton(
            onPressed: () {
              handlePopupResponse(true);
              Navigator.pop(context);
            },
            child: Text('Correct'),
          ),
          TextButton(
            onPressed: () {
              handlePopupResponse(false);
              Navigator.pop(context);
            },
            child: Text('Incorrect'),
          ),
        ],
      ),
    );
  }

  void handlePopupResponse(bool isCorrect) {
    // Handle the user's response
    if (isCorrect) {
      frameRate += 50; // Increase frame rate for correct answer
    } else {
      frameRate -= 50; // Decrease frame rate for incorrect answer
    }

    // Ensure the frame rate stays within reasonable bounds
    frameRate = frameRate.clamp(50, 1000);

    // Dismiss the popup
    Navigator.pop(context);
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
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowLength,
              ),
              itemBuilder: (context, index) {
                int row = (index / rowLength).floor();
                int col = index % rowLength;

                if (currentPiece.position.contains(index)) {
                  return Pixel(
                    color: currentPiece.color,
                  );
                } else {
                  final Tetranimo? tetranimoType = gameBoard[row][col];
                  if (tetranimoType != null) {
                    return Pixel(
                      color: tetranimoColors[tetranimoType],
                    );
                  } else {
                    return Pixel(
                      color: Colors.grey[900],
                    );
                  }
                }
              },
            ),
          ),
          Text(
            'Score: $currentScore',
            style: TextStyle(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: moveLeft,
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back_ios),
                ),
                IconButton(
                  onPressed: rotatePiece,
                  color: Colors.white,
                  icon: Icon(Icons.rotate_right),
                ),
                IconButton(
                  onPressed: moveRight,
                  color: Colors.white,
                  icon: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
