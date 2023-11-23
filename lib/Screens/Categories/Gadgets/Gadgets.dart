import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../GridViewHelper/Helper.dart';

class Gadgets extends StatefulWidget {
  const Gadgets({super.key});

  @override
  State<Gadgets> createState() => _GadgetsState();
}

class _GadgetsState extends State<Gadgets> {
  // late Stream<QuerySnapshot> FurGetter;
  List<DocumentSnapshot> GadDocs = [];
  // @override
  // void initState() {
  //   FurGetter = FirebaseFirestore.instance
  //       .collection('Products')
  //       .doc('Furniture')
  //       .collection('All Products')
  //       .snapshots();
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gadgets",
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
                    .collection('Products')
                    .doc('Gadgets')
                    .collection('All Products')
                    .snapshots(),
                builder: (context, GadSnap) {
                  if (GadSnap.connectionState == ConnectionState.waiting) {
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
                  if (GadSnap.hasError) {
                    return Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height*.4,),
                        Center(
                          child: Text(GadSnap.error.toString()),
                        ),
                      ],
                    );
                  }
                  if (!GadSnap.hasData) {
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
                  if (GadSnap.hasData || GadSnap.data!.docs.isNotEmpty) {
                    GadDocs = GadSnap.data!.docs;
                    if (GadDocs.isEmpty) {
                      return Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height*.4,),
                          const Center(
                            child: Text("There are  no Products uploaded"),
                          ),
                        ],
                      );
                    } else {
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          primary: true,
                          itemCount: GadDocs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.9,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                          itemBuilder: (context, i) {
                            return Helper(doc: GadDocs[i]);
                          });
                    }
                  }
                  return const SizedBox();
                })),
      ),
    );
  }
}
