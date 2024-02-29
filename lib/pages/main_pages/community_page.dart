import 'dart:convert';
import 'dart:math';

import 'package:carbozzo/components/carbos_manager.dart';
import 'package:carbozzo/pages/game_pages/board.dart';
import 'package:carbozzo/pages/game_pages/menu.dart';
import 'package:carbozzo/pages/main_pages/image_share.dart';
import 'package:carbozzo/screens/community_groups/cg_1.dart';
import 'package:carbozzo/screens/community_groups/cg_2.dart';
import 'package:carbozzo/screens/community_groups/cg_3.dart';
import 'package:carbozzo/screens/community_groups/cg_4.dart';
import 'package:carbozzo/screens/guide.dart';
import 'package:carbozzo/screens/info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<String> campusList = [
    'Indian Institute of Technology Bombay',
    'Veermata Jijabai Technological Institute',
    'Indian Institute of Technology Madras',
    'Indian Institute of Technology Delhi',
    'Indian Institute of Technology BHU',
    'Indian Institute of Technology Kharagpur',
    'Indian Institute of Technology Roorkee',
    'Indian Institute of Technology Guwahati'
  ];
  late CarbosManager _carbosManager;

  @override
  void initState() {
    super.initState();
    _carbosManager = CarbosManager(); // Initialize CarbosManager
    _fetchCarbos(); // Fetch carbos data
  }

  Future<void> _fetchCarbos() async {
    await _carbosManager.fetchUserId(); // Fetch user ID
    await _carbosManager.fetchCarbos(); // Fetch carbos data
    setState(() {}); // Update UI
  }

  int initialPoints = 5000;
  int decreaseBy = 250;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(198, 40, 40, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.redAccent,
                      Colors.tealAccent,
                    ],
                    radius: 3,
                    center: Alignment.topRight,
                  ),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 6.0),
                    ),
                  ],
                ),
                padding: EdgeInsets.only(top: 10.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  'Find Your',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Text(
                                'Community',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 65,
                            child: VerticalDivider(
                              color: Colors.grey[300],
                              thickness: 3,
                              width: 20,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Text(
                                  'Guide and Info',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GuideScreen()));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.black, width: 2)),
                                        padding: EdgeInsets.all(8),
                                        child: Icon(
                                          Icons
                                              .question_mark, // Replace with the actual icon you want
                                          color: Colors.black87,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  GestureDetector(
                                    onTap: () {
                                      String url =
                                          'https://www.gvi.co.uk/blog/why-reducing-your-carbon-footprint-can-make-a-big-impact/';
                                      launch(url);
                                      return null;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.black, width: 2),
                                        color: Colors.green[300],
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.priority_high,
                                        color: Colors.black,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(1, 50, 226, 0.498),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Carbopoints',
                      style: GoogleFonts.raleway(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: SizedBox(
                        width: 380,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: 170,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.teal[500],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2, // Increase the border width
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 18, left: 18),
                                  child: Center(
                                    child: Text(
                                      '${_carbosManager.carbos}', // Display the value of carbos variable using _carbosManager
                                      style: GoogleFonts.raleway(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .white, // Change text color to black
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                width: 170,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.amber[300],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 18, right: 1, left: 1),
                                        child: Center(
                                          child: Text(
                                            'Next Milestone',
                                            style: GoogleFonts.raleway(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          _getNextMilestoneText(
                                              _carbosManager.carbos),
                                          style: GoogleFonts.raleway(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Tetra Sustaina (Mini-Game)',
                      style: GoogleFonts.raleway(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MenuPage()));
                      },
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
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
                          image: DecorationImage(
                            image: AssetImage('lib/images/minigame.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Climate Groups Near You',
                      style: GoogleFonts.raleway(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 180,
                      child: Container(
                        width: 380,
                        height: 190,
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                            width: 2, // Increase the border width
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 18, bottom: 15, right: 10, left: 10),
                          child: PageView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CG1Screen()),
                                  );
                                },
                                child: promoCard('lib/images/CG1.png'),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CG2Screen()),
                                  );
                                },
                                child: promoCard('lib/images/CG2.png'),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CG3Screen()),
                                  );
                                },
                                child: promoCard('lib/images/CG3.png'),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CG4Screen()),
                                  );
                                },
                                child: promoCard('lib/images/CG4.png'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 25),
                    // Leaderboard Container

                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: BoxDecoration(
                        color: Colors.amber[700],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(6.0, 8.0),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02,
                              left: MediaQuery.of(context).size.width * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Green Campus Leaderboards',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              // Leaderboard Table
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Table(
                                  columnWidths: {
                                    0: FixedColumnWidth(
                                        MediaQuery.of(context).size.width *
                                            0.21), // Rank
                                    1: FixedColumnWidth(
                                        MediaQuery.of(context).size.width *
                                            0.39), // Campus
                                    2: FixedColumnWidth(
                                        MediaQuery.of(context).size.width *
                                            0.2), // Points
                                  },
                                  children: [
                                    // Table Header
                                    TableRow(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        color: Colors.grey[300],
                                      ),
                                      children: [
                                        Center(
                                          child: Text(
                                            'Rank',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            'Campus',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            'Points',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Empty row for spacing
                                    TableRow(
                                      children: List.generate(
                                        3,
                                        (index) => Text(
                                          '       ',
                                          style: GoogleFonts.poppins(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Custom list of campuses from the campusList variable
                                    for (int i = 0; i < campusList.length; i++)
                                      TableRow(
                                        children: [
                                          Center(
                                            child: Text(
                                              (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              campusList[i],
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              (initialPoints - i * decreaseBy)
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    // Empty row for spacing
                                    TableRow(
                                      children: List.generate(
                                        3,
                                        (index) => Text(
                                          '       ',
                                          style: GoogleFonts.poppins(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30.0),
                    Container(
                      width: 380,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 2, // Increase the border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 25, right: 18, left: 18),
                        child: Container(
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
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
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('lib/images/quote.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'External Links',
                      style: GoogleFonts.raleway(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 380,
                      height:
                          390, // Adjusted height to accommodate the contents
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 2, // Increase the border width
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, right: 18, left: 18),
                            child: GestureDetector(
                              onTap: () {
                                // google form for feedback
                                String url =
                                    'https://forms.gle/YiMMfzaJ3aeatSYN9';
                                launch(url);
                              },
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
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
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('lib/images/misc1.png'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 18, left: 18),
                            child: GestureDetector(
                              onTap: () {
                                // App website/store link
                                String url = 'https://google.com';
                                Share.share('Check out this link: $url');
                              },
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
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
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('lib/images/misc2.png'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 20, right: 18, left: 18),
                              child: Container(
                                width: 380,
                                height: 105,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.red, // Use a vibrant color
                                      Colors
                                          .redAccent, // Adjust the end color as needed
                                    ],
                                  ),
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Crafted by :',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Vedant Dasgupta',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 15,
                margin: EdgeInsets.only(
                    top: 5), // Negative margin to create a shadow at the top
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(
                          0.0, -2.0), // Offset to create a shadow at the top
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getNextMilestoneText(int carbopoints) {
    if (carbopoints < 1000) {
      return '1k';
    } else if (carbopoints < 5000) {
      return '5k';
    } else if (carbopoints < 10000) {
      return '10k';
    } else if (carbopoints < 25000) {
      return '25k';
    } else {
      return '50k';
    }
  }

  Widget promoCard(image) {
    return AspectRatio(
      aspectRatio: 2.62 / 3,
      child: Container(
        margin: EdgeInsets.only(right: 12.0, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(8.0, 8.0),
            ),
          ],
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage(image)),
        ),
      ),
    );
  }
}
