import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carbozzo/pages/suggestion.dart'; // Import SuggestionsPage

class PasskeyPage extends StatelessWidget {
  final TextEditingController _passkeyController = TextEditingController();

  void checkPasskeyAndNavigate(BuildContext context) {
    if (_passkeyController.text.trim().toUpperCase() == "IITBOMBAY") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuggestionsPage(),
        ),
      );
    } else {
      // Display a toast message for incorrect passkey
      Fluttertoast.showToast(
        msg: "Incorrect Passkey. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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
          icon: const Icon(Icons.chevron_left, color: Colors.white),
        ),
        toolbarHeight: 30,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: SizedBox(),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter Passkey :',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passkeyController,
                decoration: InputDecoration(
                  hintText: "",
                  filled: true,
                  fillColor: Colors.grey.shade700,
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                // user input color
                onSubmitted: (_) => checkPasskeyAndNavigate(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
