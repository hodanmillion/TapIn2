import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:myapp/controller/chat_controller.dart';
import 'package:myapp/controller/past_chat_controller.dart';

import '../components/message_tile.dart';
import '../model/message.dart';

class PastChatView extends GetView<PastChatListController> {
  final controller = Get.find<PastChatListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text("Chats - ${controller.streetName}",
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Container(

        child: Stack(
          children: <Widget>[
            Obx(() => controller.messagesList.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 60),
                    itemCount: controller.messagesList.length,
                    itemBuilder: (context, index) {
                      return MessageTile(
                        message: controller.messagesList[index].message,
                        sender: controller.messagesList[index].senderEmail,
                        sentByMe: controller.firebaseAuth.currentUser?.uid ==
                            controller.messagesList[index].senderId,
                        gifUrl: controller.messagesList[index].gifUrl,
                        isGif: controller.messagesList[index].isGif,
                      );
                    },
                  )
                : Container()),
          ],
        ),
      ),
    );
  }

  chatMessages() {
    return controller.messagesList.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.only(bottom: 60),
            itemCount: controller.messagesList.length,
            itemBuilder: (context, index) {
              return MessageTile(
                message: controller.messagesList[index].message,
                sender: controller.messagesList[index].senderEmail,
                sentByMe: controller.firebaseAuth.currentUser?.uid ==
                    controller.messagesList[index].senderId,
                gifUrl: controller.messagesList[index].gifUrl,
                isGif: controller.messagesList[index].isGif,
              );
            },
          )
        : Container();
  }
}
