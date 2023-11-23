import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../GridViewHelper/Helper.dart';

class Accessories extends StatefulWidget {
  const Accessories({super.key});

  @override
  State<Accessories> createState() => _AccessoriesState();
}

class _AccessoriesState extends State<Accessories> {
  late Stream<QuerySnapshot> AccGetter;
  List<DocumentSnapshot> Accdocs = [];
  @override
  void initState() {
    AccGetter = FirebaseFirestore.instance
        .collection('Products')
        .doc('Accessories')
        .collection('All Products')
        .snapshots();
    super.initState();
  }

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
            "Accessories",
            style: TextStyle(color: Colors.black, fontSize: 23),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
              child: StreamBuilder(
                  stream: AccGetter,
                  builder: (context, Accsnap) {
                    if (Accsnap.connectionState == ConnectionState.waiting) {
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
                    if (Accsnap.hasError) {
                      return Column(

                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height*.4,),
                          Center(
                            child: Text(Accsnap.error.toString()),
                          ),
                        ],
                      );
                    }
                    if (!Accsnap.hasData) {
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
                    if (Accsnap.hasData || Accsnap.data!.docs.isNotEmpty) {
                      Accdocs = Accsnap.data!.docs;
                      if (Accdocs.isEmpty) {
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
                            itemCount: Accdocs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.9,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10),
                            itemBuilder: (context, i) {
                              return Helper(doc: Accdocs[i]);
                            });
                      }
                    }
                    return const SizedBox();
                  })),
        ));
  }
}
