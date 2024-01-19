import 'package:carbozzo/components/campus.dart';
import 'package:carbozzo/components/firebase_auth_services.dart';
import 'package:carbozzo/components/internet_provider.dart';
import 'package:carbozzo/components/my_textfield.dart';

import 'package:carbozzo/components/signin_provider.dart';
import 'package:carbozzo/components/toast.dart';
import 'package:carbozzo/pages/intro_pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromRGBO(198, 40, 40, 1), // Start color
              const Color.fromRGBO(198, 40, 40, 1), // End color
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Center(
                child: Image.asset(
                  'lib/images/final.png', // Replace 'your_image.png' with the actual image asset path
                  width: 150, // Adjust width as needed
                  height: 150, // Adjust height as needed
                ),
              ),

              const SizedBox(height: 5),

              //header text
              Text(
                'Join the Carbozzo Community \nNow!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                controller: _usernameController,
                hintText: "Username",
                obscureText: false,
              ),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                controller: _emailController,
                hintText: "Email",
                obscureText: false,
              ),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                controller: _passwordController,
                hintText: "Password",
                obscureText: true,
              ),

              SizedBox(
                height: 30,
              ),
              NeuTextButton(
                borderRadius: BorderRadius.circular(12),
                buttonColor: Color.fromARGB(255, 244, 9, 83),
                buttonHeight: 60,
                buttonWidth: 250,
                enableAnimation: true,
                onPressed: () {
                  _signUp();
                },
                text: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              NeuCard(
                borderRadius: BorderRadius.circular(12),
                cardColor: Colors.tealAccent[200],
                shadowColor: Colors.black,
                cardHeight: 60,
                cardWidth: 250,
                child: Padding(
                  padding: EdgeInsets.all(10), // Adjust the padding as needed
                  child: GestureDetector(
                    onTap: () {
                      handleGoogleSignIn(context);
                    },
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.transparent, // Adjust the filter color as needed
                        BlendMode.color, // Adjust the blend mode as needed
                      ),
                      child: Image.asset(
                        'lib/images/google.png',
                        width: 100, // Adjust the width as needed
                        height: 10, // Adjust the height as needed
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false);
                    },
                    child: Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });
    if (user != null) {
      showToast(message: "Account successfully created!");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CampusSelectionPage()),
      );
    } else {
      showToast(message: "Some error occurred");
    }
  }

  // handling google sign in
  Future handleGoogleSignIn(BuildContext context) async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      showToast(message: "Check your Internet connection");
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          showToast(message: sp.errorCode.toString());
        } else {
          // checking whether user exists or not
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // user exists
              await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        showToast(message: "Sign in successful!");
                        handleAfterSignIn(context);
                      })));
            } else {
              // user does not exist
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        showToast(message: "Account successfully created!");
                        handleAfterSignIn(context);
                      })));
            }
          });
        }
      });
    }
  }

  // handle after sign in
  handleAfterSignIn(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CampusSelectionPage()),
      );
    });
  }
}
