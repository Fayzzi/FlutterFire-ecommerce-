import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../GridViewHelper/Helper.dart';

class Furniture extends StatefulWidget {
  const Furniture({super.key});

  @override
  State<Furniture> createState() => _FurnitureState();
}

class _FurnitureState extends State<Furniture> {
  late Stream<QuerySnapshot> FurGetter;
  List<DocumentSnapshot> FurDocs = [];
  @override
  void initState() {
    FurGetter = FirebaseFirestore.instance
        .collection('Products')
        .doc('Furniture')
        .collection('All Products')
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Furniture",
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
                stream: FurGetter,
                builder: (context, FurSnap) {
                  if (FurSnap.connectionState == ConnectionState.waiting) {
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
                  if (FurSnap.hasError) {
                    return Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height*.4,),
                        Center(
                          child: Text(FurSnap.error.toString()),
                        ),
                      ],
                    );
                  }
                  if (!FurSnap.hasData) {
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
                  if (FurSnap.hasData || FurSnap.data!.docs.isNotEmpty) {
                    FurDocs = FurSnap.data!.docs;
                    if (FurDocs.isEmpty) {
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
                          itemCount: FurDocs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.9,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                          itemBuilder: (context, i) {
                            return Helper(doc: FurDocs[i]);
                          });
                    }
                  }
                  return const SizedBox();
                })),
      ),
    );
  }
}
