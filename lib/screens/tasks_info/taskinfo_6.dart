// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class Task4Screen extends StatelessWidget {
  const Task4Screen({Key? key}) : super(key: key);

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
                  'lib/images/Card4.png', // Replace with the actual image path
                  width: 1000, // Adjust the width as needed
                  height: 200, // Adjust the height as needed
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sustainable \nShopping',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '> 1 tonne/\nyear',
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
                'Sustainable shopping minimizes carbon emissions by promoting eco-friendly production, ethical labor practices, and responsible consumption. Opting for locally sourced, organic, and recycled products reduces the environmental impact of manufacturing and transportation. Choosing durable goods over fast fashion decreases the frequency of replacements, curbing excess production and waste. Supporting eco-conscious brands encourages industry shifts towards greener practices. Mindful consumer choices contribute to a circular economy, where materials are reused or recycled, further reducing carbon emissions associated with the extraction and processing of raw materials.',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Included/Related Tasks:',
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
                  bulletPoint('Support Local Businesses'),
                  bulletPoint('Buy Secondhand'),
                  bulletPoint('Choose Sustainable Materials'),
                  bulletPoint('Eco-friendly Cleaning Products'),
                  bulletPoint('Shop Mindfully in Bulk'),
                  bulletPoint('Reusable Carry Bags'),
                  bulletPoint('Hybrid Cars'),
                  bulletPoint('Local Artisan Markets'),
                  bulletPoint('Digital (Paperless) Receipts'),
                  bulletPoint('Sustainable Footwear'),
                  // Add more bullet points as needed
                ],
              ),
              const SizedBox(height: 30),
              Text(
                '"Upload only task-related images. Protect privacy—avoid sharing personal or sensitive information. Click responsibly. 📷🔒 #TaskSafety"',
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
