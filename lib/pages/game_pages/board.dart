import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:carbozzo/pages/game_pages/piece.dart';
import 'package:carbozzo/pages/game_pages/pixel.dart';
import 'package:carbozzo/pages/game_pages/quiz_data.dart';
import 'package:carbozzo/pages/game_pages/values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shake/shake.dart';

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
  bool showRedOverlay = false;

  Timer? _gameLoopTimer;
  Timer? _buttonVisibilityTimer;
  late AudioPlayer audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    startGame();

    audioPlayer = AudioPlayer();
    playBackgroundMusic();
  }

  @override
  void dispose() {
    _gameLoopTimer?.cancel(); // Cancel the timer in dispose
    _buttonVisibilityTimer
        ?.cancel(); // Cancel the button visibility timer in dispose
    audioPlayer.dispose();
    super.dispose();
  }

  void playBackgroundMusic() async {
    await audioPlayer.setSource(AssetSource('audio/neon.mp3'));
    await audioPlayer.setVolume(9);
    await audioPlayer.resume();
  }

  void shakeScreen() {
    // Perform the screen shake effect here
    HapticFeedback.vibrate();
  }

  // Method to display a red overlay across the entire screen for a split second
  void flashRedOverlay() {
    setState(() {
      showRedOverlay = true; // Set flag to true to show red overlay
    });

    // Revert back to original state after a split second
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        showRedOverlay = false; // Set flag to false to hide red overlay
      });
    });
  }

  void stopBackgroundMusic() async {
    await audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  void startGame() {
    currentPiece.initializePiece();

    if (_gameLoopTimer == null || !_gameLoopTimer!.isActive) {
      const Duration initialFrameRate = Duration(milliseconds: 500);
      const double frameRateDecrement = 0.1;
      const Duration minFrameRate = Duration(milliseconds: 100);

      _gameLoopTimer = Timer.periodic(initialFrameRate, (timer) {
        setState(() {
          clearLines();
          checkLanding();
          if (gameOver) {
            timer.cancel();
            showGameOverDialog();
          }

          currentPiece.movePiece(Direction.down);

          pieceCollisionCount++;
          if (pieceCollisionCount % 25 == 0) {
            showButtons = true;
          } else if (pieceCollisionCount % 45 == 0) {
            showButtons = false;
          }

          if (timer.tick % 100 == 0) {
            Duration newFrameRate = Duration(
              milliseconds:
                  (initialFrameRate.inMilliseconds * (1 - frameRateDecrement))
                      .toInt(),
            );
            _gameLoopTimer!.cancel();
            if (newFrameRate < minFrameRate) {
              newFrameRate = minFrameRate;
            }
            _gameLoopTimer = Timer.periodic(newFrameRate, (timer) {
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
        });
      });
    }
  }

  void showGameOverDialog() {
    writeToFirestore();
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
    _gameLoopTimer?.cancel();
    _buttonVisibilityTimer?.cancel();
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
      writeToFirestore();
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

  //now we update the score in firebase

  void writeToFirestore() async {
    try {
      final user = FirebaseAuth.instance
          .currentUser; // Assuming you're using Firebase Authentication

      if (user != null) {
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Check if the document exists
        final docSnapshot = await userDoc.get();
        if (docSnapshot.exists) {
          final currentScoreInFirestore = docSnapshot.get('score') ?? 0;

          // Ensure currentScore is of type int
          if (currentScore is int) {
            // Update the 'Score' field only if currentScore is higher
            if (currentScore > currentScoreInFirestore) {
              await userDoc.update({
                'score': currentScore,
              });
              print('Score updated successfully!');
            } else {
              print(
                  'Current score is not higher than the existing score in Firestore.');
            }
          } else {
            print('Current score is not of type int.');
          }
        } else {
          // Document doesn't exist, create it with the 'Score' field
          await userDoc.set({
            'score': currentScore,
          });
          print('New document created with Score field!');
        }
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error writing score to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: showRedOverlay ? 1.0 : 0.0, // Show/hide the red overlay
              duration: Duration(milliseconds: 300), // Animation duration
              child: Container(
                color: Colors.red.withOpacity(1), // Red background color
              ),
            ),
          ),
          Column(
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
                          color:
                              currentPiece.color, // Color of the current piece
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
                              if (quizData[currentQuestionIndex]
                                      .correctOptionIndex ==
                                  0) {
                                currentScore +=
                                    5; // Increase score if correct option selected
                              } else {
                                currentScore = max(0, currentScore - 5);
                                shakeScreen(); // Decrease score if incorrect option selected
                                flashRedOverlay();
                              }
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
                              if (quizData[currentQuestionIndex]
                                      .correctOptionIndex ==
                                  1) {
                                currentScore +=
                                    5; // Increase score if correct option selected
                              } else {
                                currentScore = max(0, currentScore - 5);
                                shakeScreen(); // Decrease score if incorrect option selected
                                flashRedOverlay();
                              }
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
                                    fontSize: 12,
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
        ],
      ),
    );
  }
}
