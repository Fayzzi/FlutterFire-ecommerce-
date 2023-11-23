import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project_ecommerce/Screens/AdminPanel/ItemsFav/Helper/FavAndCarteHelper.dart';

import '../../GridViewHelper/Helper.dart';

class MyFavorite extends StatefulWidget {
  const MyFavorite({super.key});

  @override
  State<MyFavorite> createState() => _MyFavoriteState();
}

class _MyFavoriteState extends State<MyFavorite> {
  List<DocumentSnapshot> fDocs = [];
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorites",
          style: TextStyle(color: Colors.black, fontSize: 23),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(user!.uid)
                    .collection('Fav')
                    .snapshots(),
                builder: (context, FavSnap) {
                  if (FavSnap.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .4,
                        ),
                        const Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  }
                  if (FavSnap.hasError) {
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .4,
                        ),
                        Center(
                          child: Text(FavSnap.error.toString()),
                        ),
                      ],
                    );
                  }
                  if (!FavSnap.hasData) {
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .4,
                        ),
                        const Center(
                          child: Text(
                              "An error has occured please try again later"),
                        ),
                      ],
                    );
                  }
                  if (FavSnap.hasData || FavSnap.data!.docs.isNotEmpty) {
                    fDocs = FavSnap.data!.docs;
                    if (fDocs.isEmpty) {
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .4,
                          ),
                          const Center(
                            child: Text("There are  no Products added to Favorites"),
                          ),
                        ],
                      );
                    } else {
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          primary: true,
                          itemCount: fDocs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.9,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                          itemBuilder: (context, i) {
                            return FavCartHelper(doc: fDocs[i]);
                          });
                    }
                  }
                  return const SizedBox();
                })),
      ),
    );
  }
}
