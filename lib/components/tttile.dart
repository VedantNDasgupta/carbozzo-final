import 'package:carbozzo/components/eventcard.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimeLineTile extends StatelessWidget {
  final int carbos;
  final bool achieved;
  final String heading;
  final String description;
  final String points;
  final String imagePath;

  const MyTimeLineTile({
    Key? key,
    required this.carbos,
    required this.achieved,
    required this.heading,
    required this.description,
    required this.points,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      beforeLineStyle: LineStyle(
        color: achieved ? Colors.teal : Colors.redAccent.shade100,
        thickness: 6,
      ),
      indicatorStyle: IndicatorStyle(
        width: 40,
        color: achieved ? Colors.teal : Colors.redAccent.shade100,
        iconStyle: IconStyle(
          iconData: achieved ? Icons.done : Icons.circle_outlined,
          color: Colors.white,
        ),
      ),
      endChild: EventCard(
        isPast: achieved,
        heading: heading,
        description: description,
        points: points,
        imagePath: imagePath,
      ),
    );
  }
}
