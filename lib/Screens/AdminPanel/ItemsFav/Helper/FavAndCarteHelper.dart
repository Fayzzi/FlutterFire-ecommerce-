import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_project_ecommerce/Screens/AdminPanel/ItemsFav/Remover/FavRemover.dart';

import '../../../ProductDetailsPage/DetailsPage.dart';

class FavCartHelper extends StatelessWidget {
  DocumentSnapshot doc;
  FavCartHelper({required this.doc});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
    String productName = docData['Product name'];
    String productPrice = docData['Product Price'];
    String category = docData['Category'];
    List<String> productImages = List<String>.from(docData['Product Images']);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DetailsPage(ID: doc.id)));
      },
      child: Card(
        elevation: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 5),
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Images
              Expanded(
                  child: CachedNetworkImage(
                imageUrl: productImages.first,
                placeholder: (context, url) => Center(
                  child: CupertinoActivityIndicator(),
                ),
                errorWidget: (context, url, error) =>
                    Center(child: Text("An error has occured")),
                imageBuilder: (context, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: imageProvider // Placeholder image URL
                          ),
                    ),
                  );
                },
              )),
              const SizedBox(width: 16),
              // Product Details
              Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$category',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$$productPrice',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.green),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await FavRemover().remove(doc.id);
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                    // SizedBox(height: 8),
                    // Text(
                    //   productDescription,
                    //   maxLines: 3,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: TextStyle(fontSize: 14, color: Colors.grey),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
