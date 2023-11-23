import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mad_project_ecommerce/Screens/Add%20product/Addproduct.dart';
import 'package:mad_project_ecommerce/Screens/Categories/Accessories/Accessories.dart';
import 'package:mad_project_ecommerce/Screens/Categories/Cloths/tab.dart';
import 'package:mad_project_ecommerce/Screens/Categories/Furniture/Furniture.dart';
import 'package:mad_project_ecommerce/Screens/Categories/tools/Tools.dart';
import 'package:mad_project_ecommerce/Screens/ChatScreen/AllChatScreen/Allchatscreen.dart';
import 'package:mad_project_ecommerce/Screens/GridViewHelper/Helper.dart';
import 'package:mad_project_ecommerce/Screens/SearchScreen/SearchScreen.dart';
import '../../AuthServics/AuthServics.dart';
import '../Categories/Footwear/TabBar.dart';
import '../Categories/Gadgets/Gadgets.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Column(
            children: [
              SizedBox(
                height: 3,
              ),
              Text(
                "Shoppit",
                style: TextStyle(color: Colors.black, fontSize: 23),
              ),
              Text(
                "All you need is here",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  Get.defaultDialog(
                      title: "Logout",
                      content: const Text('Are you sure you want to Logout?'),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              Get.back();
                            },
                            child: const Text("No")),
                        TextButton(
                            onPressed: () async {
                              await AuthSevices().logout();
                            },
                            child: const Text("Yes")),
                      ]);
                },
                icon: FaIcon(FontAwesomeIcons.arrowRightFromBracket,color: Colors.black,))

          ],
          leading: IconButton(
              onPressed: () {
                Get.to(() => AllChatScreen());
              },
              icon: const FaIcon(
                FontAwesomeIcons.commentDots,
                color: Colors.black,
              )),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const SearchScreen(),
                        transition: Transition.cupertino);
                  },
                  child: AbsorbPointer(
                    absorbing: true,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.search),
                                hintText: "Search here",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30))),
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Categories",
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Get.to(() => Accessories(),
                              transition: Transition.cupertino);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [Colors.green, Colors.pink])),
                            height: 200,
                            width: 200,
                            child: Column(
                              children: [
                                Container(
                                  height: 175,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        topLeft: Radius.circular(25)),
                                    image: DecorationImage(
                                        image: AssetImage('images/acc.jpg'),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: const Text(
                                    "Accessories",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Get.to(() => TabBarFootwear(),
                              transition: Transition.cupertino);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [Colors.green, Colors.pink])),
                            child: Column(
                              children: [
                                Container(
                                  height: 175,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        topLeft: Radius.circular(25)),
                                    image: DecorationImage(
                                        image:
                                            AssetImage('images/footwear.jpg'),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: const Text(
                                    "Footwear",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Get.to(() => ClothsTab(),
                              transition: Transition.cupertino);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [Colors.green, Colors.pink])),
                            height: 200,
                            width: 200,
                            child: Column(
                              children: [
                                Container(
                                  height: 175,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        topLeft: Radius.circular(25)),
                                    image: DecorationImage(
                                        image: AssetImage('images/cloths.jpg'),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: const Text(
                                    "Clothing",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Get.to(() => Gadgets(),
                              transition: Transition.cupertino);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [Colors.green, Colors.pink])),
                            height: 200,
                            width: 200,
                            child: Column(
                              children: [
                                Container(
                                  height: 175,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        topLeft: Radius.circular(25)),
                                    image: DecorationImage(
                                        image: AssetImage('images/gad.jpg'),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: const Text(
                                    "Gadgets",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => Furniture(),
                              transition: Transition.cupertino);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [Colors.green, Colors.pink])),
                            height: 200,
                            width: 200,
                            child: Column(
                              children: [
                                Container(
                                  height: 175,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        topLeft: Radius.circular(25)),
                                    image: DecorationImage(
                                        image: AssetImage('images/fur.jpg'),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: const Text(
                                    "Furniture",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => Tools(),
                              transition: Transition.cupertino);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [Colors.green, Colors.pink])),
                            height: 200,
                            width: 200,
                            child: Column(
                              children: [
                                Container(
                                  height: 175,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        topLeft: Radius.circular(25)),
                                    image: DecorationImage(
                                        image: AssetImage('images/tools.jpg'),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: const Text(
                                    "Tools",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                          "Newly Arrived",
                          style: TextStyle(color: Colors.green, fontSize: 16),
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
                  height: 10,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Products")
                        .doc("All products")
                        .collection('All Products')
                        .snapshots(),
                    builder: (context, homepagesnap) {
                      if (homepagesnap.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        );
                      }
                      if (homepagesnap.hasError) {
                        return Center(
                          child: Text(homepagesnap.error.toString()),
                        );
                      }
                      if (!homepagesnap.hasData) {
                        return const Center(
                          child: Text(
                              "An error has occured please try again later"),
                        );
                      }
                      if (homepagesnap.hasData ||
                          homepagesnap.data!.docs.isNotEmpty) {
                        List<DocumentSnapshot> homepageDocs =
                            homepagesnap.data!.docs;
                        if (homepageDocs.isEmpty) {
                          return const Center(
                            child: Text("There are  no Products uploaded"),
                          );
                        } else {
                          return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              primary: true,
                              itemCount: homepageDocs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.9,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10),
                              itemBuilder: (context, i) {
                                return Helper(doc: homepageDocs[i]);
                              });
                        }
                      }
                      return const SizedBox();
                    })
              ],
            ),
          ),
        ));
  }
}
