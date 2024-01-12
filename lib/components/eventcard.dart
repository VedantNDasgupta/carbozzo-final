import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final bool isPast;
  final String heading;
  final String description;
  final String points;

  const EventCard({
    Key? key,
    required this.isPast,
    required this.heading,
    required this.description,
    required this.points,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      margin: EdgeInsets.all(25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isPast ? Colors.tealAccent[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(8),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3),
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(right: 1), // Adjusted left margin
                child: Icon(Icons.star, color: Colors.amber, size: 20),
              ),
              SizedBox(width: 3),
              Text(
                points,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
