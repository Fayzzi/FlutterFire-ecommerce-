import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mad_project_ecommerce/Screens/ProductDetailsPage/DetailsPage.dart';

import '../AdminPanel/AdminPanel.dart';

class Helper extends StatelessWidget {
  final DocumentSnapshot doc;
  Helper({required this.doc});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
    String productName = docData['Product name'];
    String productPrice = docData['Product Price'];
    String category = docData['Category'];
    List<String> productImages = List<String>.from(docData['Product Images']);
    User? user=FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DetailsPage(ID: doc.id)));
        if (docData['Category'] == 'Clothing' ||
            docData['Category'] == 'Footwear') {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(user!.uid)
              .collection('Viewed')
              .doc(doc.id)
              .set({
            "Product name": docData['Product name'],
            "Product Price": docData['Product Price'],
            "Category": docData['Category'],
            'Product Images': docData['Product Images'],
            'Condition': docData['Condition'],
            'Delivery Service': docData['Delivery Service'],
            'Description': docData['Description'],
            'Quantity': docData['Quantity'],
            'Uploaded on': docData['Uploaded on'],
            'Uploader Contatct': docData['Uploader Contatct'],
            'Uploader Id': docData['Uploader Id'],
            'For ages': docData['Uploader Id'],
            'Sizes available': docData['Sizes available'],
          });
        } else {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(user!.uid)
              .collection('Viewed')
              .doc(doc.id)
              .set({
            "Product name": docData['Product name'],
            "Product Price": docData['Product Price'],
            "Category": docData['Category'],
            'Product Images': docData['Product Images'],
            'Condition': docData['Condition'],
            'Delivery Service': docData['Delivery Service'],
            'Description': docData['Description'],
            'Quantity': docData['Quantity'],
            'Uploaded on': docData['Uploaded on'],
            'Uploader Contatct': docData['Uploader Contatct'],
            'Uploader Id': docData['Uploader Id'],
          });
        }
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
                          onTap: ()async{
                            Get.closeAllSnackbars();

                            if (docData['Category'] ==
                                'Clothing' ||
                                docData['Category'] ==
                                    'Footwear') {
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(user!.uid)
                                  .collection('Carted')
                                  .doc(doc.id)
                                  .set({
                                "Product name":
                                docData['Product name'],
                                "Product Price":
                                docData['Product Price'],
                                "Category": docData['Category'],
                                'Product Images':
                                docData['Product Images'],
                                'Condition':
                                docData['Condition'],
                                'Delivery Service':
                                docData['Delivery Service'],
                                'Description':
                                docData['Description'],
                                'Quantity': docData['Quantity'],
                                'Uploaded on':
                                docData['Uploaded on'],
                                'Uploader Contatct': docData[
                                'Uploader Contatct'],
                                'Uploader Id':
                                docData['Uploader Id'],
                                'For ages':
                                docData['Uploader Id'],
                                'Sizes available':
                                docData['Sizes available'],
                              });
                            } else {
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(user!.uid)
                                  .collection('Carted')
                                  .doc(doc.id)
                                  .set({
                                "Product name":
                                docData['Product name'],
                                "Product Price":
                                docData['Product Price'],
                                "Category": docData['Category'],
                                'Product Images':
                                docData['Product Images'],
                                'Condition':
                                docData['Condition'],
                                'Delivery Service':
                                docData['Delivery Service'],
                                'Description':
                                docData['Description'],
                                'Quantity': docData['Quantity'],
                                'Uploaded on':
                                docData['Uploaded on'],
                                'Uploader Contatct': docData[
                                'Uploader Contatct'],
                                'Uploader Id':
                                docData['Uploader Id'],
                              });
                            }
                            Get.snackbar("Success",
                                "${docData['Product name']} added to Carts",
                                snackPosition: SnackPosition.BOTTOM,
                                isDismissible: true,
                                duration:
                                const Duration(seconds: 2),
                                colorText: Colors.white,
                                backgroundColor: Colors.green);
                          },
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 15,
                              child: FaIcon(FontAwesomeIcons.plus,color: Colors.white,),
                            ))
                      ],
                    ),


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
