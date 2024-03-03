import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class HowScreen extends StatelessWidget {
  const HowScreen({Key? key}) : super(key: key);

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
                  'lib/images/guidebanner.png',
                  width: 1000,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text('Tetra Sustaina',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.pressStart2p(
                      textStyle: TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    )),
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
              //seperation effect
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
                'Tasks & Sharing',
                style: GoogleFonts.pressStart2p(
                  fontSize: 21,
                  color: Colors.amber,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'You can use the Home Screen to browse through the categories of green tasks. Once you complete a green task in real life, simply tap the category of that task and click an image proof of the same. Submit the image to your partner for cross-verification.',
                style: GoogleFonts.pressStart2p(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'lib/images/homeshare.png',
                  width: 500,
                  height: 300, // Adjust the height as needed
                  fit: BoxFit.cover,
                ),
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
                'Inspiration and Rewards',
                style: GoogleFonts.pressStart2p(
                  fontSize: 21,
                  color: Colors.amber,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Check the Inspiration Page to know more about your task categories. Keep a record of your progress in the Carbo Roadmap to unlock new and exciting rewards. Browse through the various insightful stats to discover the goodness you are adding to the environment through Carbozzo.',
                style: GoogleFonts.pressStart2p(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'lib/images/carbomapinspi.png',
                  width: 500,
                  height: 300,
                  fit: BoxFit.cover,
                ),
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
                'Community and Profile',
                style: GoogleFonts.pressStart2p(
                  fontSize: 21,
                  color: Colors.amber,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Check the Community tab to discover Environmental NGOs and local organisations around you. Read their brochures and join the ones whose initiatives allign with your actions. Tinker with your username and avatar in the Profile Page and optimise the settings as per your needs.',
                style: GoogleFonts.pressStart2p(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'lib/images/communityprofile.png',
                  width: 500,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),

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
