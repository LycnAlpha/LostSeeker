import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile/shared_preference_helper.dart';

class Activity extends StatefulWidget {
  const Activity({Key? key}) : super(key: key);

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'My Activity',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      myItemsList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
            snap['image'].toString() != ''
                ? CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('${snap['image']}'),
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) => Container(
                          child: itemCard(snapshot.data!.docs[index].data(),
                              snapshot.data!.docs[index].id, context),
                        )));
              }
            }),
      ),
    );
  }
}
