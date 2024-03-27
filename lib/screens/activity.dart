import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile/shared_preference_helper.dart';

class Activity extends StatefulWidget {
  const Activity({Key? key}) : super(key: key);

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  void deleteItem(docID, BuildContext context) {
    try {
      final db = FirebaseFirestore.instance;
      db.collection('items').doc(docID).delete();
      showSuccessSnackbar('Item Deleted Successfully', context);
    } catch (e) {
      showErrorSnackbar(e.toString(), context);
    }
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

  void showSuccessSnackbar(message, BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Activity"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: 400,
              height: 100,
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
                    'My Activity',
                    style: TextStyle(color: Colors.white),
                  ),
                  myItemsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemCard(snap, docID, BuildContext context) {
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
                  setState(() {
                    deleteItem(docID, context);
                  });
                },
                icon: const Icon(Icons.cancel))
          ],
        ),
      ),
    );
  }

  Widget myItemsList() {
    final uid = SharedPreferenceHelper.getUserID();
    return Expanded(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('items')
              .where('userID', isEqualTo: uid)
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
                      child: itemCard(snapshot.data!.docs[index].data(),
                          snapshot.data!.docs[index].id, context),
                    )));
          }),
    );
  }
}
