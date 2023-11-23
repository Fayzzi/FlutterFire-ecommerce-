import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mad_project_ecommerce/Screens/AdminPanel/ItemsFav/Favorite.dart';
import 'package:mad_project_ecommerce/Screens/AdminPanel/ProfilePicture/AdminProfile.dart';
import 'package:mad_project_ecommerce/Screens/AdminPanel/RecentlyViewed/RecentlyViewed.dart';
import 'package:mad_project_ecommerce/Screens/AdminPanel/uploadedproduct/uploadedProduct.dart';

import 'ItemCarted/Carted.dart';

class ImageController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  User? user = FirebaseAuth.instance.currentUser;

  RxString imageUrl = ''.obs;
  File? file;
  Future pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;
    file = File(pickedFile.path);
    Reference ref = FirebaseStorage.instance
        .ref('Users')
        .child(user!.uid)
        .child('Profile Picture')
        .child('profile_image.jpg');
    await ref.putFile(file!);
    imageUrl.value = await ref.getDownloadURL();
    print(imageUrl.value);
    if (user!.uid == FirebaseAuth.instance.currentUser!.uid) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(user!.uid)
          .update({"Profile Picture": imageUrl.value});
    }
  }
}

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  ImageController controller = Get.put(ImageController());
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Admin",
            style: TextStyle(color: Colors.black, fontSize: 23),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(user!.uid)
                      .snapshots(),
                  builder: (context, usersnapshot) {
                    if (usersnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      );
                    }
                    if (usersnapshot.hasError) {
                      return Center(
                        child: Text(usersnapshot.error.toString()),
                      );
                    }
                    if (!usersnapshot.hasData || !usersnapshot.data!.exists) {
                      return const Center(
                        child: Text(
                            "An error has occurred, please try again later"),
                      );
                    }
                    if (usersnapshot.hasData || usersnapshot.data!.exists) {
                      Map<String, dynamic> userData =
                          usersnapshot.data!.data() as Map<String, dynamic>;
                      String userPic = userData['Profile Picture'] ?? "";

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          userPic != ''
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileView(imagel: userPic)));
                                  },
                                  child: Hero(
                                      tag: "PROF",
                                      child: CachedNetworkImage(
                                        imageUrl: userPic,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CupertinoActivityIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                          child: Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        ),
                                        imageBuilder: (context, ImageProvider) {
                                          return Container(
                                              alignment: Alignment.topRight,
                                              height: 200,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: ImageProvider,
                                                      fit: BoxFit.cover),
                                                  shape: BoxShape.circle),
                                              child: GestureDetector(
                                                onTap: () {
                                                  controller.pickImage();
                                                },
                                                child: const CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.white,
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.black,
                                                    size: 30,
                                                  ),
                                                ),
                                              ));
                                        },
                                      )),
                                )
                              : Container(
                                  alignment: Alignment.topRight,
                                  height: 200,
                                  width: 200,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.pickImage();
                                    },
                                    child: const CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('images/user.jpg'),
                                          fit: BoxFit.cover),
                                      shape: BoxShape.circle),
                                ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Divider(
                                    thickness: 0.7,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 2, right: 2),
                                  child: Text(
                                    formatDateTime(userData['Date Joined']),
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(
                                    thickness: 0.7,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          if (userData['Username'] != null)
                            ListTile(
                                leading: const Icon(Icons.person),
                                title: const Text(
                                  "Username",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 19),
                                ),
                                subtitle: Text(
                                  userData['Username'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14),
                                )),
                          if (userData['Email'] != null)
                            ListTile(
                                leading: const Icon(Icons.email),
                                title: const Text(
                                  "Email",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 19),
                                ),
                                subtitle: Text(
                                  userData['Email'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14),
                                )),
                          if (userData['Gender'] != null)
                            ListTile(
                                leading: userData['Gender'] == 'Rather not say'
                                    ? const Icon(Icons.question_mark)
                                    : userData['Gender'] == 'Male'
                                        ? const Icon(Icons.male)
                                        : const Icon(Icons.female),
                                title: const Text(
                                  "Gender",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 19),
                                ),
                                subtitle: Text(
                                  userData['Gender'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14),
                                )),
                          const SizedBox(
                            height: 15,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 0.7,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2, right: 2),
                                  child: Text(
                                    "Interactions",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 0.7,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(user!.uid)
                                  .collection('Fav')
                                  .snapshots(),
                              builder: (context, favsnap) {
                                if (favsnap.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.green,
                                    ),
                                  );
                                }
                                if (favsnap.hasError) {
                                  return Center(
                                    child: Text(favsnap.error.toString()),
                                  );
                                }
                                if (!favsnap.hasData) {
                                  return const Center(
                                    child: Text(
                                        "An error has occured please try again later"),
                                  );
                                } else {
                                  List<DocumentSnapshot> favDocs =
                                      favsnap.data!.docs;
                                  return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(user!.uid)
                                          .collection('Carted')
                                          .snapshots(),
                                      builder: (context, CartSnap) {
                                        if (CartSnap.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.green,
                                            ),
                                          );
                                        }
                                        if (CartSnap.hasError) {
                                          return Center(
                                            child:
                                                Text(CartSnap.error.toString()),
                                          );
                                        }
                                        if (!CartSnap.hasData) {
                                          return const Center(
                                            child: Text(
                                                "An error has occured please try again later"),
                                          );
                                        } else {
                                          List<DocumentSnapshot> CartDocs =
                                              CartSnap.data!.docs;
                                          return StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('Users')
                                                  .doc(user!.uid)
                                                  .collection('Viewed')
                                                  .snapshots(),
                                              builder: (context, ViewSnap) {
                                                if (ViewSnap.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.green,
                                                    ),
                                                  );
                                                }
                                                if (ViewSnap.hasError) {
                                                  return Center(
                                                    child: Text(ViewSnap.error
                                                        .toString()),
                                                  );
                                                }
                                                if (!ViewSnap.hasData) {
                                                  return const Center(
                                                    child: Text(
                                                        "An error has occured please try again later"),
                                                  );
                                                } else {
                                                  List<DocumentSnapshot>
                                                      ViewsDocs =
                                                      ViewSnap.data!.docs;
                                                  return StreamBuilder(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('Users')
                                                          .doc(user!.uid)
                                                          .collection(
                                                              'Products')
                                                          .snapshots(),
                                                      builder:
                                                          (context, MyUpload) {
                                                        if (MyUpload
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          );
                                                        }
                                                        if (MyUpload.hasError) {
                                                          return Center(
                                                            child: Text(MyUpload
                                                                .error
                                                                .toString()),
                                                          );
                                                        }
                                                        if (!MyUpload.hasData) {
                                                          return const Center(
                                                            child: Text(
                                                                "An error has occurred please try again later"),
                                                          );
                                                        } else {
                                                          List<DocumentSnapshot>
                                                              myDocs = MyUpload
                                                                  .data!.docs;
                                                          return SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Get.to(
                                                                        () =>
                                                                            RecentlyViewed(),
                                                                        transition:
                                                                            Transition.cupertino);
                                                                  },
                                                                  child: Card(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20)),
                                                                    elevation:
                                                                        4,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          150,
                                                                      width:
                                                                          150,
                                                                      decoration: BoxDecoration(
                                                                          gradient: const LinearGradient(
                                                                              begin: Alignment.topRight,
                                                                              end: Alignment.bottomCenter,
                                                                              colors: [
                                                                                Colors.blue,
                                                                                Colors.green
                                                                              ]),
                                                                          borderRadius:
                                                                              BorderRadius.circular(20)),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            const Text(
                                                                              "Recently Viewed",
                                                                              style: TextStyle(color: Colors.white, fontSize: 18),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 8,
                                                                            ),
                                                                            Icon(
                                                                              Icons.visibility,
                                                                              color: Colors.white,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 8,
                                                                            ),
                                                                            Text(
                                                                              ViewsDocs.length.toString(),
                                                                              style: const TextStyle(color: Colors.white, fontSize: 17),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 6,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Get.to(
                                                                        () =>
                                                                            UploadedProducts(),
                                                                        transition:
                                                                            Transition.cupertino);
                                                                  },
                                                                  child: Card(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20)),
                                                                    elevation:
                                                                        4,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          150,
                                                                      width:
                                                                          150,
                                                                      decoration: BoxDecoration(
                                                                          gradient: const LinearGradient(
                                                                              begin: Alignment.topRight,
                                                                              end: Alignment.bottomCenter,
                                                                              colors: [
                                                                                Colors.blue,
                                                                                Colors.green
                                                                              ]),
                                                                          borderRadius:
                                                                              BorderRadius.circular(20)),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            const Text(
                                                                              "my Uploads",
                                                                              style: TextStyle(color: Colors.white, fontSize: 18),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 8,
                                                                            ),
                                                                            FaIcon(
                                                                              FontAwesomeIcons.cloudArrowUp,
                                                                              color: Colors.white,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 8,
                                                                            ),
                                                                            Text(
                                                                              myDocs.length.toString(),
                                                                              style: const TextStyle(color: Colors.white, fontSize: 17),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 6,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Get.to(
                                                                        () =>
                                                                            MyFavorite(),
                                                                        transition:
                                                                            Transition.cupertino);
                                                                  },
                                                                  child: Card(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20)),
                                                                    elevation:
                                                                        4,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          150,
                                                                      width:
                                                                          150,
                                                                      decoration: BoxDecoration(
                                                                          gradient: const LinearGradient(
                                                                              begin: Alignment.topRight,
                                                                              end: Alignment.bottomCenter,
                                                                              colors: [
                                                                                Colors.blue,
                                                                                Colors.green
                                                                              ]),
                                                                          borderRadius:
                                                                              BorderRadius.circular(20)),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            const Text(
                                                                              "Items Favorite",
                                                                              style: TextStyle(color: Colors.white, fontSize: 18),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 8,
                                                                            ),
                                                                            FaIcon(
                                                                              FontAwesomeIcons.solidHeart,
                                                                              color: Colors.red,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 8,
                                                                            ),
                                                                            Text(
                                                                              favDocs.length.toString(),
                                                                              style: const TextStyle(color: Colors.white, fontSize: 17),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 6,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Get.to(
                                                                        () =>
                                                                            CartedItems(),
                                                                        transition:
                                                                            Transition.cupertino);
                                                                  },
                                                                  child: Card(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20)),
                                                                    elevation:
                                                                        4,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          150,
                                                                      width:
                                                                          150,
                                                                      decoration: BoxDecoration(
                                                                          gradient: const LinearGradient(
                                                                              begin: Alignment.topRight,
                                                                              end: Alignment.bottomCenter,
                                                                              colors: [
                                                                                Colors.blue,
                                                                                Colors.green
                                                                              ]),
                                                                          borderRadius:
                                                                              BorderRadius.circular(20)),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            const Text(
                                                                              "Items Carted",
                                                                              style: TextStyle(color: Colors.white, fontSize: 18),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 8,
                                                                            ),
                                                                            FaIcon(
                                                                              FontAwesomeIcons.cartArrowDown,
                                                                              color: Colors.white,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 8,
                                                                            ),
                                                                            Text(
                                                                              CartDocs.length.toString(),
                                                                              style: const TextStyle(color: Colors.white, fontSize: 17),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                      });
                                                }
                                                return const SizedBox();
                                              });
                                        }
                                        return const SizedBox();
                                      });
                                }
                                return const SizedBox();
                              })
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String formatDateTime(dynamic timestamp) {
  if (timestamp == null) {
    return 'Invalid Date'; // Handle null timestamp case
  }

  DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = today.subtract(Duration(days: 1));
  DateTime twoDaysAgo = today.subtract(Duration(days: 2));

  if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day) {
    // Today
    return 'Today, ${DateFormat('h:mm a').format(dateTime)}';
  } else if (dateTime.year == yesterday.year &&
      dateTime.month == yesterday.month &&
      dateTime.day == yesterday.day) {
    // Yesterday
    return 'Yesterday, ${DateFormat('h:mm a').format(dateTime)}';
  } else if (dateTime.year == twoDaysAgo.year &&
      dateTime.month == twoDaysAgo.month &&
      dateTime.day == twoDaysAgo.day) {
    // Two days ago
    return 'Two days ago, ${DateFormat('h:mm a').format(dateTime)}';
  } else {
    // Exact date and time if exceeds two days
    return DateFormat('MMM dd, yyyy, h:mm a').format(dateTime);
  }
}
