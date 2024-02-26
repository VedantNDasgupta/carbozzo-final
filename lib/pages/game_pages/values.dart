import 'package:flutter/material.dart';

int rowLength = 10;
int colLength = 15;

enum Direction {
  left,
  right,
  down,
}

enum Tetranimo {
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}

const Map<Tetranimo, Color> tetranimoColors = {
  Tetranimo.L: Color(0xFFFFA500),
  Tetranimo.J: Color.fromARGB(255, 0, 102, 255),
  Tetranimo.I: Color.fromARGB(255, 242, 0, 255),
  Tetranimo.O: Color(0xFFFFFF00),
  Tetranimo.S: Color(0xFF008000),
  Tetranimo.Z: Color(0xFFFF0000),
  Tetranimo.T: Color.fromARGB(255, 144, 0, 255),
};
