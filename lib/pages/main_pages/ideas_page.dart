import 'package:carbozzo/screens/challenge_screen.dart';
import 'package:carbozzo/screens/tasks_info/taskinfo_1.dart';
import 'package:carbozzo/screens/tasks_info/taskinfo_2.dart';
import 'package:carbozzo/screens/tasks_info/taskinfo_3.dart';
import 'package:carbozzo/screens/tasks_info/taskinfo_4.dart';
import 'package:carbozzo/screens/timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdeasPage extends StatefulWidget {
  const IdeasPage({Key? key}) : super(key: key);

  @override
  State<IdeasPage> createState() => _IdeasPageState();
}

class _IdeasPageState extends State<IdeasPage> {
  late List<Color> dayColors = [];

  @override
  void initState() {
    super.initState();
    loadDayColors();
  }

  Future<void> loadDayColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    int? lastOpenedDay = prefs.getInt('last_opened_day');
    int currentDayIndex = now.weekday - 1;

    if (lastOpenedDay == null ||
        now
                .difference(DateTime.fromMillisecondsSinceEpoch(lastOpenedDay))
                .inDays >=
            1) {
      if (lastOpenedDay != null) {
        // Keep the previously green tile green
        dayColors[lastOpenedDay - 1] = Colors.green;
      }
      updateDayColors(currentDayIndex);
      prefs.setInt('last_opened_day', now.millisecondsSinceEpoch);
    } else {
      updateDayColors(lastOpenedDay - 1);
    }
  }

  void updateDayColors(int index) {
    setState(() {
      dayColors =
          List.generate(7, (i) => i == index ? Colors.green : Colors.black);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dayColors.isEmpty) {
      // Return a loading indicator or some default UI until dayColors is initialized.
      return CircularProgressIndicator();
    }

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
                    color: Colors.white,
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
                                  'Inspiration',
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
                              children: [
                                Text(
                                  'Weekly Streak',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.only(right: 1.0),
                                  child: Row(
                                    children: List.generate(
                                      7,
                                      (index) => Container(
                                        width: 23,
                                        height: 23,
                                        margin:
                                            EdgeInsets.only(top: 5, right: 3),
                                        decoration: BoxDecoration(
                                          color: dayColors[index],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Text(
                                            _getDayLetter(index),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
                        'Know Your Tasks',
                        style: GoogleFonts.raleway(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 3.0), //list padding horizontal
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Task1Screen(),
                                    ),
                                  );
                                  // Navigate to Task1Screen
                                },
                                child: promoCard('lib/images/Card1.png'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 3.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Task2Screen(),
                                    ),
                                  );
                                  // Navigate to Task2Screen
                                },
                                child: promoCard('lib/images/Card2.png'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 3.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Task3Screen(),
                                    ),
                                  );
                                  // Navigate to Task3Screen
                                },
                                child: promoCard('lib/images/Card3.png'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 3.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Task4Screen(),
                                    ),
                                  );
                                  // Navigate to Task4Screen
                                },
                                child: promoCard('lib/images/Card4.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'November Challenge',
                        style: GoogleFonts.raleway(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChallengeScreen()),
                          );
                          // Navigate to the new page here
                        },
                        child: Container(
                          height: 150,
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
                              image:
                                  AssetImage('lib/images/challenge_visual.png'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Progress Roadmap',
                        style: GoogleFonts.raleway(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimelineScreen()),
                          );
                          // Navigate to the new page here
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
                              image: AssetImage('lib/images/roadmap.png'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Eco Tips',
                    style: GoogleFonts.raleway(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: 380,
                  height: 190,
                  margin: EdgeInsets.only(right: 20.0, left: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                      width: 2, // Increase the border width
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 20),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Swiper(
                            autoplayDelay: 1700,
                            itemWidth: 290,
                            itemHeight: 150,
                            loop: true,
                            duration: 900,
                            curve: Curves.ease,
                            physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 3, // Increase the border width
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(3.0, 3.0),
                                    ),
                                  ],
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(imagepath[index]),
                                  ),
                                ),
                              );
                            },
                            itemCount: 6,
                            layout: SwiperLayout.STACK,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Recent Stats',
                    style: GoogleFonts.raleway(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildClassicCard(
                                '10.8',
                                'Average Yearly Carbon Footprint of a human',
                                'Metric Tonnes',
                                0.10),
                            _buildClassicCard(
                                '110',
                                'Species of Flora and Fauna at risk of extinction',
                                'In Hundreds',
                                0.35),
                            _buildClassicCard(
                                '15',
                                'Global Carbon Emission due to Deforestation alone',
                                'In Percent',
                                0.85),
                            _buildClassicCard(
                                '2',
                                'Predicted Rise in Earth\'s Temperature due to CO2',
                                'In\n Celsius',
                                0.20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
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
              ]),
        )));
  }

  List imagepath = [
    'lib/images/tip1.png',
    'lib/images/tip2.png',
    'lib/images/tip3.png',
    'lib/images/tip4.png',
    'lib/images/tip5.png',
    'lib/images/tip6.png',
  ];

  Widget _buildClassicCard(
      String number, String description, String label, double progressValue) {
    return Container(
      width: 167,
      height: 400, // Set the height to match the first container
      margin: EdgeInsets.only(right: 15.0, bottom: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white70,
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
            label,
            style: GoogleFonts.montserrat(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: progressValue,
                  backgroundColor: Color.fromARGB(206, 255, 0, 0),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(234, 5, 215, 43),
                  ),
                  strokeWidth: 20.0,
                ),
              ),
              Text(
                number,
                style: GoogleFonts.openSans(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            description,
            style: GoogleFonts.josefinSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Function to get the corresponding day letter
  String _getDayLetter(int index) {
    final List<String> dayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return dayLetters[index];
  }

  Widget promoCard(image) {
    double cardWidth = MediaQuery.of(context).size.width * 0.4;
    double cardHeight = cardWidth * (3 / 2.62);

    return AspectRatio(
      aspectRatio: 2.5 / 3,
      child: Container(
        margin: EdgeInsets.only(right: 15.0, bottom: 5),
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              cardWidth * 0.1), // Adjust the borderRadius dynamically
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
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage(image)),
        ),
      ),
    );
  }
}
