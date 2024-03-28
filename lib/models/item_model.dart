import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String? imageUrl;
  final String? title;
  final String? location;
  final String? category;
  final String? contactNumber;
  final String? userID;

  ItemModel({
    this.imageUrl,
    this.title,
    this.location,
    this.category,
    this.contactNumber,
    this.userID,
  });

  factory ItemModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return ItemModel(
      imageUrl: data?['image'],
      title: data?['title'],
      location: data?['location'],
      category: data?['category'],
      contactNumber: data?['contactNumber'],
      userID: data?['userID'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (imageUrl != null) 'image': imageUrl,
      if (title != null) 'title': title,
      if (location != null) 'location': location,
      if (category != null) 'category': category,
      if (userID != null) 'userID': userID,
      if (contactNumber != null) 'contactNumber': contactNumber,
    };
  }
}
