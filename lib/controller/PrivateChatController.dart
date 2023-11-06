import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/message_chat.dart';

class PrivateChatController extends GetxController {
  FirebaseAuth? firebaseAuth = null;
  FirebaseFirestore? fireStore = null;
  RxList<Message> messages = RxList<Message>();
  final messageController = TextEditingController().obs;
  final searchGifText = TextEditingController().obs;

  Future<void> sendMessage(String receiverId, String message) async {
    //get current user info

    final String currentUserId = firebaseAuth!.currentUser!.uid;
    final String currentUserEmail = firebaseAuth!.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    //create a new message
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        timestamp: timestamp,
        message: message,
        gifUrl: selectedGifUrl.value,
        isGif: selectedGifUrl.value.isNotEmpty ? true : false);
    //construct chat room id from current user id and receiver id
    searchGifText.value.text = "";

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    print("=====image gallary--" + selectedGifUrl.value);
    await fireStore!
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
    //add new msg to db
  }

  //GET MSG
  getMessageRoomID(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    print("====romm id--" + chatRoomId);
    return chatRoomId;
  }

  getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    var query = fireStore!
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false);

    var message = query.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => Message.fromJson(docSnap))
          .toList();
    });

    messages.bindStream(message);
  }

  Future<void> getUserLocation(String userId) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      print("==userid==" + userId);
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final Position position = await Geolocator.getCurrentPosition();
        final double latitude = position.latitude;
        final double longitude = position.longitude;

        final List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
        if (placemarks.isNotEmpty) {
          final Placemark placemark = placemarks.first;
          final String address =
              "${placemark.locality}, ${placemark.administrativeArea}";
          userLocation.value = address;
        }
      } else {
        print('Location permission denied');
      }
    } catch (e) {
      print('Error retrieving user location: $e');
    }
  }

  Future<bool> checkIfContacts() async {
    final currentUserUid = firebaseAuth!.currentUser?.uid;
    if (currentUserUid != null) {
      final contactsQuery = FirebaseFirestore.instance
          .collection('contacts')
          .where('userId', isEqualTo: currentUserUid)
          .where('contactId', isEqualTo: receiverUserID);

      final contactsSnapshot = await contactsQuery.get();

      print("Number of contacts found: ${contactsSnapshot.docs.length}");

      return contactsSnapshot.docs.isNotEmpty;
    }
    print("Current user UID is null.");
    return false;
  }

  var receiverUserID = "".obs;
  var receiverUserEmail = "".obs;
  var senderId = "".obs;

  RxString userLocation = 'Loading location...'.obs;
  RxString emailP = 'Loading ...'.obs;
  RxString userNameP = 'Loading ...'.obs;
  RxString userImageP = 'Loading ...'.obs;
  RxString isMainUSerP = 'Loading ...'.obs;




  RxList<String> gifUrl = RxList<String>();

  String searchGifString = "";

  static const String apiKey =
      'l1WfAFgqA5WupWoMaCaWKB12G54J6LtZ'; // Replace with your GIPHY API key
  static const String endpoint =
      'https://api.giphy.com/v1/gifs/trending?api_key=$apiKey&limit=10';

  RxList<String> titleGif = RxList<String>();

  RxString selectedGifUrl = ''.obs;

  RxBool isSeachActive = false.obs;

  cancelSearch() {
    isSeachActive.value = false;
    gifUrl.clear();
    titleGif.clear();
    fetchGifs();
    searchGifText.value.text = "";
  }

  searchByGifName() async {
    isSeachActive.value = true;
    final response = await http.get(Uri.parse(
        'https://api.giphy.com/v1/gifs/search?api_key=$apiKey&limit=10&q=${searchGifText.value.text.toString().trim()}'));
    if (response.statusCode == 200) {
      gifUrl.clear();
      titleGif.clear();
      final data = json.decode(response.body);
      gifUrl.addAll(List<String>.from(
          data['data'].map((x) => x['images']['original']['url'])));
      titleGif.addAll(List<String>.from(data['data'].map((x) => x['title'])));
    } else {
      throw Exception('Failed to load GIFs');
    }
  }

  fetchGifs() async {
    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      gifUrl.addAll(List<String>.from(
          data['data'].map((x) => x['images']['original']['url'])));

      titleGif.addAll(List<String>.from(data['data'].map((x) => x['title'])));
    } else {
      throw Exception('Failed to load GIFs');
    }
  }
  Future<bool?> updateReadMessage({required String doc, required bool isRead}) async {
    try {
      final user = firebaseAuth!.currentUser;
      if (user != null) {
        final currentUserUid = user.uid;
        // Query for unread messages in the 'contacts' collection
        final unreadMessagesQuery = FirebaseFirestore.instance
            .collection('accepted_c')
            .doc(doc)
            .collection('contacts')
            .doc(currentUserUid)
            .update({"isRead": isRead});
      }
    } catch (error) {
      // Handle any other errors that might occur during data retrieval
      print("Failed to fetch accepted contacts: $error");
    }
  }

  @override
  void onInit() {
    super.onInit();
    firebaseAuth = FirebaseAuth.instance;
    fireStore = FirebaseFirestore.instance;

    receiverUserID.value = Get.parameters["receiverUserID"]!;
    receiverUserEmail.value = Get.parameters["receiverUserEmail"]!;
    senderId.value = Get.parameters["senderId"]!;

    getUserLocation(receiverUserID.value);
    getMessages(firebaseAuth!.currentUser!.uid, receiverUserID.value);
    fetchGifs();
  }
}
