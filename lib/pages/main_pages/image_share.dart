import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';

class ImageGalleryPage extends StatefulWidget {
  @override
  _ImageGalleryPageState createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  late User currentUser;
  late Stream<QuerySnapshot<Map<String, dynamic>>> imageStream;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!;
    imageStream = FirebaseFirestore.instance
        .collection('shared_gallery')
        .where('user1_uid', isEqualTo: currentUser.uid)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getPartnerPairings() async {
    CollectionReference pairingsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('pairings');

    return await pairingsCollection.get()
        as QuerySnapshot<Map<String, dynamic>>;
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildGridView(List<Widget> images) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 1,
      mainAxisSpacing: 5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: images,
    );
  }

  Widget _buildImageSection(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    var photosCollection = document.reference.collection('photos');

    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: photosCollection.get(),
      builder: (context, photosSnapshot) {
        if (photosSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (photosSnapshot.hasError) {
          return Center(child: Text('Error: ${photosSnapshot.error}'));
        }

        if (!photosSnapshot.hasData || photosSnapshot.data!.docs.isEmpty) {
          return Center(
              child: Text(
            'No images found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ));
        }

        var photoDocuments = photosSnapshot.data!.docs;

        // Check if the images belong to your partner and are displayed under "Partner's Images"
        var isPartnerImage = document.get('user1_uid') != currentUser.uid;

        return Hero(
          tag: document.id,
          child: GestureDetector(
            onTap: isPartnerImage
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageDetailPage(
                          images: photoDocuments,
                          initialIndex: 0,
                        ),
                      ),
                    );
                  }
                : null,
            child: Card(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 100,
                ),
                itemCount: photoDocuments.length,
                itemBuilder: (context, photoIndex) {
                  var photoDocument = photoDocuments[photoIndex];
                  var imageUrl = photoDocument['imageUrl'];
                  var caption = photoDocument['caption'];

                  return Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        caption,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 1),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildPartnerImages(
    Stream<QuerySnapshot<Map<String, dynamic>>> partnerImagesStream,
  ) {
    return [
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: partnerImagesStream,
        builder: (context, partnerImagesSnapshot) {
          if (partnerImagesSnapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (partnerImagesSnapshot.hasError) {
            return Center(child: Text('Error: ${partnerImagesSnapshot.error}'));
          }

          var partnerImages = partnerImagesSnapshot.data!.docs
              .map((document) => _buildImageSection(document))
              .toList();

          return _buildGridView(partnerImages);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(198, 40, 40, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(198, 40, 40, 1),
        elevation: 5,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Ionicons.chevron_back,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 30,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: const SizedBox(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: imageStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: Text(
                'No images found',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ));
          }

          var myImages = snapshot.data!.docs
              .map((document) => _buildImageSection(document))
              .toList();

          return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: _getPartnerPairings(),
            builder: (context, partnerPairingsSnapshot) {
              if (partnerPairingsSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (partnerPairingsSnapshot.hasError) {
                return Center(
                    child: Text('Error: ${partnerPairingsSnapshot.error}'));
              }

              var partnerImages = <Widget>[];

              for (var pairingDocument in partnerPairingsSnapshot.data!.docs) {
                var user2Uid = pairingDocument.get('user2Uid');
                var partnerImagesStream = FirebaseFirestore.instance
                    .collection('shared_gallery')
                    .where('user1_uid', isEqualTo: user2Uid)
                    .snapshots();

                partnerImages.add(
                  _buildSectionHeader("Partner's Images"),
                );
                partnerImages.add(
                  Container(
                    height: 3,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                );
                partnerImages.add(SizedBox(height: 20));
                partnerImages.add(_buildGridView(
                  _buildPartnerImages(partnerImagesStream),
                ));
                partnerImages.add(SizedBox(height: 20));
                partnerImages.add(
                  Container(
                    height: 3,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                );
              }

              return ListView(
                children: [
                  _buildSectionHeader('Your Images'),
                  Container(
                    height: 3,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  _buildGridView(myImages),
                  SizedBox(height: 20),
                  Container(
                    height: 3,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                  ...partnerImages,
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class ImageDetailPage extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> images;
  final int initialIndex;

  ImageDetailPage({
    required this.images,
    required this.initialIndex,
  });

  @override
  _ImageDetailPageState createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    currentIndex = widget.initialIndex;
  }

  // Function to show a toast message
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 0,
      backgroundColor: Colors.blue,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(198, 40, 40, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(198, 40, 40, 1),
        leading: IconButton(
          icon: Icon(Ionicons.chevron_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          var imageUrl = widget.images[index]['imageUrl'];
          var caption = widget.images[index]['caption'];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Hero(
                  tag: widget.images[index].id,
                  child: Image.network(
                    imageUrl,
                    width: MediaQuery.of(context).size.width - 40,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    caption,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                // Buttons at the bottom left and right
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35, top: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showToast('Image Proof REJECTED');
                          {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 90,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showToast('Image Proof ACCEPTED');
                          {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 90,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ImageGalleryPage(),
  ));
}
