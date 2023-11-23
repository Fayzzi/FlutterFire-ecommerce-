import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../GridViewHelper/Helper.dart';

class RecentlyViewed extends StatefulWidget {
  const RecentlyViewed({super.key});

  @override
  State<RecentlyViewed> createState() => _RecentlyViewedState();
}

class _RecentlyViewedState extends State<RecentlyViewed> {

  List<DocumentSnapshot> Views = [];
  User? user=FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: const Text(
            "Recently Viewed",
            style: TextStyle(color: Colors.black, fontSize: 23),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(user!.uid)
                      .collection('Viewed')
                      .snapshots(),
                  builder: (context, ViewSnap) {
                    if (ViewSnap.connectionState == ConnectionState.waiting) {
                      return Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height*.4,),
                          const Center(
                            child: CircularProgressIndicator(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    }
                    if (ViewSnap.hasError) {
                      return Column(

                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height*.4,),
                          Center(
                            child: Text(ViewSnap.error.toString()),
                          ),
                        ],
                      );
                    }
                    if (!ViewSnap.hasData) {
                      return Column(

                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height*.4,),
                          const Center(
                            child:
                            Text("An error has occured please try again later"),
                          ),
                        ],
                      );
                    }
                    if (ViewSnap.hasData || ViewSnap.data!.docs.isNotEmpty) {
                      Views = ViewSnap.data!.docs;
                      if (Views.isEmpty) {
                        return Column(

                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height*.4,),
                            const Center(
                              child: Text("There are  no Products viewed"),
                            ),
                          ],
                        );
                      } else {
                        return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            primary: true,
                            itemCount: Views.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.9,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10),
                            itemBuilder: (context, i) {
                              return Helper(doc: Views[i]);
                            });
                      }
                    }
                    return const SizedBox();
                  })),
        ));
  }
}
