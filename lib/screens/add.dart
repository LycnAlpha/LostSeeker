import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile/models/item_model.dart';
import 'package:flutter_mobile/screens/activity.dart';
import 'package:flutter_mobile/screens/home.dart';
import 'package:flutter_mobile/screens/message.dart';
import 'package:flutter_mobile/screens/profile.dart';
import 'package:flutter_mobile/shared_preference_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();

  Uint8List? _image;
  File? selectedImage;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Item"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const Column(
                  children: <Widget>[
                    Text(
                      "Add Item",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Center(
                    child: Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 100,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : const CircleAvatar(
                                radius: 100,
                                backgroundImage: NetworkImage(
                                    "https://www.google.com/url?sa=i&url=https%3A%2F%2Fdepositphotos.com%2Fvectors%2Fuser-profile.html&psig=AOvVaw3r4DnES6jSQgO3ubuM7BtW&ust=1710902982920000&source=images&cd=vfe&opi=89978449&ved=0CBMQjRxqFwoTCMjMrrao_4QDFQAAAAAdAAAAABAJ"),
                              ),
                        Positioned(
                          bottom: 0,
                          left: 140,
                          child: IconButton(
                            onPressed: () {
                              showImagePickerOption(context);
                            },
                            icon: const Icon(Icons.add_a_photo),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    controller: _title,
                    decoration: InputDecoration(
                        hintText: "Title",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: const Color.fromARGB(255, 40, 5, 238)
                            .withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.title)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    controller: _location,
                    decoration: InputDecoration(
                        hintText: "Location",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: const Color.fromARGB(255, 40, 5, 238)
                            .withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.location_city)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: "Category",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: const Color.fromARGB(255, 40, 5, 238)
                          .withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.category),
                    ),
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                    items: <String>['Bag', 'wallet', 'Mobile', 'Pet']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    controller: _contactNumber,
                    decoration: InputDecoration(
                      hintText: "Contact",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: const Color.fromARGB(255, 40, 5, 238)
                          .withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.mobile_friendly),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: ElevatedButton(
                    onPressed: () {
                      uploadImage();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color.fromARGB(255, 193, 235, 8),
                    ),
                    child: const Text(
                      "Add Item",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
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

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.blue[100],
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImageFromGallery();
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 70,
                          ),
                          Text("Gallery")
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImageFromCamera();
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera,
                            size: 70,
                          ),
                          Text("Camera")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //gallery
  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop();
  }

  //camera
  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop();
  }

  void uploadImage() async {
    try {
      final uid = await SharedPreferenceHelper.getUserID();
      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef.child('items');
      final spaceRef = imagesRef.child(
          '$uid/${_title.text}_${_location.text}_$selectedCategory.${selectedImage!.path.split('.').last}');
      if (selectedImage != null) {
        final uploadTask = spaceRef.putFile(selectedImage!);

        uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
          switch (taskSnapshot.state) {
            case TaskState.running:
              final progress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              showSuccessToast("Upload is $progress% complete.");

              break;
            case TaskState.paused:
              showErrorSnackbar('Image upload paused');
              break;
            case TaskState.canceled:
              showErrorSnackbar('Image upload canceled');
              break;
            case TaskState.error:
              showErrorSnackbar('Image upload error occured');
              break;
            case TaskState.success:
              saveItemDetails(spaceRef);
              break;
          }
        });
      }
    } catch (e) {
      print(e.toString());
      showErrorSnackbar(e.toString());
    }
  }

  void saveItemDetails(storageRef) async {
    try {
      final String imageUrl = await storageRef.getDownloadURL();
      final uid = await SharedPreferenceHelper.getUserID();
      final db = FirebaseFirestore.instance;

      ItemModel item = ItemModel(
          imageUrl: imageUrl,
          userID: uid,
          title: _title.text,
          category: selectedCategory,
          location: _location.text,
          contactNumber: _contactNumber.text);

      final docRef = db
          .collection('items')
          .withConverter(
              fromFirestore: ItemModel.fromFirestore,
              toFirestore: (ItemModel item, options) => item.toFirestore())
          .doc();
      docRef.set(item);
      showSuccessToast('Item added successfully');
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Activity()),
      );
    } catch (e) {
      print(e.toString());
      showErrorSnackbar(e.toString());
    }
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
