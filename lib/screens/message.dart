import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile/screens/add.dart';
import 'package:flutter_mobile/screens/home.dart';
import 'package:flutter_mobile/screens/profile.dart';
import 'package:flutter_mobile/shared_preference_helper.dart';

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  String uid = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        getUserID();
      });
    });

    super.initState();
  }

  void getUserID() async {
    uid = await SharedPreferenceHelper.getUserID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Receieved Messages',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                myMessagesList(),
              ],
            ),
          ),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              snap['senderUsername'],
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            Text(
              'Message: ${snap['message']}',
              style: TextStyle(fontSize: 15.0, color: Colors.grey.shade600),
            ),
            Text(
              'Conatct Number: ${snap['senderContactNumber']}',
              style: TextStyle(fontSize: 15.0, color: Colors.grey.shade600),
            ),
            Text(
              '${snap['date']}',
              style: TextStyle(fontSize: 15.0, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget myMessagesList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('messages')
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
      ),
    );
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
