import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile/screens/add.dart';
import 'package:flutter_mobile/screens/home.dart';
import 'package:flutter_mobile/screens/profile.dart';
import 'package:flutter_mobile/shared_preference_helper.dart';

class Message extends StatelessWidget {
  const Message({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        width: 400,
        height: 300,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              'Receieved Messages',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20), // Adding space between text and buttons
            myMessagesList(),
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
            const Icon(
              Icons.message,
              color: Colors.white,
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

  Widget messageCard(snap, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getSenderUsername(snap['senderID'], context),
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            Text(
              'Message: ${snap['message']}',
              style: TextStyle(fontSize: 15.0, color: Colors.grey.shade600),
            ),
            Text(
              '${snap['date']}',
              style: TextStyle(fontSize: 15.0, color: Colors.grey.shade600),
            ),
            Text(
              'Conatct Number: ${getSenderContact(snap['senderID'], context)}',
              style: TextStyle(fontSize: 15.0, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget myMessagesList() {
    final uid = SharedPreferenceHelper.getUserID();
    return Expanded(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('items')
              .where('receiverID', isEqualTo: uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: ((context, index) => Container(
                      child: messageCard(
                          snapshot.data!.docs[index].data(), context),
                    )));
          }),
    );
  }

  String getSenderUsername(senderID, BuildContext context) {
    String senderUsername = '';
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(senderID)
          .get()
          .then((value) {
        senderUsername = value['username'];
      });
    } catch (e) {
      showErrorSnackbar(e.toString(), context);
    }

    return senderUsername;
  }

  String getSenderContact(sendeID, BuildContext context) {
    String senderContactNumber = '';
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(sendeID)
          .get()
          .then((value) {
        senderContactNumber = value['contactNumber'];
      });
    } catch (e) {
      showErrorSnackbar(e.toString(), context);
    }

    return senderContactNumber;
  }

  void showErrorSnackbar(message, BuildContext context) {
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
