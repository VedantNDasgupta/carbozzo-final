import 'package:carbozzo/components/toast.dart';
import 'package:carbozzo/pages/intro_pages/login_page.dart';
import 'package:carbozzo/pages/main_pages/image_share.dart';
import 'package:carbozzo/pages/passkey.dart';
import 'package:carbozzo/screens/profile/qrpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedAvatar = 'lib/images/carbozzo_pfp.png'; // Default avatar

  List<String> avatarList = [
    'lib/images/av1.png',
    'lib/images/av2.png',
    'lib/images/av3.png',
    'lib/images/av4.png',
    'lib/images/av5.png',
    'lib/images/av6.png',
    'lib/images/av7.png',
    'lib/images/av8.png',
    'lib/images/av9.png',
    'lib/images/av10.png',
    'lib/images/av11.png',
    'lib/images/av12.png',
  ];

  TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        selectedAvatar = prefs.getString('profile_avatar') ?? selectedAvatar;
        usernameController.text =
            prefs.getString('profile_username') ?? user.displayName ?? '';
      });
    }
  }

  Future<void> saveProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_avatar', selectedAvatar);
    await prefs.setString('profile_username', usernameController.text);
  }

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
        toolbarHeight: 30,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: const SizedBox(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.04,
          right: MediaQuery.of(context).size.width * 0.04,
          left: MediaQuery.of(context).size.width * 0.04,
          bottom: MediaQuery.of(context).size.height * 0.03,
        ),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(selectedAvatar),
                    radius: 60,
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: usernameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9_]')),
                        TextInputFormatter.withFunction(
                          (oldValue, newValue) {
                            if (newValue.text.isNotEmpty) {
                              return TextEditingValue(
                                text: newValue.text
                                        .substring(0, 1)
                                        .toUpperCase() +
                                    newValue.text.substring(1),
                                selection: newValue.selection,
                              );
                            }
                            return newValue;
                          },
                        ),
                      ],
                      maxLength: 12,
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                'Choose your avatar:',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                  color: Colors.teal,
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
                ),
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: MediaQuery.of(context).size.width * 0.05,
                    runSpacing: MediaQuery.of(context).size.height * 0.01,
                    children: [
                      for (String avatar in avatarList)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAvatar = avatar;
                            });
                          },
                          child: CircleAvatar(
                            backgroundImage: AssetImage(avatar),
                            radius: MediaQuery.of(context).size.width * 0.08,
                            backgroundColor:
                                selectedAvatar == avatar ? Colors.blue : null,
                            foregroundColor: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              //save button
              Center(
                child: GestureDetector(
                  onTap: () async {
                    await saveProfileData();
                    print(
                        'Username: ${usernameController.text}, Avatar: $selectedAvatar');
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 100,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.green,
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
                          Icons.save,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Save',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Notifications button
                  GestureDetector(
                    onTap: () {
                      // Add your button 1 functionality here
                    },
                    child: Container(
                      width: 120,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
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
                            Icons.notifications,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Notifs',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Sign Out Button
                  GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                      showToast(message: "Successfully signed out");
                    },
                    child: Container(
                      width: 120,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.brown,
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
                            Icons.exit_to_app,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Sign Out',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              //qr code button
              SizedBox(height: 25),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    // Open QR code generator
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: 180,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.red[800],
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
                          Icons.qr_code,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'QR Code',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),

              // Delete button
              Center(
                child: GestureDetector(
                  onTap: () async {},
                  child: Container(
                    width: 180,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.red[800],
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
                          Icons.delete,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Delete Account',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),

              // Delete button
              Center(
                child: GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PasskeyPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: 180,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.teal,
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
                          Icons.password_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Enter Passkey',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
