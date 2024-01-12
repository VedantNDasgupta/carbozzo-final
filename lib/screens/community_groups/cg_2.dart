// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:url_launcher/url_launcher.dart';

class CG2Screen extends StatelessWidget {
  const CG2Screen({Key? key}) : super(key: key);

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
          preferredSize: const Size.fromHeight(30),
          child: const SizedBox(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 30, right: 14, left: 14),
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
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'lib/images/CG2.png', // Replace with the actual image path
                  width: 1000, // Adjust the width as needed
                  height: 200, // Adjust the height as needed
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Sacramento, California',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Under2',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Since 2015',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                'The Under2 Coalition is a coalition of subnational governments that aims to achieve greenhouse gases emissions mitigation. It started as a memorandum of understanding, which was signed by twelve founding jurisdictions on May 19, 2015 in Sacramento, California. Although it was originally called the Under2 MOU, it became known as the Under2 Coalition in 2017. As of October 2022, the list of signatories had grown to 270 governments which represented over 1.75 billion people and 50% of the world economy. The Under2 MOU was conceived through a partnership between the governments of California and Baden-Wurttemberg, with The Climate Group acting as secretariat.',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              SlideAction(
                borderRadius: 12,
                elevation: 0,
                innerColor: Colors.deepPurple,
                outerColor: Colors.deepPurple[200],
                sliderButtonIcon: const Icon(
                  Icons.arrow_forward_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                sliderRotate: false,
                reversed: false,
                onSubmit: () {
                  String url = 'https://en.wikipedia.org/wiki/Under2Coalition';
                  launch(url);
                  return null;
                },
                height: 60,
                text: "Visit Website",
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 30), // Added empty SizedBox
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1,
              color: Colors.white,
            ),
          ),
        ),
        child: Container(
          height: 30,
          color: Colors.black,
          padding: const EdgeInsets.only(left: 60),
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
              style: GoogleFonts.poppins(
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
