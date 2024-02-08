import 'package:cloud_firestore/cloud_firestore.dart';

class CarbopointsDatabase {
  static int _carbopoints = 0;

  static int get carbopoints => _carbopoints;

  static Future<void> fetchCarbopoints(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (userSnapshot.exists) {
        _carbopoints = userSnapshot.data()?['carbopoints'] ?? 0;
        print('Fetched carbopoints: $_carbopoints'); // Print the fetched value
      } else {
        print('User document does not exist');
        _carbopoints = 0; // Reset carbopoints if user document doesn't exist
      }
    } catch (e) {
      print('Error fetching carbopoints: $e');
      _carbopoints = 0; // Reset carbopoints if an error occurs
    }

    // Print the current value of carbopoints after fetching
    print('Current value of carbopoints: $_carbopoints');
  }
}
