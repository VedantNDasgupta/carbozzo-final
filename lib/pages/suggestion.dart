import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuggestionsPage extends StatefulWidget {
  @override
  _SuggestionsPageState createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  TextEditingController _passkeyController = TextEditingController();
  bool showEcoSuggestion = false;
  String _greeting = '';
  String _username = '';
  Map<String, String> _suggestions = {
    "A":
        "Every drop counts! Shorten your shower time to conserve water and help protect our planet's precious resources.",
    "B":
        "Banish food waste! Start composting your kitchen scraps to reduce methane emissions from landfills and nourish the soil for healthier plants.",
    "C":
        "Cut down on energy waste! Invest in energy-efficient appliances to save money on bills and reduce your carbon footprint.",
    "D":
        "Defend our forests! Plant a tree in your backyard or participate in tree-planting initiatives to combat deforestation and promote biodiversity.",
    "E":
        "Eco-friendly commutes are the way to go! Opt for biking, walking, or public transportation to reduce traffic congestion and air pollution.",
    "F":
        "Flip the switch to sustainability! Switching to LED light bulbs not only saves energy but also illuminates your space with long-lasting brightness.",
    "G":
        "Grow local, go green! Support local farmers and reduce your carbon footprint by purchasing locally grown produce.",
    "H":
        "Harness the power of digital! Reduce paper usage by opting for digital documents and e-transactions to minimize deforestation and waste.",
    "I":
        "Initiate change with reusable bags! Ditch single-use plastics and carry reusable shopping bags to curb plastic pollution in our oceans and landfills.",
    "J":
        "Join the energy-saving movement! Unplug electronics when not in use to prevent phantom energy consumption and save on your electricity bill.",
    "K":
        "Keep waste out of landfills! Practice proper recycling of paper, plastic, glass, and metal to conserve resources and protect the environment.",
    "L":
        "Lead by example in water conservation! Fix leaks and install water-saving fixtures to preserve this precious resource for future generations.",
    "M":
        "Minimize packaging, maximize sustainability! Choose products with minimal packaging to reduce waste and lower your environmental impact.",
    "N":
        "Nurture awareness! Educate others about environmental issues and inspire action towards a more sustainable future.",
    "O":
        "Opt for organic, opt for sustainability! Choose organic and locally sourced food to support sustainable agriculture practices and reduce chemical pollution.",
    "P":
        "Pitch in for a cleaner community! Participate in community clean-up events to beautify your surroundings and protect wildlife habitats.",
    "Q":
        "Quell the carbon footprint of your diet! Reduce meat consumption and explore plant-based meal options for a healthier planet and body.",
    "R":
        "Revive, reuse, recycle! Embrace the mantra of 'reduce, reuse, recycle' to minimize waste and conserve resources for a greener tomorrow.",
    "S":
        "Set the thermostat to savings! Save energy by optimizing your thermostat settings and embracing energy-saving habits at home.",
    "T":
        "Transform your commute, transform the planet! Take public transportation or carpool to reduce traffic congestion and lower greenhouse gas emissions.",
    "U":
        "Unlock creativity with upcycling! Give old items new life by upcycling them into unique creations and reducing waste in the process.",
    "V":
        "Volunteer for the planet! Join environmental organizations and participate in conservation projects to make a positive impact in your community.",
    "W":
        "Walk the talk of sustainability! Choose walking or biking for short trips to reduce emissions and promote a healthier lifestyle.",
    "X":
        "Xperience the rewards of sustainable living! Evaluate your lifestyle choices and identify areas where you can make more eco-friendly decisions.",
    "Y":
        "Yearn for a greener yard! Compost yard waste like grass clippings and leaves to enrich soil and reduce the need for chemical fertilizers.",
    "Z":
        "Zero in on waste reduction! Embrace a zero-waste lifestyle by minimizing consumption, reusing items, and recycling materials to eliminate waste."
  };

  @override
  void initState() {
    super.initState();
    _setGreeting();
    loadProfileData();
  }

  void _setGreeting() {
    DateTime now = DateTime.now();
    if (now.hour < 12) {
      setState(() {
        _greeting = 'Good Morning';
      });
    } else if (now.hour < 18) {
      setState(() {
        _greeting = 'Good Afternoon';
      });
    } else {
      setState(() {
        _greeting = 'Good Evening';
      });
    }
  }

  void loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _username =
            prefs.getString('profile_username') ?? user.displayName ?? '';
      });
    }
  }

  String getSuggestionForUsername(String username) {
    String firstLetter =
        username.isNotEmpty ? username.substring(0, 1).toUpperCase() : '';
    return _suggestions[firstLetter] ?? 'No suggestion available';
  }

  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.green.shade600,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$_greeting, \n$_username',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Image.asset(
              'lib/images/suggestion.png', // Replace 'lib/images/challenge_visual.png' with the path to your image asset
              width: 350, // Adjust the width as needed
              height: 200, // Adjust the height as needed
            ),
            SizedBox(height: 10),
            Text(
              // Your eco-friendly suggestion based on username
              getSuggestionForUsername(_username),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  showEcoSuggestion = false;
                });
              },
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
