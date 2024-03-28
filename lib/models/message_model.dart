import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? senderID;
  final String? receiverID;
  final String? message;
  final String? date;
  final String? senderUsername;
  final String? senderContactNumber;

  MessageModel({
    this.senderID,
    this.receiverID,
    this.message,
    this.date,
    this.senderUsername,
    this.senderContactNumber,
  });

  factory MessageModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return MessageModel(
        senderID: data?['senderID'],
        receiverID: data?['receiverID'],
        message: data?['message'],
        date: data?['date'],
        senderUsername: data?['senderUsername'],
        senderContactNumber: data?['senderContactNumber']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (senderID != null) 'senderID': senderID,
      if (receiverID != null) 'receiverID': receiverID,
      if (message != null) 'message': message,
      if (date != null) 'date': date,
      if (senderUsername != null) 'senderUsername': senderUsername,
      if (senderContactNumber != null)
        'senderContactNumber': senderContactNumber,
    };
  }
}
