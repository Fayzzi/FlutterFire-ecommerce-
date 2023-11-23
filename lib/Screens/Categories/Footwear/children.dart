import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../GridViewHelper/Helper.dart';

class Children extends StatelessWidget {
  const Children({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Products")
            .doc('Footwear')
            .collection('childrens')
            .snapshots(),
        builder: (context, ChilFoot) {
          if (ChilFoot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            );
          }
          if (ChilFoot.hasError) {
            return Scaffold(
              body: Center(
                child: Text(ChilFoot.error.toString()),
              ),
            );
          }
          if (!ChilFoot.hasData) {
            return Scaffold(
              body: Center(
                child:
                Text("An error has occured please try again later"),
              ),
            );
          }
          if (ChilFoot.hasData || ChilFoot.data!.docs.isNotEmpty) {
            List<DocumentSnapshot> CFoot = ChilFoot.data!.docs;
            if (CFoot.isEmpty) {
              return Scaffold(
                body: Center(
                  child: Text("There are  no Products uploaded"),
                ),
              );
            } else {
              return Scaffold(
                body: SingleChildScrollView(
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      primary: true,
                      itemCount: CFoot.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10),
                      itemBuilder: (context, i) {
                        return Helper(doc: CFoot[i]);
                      }),
                ),
              );
            }
          }
          return const SizedBox();
        });
  }
}
