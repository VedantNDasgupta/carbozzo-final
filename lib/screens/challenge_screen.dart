// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class ChallengeScreen extends StatelessWidget {
  ChallengeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(198, 40, 40, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(198, 40, 40, 1),
          elevation: 10,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Ionicons.chevron_back,
              color: Colors.white,
            ),
          ),
          toolbarHeight: 30, // Adjust the height as needed
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: SizedBox(),
          ),
        ),
        body: Container(
          padding:
              const EdgeInsets.only(top: 30, right: 14, left: 14, bottom: 120),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(30), // Adjust the radius as needed
                  child: Image.asset(
                    'lib/images/challenge_visual.png', // Replace with the actual image path
                    width: 1000, // Adjust the width as needed
                    height: 200, // Adjust the height as needed
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'The 30 Days Saviour Challenge',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  'Ozzo and his friends are in dire danger and need your help. All you need to do to help him is to complete your four daily tasks towards saving the planet. If you manage to complete these daily tasks continuously for over a month, you will become one of the best saviors of planet Earth that Ozzo has come across.',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Rewards',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.amber,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Do you genuinely want a reward for this?\nI mean, you made a major contribution towards saving Ozzo’s future, so what might be a better reward? :)',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    width: 1,
                    color:
                        Colors.white), // Adjust the width and color as needed
              ),
            ),
            child: Container(
                height: 30,
                color: Colors.black,
                padding: const EdgeInsets.only(left: 60))));
  }
}
