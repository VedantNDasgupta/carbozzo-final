import 'package:camera/camera.dart';
import 'package:carbozzo/components/campus.dart';
import 'package:carbozzo/components/month_summary.dart';
import 'package:carbozzo/components/task_tile.dart';
import 'package:carbozzo/data/habit_database.dart';
import 'package:carbozzo/pages/camera_page.dart';
import 'package:carbozzo/pages/main_pages/image_share.dart';
import 'package:carbozzo/pages/share_page.dart';
import 'package:carbozzo/pages/intro_pages/splash_page.dart';
import 'package:carbozzo/screens/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 1;
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");
  int tickedTileCount = 0;
  String username = '';
  String profileAvatar = 'lib/images/carbozzo_pfp.png';

  @override
  void initState() {
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    } else {
      db.loadData();
    }

    db.updateDatabase();

    loadProfileData();

    super.initState();
  }

  Future<void> loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        username =
            prefs.getString('profile_username') ?? user.displayName ?? '';
        profileAvatar = prefs.getString('profile_avatar') ?? profileAvatar;
      });
    }
  }

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
      if (value == true) {
        tickedTileCount++;
      } else {
        tickedTileCount--;
      }
    });
    db.updateDatabase();
  }

  bool isAtLeastOneTileGreen() {
    for (int i = 0; i < db.todaysHabitList.length; i++) {
      if (db.todaysHabitList[i][1] == true) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool showLaunchCameraButton = tickedTileCount > 0;

    return Scaffold(
      backgroundColor: Color.fromRGBO(198, 40, 40, 1),
      body: ListView(
        children: [
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
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
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
                              'Welcome back,',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text(
                            username.isNotEmpty ? username : 'Saviour!',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          );
                          // Reload profile data when returning from ProfilePage
                          loadProfileData();
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 5,
                            ),
                          ),
                          child: ClipOval(
                            child: Image(
                              image: AssetImage(profileAvatar),
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            ),
                          ),
                        ),
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

          SizedBox(
            height: 15,
          ),
          // Monthly summary heat map
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.white,
                  Colors.white70,
                ],
                radius: 1.5,
                center: Alignment.topRight,
              ),
              borderRadius: BorderRadius.all(Radius.circular(30)),
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
            child: MonthlySummary(
              datasets: db.heatMapDataSet,
              startDate: _myBox.get("START_DATE"),
            ),
          ),

          SizedBox(height: 12),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.amberAccent[700],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(4.0, 3.0),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 3),
                      child: Text(
                        '${DateFormat('MMMM, yyyy').format(DateTime.now())}',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 1.0, top: 5, bottom: 3),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(_createRoute());
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(3),
                        ),
                        child: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          12,
                          (index) {
                            // Determine the color based on the number of completed months
                            Color lineColor = index < DateTime.now().month
                                ? Colors.green
                                : Colors.white;

                            return lineColor == Colors.green
                                ? Shimmer.fromColors(
                                    period: Duration(milliseconds: 3000),
                                    baseColor: Colors.green,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      height: 6,
                                      width: 21,
                                      color: lineColor,
                                    ),
                                  )
                                : Container(
                                    height: 6,
                                    width: 21,
                                    color: lineColor,
                                  );
                          },
                        ),
                      ),
                      SizedBox(height: 3),
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 6.0, bottom: 8),
                            child: Text('Jan',
                                style: TextStyle(color: Colors.black)),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 8,
                                left: MediaQuery.of(context).size.width * 0.66),
                            child: Text('Dec',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // List of tasks
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.todaysHabitList.length,
            itemBuilder: (context, index) {
              return TaskTile(
                habitName: db.todaysHabitList[index][0],
                habitCompleted: db.todaysHabitList[index][1],
                onChanged: (value) => checkBoxTapped(value, index),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          // Camera Tile (conditionally displayed)
          if (showLaunchCameraButton)
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(6.0, 6.0),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  'Launch Camera',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                leading: Icon(Icons.camera_alt),
                onTap: () async {
                  final cameras = await availableCameras();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraPage(cameras: cameras),
                    ),
                  );
                },
              ),
            ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            width: 380,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.teal[200],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black,
                width: 3,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 18,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    'Today\'s Eco Activities',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageGalleryPage()),
                      );
                    },
                    child: Container(
                      width: 130,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent[400],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 28,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Verify',
                            style: GoogleFonts.poppins(
                              fontSize: 21,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
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

          SizedBox(height: 10),
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
                  offset:
                      Offset(0.0, -2.0), // Offset to create a shadow at the top
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SharePage(
        db: db,
      ),
      transitionDuration: Duration(milliseconds: 800),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset(0.0, 0.0);
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
