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
                heading: 'Reward 1',
                description: 'Description 1',
                points: '10 Carbopoints',
              ),
              //middle
              MyTimeLineTile(
                isFirst: false,
                isLast: false,
                isPast: true,
                heading: 'Reward 2',
                description: 'Description 2',
                points: '20 Carbopoints',
              ),
              MyTimeLineTile(
                isFirst: false,
                isLast: false,
                isPast: true,
                heading: 'Reward 3',
                description: 'Description 3',
                points: '30 Carbopoints',
              ),
              MyTimeLineTile(
                isFirst: false,
                isLast: false,
                isPast: true,
                heading: 'Reward 4',
                description: 'Description 4',
                points: '40 Carbopoints',
              ),
              //end
              MyTimeLineTile(
                isFirst: false,
                isLast: true,
                isPast: false,
                heading: 'Reward 5',
                description: 'Description 5',
                points: '50 Carbopoints',
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
