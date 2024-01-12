import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;

  const TaskTile({
    Key? key,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0),
      child: GestureDetector(
        onTap: () {
          // Trigger the onChanged callback when tapped
          if (onChanged != null) {
            onChanged!(!habitCompleted);
          }
        },
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: habitCompleted ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(12),
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
          child: Row(
            children: [
              // checkbox
              Checkbox(
                value: habitCompleted,
                onChanged: onChanged,
              ),

              // task name
              Text(
                habitName,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
