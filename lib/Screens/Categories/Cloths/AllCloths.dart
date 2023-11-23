import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../GridViewHelper/Helper.dart';

class AllCloths extends StatelessWidget {
  const AllCloths({super.key});

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Products")
            .doc('Clothing')
            .collection('All Products')
            .snapshots(),
        builder: (context, AllCLS) {
          if (AllCLS.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            );
          }
          if (AllCLS.hasError) {
            return Scaffold(
              body: Center(
                child: Text(AllCLS.error.toString()),
              ),
            );
          }
          if (!AllCLS.hasData) {
            return Scaffold(
              body: Center(
                child: Text("An error has occured please try again later"),
              ),
            );
          }
          if (AllCLS.hasData || AllCLS.data!.docs.isNotEmpty) {
            List<DocumentSnapshot> ADocs = AllCLS.data!.docs;
            if (ADocs.isEmpty) {
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
                      itemCount: ADocs.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10),
                      itemBuilder: (context, i) {
                        return Helper(doc: ADocs[i]);
                      }),
                ),
              );
            }
          }
          return const SizedBox();
        })
    ;
  }
}
