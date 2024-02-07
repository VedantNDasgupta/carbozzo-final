import 'package:cloud_firestore/cloud_firestore.dart';

class CarbopointsDatabase {
  static int _carbopoints = 0;

  static int get carbopoints => _carbopoints;

  static Future<void> fetchCarbopoints(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        // Get the value of carbopoints field
        _carbopoints = userSnapshot['carbopoints'] ?? 0;
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Error fetching carbopoints: $e');
    }
  }

  static void incrementCarbopoints() {
    _carbopoints++;
  }
}
