import 'package:cloud_firestore/cloud_firestore.dart';

import 'message.dart';

class MessageModel extends MessagePublicChat {
  MessageModel(
      {final String? senderId,
      final String? senderEmail,
      final String? message,
      final DateTime? timestamp,
      final String? gifUrl,
      final bool? isGif})
      : super(
            senderId: senderId!,
            senderEmail: senderEmail!,
            message: message!,
            timestamp: timestamp!,
            gifUrl: gifUrl!,
            isGif: isGif!);

//This is where we define from json and to json methods.

  static MessageModel fromJson(DocumentSnapshot json) {
    DateTime dt = (json.get('time') as Timestamp).toDate();

    // var date = DateTime.fromMillisecondsSinceEpoch(json.get('datetime') * 1000);
print("===giffff"+json.get('gifUrl'));
    return MessageModel(
        senderId: json.get('sender'),
        senderEmail: json.get('sendername'),
        message: json.get('message'),
        gifUrl: json.get('gifUrl'),
        isGif: json.get('isGif'),
        timestamp: dt);
  }

  Map<String, dynamic> toJson() {
    return {
      "sender": senderId,
      "sendername": senderEmail,
      "message": message,
      "time": timestamp,
      "gifUrl": gifUrl,
      "isGif": isGif
    };
  }
}
