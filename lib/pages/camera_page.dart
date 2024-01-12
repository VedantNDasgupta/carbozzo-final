import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;

  const CameraPage({this.cameras, Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with TickerProviderStateMixin {
  late CameraController controller;
  XFile? pictureFile;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool isFlashOn = false;

  @override
  void initState() {
    super.initState();
    if (widget.cameras != null && widget.cameras!.isNotEmpty) {
      controller = CameraController(
        widget.cameras![0],
        ResolutionPreset.max,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onCaptureButtonPressed() async {
    _animationController.forward();
    await Future.delayed(Duration(milliseconds: 100));
    pictureFile = await controller.takePicture();
    _showImagePreviewDialog();
    setState(() {});
  }

  void _onFlipCameraPressed() async {
    if (widget.cameras == null || widget.cameras!.isEmpty) return;

    int currentCameraIndex = widget.cameras!.indexOf(controller.description);
    int nextCameraIndex = (currentCameraIndex + 1) % widget.cameras!.length;

    await controller.dispose();

    controller = CameraController(
      widget.cameras![nextCameraIndex],
      ResolutionPreset.max,
    );

    await controller.initialize();

    setState(() {});
  }

  void _onToggleFlashPressed() {
    if (controller.value.isInitialized) {
      isFlashOn = !isFlashOn;
      controller.setFlashMode(
        isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    }
  }

  void _showImagePreviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String caption = '';

        return AlertDialog(
          content: Column(
            children: [
              Image.file(File(pictureFile!.path)),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  caption = value;
                },
                decoration: InputDecoration(labelText: 'Enter Caption'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await _uploadImageToFirestore(caption);
                Navigator.of(context).pop();
              },
              child: Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadImageToFirestore(String caption) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('Error: User not authenticated.');
        return;
      }

      String userId = user.uid;
      String documentId = DateTime.now().millisecondsSinceEpoch.toString();

      CollectionReference imagesCollection =
          FirebaseFirestore.instance.collection('images');

      File imageFile = File(pictureFile!.path);

      // Print statements for debugging
      print('Uploading image to storage...');
      UploadTask uploadTask = FirebaseStorage.instance.ref().putFile(imageFile);

      // Wait for the upload to complete and get the download URL
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Print statements for debugging
      print('Image uploaded to storage successfully.');
      print('Download URL: $downloadUrl');

      // Create a Firestore document with image details
      await imagesCollection.doc(documentId).set({
        'userId': userId,
        'imageUrl': downloadUrl,
        'caption': caption,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Firestore document created successfully.');
    } catch (e) {
      print('Error during image upload: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.red,
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, right: 15, left: 15),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.amber),
                    child: CameraPreview(controller)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: _onToggleFlashPressed,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _onCaptureButtonPressed,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.camera,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _onFlipCameraPressed,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.switch_camera_rounded,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(bottom: 15.0, top: 5, left: 10, right: 10),
          child: GestureDetector(
            onTap: () {
              print('Image Submitted');
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Submit',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple[600],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
