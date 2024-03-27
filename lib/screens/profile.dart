import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile/screens/activity.dart';
import 'package:flutter_mobile/screens/add.dart';
import 'package:flutter_mobile/screens/home.dart';
import 'package:flutter_mobile/screens/login.dart';
import 'package:flutter_mobile/screens/message.dart';
import 'package:flutter_mobile/screens/update_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Update()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) => const Color.fromARGB(255, 224, 228, 5),
                ),
              ),
              child: const Text("Edit Profile"),
            ),
            const SizedBox(height: 20), // Adding space between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Activity()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) => const Color.fromARGB(255, 224, 228, 5),
                ),
              ),
              child: const Text("My Activities"),
            ),
            const SizedBox(height: 20), // Adding space between buttons
            ElevatedButton(
              onPressed: () {
                // Show confirmation dialog before logging out
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm Log Out"),
                      content: const Text("Are you sure you want to log out?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            logout(context);
                          },
                          child: const Text("Log Out"),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) => const Color.fromARGB(255, 224, 228, 5),
                ),
              ),
              child: const Text("Log Out"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.blue[800],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              icon: const Icon(Icons.home, color: Colors.white),
            ),
            // No need to navigate to Message screen again
            // Just keep it as a selected icon
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Message()),
                );
              },
              icon: const Icon(Icons.message, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Add()),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              },
              icon: const Icon(Icons.person, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void logout(BuildContext context) async {
    try {
      final auth = FirebaseAuth.instance;
      await auth.signOut();
      SharedPreferences sh = await SharedPreferences.getInstance();
      sh.remove('USER_ID');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      showErrorSnackbar(context, e.toString());
    }
  }

  void showErrorSnackbar(BuildContext context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        showCloseIcon: false,
      ),
    );
  }
}
