import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/services/firestore/firestore.dart';
import '../controller/UserController.dart';
import '../routes/app_route.dart';
import '../services/storage/fire_storage.dart';
import '../utils/colors.dart';
import '../utils/image_select.dart';
import '../utils/upload_image_dialogue.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final controller = Get.find<UserController>();

  @override
  void initState() {
    super.initState();

    controller.getUserAppLocation(_auth!.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    // final Map<String, String> params = Get.arguments;
    // // Access the parameters
    // final String email = params['email'] ?? '';
    // final String userName = params['userName'] ?? '';
    // final String userImage = params['userImage'] ?? '';
    // final String location = params['location'] ?? '';
    // final String isMainUSer = params['isMainUSer'] ?? '';
    // final String userId = params['userId'] ?? '';
    // print("emasail $email");

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                (controller.emailP.value != '')
                    ? Stack(
                        children: [
                          Obx(
                            () => InkWell(
                              onTap: () {
                                Map<String, String> params = {
                                  "imageUrl": controller.userImageP.value ?? '',
                                };
                                Get.toNamed(PageConst.imageView,
                                    arguments: params);
                              },
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  fit: BoxFit.cover,
                                  imageUrl: controller.userImage.value,
                                  width: 100.0,
                                  height: 100.0,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0, // Adjust the position as needed
                            right: 0, // Adjust the position as needed
                            child: GestureDetector(
                              onTap: () {
                                // Handle the "change image" action when the icon is tapped
                                // You can show a file picker or trigger any other action here.
                                showUploadOption(context, () async {
                                  print('gallery');
                                  Uint8List? imageCode =
                                      await handleImageUpload(
                                          ImageSource.gallery);
                                  if (imageCode != null) {
                                    try {
                                      String imageUrl = await StorageMethods()
                                          .uploadImageToStorage(
                                              'profilePics/${controller.userIdP.value}',
                                              imageCode,
                                              false);

                                      print("=====image url--" + imageUrl);
                                      print("=====room--" + imageUrl);

                                      print('image uploaded: $imageUrl');
                                      // TODO - save image url in firebase firestore in the chat
                                      controller.userImage.value = imageUrl;
                                      await controller.updateProImage(
                                          userId: controller.userIdP.value,
                                          newImageUrl: imageUrl);
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    } catch (e) {
                                      print('error occurred: $e');
                                    }
                                  }
                                }, () async {
                                  print('camera');
                                  Uint8List? imageCode =
                                      await handleImageUpload(
                                          ImageSource.camera);
                                  if (imageCode != null) {
                                    try {
                                      String imageUrl = await StorageMethods()
                                          .uploadImageToStorage(
                                              'profilePics/${controller.userIdP.value}',
                                              imageCode,
                                              false);
                                      print('image uploaded: $imageUrl');
                                      controller.userImage.value = imageUrl;
                                      await controller.updateProImage(
                                          userId: controller.userIdP.value,
                                          newImageUrl: imageUrl);

                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    } catch (e) {
                                      print('error occurred: $e');
                                    }
                                  }
                                }, true);
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryColor,
                                  // Customize the color as needed
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(8.0),
                                // Adjust the padding as needed
                                child: const Icon(
                                  Icons.edit,
                                  // Use an appropriate icon for "change image"
                                  color: Colors.white,
                                  // Customize the color as needed
                                  size: 24.0, // Customize the size as needed
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 60,
                      ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  controller.userNameP.value,
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25,
                        letterSpacing: .5),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                color: Colors.black,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
                      ),
                      border: Border.all(
                        width: 3,
                        color: Colors.white,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          title: Text(
                            "Display Name",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey,
                                  letterSpacing: .5),
                            ),
                          ),
                          subtitle: Text(
                            controller.userNameP.value,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 25,
                                  letterSpacing: .5),
                            ),
                          ),
                        ),
                        tile(
                            title: "Email Address",
                            subTitle: controller.emailP.value),
                        Obx(
                          () => tile(
                              title: "Location",
                              subTitle: controller.userAppLocation.value),
                        ),
                        InkWell(
                          onTap: () {
                            print('delete account');
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text('Deleting Account!'),
                                      content: const Text(
                                          'are you sure you want to delete your account?'),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            print('Delete account logic');
                                            bool result = await FirestoreDB()
                                                .deleteUserData('');
                                            if (result == false) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'error deleting account try again later'),
                                                  ),
                                                );
                                              }
                                              Get.toNamed(PageConst.login);
                                            }
                                          },
                                          child: const Text(
                                            'delete account',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        // Expanded(child: Container()),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('cancel'),
                                        ),
                                      ],
                                    ));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Delete Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tile({required String title, required String subTitle}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        title,
        style: GoogleFonts.openSans(
          textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.grey,
              letterSpacing: .5),
        ),
      ),
      subtitle: Text(
        subTitle,
        style: GoogleFonts.openSans(
          textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18,
              letterSpacing: .5),
        ),
      ),
    );
  }
}
