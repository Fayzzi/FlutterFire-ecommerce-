import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../GridViewHelper/Helper.dart';

class GentsCloths extends StatelessWidget {
  const GentsCloths({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Products")
            .doc('Clothing')
            .collection('Gents')
            .snapshots(),
        builder: (context, GenClo) {
          if (GenClo.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            );
          }
          if (GenClo.hasError) {
            return Scaffold(
              body: Center(
                child: Text(GenClo.error.toString()),
              ),
            );
          }
          if (!GenClo.hasData) {
            return Scaffold(
              body: Center(
                child: Text("An error has occured please try again later"),
              ),
            );
          }
          if (GenClo.hasData || GenClo.data!.docs.isNotEmpty) {
            List<DocumentSnapshot> GDocs = GenClo.data!.docs;
            if (GDocs.isEmpty) {
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
                      itemCount: GDocs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.9,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                      itemBuilder: (context, i) {
                        return Helper(doc: GDocs[i]);
                      }),
                ),
              );
            }
          }
          return const SizedBox();
        });
  }
}
