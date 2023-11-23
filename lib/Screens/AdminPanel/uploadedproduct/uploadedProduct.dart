import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../GridViewHelper/Helper.dart';
import 'Helper/Helper.dart';

class UploadedProducts extends StatefulWidget {
  const UploadedProducts({super.key});

  @override
  State<UploadedProducts> createState() => _UploadedProductsState();
}

class _UploadedProductsState extends State<UploadedProducts> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
          onPressed: (){
            Get.back();
          },
        ),
        title: Text(
          'My Uploads',
          style: TextStyle(color: Colors.black, fontSize: 23),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user!.uid)
                  .collection('Products')
                  .snapshots(),
              builder: (context, uploadedSnap) {
                if (uploadedSnap.connectionState == ConnectionState.waiting) {
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
                if (uploadedSnap.hasError) {
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .4,
                      ),
                      Center(
                        child: Text(uploadedSnap.error.toString()),
                      ),
                    ],
                  );
                }
                if (!uploadedSnap.hasData) {
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .4,
                      ),
                      const Center(
                        child:
                            Text("An error has occured please try again later"),
                      ),
                    ],
                  );
                }
                if (uploadedSnap.hasData ||
                    uploadedSnap.data!.docs.isNotEmpty) {
                  List<DocumentSnapshot> Upcdocs = uploadedSnap.data!.docs;
                  if (Upcdocs.isEmpty) {
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .4,
                        ),
                        const Center(
                          child: Text("There are  no Products uploaded"),
                        ),
                      ],
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        primary: true,
                        itemCount: Upcdocs.length,

                        itemBuilder: (context, i) {
                          return UploadedHelper(doc: Upcdocs[i]);
                        });
                  }
                }
                return const SizedBox();
              }),
        ),
      ),
    );
  }
}
