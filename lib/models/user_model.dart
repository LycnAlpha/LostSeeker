import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? username;
  final String? email;
  final String? contactNumber;
  final String? userID;

  UserModel({this.username, this.email, this.contactNumber, this.userID});

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return UserModel(
        username: data?['username'],
        email: data?['email'],
        contactNumber: data?['contactNumber'],
        userID: data?['userID']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (contactNumber != null) 'contactNumber': contactNumber,
      if (userID != null) 'userID': userID,
    };
  }
}
