import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarbosManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _userId;
  int carbos = 0;

  CarbosManager() {
    _userId = ''; // Initializing _userId to an empty string
  }

  Future<void> fetchUserId() async {
    // Fetch the user ID of the current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
    } else {
      // Handle the case where user is not authenticated
      print('User not authenticated');
    }
  }

  Future<void> fetchCarbos() async {
    try {
      // Fetch carbopoints value from Firestore
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(_userId).get();

      // Retrieve carbopoints from the document
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('carbopoints')) {
        // Parse the value as an integer
        carbos = int.tryParse(data['carbopoints'] ?? '') ?? 0;
      }
    } catch (e) {
      print('Error fetching carbopoints: $e');
    }
  }

  // Call this function whenever you want to update carbos value
  Future<void> updateCarbos() async {
    await fetchCarbos();
  }
}
