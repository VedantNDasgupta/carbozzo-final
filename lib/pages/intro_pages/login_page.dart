import 'package:carbozzo/components/firebase_auth_services.dart';
import 'package:carbozzo/components/internet_provider.dart';
import 'package:carbozzo/components/my_login_textfield.dart';
import 'package:carbozzo/components/nav_bar.dart';
import 'package:carbozzo/components/signin_provider.dart';
import 'package:carbozzo/components/toast.dart';
import 'package:carbozzo/pages/intro_pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
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
                  'lib/images/final.png',
                  width: 150,
                  height: 150,
                ),
              ),

              const SizedBox(height: 5),
              //header text
              Text(
                'Welcome back, \nyou\'ve been missed!',
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
              // MyLoginTextField(
              //   controller: _emailController,
              //   hintText: "Email",
              //   obscureText: false,
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // MyLoginTextField(
              //   controller: _passwordController,
              //   hintText: "Password",
              //   obscureText: true,
              // ),
              // SizedBox(
              //   height: 30,
              // ),
              // NeuTextButton(
              //   borderRadius: BorderRadius.circular(12),
              //   buttonColor: Color.fromARGB(255, 244, 9, 83),
              //   buttonHeight: 60,
              //   buttonWidth: 250,
              //   enableAnimation: true,
              //   onPressed: () {
              //     _signIn();
              //   },
              //   text: Text(
              //     "Log In",
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 23,
              //     ),
              //   ),
              // ),

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
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      handleGoogleSignIn(context);
                    },
                    child: _isSigning
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          )
                        : ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.transparent,
                              BlendMode.color,
                            ),
                            child: Image.asset(
                              'lib/images/google.png',
                              width: 100,
                              height: 10,
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
                    'Don\'t have an account?',
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
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      'Sign Up',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      showToast(message: "User is successfully signed in");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );
    } else {
      showToast(message: "Some error occurred");
    }
  }

  // handling google sign in
  Future handleGoogleSignIn(BuildContext context) async {
    if (_isSigning) {
      return; // Prevent multiple sign-in attempts
    }

    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      showToast(message: "Check your Internet connection");
    } else {
      setState(() {
        _isSigning = true;
      });

      await sp.signInWithGoogle().then((value) {
        setState(() {
          _isSigning = false;
        });

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
                        showToast(message: "Sign in successful");
                        handleAfterSignIn(context);
                      })));
            } else {
              // user does not exist
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        showToast(message: "Sign in successful");
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
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );
    });
  }
}
