import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile/models/message_model.dart';
import 'package:flutter_mobile/screens/add.dart';
import 'package:flutter_mobile/screens/message.dart';
import 'package:flutter_mobile/screens/profile.dart';
import 'package:flutter_mobile/shared_preference_helper.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _message = TextEditingController();

  void sendMessage(receiverID) async {
    try {
      final uid = await SharedPreferenceHelper.getUserID();
      final db = FirebaseFirestore.instance;

      MessageModel message = MessageModel(
          senderID: uid,
          receiverID: receiverID,
          message: _message.text,
          date: DateFormat('yyyy-MM-dd hh-mm a').format(DateTime.now()));

      final docRef = db
          .collection('messages')
          .withConverter(
              fromFirestore: MessageModel.fromFirestore,
              toFirestore: (MessageModel message, options) =>
                  message.toFirestore())
          .doc();

      docRef.set(message);
      Navigator.pop(context);
      showSuccessSnackbar('Message Sent Successfully');
    } catch (e) {
      showErrorSnackbar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: 400,
              height: 50,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'ALl Items',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  // Adding space between text and buttons
                  itemsList()
                ],
              ),
            ),
          ),
        ],
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

  Widget itemCard(snap) {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: SizedBox(
                height: 100,
                child: Image.network(snap['imageUrl']),
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${snap['title']}',
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Category: ${snap['category']}',
                    style:
                        TextStyle(fontSize: 15.0, color: Colors.grey.shade600),
                  ),
                  Text(
                    'Location: ${snap['location']}',
                    style:
                        TextStyle(fontSize: 15.0, color: Colors.grey.shade600),
                  ),
                  Text(
                    'Conatct Number: ${snap['contactNumber']}',
                    style:
                        TextStyle(fontSize: 15.0, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: ((context) => messageDialogBox(snap['userID'])));
                },
                icon: const Icon(Icons.message))
          ],
        ),
      ),
    );
  }

  Widget itemsList() {
    return Expanded(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('items').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: ((context, index) => Container(
                      child: itemCard(snapshot.data!.docs[index].data()),
                    )));
          }),
    );
  }

  Widget messageDialogBox(receiverID) {
    return PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text(
            'Send a message',
            style: TextStyle(color: Color(0xff329BFC)),
          ),
          titlePadding: const EdgeInsets.all(15.0),
          contentPadding: const EdgeInsets.all(15.0),
          actionsPadding: const EdgeInsets.all(15.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please enter your message below',
                textAlign: TextAlign.center,
              ),
              TextField(
                controller: _message,
                decoration: InputDecoration(
                    hintText: "Message",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor:
                        const Color.fromARGB(255, 40, 5, 238).withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.message)),
              ),
            ],
          ),
          actions: [
            Container(
                padding: const EdgeInsets.only(top: 3, left: 3),
                child: ElevatedButton(
                  onPressed: () {
                    sendMessage(receiverID);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color.fromARGB(255, 193, 235, 8),
                  ),
                  child: const Text(
                    "Send Message",
                    style: TextStyle(fontSize: 20),
                  ),
                )),
            Container(
                padding: const EdgeInsets.only(top: 3, left: 3),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontSize: 20),
                  ),
                )),
          ],
        ));
  }

  void showErrorSnackbar(message) {
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

  void showSuccessSnackbar(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        showCloseIcon: false,
      ),
    );
  }
}
