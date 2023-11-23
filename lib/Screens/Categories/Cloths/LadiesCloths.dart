import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../GridViewHelper/Helper.dart';

class LadiesCloths extends StatelessWidget {
  const LadiesCloths({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Products")
            .doc('Clothing')
            .collection('Ladies')
            .snapshots(),
        builder: (context, LadClo) {
          if (LadClo.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            );
          }
          if (LadClo.hasError) {
            return Scaffold(
              body: Center(
                child: Text(LadClo.error.toString()),
              ),
            );
          }
          if (!LadClo.hasData) {
            return Scaffold(
              body: Center(
                child: Text("An error has occured please try again later"),
              ),
            );
          }
          if (LadClo.hasData || LadClo.data!.docs.isNotEmpty) {
            List<DocumentSnapshot> LDocs = LadClo.data!.docs;
            if (LDocs.isEmpty) {
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
                      itemCount: LDocs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.9,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                      itemBuilder: (context, i) {
                        return Helper(doc: LDocs[i]);
                      }),
                ),
              );
            }
          }
          return const SizedBox();
        });
  }
}
