import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../GridViewHelper/Helper.dart';

class AllFootwear extends StatelessWidget {
  const AllFootwear({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Products")
            .doc('Footwear')
            .collection('All Products')
            .snapshots(),
        builder: (context, ALLFOOT) {
          if (ALLFOOT.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            );
          }
          if (ALLFOOT.hasError) {
            return Scaffold(
              body: Center(
                child: Text(ALLFOOT.error.toString()),
              ),
            );
          }
          if (!ALLFOOT.hasData) {
            return const Scaffold(
              body: Center(
                child:
                Text("An error has occured please try again later"),
              ),
            );
          }
          if (ALLFOOT.hasData || ALLFOOT.data!.docs.isNotEmpty) {
            List<DocumentSnapshot> Adoc = ALLFOOT.data!.docs;
            if (Adoc.isEmpty) {
              return const Scaffold(
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
                      itemCount: Adoc.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10),
                      itemBuilder: (context, i) {
                        return Helper(doc: Adoc[i]);
                      }),
                ),
              );
            }
          }
          return const SizedBox();
        });
  }
}
