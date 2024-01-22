import 'package:carbozzo/components/tttile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class TimelineScreen extends StatelessWidget {
  TimelineScreen({Key? key}) : super(key: key);

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
        title: Padding(
          padding: const EdgeInsets.only(left: 50, top: 20),
          child: Text(
            'Carbo Roadmap',
            style: GoogleFonts.poppins(
                fontSize: 23, color: Colors.white, fontWeight: FontWeight.w600),
          ),
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
            children: [
              //start
              MyTimeLineTile(
                isFirst: true,
                isLast: false,
                isPast: true,
                heading: 'Tier 1',
                description: '50% off any desired Udemy course',
                points: '1000 Carbopoints',
                imagePath: 'lib/images/udemy.png',
              ),
              //middle
              MyTimeLineTile(
                isFirst: false,
                isLast: false,
                isPast: true,
                heading: 'Tier 2',
                description: '₹500/- Zomato Gift Cards',
                points: '5000 Carbopoints',
                imagePath: 'lib/images/zomato.png',
              ),
              MyTimeLineTile(
                isFirst: false,
                isLast: false,
                isPast: true,
                heading: 'Tier 3',
                description: '1 month free Netflix subscription',
                points: '10000 Carbopoints',
                imagePath: 'lib/images/netflix.png',
              ),
              MyTimeLineTile(
                isFirst: false,
                isLast: false,
                isPast: true,
                heading: 'Tier 4',
                description: '₹1000/- Amazon Gift Cards',
                points: '25000 Carbopoints',
                imagePath: 'lib/images/amazon.png',
              ),
              //end
              MyTimeLineTile(
                isFirst: false,
                isLast: true,
                isPast: false,
                heading: 'Tier 5',
                description: 'Noise Midnight Blue Color Smartwatch',
                points: '50000 Carbopoints',
                imagePath: 'lib/images/smartwatch.png',
              ),
            ],
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
          height: 30,
          color: Colors.black,
          padding: const EdgeInsets.only(left: 60),
        ),
      ),
    );
  }
}
