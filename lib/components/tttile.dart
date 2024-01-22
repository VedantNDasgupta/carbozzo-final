import 'package:carbozzo/components/eventcard.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimeLineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String heading;
  final String description;
  final String points;
  final String imagePath; // Add imagePath parameter for the image

  const MyTimeLineTile({
    Key? key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.heading,
    required this.description,
    required this.points,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
        color: isPast ? Colors.teal : Colors.redAccent.shade100,
        thickness: 6,
      ),
      indicatorStyle: IndicatorStyle(
        width: 40,
        color: isPast ? Colors.teal : Colors.redAccent.shade100,
        iconStyle: IconStyle(
          iconData: Icons.done,
          color: Colors.white,
        ),
      ),
      endChild: EventCard(
        isPast: isPast,
        heading: heading,
        description: description,
        points: points,
        imagePath: imagePath, // Pass the imagePath to EventCard
      ),
    );
  }
}
