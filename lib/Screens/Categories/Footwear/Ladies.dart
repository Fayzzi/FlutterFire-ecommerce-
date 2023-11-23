import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../GridViewHelper/Helper.dart';

class LadiesFootwear extends StatelessWidget {
  const LadiesFootwear({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Products")
            .doc('Footwear')
            .collection('Ladies')
            .snapshots(),
        builder: (context, LadFot) {
          if (LadFot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            );
          }
          if (LadFot.hasError) {
            return Scaffold(
              body: Center(
                child: Text(LadFot.error.toString()),
              ),
            );
          }
          if (!LadFot.hasData) {
            return Scaffold(
              body: Center(
                child:
                Text("An error has occured please try again later"),
              ),
            );
          }
          if (LadFot.hasData || LadFot.data!.docs.isNotEmpty) {
            List<DocumentSnapshot> LFoo = LadFot.data!.docs;
            if (LFoo.isEmpty) {
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
                      itemCount: LFoo.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10),
                      itemBuilder: (context, i) {
                        return Helper(doc: LFoo[i]);
                      }),
                ),
              );
            }
          }
          return const SizedBox();
        });
  }
}
