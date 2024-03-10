import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class HowScreen extends StatefulWidget {
  const HowScreen({Key? key}) : super(key: key);

  @override
  _HowScreenState createState() => _HowScreenState();
}

class _HowScreenState extends State<HowScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _colorAnimation =
        ColorTween(begin: Colors.red, end: Colors.green).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 30, right: 14, left: 14),
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'lib/images/minigame.png',
                  width: 1000,
                  height: 350,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: AnimatedBuilder(
                  animation: _colorAnimation,
                  builder: (context, child) {
                    return Text(
                      'Tetra Sustaina',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.pressStart2p(
                        textStyle: TextStyle(
                          fontSize: 23,
                          color: _colorAnimation.value,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Guide:',
                    style: GoogleFonts.pressStart2p(
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text('How to Play',
                      style: GoogleFonts.pressStart2p(
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 0.3,
                decoration: BoxDecoration(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'Classic Tetris',
                style: GoogleFonts.pressStart2p(
                  fontSize: 21,
                  color: Colors.amber,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Remember the time when you enjoyed the classic fan-favorite game of Tetris at your local arcade, while being surrounded by excited friends? \nTake a trip down memory lane, as you dive deep into setting the blocks right, but with an eco-friendly twist this time. Are you quick enough to make the blocks vanish in thin air?',
                style: GoogleFonts.pressStart2p(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 0.3,
                decoration: BoxDecoration(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'Sustainable Wisdom',
                style: GoogleFonts.pressStart2p(
                  fontSize: 21,
                  color: Colors.amber,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'As you play your sweet game of Tetris, you will be bombarded with hot questions that will challenge your knowledge about sustainability and the environment. Each correct answer rewards you with 5 extra points, while wrong ones punish you. Can you flex your green wisdom?',
                style: GoogleFonts.pressStart2p(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 0.3,
                decoration: BoxDecoration(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'Beat the High Scores!',
                style: GoogleFonts.pressStart2p(
                  fontSize: 21,
                  color: Colors.amber,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Set new high scores and try to beat them, as your enjoy your classic retro arcade version of Tetris, combined with side-questions that test your knowledge about sustainability. Are you the best player in town?',
                style: GoogleFonts.pressStart2p(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            Icons.check,
            color: Colors.green,
            size: 20,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.pressStart2p(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
