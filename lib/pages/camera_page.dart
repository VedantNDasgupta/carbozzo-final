import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('Error: User not authenticated.');
      return;
    }

    String userId = user.uid;
    String galleryId = DateTime.now().millisecondsSinceEpoch.toString();
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    CollectionReference sharedGalleryCollection =
        FirebaseFirestore.instance.collection('shared_gallery');

    DocumentReference sharedGalleryDocument =
        await sharedGalleryCollection.add({
      'user1_uid': userId,
      'user2_uid': '', // Add the UID of the other user when paired
    });

    String documentId = sharedGalleryDocument.id;

    String imageUrl = await _uploadImageToStorage(
        File(pictureFile!.path), userId, galleryId, timestamp);

    // Store metadata in the 'photos' subcollection
    await sharedGalleryDocument.collection('photos').add({
      'imageUrl': imageUrl,
      'caption': caption,
      'timestamp': timestamp,
    });
  }

  Future<String> _uploadImageToStorage(
      File imageFile, String userId, String galleryId, String timestamp) async {
    try {
      String imageName = '$timestamp.jpg';
      String imagePath = 'shared_gallery/$galleryId/photos/$imageName';

      UploadTask uploadTask =
          FirebaseStorage.instance.ref().child(imagePath).putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      throw ('Error during image upload to storage: $e');
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
          padding:
              const EdgeInsets.only(top: 20.0, left: 10, right: 10, bottom: 20),
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
      ]),
    );
  }
}
