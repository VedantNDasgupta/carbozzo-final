import 'dart:convert';
import 'package:carbozzo/components/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class CampusSelectionPage extends StatefulWidget {
  const CampusSelectionPage({Key? key}) : super(key: key);

  @override
  _CampusSelectionPageState createState() => _CampusSelectionPageState();
}

class _CampusSelectionPageState extends State<CampusSelectionPage> {
  bool isStudent = false;
  String selectedCampus = '';
  int selectedYear = DateTime.now().year;
  List<String> campusList = [];
  List<int> yearList =
      List.generate(31, (index) => DateTime.now().year + index);

  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  @override
  void initState() {
    super.initState();
    loadCampusList();
  }

  Future<void> loadCampusList() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('lib/components/campus_list.json');
    List<dynamic> jsonList = json.decode(jsonString);
    List<String> campusOptions =
        jsonList.map((dynamic item) => item.toString()).toList();

    setState(() {
      campusList = campusOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(160, 40, 40, 1),
          borderRadius: BorderRadius.circular(30),
          border: Border(
            bottom: BorderSide(color: Colors.black, width: 6),
            top: BorderSide(color: Colors.black, width: 6),
            right: BorderSide(color: Colors.black, width: 2),
            left: BorderSide(color: Colors.black, width: 2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you a student?',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  isStudent = !isStudent;
                });
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.amberAccent,
                    width: 5,
                  ),
                ),
                child: isStudent
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 30,
                      )
                    : Container(
                        width: 30,
                        height: 30,
                      ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Yes',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 23,
              ),
            ),
            Container(
              height: 2,
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 10),
            ),
            if (isStudent)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select your campus:',
                    style: TextStyle(
                      letterSpacing: 1,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 21,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SimpleAutoCompleteTextField(
                    key: key,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(160, 40, 40, 1),
                        ),
                      ),
                    ),
                    controller: TextEditingController(),
                    suggestions: campusList,
                    textChanged: (text) {
                      selectedCampus = text;
                    },
                    clearOnSubmit: false,
                    textSubmitted: (text) {
                      setState(() {
                        selectedCampus = text;
                      });
                    },
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Select the Graduation year:',
                    style: TextStyle(
                      letterSpacing: 1,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 21,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButton<int>(
                    value: selectedYear,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedYear = newValue!;
                      });
                    },
                    items: yearList.map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                    dropdownColor: Color.fromRGBO(160, 40, 40, 1),
                    underline: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () async {
                if (isStudent) {
                  if (selectedCampus.isEmpty || selectedYear == 0) {
                    // Condition 1: Show toast if the student did not select a campus or year
                    Fluttertoast.showToast(
                      msg: 'Campus or graduation year not selected',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  } else {
                    // Condition 2: If student presses 'Yes' and selects a campus and year, navigate to BottomNavBarPage
                    await updateFirestore(selectedCampus, selectedYear);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavBar(),
                      ),
                    );
                  }
                } else {
                  // Condition 3: If not a student, navigates to Bottomnavpage
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavBar(),
                    ),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Let\'s Go',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateFirestore(String selectedCampus, int selectedYear) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get the current user's doc in the users collection
        DocumentReference userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Update the Campus and GraduationYear fields in the doc
        await userDoc.update({
          'campus': selectedCampus,
          'graduationYear': selectedYear,
        });
      }
    } catch (e) {
      print('Error updating Firestore: $e');
    }
  }
}
