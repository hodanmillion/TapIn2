import 'package:flutter/material.dart';
import 'package:myapp/services/firestore/firestore.dart';
import 'package:myapp/utils/colors.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final String? gifUrl; // Added the gifUrl parameter
  final bool? isGif; // Added the gifUrl parameter

  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sentByMe,
      required this.gifUrl,
      required this.isGif // Updated the constructor to accept gifUrl
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: sentByMe ? AppColors.primaryColor : Colors.grey[300],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
  future: FirestoreDB().getUserDataByEmail(sender),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Text('...'); // Placeholder for loading state
    } else if (snapshot.hasError || snapshot.data == null) {
      return Text('user'); // Handle the error or null data
    }
    if (snapshot.data != null) {
      print('snap data username: ${snapshot.data['username']}');
      return Text(
        sentByMe ? 'you' : snapshot.data['username'],
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      );
    } else {
      return Text('user'); // Handle other unexpected cases
    }
  }
),

            if (isGif!) // Check if gifUrl is not null

              SizedBox(
                width: 150, // Adjust the width as needed
                child: Image.network(
                  gifUrl!,
                  errorBuilder: (context, error, stackTrace) => Container(),
                  width: 150, // Adjust the width as needed
                ),
              ),
            Text(
              message,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimestampedMessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final String time;
  final bool sentByMe;
  final String? gifUrl; // Added the gifUrl parameter
  final bool? isGif; // Added the gifUrl parameter

  const TimestampedMessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.time,
      required this.sentByMe,
      this.gifUrl,
      required this.isGif // Updated the constructor to accept gifUrl
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        MessageTile(
          message: message,
          sender: sender,
          sentByMe: sentByMe,
          gifUrl: gifUrl,
          isGif: isGif, // Pass the gifUrl to the MessageTile
        ),
        // Padding for space below the timestamp
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 12),
          child: Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black45,
            ),
          ),
        ),
      ],
    );
  }
}
