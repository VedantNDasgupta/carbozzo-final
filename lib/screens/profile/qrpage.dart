import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QRPage extends StatefulWidget {
  @override
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Barcode result;
  late QRViewController controller;
  String userUid = "";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      userEmail = user.email ?? "";

      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userQuery.docs.isNotEmpty) {
        String userDocumentId = userQuery.docs.first.id;

        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDocumentId)
            .get();

        setState(() {
          userUid = userSnapshot.get('uid') ?? "";
        });
      }
    }
  }

  Widget buildQRCode(String userUid) {
    return QrImageView(
      data: userUid,
      version: QrVersions.auto,
      size: 300.0,
      backgroundColor: Colors.white,
      padding: EdgeInsets.all(18.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(198, 40, 40, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(198, 40, 40, 1),
        elevation: 10,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Ionicons.chevron_back, color: Colors.white),
        ),
        toolbarHeight: 30,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: SizedBox(),
        ),
      ),
      body: Container(
        height: 760,
        padding:
            const EdgeInsets.only(top: 30, right: 14, left: 14, bottom: 25),
        decoration: BoxDecoration(
          color: Color.fromRGBO(160, 40, 40, 1),
          borderRadius: BorderRadius.circular(30),
          border: Border(
            bottom: BorderSide(color: Colors.black, width: 6),
            top: BorderSide(color: Colors.black, width: 6),
            right: BorderSide(color: Colors.black, width: 2),
            left: BorderSide(color: Colors.black, width: 2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: 70),
                  GestureDetector(
                    onTap: () {
                      print('Scan QR Code button pressed');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              QRScannerScreen(userUid: userUid),
                        ),
                      );
                    },
                    child: Container(
                      width: 230,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(6.0, 6.0),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            weight: 90,
                            size: 35,
                            color: Colors.black,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Scan QR Code',
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        width: 6,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(12.0, 12.0),
                        ),
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(12.0, 12.0),
                        ),
                      ],
                    ),
                    child: buildQRCode(userUid),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QRScannerScreen extends StatefulWidget {
  final String userUid;

  QRScannerScreen({required this.userUid});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Barcode result;
  late QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: (QRViewController controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  setState(() {
                    result = scanData;
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String? pairedUserUid = result.code;

                        CollectionReference userPairingsCollection =
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.userUid)
                                .collection('pairings');

                        userPairingsCollection
                            .where('user2Uid', isEqualTo: pairedUserUid)
                            .get()
                            .then((querySnapshot) {
                          if (querySnapshot.docs.isEmpty) {
                            userPairingsCollection.add({
                              'user1Uid': widget.userUid,
                              'user2Uid': pairedUserUid,
                              'pairingTimestamp': FieldValue.serverTimestamp(),
                              'expirationTimestamp':
                                  DateTime.now().add(Duration(days: 7)),
                            });
                          }
                        });

                        return AlertDialog(
                          backgroundColor: Colors.black,
                          title: Text(
                            'Paired to user: $pairedUserUid',
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'OK',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  });
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.black,
            child: Text(
              'Point the camera at a QR code to scan',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
