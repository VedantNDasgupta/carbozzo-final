import 'package:carbozzo/pages/intro_pages/intropage_1.dart';
import 'package:carbozzo/pages/intro_pages/intropage_2.dart';
import 'package:carbozzo/pages/intro_pages/intropage_3.dart';
import 'package:carbozzo/pages/intro_pages/intropage_4.dart';
import 'package:carbozzo/pages/intro_pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  //page track controller
  final PageController _controller = PageController();

  //last intro page tracker
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //page view
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 3);
              });
            },
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
              IntroPage4(),
            ],
          ),

          //dot indicators main
          Container(
            alignment: const Alignment(0, 0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(3);
                  },
                  child: Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(6.0, 6.0),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.skip_next_outlined,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),

                //dot indicator
                SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: WormEffect(
                    // You can use other effects as well
                    activeDotColor: Colors.amber, // Set the active dot color
                    dotColor: Colors.white, // Set the inactive dot color
                    dotHeight: 20,
                    dotWidth: 20,
                  ),
                ),

                //next or done
                GestureDetector(
                  onTap: () {
                    onLastPage
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const SignUpPage();
                              },
                            ),
                          )
                        : _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                  },
                  child: Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(6.0, 6.0),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: onLastPage
                            ? [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.done_outlined,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ]
                            : [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.arrow_forward_outlined,
                                      size: 25,
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
        ],
      ),
    );
  }
}
