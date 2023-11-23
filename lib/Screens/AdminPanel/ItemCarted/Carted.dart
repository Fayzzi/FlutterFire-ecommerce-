import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project_ecommerce/Screens/AdminPanel/ItemCarted/Helper/CartHelper.dart';

import '../ItemsFav/Helper/FavAndCarteHelper.dart';

class CartedItems extends StatelessWidget {
  List<DocumentSnapshot> CartDoc = [];
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Carted",
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
                    .collection('Carted')
                    .snapshots(),
                builder: (context, CartSnap) {
                  if (CartSnap.connectionState == ConnectionState.waiting) {
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
                  if (CartSnap.hasError) {
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .4,
                        ),
                        Center(
                          child: Text(CartSnap.error.toString()),
                        ),
                      ],
                    );
                  }
                  if (!CartSnap.hasData) {
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
                  if (CartSnap.hasData || CartSnap.data!.docs.isNotEmpty) {
                    CartDoc = CartSnap.data!.docs;
                    if (CartDoc.isEmpty) {
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .4,
                          ),
                          const Center(
                            child: Text(
                                "There are  no Products added to the cart"),
                          ),
                        ],
                      );
                    } else {
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          primary: true,
                          itemCount: CartDoc.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.9,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                          itemBuilder: (context, i) {
                            return CartHelper(doc: CartDoc[i]);
                          });
                    }
                  }
                  return const SizedBox();
                })),
      ),
    );
  }
}
