import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../GridViewHelper/Helper.dart';

class Tools extends StatefulWidget {
  const Tools({super.key});

  @override
  State<Tools> createState() => _ToolsState();
}

class _ToolsState extends State<Tools> {
  late Stream<QuerySnapshot> ToolGetter;
  List<DocumentSnapshot> TDocs = [];
  @override
  void initState() {
    ToolGetter = FirebaseFirestore.instance
        .collection('Products')
        .doc('Tools')
        .collection('All Products')
        .snapshots();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tools",
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
                stream: ToolGetter,
                builder: (context, ToolSnap) {
                  if (ToolSnap.connectionState == ConnectionState.waiting) {
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
                  if (ToolSnap.hasError) {
                    return Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height*.4,),
                        Center(
                          child: Text(ToolSnap.error.toString()),
                        ),
                      ],
                    );
                  }
                  if (!ToolSnap.hasData) {
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
                  if (ToolSnap.hasData || ToolSnap.data!.docs.isNotEmpty) {
                    TDocs = ToolSnap.data!.docs;
                    if (TDocs.isEmpty) {
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
                          itemCount: TDocs.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.9,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                          itemBuilder: (context, i) {
                            return Helper(doc: TDocs[i]);
                          });
                    }
                  }
                  return const SizedBox();
                })),
      ),
    );
  }
}
