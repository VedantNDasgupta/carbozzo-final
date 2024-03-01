import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carbozzo/pages/game_pages/settings.dart';
import 'package:carbozzo/pages/game_pages/board.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    playBackgroundMusic();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void playBackgroundMusic() async {
    await audioPlayer.setSource(AssetSource('audio/neon.mp3'));
    await audioPlayer.setVolume(9);
    await audioPlayer.resume();
  }

  void stopBackgroundMusic() async {
    await audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF000033),
              Color(0xFFCC00FF),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Tetra\nSustaina',
                textAlign: TextAlign.center,
                style: GoogleFonts.pressStart2p(
                  textStyle: TextStyle(
                    fontSize: 45,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              GestureDetector(
                onTap: () {
                  stopBackgroundMusic();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameBoard()),
                  );
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(6, 6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Text(
                    'Start Game',
                    style: GoogleFonts.pressStart2p(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  // Navigate to game guide screen
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(6, 6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Text(
                    'How to Play',
                    style: GoogleFonts.pressStart2p(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(6, 6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Text(
                    'Settings',
                    style: GoogleFonts.pressStart2p(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(6, 6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Text(
                    'Quit Game',
                    style: GoogleFonts.pressStart2p(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
