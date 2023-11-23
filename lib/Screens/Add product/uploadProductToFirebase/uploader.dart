import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class uploadtoFirebase {
  User? user = FirebaseAuth.instance.currentUser;
  Future clothsProduct(
      String name,
      String price,
      String contact,
      String des,
      String cat,
      String age,
      String size,
      String condition,
      List<String> images,
      String quantity,
      String delivery) async {
    DocumentReference ref = FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .collection('Products')
        .doc();
    String docID = ref.id;
    ref.set({
      "Product name": name,
      "Product Price": price,
      "Product Images": images,
      'Uploader Id': user!.uid,
      "Uploaded on": DateTime.now(),
      "Category": cat,
      "Quantity": quantity,
      "Condition":condition,
      "Delivery Service": delivery,
      "Uploader Contatct": contact,
      "Description": des,
      "Sizes available": size,
      "For ages": age,
      'Uploader Email':user!.email,
    });
    await FirebaseFirestore.instance
        .collection("Products")
        .doc(cat)
        .collection("All Products")
        .doc(docID)
        .set({
      "Product name": name,
      "Product Price": price,
      "Product Images": images,
      'Uploader Id': user!.uid,
      "Uploaded on": DateTime.now(),
      "Condition":condition,
      "Category": cat,
      "Quantity": quantity,
      "Delivery Service": delivery,
      "Uploader Contatct": contact,
      "Description": des,
      "Sizes available": size,
      "For ages": age,
      'Uploader Email':user!.email,
    });
    await FirebaseFirestore.instance
        .collection("Products")
        .doc(cat)
        .collection(age)
        .doc(docID)
        .set({
      "Product name": name,
      "Product Price": price,
      "Product Images": images,
      "Condition":condition,
      'Uploader Id': user!.uid,
      "Uploaded on": DateTime.now(),
      "Category": cat,
      "Quantity": quantity,
      "Delivery Service": delivery,
      "Uploader Contatct": contact,
      "Description": des,
      "Sizes available": size,
      "For ages": age,
      'Uploader Email':user!.email,
    });
    await FirebaseFirestore.instance
        .collection("Products")
        .doc("All products")
        .collection("All Products")
        .doc(docID)
        .set({
      "Product name": name,
      "Product Price": price,
      "Product Images": images,
      'Uploader Id': user!.uid,
      'Uploader Email':user!.email,
      "Uploaded on": DateTime.now(),
      "Condition":condition,
      "Category": cat,
      "Quantity": quantity,
      "Delivery Service": delivery,
      "Uploader Contatct": contact,
      "Description": des,
      "Sizes available": size,
      "For ages": age,
    });
  }

  Future simple(String name, String price, String contact, String des,
      String cat, List<String> images, String quantity, String delivery,String condition) async {
    DocumentReference ref = FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .collection('Products')
        .doc();
    String doc = ref.id;
    ref.set({
      "Product name": name,
      "Product Price": price,
      "Product Images": images,
      'Uploader Id': user!.uid,
      'Uploader Email':user!.email,
      "Condition":condition,
      "Uploaded on": DateTime.now(),
      "Category": cat,
      "Quantity": quantity,
      "Delivery Service": delivery,
      "Uploader Contatct": contact,
      "Description": des,
    });
    await FirebaseFirestore.instance
        .collection("Products")
        .doc(cat)
        .collection("All Products")
        .doc(doc)
        .set({
      "Product name": name,
      "Product Price": price,
      "Product Images": images,
      "Condition":condition,
      'Uploader Id': user!.uid,
      'Uploader Email':user!.email,
      "Uploaded on": DateTime.now(),
      "Category": cat,
      "Quantity": quantity,
      "Delivery Service": delivery,
      "Uploader Contatct": contact,
      "Description": des,
    });
    await FirebaseFirestore.instance
        .collection("Products")
        .doc("All products")
        .collection("All Products")
        .doc(doc)
        .set({
      "Product name": name,
      "Product Price": price,
      "Condition":condition,
      "Product Images": images,
      'Uploader Id': user!.uid,
      'Uploader Email':user!.email,
      "Uploaded on": DateTime.now(),
      "Category": cat,
      "Quantity": quantity,
      "Delivery Service": delivery,
      "Uploader Contatct": contact,
      "Description": des,
    });
  }
}
