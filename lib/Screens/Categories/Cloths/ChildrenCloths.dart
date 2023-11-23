import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../GridViewHelper/Helper.dart';

class ChildrenCloths extends StatelessWidget {
  const ChildrenCloths({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Products")
            .doc('Clothing')
            .collection('childrens')
            .snapshots(),
        builder: (context, ChilClo) {
          if (ChilClo.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            );
          }
          if (ChilClo.hasError) {
            return Scaffold(
              body: Center(
                child: Text(ChilClo.error.toString()),
              ),
            );
          }
          if (!ChilClo.hasData) {
            return Scaffold(
              body: Center(
                child:
                Text("An error has occured please try again later"),
              ),
            );
          }
          if (ChilClo.hasData || ChilClo.data!.docs.isNotEmpty) {
            List<DocumentSnapshot> CDocs = ChilClo.data!.docs;
            if (CDocs.isEmpty) {
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
                      itemCount: CDocs.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10),
                      itemBuilder: (context, i) {
                        return Helper(doc: CDocs[i]);
                      }),
                ),
              );
            }
          }
          return const SizedBox();
        });
  }
}
