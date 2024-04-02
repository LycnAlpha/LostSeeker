import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobile/models/message_model.dart';
import 'package:flutter_mobile/models/user_model.dart';
import 'package:flutter_mobile/screens/add.dart';
import 'package:flutter_mobile/screens/message.dart';
import 'package:flutter_mobile/screens/profile.dart';
import 'package:flutter_mobile/shared_preference_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

      final DocumentSnapshot snapShot = await FirebaseFirestore.instance
          .collection('users')
          .withConverter(
              fromFirestore: UserModel.fromFirestore,
              toFirestore: (UserModel user, options) => user.toFirestore())
          .doc(uid)
          .get();

      UserModel user = snapShot.data() as UserModel;

      MessageModel message = MessageModel(
          senderID: uid,
          receiverID: receiverID,
          message: _message.text,
          date: DateFormat('yyyy-MM-dd hh-mm a').format(DateTime.now()),
          senderContactNumber: user.contactNumber,
          senderUsername: user.username);

      final docRef = db
          .collection('messages')
          .withConverter(
              fromFirestore: MessageModel.fromFirestore,
              toFirestore: (MessageModel message, options) =>
                  message.toFirestore())
          .doc();

      docRef.set(message);
      Navigator.pop(context);
      showSuccessToast('Message Sent Successfully');
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                            'All Items',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Adding space between text and buttons
                        itemsList()
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
            snap['image'].toString() != ''
                ? GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: ((context) =>
                              viewImageDialog(snap['image'])));
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage('${snap['image']}'),
                    ),
                  )
                : CircleAvatar(
                    radius: 40,
                    child: Text(
                      snap['category'].toString().substring(0, 1),
                      style: const TextStyle(fontSize: 25),
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
                        TextStyle(fontSize: 12.0, color: Colors.grey.shade600),
                  ),
                  Text(
                    'Location: ${snap['location']}',
                    style:
                        TextStyle(fontSize: 12.0, color: Colors.grey.shade600),
                  ),
                  Text(
                    'Conatct Number: ${snap['contactNumber']}',
                    style:
                        TextStyle(fontSize: 12.0, color: Colors.grey.shade600),
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

  Widget viewImageDialog(imageUrl) {
    return PopScope(
        child: AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            "Image",
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.cancel,
              color: Colors.redAccent,
              size: 40.0,
            ),
          ),
        ],
      ),
      titlePadding: const EdgeInsets.all(15.0),
      contentPadding: const EdgeInsets.all(15.0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: SizedBox(
        height: 200,
        child: Image.network(imageUrl),
      ),
    ));
  }

  Widget itemsList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
      ),
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
              const Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Text(
                  'Please enter your message below',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
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
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      sendMessage(receiverID);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.lightGreen),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text(
                        "Send",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.red),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            )
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

  void showSuccessToast(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
        textColor: Colors.white,
        backgroundColor: Colors.green);
  }
}
