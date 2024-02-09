import 'package:carbozzo/components/carbos_manager.dart';
import 'package:flutter/material.dart';
import 'package:carbozzo/components/tttile.dart'; // Import MyTimeLineTile

class TimelineScreen extends StatefulWidget {
  TimelineScreen({Key? key}) : super(key: key);

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  // Instantiate the CarbosManager class
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

  @override
  Widget build(BuildContext context) {
    // Get the current value of carbos from the CarbosManager instance
    int carbos = _carbosManager.carbos;

    // List of MyTimeLineTile widgets
    List<MyTimeLineTile> timelineTiles = [
      MyTimeLineTile(
        achieved: false,
        heading: 'Tier 1',
        description: '50% off any desired Udemy course',
        points: '1000 Carbopoints',
        imagePath: 'lib/images/udemy.png',
        carbos: 1000, // Add the value of carbos for Tier 1
      ),
      MyTimeLineTile(
        achieved: false,
        heading: 'Tier 2',
        description: '₹500/- Zomato Gift Cards',
        points: '5000 Carbopoints',
        imagePath: 'lib/images/zomato.png',
        carbos: 5000, // Add the value of carbos for Tier 2
      ),
      MyTimeLineTile(
        achieved: false,
        heading: 'Tier 3',
        description: '1 month free Netflix subscription',
        points: '10000 Carbopoints',
        imagePath: 'lib/images/netflix.png',
        carbos: 10000, // Add the value of carbos for Tier 3
      ),
      MyTimeLineTile(
        achieved: false,
        heading: 'Tier 4',
        description: '₹1000/- Amazon Gift Cards',
        points: '25000 Carbopoints',
        imagePath: 'lib/images/amazon.png',
        carbos: 25000, // Add the value of carbos for Tier 4
      ),
      MyTimeLineTile(
        achieved: false,
        heading: 'Tier 5',
        description: 'Noise Midnight Blue Color Smartwatch',
        points: '50000 Carbopoints',
        imagePath: 'lib/images/smartwatch.png',
        carbos: 50000, // Add the value of carbos for Tier 5
      ),
    ];

    // Update 'achieved' boolean based on 'carbos' value
    for (int i = 0; i < timelineTiles.length; i++) {
      if (carbos >= timelineTiles[i].carbos) {
        timelineTiles[i] = MyTimeLineTile(
          achieved: true,
          heading: timelineTiles[i].heading,
          description: timelineTiles[i].description,
          points: timelineTiles[i].points,
          imagePath: timelineTiles[i].imagePath,
          carbos: timelineTiles[i].carbos,
        );
      }
    }

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
            Icons.chevron_left,
            color: Colors.white,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 50, top: 20),
        ),
        toolbarHeight: 45,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: SizedBox(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 30, right: 14, left: 14),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border(
            top: BorderSide(color: Colors.black, width: 2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: const Offset(6.0, 6.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: ListView(
            children: timelineTiles,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color: Colors.white),
          ),
        ),
        child: Container(
          height: 50,
          color: Colors.black,
          padding: const EdgeInsets.only(left: 60),
        ),
      ),
    );
  }
}
