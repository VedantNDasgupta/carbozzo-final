import 'dart:io';
import 'dart:typed_data';

import 'package:carbozzo/components/month_summary.dart';
import 'package:carbozzo/data/habit_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class SharePage extends StatefulWidget {
  final HabitDatabase db;

  SharePage({required this.db});

  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final _screenshotController = ScreenshotController();
  final _myBox = Hive.box("Habit_Database");

  // Define a variable to store the selected color
  Color selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(198, 40, 40, 1),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            padding: EdgeInsets.only(top: 10.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 3,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  GestureDetector(
                    onVerticalDragDown: (details) {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 25,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(1, 50, 226, 0.498),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          // Monthly summary heat map
          Screenshot(
            controller: _screenshotController,
            child: Container(
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.circular(15),
                border: Border(
                  bottom: BorderSide(color: Colors.black, width: 6),
                  top: BorderSide(color: Colors.black, width: 6),
                  right: BorderSide(color: Colors.black, width: 2),
                  left: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              child: Container(
                margin:
                    EdgeInsets.only(left: 30, right: 30, top: 150, bottom: 170),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.white,
                      Colors.white70,
                    ],
                    radius: 1.5,
                    center: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 6.0),
                    ),
                  ],
                ),
                child: MonthlySummary(
                  datasets: widget.db.heatMapDataSet,
                  startDate: _myBox.get("START_DATE"),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          // Color selection and share buttons
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
              color: Color.fromRGBO(160, 40, 40, 1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // First row of color selection and share button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Color selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (Color color in [
                          Colors.red,
                          Colors.orange,
                          Colors.yellow,
                          Colors.green,
                          Colors.cyan,
                          Color.fromARGB(255, 13, 0, 255),
                        ])
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColor = color;
                              });
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              margin: EdgeInsets.only(
                                  left: color == Colors.red ? 10 : 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    // Share button
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _shareScreenshot();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: CircleBorder(),
                        ),
                        child: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                // Second row of color selection and download button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Color selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (Color color in [
                          Colors.white,
                          Colors.purple,
                          Colors.pink,
                          Colors.teal,
                          Colors.brown,
                          Colors.grey,
                        ])
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColor = color;
                              });
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              margin: EdgeInsets.only(
                                  left: color == Colors.white ? 10 : 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    // Download button
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _saveToGallery();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: CircleBorder(),
                        ),
                        child: Icon(
                          Icons.download_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _shareScreenshot() async {
    final Uint8List? imageBytes = await _screenshotController.capture();
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/image.png');
    await file.writeAsBytes(imageBytes!);

    // Share the screenshot
    Share.shareFiles([file.path], text: 'Check out my Carbomap!');
  }

  Future<void> _saveToGallery() async {
    try {
      final Uint8List? imageBytes = await _screenshotController.capture();
      String tempPath = (await getTemporaryDirectory()).path;
      File file = File('$tempPath/image.png');
      await file.writeAsBytes(imageBytes!);

      // Save the image to the gallery
      bool success =
          (await GallerySaver.saveImage(file.path, albumName: 'Carbomap')) ??
              false;

      if (success) {
        Fluttertoast.showToast(
          msg: 'Carbomap Downloaded!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to save Carbomap to gallery.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      // Handle any errors that occurred during the process
      print('Error saving to gallery: $e');

      Fluttertoast.showToast(
        msg: 'Failed to save Carbomap to gallery.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
