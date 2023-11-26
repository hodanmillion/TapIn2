import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/controller/PrivateChatController.dart';
import '../routes/app_route.dart';

import 'package:myapp/models/RemoteUser.dart';

class UserPrivateProfilePage extends StatefulWidget {
  const UserPrivateProfilePage({Key? key}) : super(key: key);

  @override
  State<UserPrivateProfilePage> createState() =>
      _UserPrivateProfilePageState();
}

class _UserPrivateProfilePageState extends State<UserPrivateProfilePage> {
  final prController = Get.find<PrivateChatController>();

  @override
  Widget build(BuildContext context) {
    RemoteUser? remoteUser = prController.remoteUser;

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
                (remoteUser?.profileImage ?? '') != ''
                    ? InkWell(
                        onTap: () {
                          Map<String, String> params = {
                            "imageUrl": remoteUser?.profileImage ?? '',
                          };
                          Get.toNamed(PageConst.imageView,
                              arguments: params);
                        },
                        child: Obx(
                          () => ClipOval(
                            child: CachedNetworkImage(
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              fit: BoxFit.cover,
                              imageUrl: remoteUser?.profileImage ?? '',
                              width: 100.0,
                              height: 100.0,
                            ),
                          ),
                        ),
                      )
                    : Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 60,
                      ),
                SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Text(
                    remoteUser?.name ?? '',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25,
                          letterSpacing: .5),
                    ),
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
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.grey,
                                letterSpacing: .5),
                          ),
                        ),
                        subtitle: Obx(
                          () => Text(
                            remoteUser?.name ?? '',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 25,
                                  letterSpacing: .5),
                            ),
                          ),
                        ),
                      ),
                      tile(title: "Email Address", subTitle: remoteUser?.email ?? ''),
                      tile(title: "Location", subTitle: remoteUser?.location ?? ''),
                    ],
                  ),
                ),
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
