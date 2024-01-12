// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:url_launcher/url_launcher.dart';

class CG3Screen extends StatelessWidget {
  const CG3Screen({Key? key}) : super(key: key);

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
                  'lib/images/CG3.png', // Replace with the actual image path
                  width: 1000, // Adjust the width as needed
                  height: 200, // Adjust the height as needed
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Mumbai, India',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'The India Climate \nCollaborative',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Since 2018',
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
                'The India Climate Collaborative is a living system. We leverage the strength of our network, spanning across government, business, philanthropy, academia, and civil society, to overcome the greatest crisis facing our world and our country today: climate change. We convene stakeholders across disciplines to design, finance, and implement pathbreaking climate solutions.\n'
                '\nWe build alignment and collective action across the climate sphere, in order to enhance the value of climate investments. We achieve this by convening decision-makers to set collective goals and measurement criteria, building the capacity of institutions and communities, and developing open-source tools and knowledge products.',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Funders and Supporters:',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.amber,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              // List of 10 bullet points
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bulletPoint('JSW Foundation'),
                  bulletPoint('TATA Trusts'),
                  bulletPoint('Hewlett Foundation'),
                  bulletPoint('Bloomberg Philanthropies'),
                  // Add more bullet points as needed
                ],
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
                  String url = 'https://indiaclimatecollaborative.org/';
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
