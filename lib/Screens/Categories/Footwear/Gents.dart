import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../GridViewHelper/Helper.dart';

class GentsFootwear extends StatelessWidget {
  const GentsFootwear({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Products")
            .doc('Footwear')
            .collection('Gents')
            .snapshots(),
        builder: (context, GentsFoo) {
          if (GentsFoo.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            );
          }
          if (GentsFoo.hasError) {
            return Scaffold(
              body: Center(
                child: Text(GentsFoo.error.toString()),
              ),
            );
          }
          if (!GentsFoo.hasData) {
            return Scaffold(
              body: Center(
                child:
                Text("An error has occured please try again later"),
              ),
            );
          }
          if (GentsFoo.hasData || GentsFoo.data!.docs.isNotEmpty) {
            List<DocumentSnapshot> GFoot = GentsFoo.data!.docs;
            if (GFoot.isEmpty) {
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
                      itemCount: GFoot.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10),
                      itemBuilder: (context, i) {
                        return Helper(doc: GFoot[i]);
                      }),
                ),
              );
            }
          }
          return const SizedBox();
        });
  }
}
