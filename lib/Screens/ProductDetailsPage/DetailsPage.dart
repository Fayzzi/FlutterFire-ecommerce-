import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mad_project_ecommerce/Controllers/ChatIDGenerator/generator.dart';
import 'package:mad_project_ecommerce/Screens/ChatScreen/ChatScreen.dart';
import 'package:mad_project_ecommerce/Screens/GridViewHelper/Helper.dart';

import '../AdminPanel/AdminPanel.dart';
import 'ViewIngImage/ImageViewer.dart';

class DetailsPage extends StatefulWidget {
  String ID;
  DetailsPage({required this.ID});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Products")
            .doc("All products")
            .collection('All Products')
            .doc(widget.ID)
            .snapshots(),
        builder: (context, clickedProduct) {
          if (clickedProduct.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            );
          }
          if (clickedProduct.hasError) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: Text(clickedProduct.error.toString())),
            );
          }
          if (!clickedProduct.hasData || !clickedProduct.data!.exists) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                  child: Text("An error has occured please try again later")),
            );
          }
          if (clickedProduct.hasData && clickedProduct.data!.exists) {
            Map<String, dynamic> productData =
                clickedProduct.data!.data() as Map<String, dynamic>;
            List<String> images =
                List<String>.from(productData['Product Images']);
            String uploader = productData['Uploader Id'];
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(uploader)
                    .snapshots(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      backgroundColor: Colors.white,
                      body: Center(
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      ),
                    );
                  }
                  if (userSnapshot.hasError) {
                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: Center(child: Text(userSnapshot.error.toString())),
                    );
                  }
                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return const Scaffold(
                      backgroundColor: Colors.white,
                      body: Center(
                          child: Text(
                              "An error has occured please try again later")),
                    );
                  }
                  if (userSnapshot.hasData && userSnapshot.data!.exists) {
                    Map<String, dynamic> userData =
                        userSnapshot.data!.data() as Map<String, dynamic>;
                    String userImage = userData['Profile Picture'] ?? "";
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Products")
                            .doc('All products')
                            .collection('All Products')
                            .snapshots(),
                        builder: (context, ProdSna) {
                          if (ProdSna.connectionState ==
                              ConnectionState.waiting) {
                            return const Scaffold(
                              backgroundColor: Colors.white,
                              body: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.green,
                                ),
                              ),
                            );
                          }
                          if (ProdSna.hasError) {
                            return Scaffold(
                              backgroundColor: Colors.white,
                              body:
                                  Center(child: Text(ProdSna.error.toString())),
                            );
                          }
                          if (!ProdSna.hasData || ProdSna.data!.docs.isEmpty) {
                            return const Scaffold(
                              backgroundColor: Colors.white,
                              body: Center(
                                child: Text(
                                    "An error has occured please try again later"),
                              ),
                            );
                          }
                          if (ProdSna.hasData ||
                              ProdSna.data!.docs.isNotEmpty) {
                            List<DocumentSnapshot> Allproducts =
                                ProdSna.data!.docs;
                            return Scaffold(
                              backgroundColor: Colors.white,
                              appBar: AppBar(
                                actions: [
                                  IconButton(
                                      onPressed: () async {

                                          Get.closeAllSnackbars();

                                        if (productData['Category'] ==
                                                'Clothing' ||
                                            productData['Category'] ==
                                                'Footwear') {
                                          await FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(user!.uid)
                                              .collection('Carted')
                                              .doc(widget.ID)
                                              .set({
                                            "Product name":
                                                productData['Product name'],
                                            "Product Price":
                                                productData['Product Price'],
                                            "Category": productData['Category'],
                                            'Product Images':
                                                productData['Product Images'],
                                            'Condition':
                                                productData['Condition'],
                                            'Delivery Service':
                                                productData['Delivery Service'],
                                            'Description':
                                                productData['Description'],
                                            'Quantity': productData['Quantity'],
                                            'Uploaded on':
                                                productData['Uploaded on'],
                                            'Uploader Contatct': productData[
                                                'Uploader Contatct'],
                                            'Uploader Id':
                                                productData['Uploader Id'],
                                            'For ages':
                                                productData['Uploader Id'],
                                            'Sizes available':
                                                productData['Sizes available'],
                                          });
                                        } else {
                                          await FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(user!.uid)
                                              .collection('Carted')
                                              .doc(widget.ID)
                                              .set({
                                            "Product name":
                                                productData['Product name'],
                                            "Product Price":
                                                productData['Product Price'],
                                            "Category": productData['Category'],
                                            'Product Images':
                                                productData['Product Images'],
                                            'Condition':
                                                productData['Condition'],
                                            'Delivery Service':
                                                productData['Delivery Service'],
                                            'Description':
                                                productData['Description'],
                                            'Quantity': productData['Quantity'],
                                            'Uploaded on':
                                                productData['Uploaded on'],
                                            'Uploader Contatct': productData[
                                                'Uploader Contatct'],
                                            'Uploader Id':
                                                productData['Uploader Id'],
                                          });
                                        }

                                        Get.snackbar("Success",
                                            "${productData['Product name']} added to cart",
                                            snackPosition: SnackPosition.BOTTOM,
                                            isDismissible: true,
                                            duration:
                                                const Duration(seconds: 2),
                                            colorText: Colors.white,
                                            backgroundColor: Colors.green);
                                      },
                                      icon:FaIcon(FontAwesomeIcons.cartPlus,color: Colors.blue,)),
                                  IconButton(
                                      onPressed: () async {
                                        Get.closeAllSnackbars();

                                        if (productData['Category'] ==
                                                'Clothing' ||
                                            productData['Category'] ==
                                                'Footwear') {
                                          await FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(user!.uid)
                                              .collection('Fav')
                                              .doc(widget.ID)
                                              .set({
                                            "Product name":
                                                productData['Product name'],
                                            "Product Price":
                                                productData['Product Price'],
                                            "Category": productData['Category'],
                                            'Product Images':
                                                productData['Product Images'],
                                            'Condition':
                                                productData['Condition'],
                                            'Delivery Service':
                                                productData['Delivery Service'],
                                            'Description':
                                                productData['Description'],
                                            'Quantity': productData['Quantity'],
                                            'Uploaded on':
                                                productData['Uploaded on'],
                                            'Uploader Contatct': productData[
                                                'Uploader Contatct'],
                                            'Uploader Id':
                                                productData['Uploader Id'],
                                            'For ages':
                                                productData['Uploader Id'],
                                            'Sizes available':
                                                productData['Sizes available'],
                                          });
                                        } else {
                                          await FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(user!.uid)
                                              .collection('Fav')
                                              .doc(widget.ID)
                                              .set({
                                            "Product name":
                                                productData['Product name'],
                                            "Product Price":
                                                productData['Product Price'],
                                            "Category": productData['Category'],
                                            'Product Images':
                                                productData['Product Images'],
                                            'Condition':
                                                productData['Condition'],
                                            'Delivery Service':
                                                productData['Delivery Service'],
                                            'Description':
                                                productData['Description'],
                                            'Quantity': productData['Quantity'],
                                            'Uploaded on':
                                                productData['Uploaded on'],
                                            'Uploader Contatct': productData[
                                                'Uploader Contatct'],
                                            'Uploader Id':
                                                productData['Uploader Id'],
                                          });
                                        }
                                        Get.snackbar("Success",
                                            "${productData['Product name']} added to Favorites",
                                            snackPosition: SnackPosition.BOTTOM,
                                            isDismissible: true,
                                            duration:
                                                const Duration(seconds: 2),
                                            colorText: Colors.white,
                                            backgroundColor: Colors.green);
                                      },
                                      icon:FaIcon(FontAwesomeIcons.heartCirclePlus,color: Colors.red,)),
                                ],
                                leading: IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.black,
                                  ),
                                ),
                                backgroundColor: Colors.white,
                                title: const Text(
                                  "Product Details",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 23),
                                ),
                              ),
                              body: SafeArea(
                                child: ListView(
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    images.length == 1
                                        ? SizedBox(
                                            height: 350,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Center(
                                              child: ListView.builder(
                                                  itemCount: images.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, i) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5, right: 5),
                                                      child: CachedNetworkImage(
                                                        imageUrl: images[i],
                                                        placeholder:
                                                            (context, url) =>
                                                                const Center(
                                                          child:
                                                              CupertinoActivityIndicator(),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Center(
                                                          child: Icon(
                                                            Icons.error,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        imageBuilder: (context,
                                                            ImageProvider) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              Get.to(() =>
                                                                  ImageViewer(
                                                                      images:
                                                                          images,
                                                                      index: i));
                                                            },
                                                            child: Container(
                                                              height: 350,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .94,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5),
                                                                    spreadRadius:
                                                                        3,
                                                                    blurRadius: 7,
                                                                    offset:
                                                                        const Offset(
                                                                            0, 5),
                                                                  ),
                                                                ],
                                                                image: DecorationImage(
                                                                    image:
                                                                        ImageProvider,
                                                                    fit: BoxFit
                                                                        .cover),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          )
                                        : SizedBox(
                                            height: 350,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ListView.builder(
                                                itemCount: images.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemBuilder: (context, i) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    child: CachedNetworkImage(
                                                      imageUrl: images[i],
                                                      placeholder:
                                                          (context, url) =>
                                                              const Center(
                                                        child:
                                                            CupertinoActivityIndicator(),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Center(
                                                        child: Icon(
                                                          Icons.error,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      imageBuilder: (context,
                                                          ImageProvider) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            Get.to(() =>
                                                                ImageViewer(
                                                                    images:
                                                                        images,
                                                                    index: i));
                                                          },
                                                          child: Container(
                                                            height: 350,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .94,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      3,
                                                                  blurRadius: 7,
                                                                  offset:
                                                                      const Offset(
                                                                          0, 5),
                                                                ),
                                                              ],
                                                              image: DecorationImage(
                                                                  image:
                                                                      ImageProvider,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                }),
                                          ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (productData['Product name'] !=
                                              null)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${productData['Product name']}',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 33,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    // or TextOverflow.clip, depending on your preference
                                                    textAlign: TextAlign
                                                        .justify, // Set the desired text alignment (left, right, center, etc.)
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .green.shade500,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: Center(
                                                      child: Text(
                                                        '${productData['Condition']}',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          if (productData['Category'] != null)
                                            const SizedBox(
                                              height: 3,
                                            ),
                                          if (productData['Category'] != null)
                                            Text(
                                              '${productData['Category']}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18,
                                              ),
                                            ),
                                          if (productData['Product Price'] !=
                                              null)
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          if (productData['Product Price'] !=
                                              null)
                                            Text(
                                              '\$${productData['Product Price']}',
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontSize: 25,
                                              ),
                                            ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Text(
                                            'Product Details',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,
                                            ),
                                            // or TextOverflow.clip, depending on your preference
                                            textAlign: TextAlign
                                                .justify, // Set the desired text alignment (left, right, center, etc.)
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.7),
                                                      blurRadius: 8,
                                                      spreadRadius: 2,
                                                      offset:
                                                          const Offset(0, 3))
                                                ]),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (productData[
                                                            'For ages'] !=
                                                        null)
                                                      const Text(
                                                        'For Ages',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 18),
                                                      ),
                                                    if (productData[
                                                            'Sizes available'] !=
                                                        null)
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                    if (productData[
                                                            'Sizes available'] !=
                                                        null)
                                                      const Text(
                                                        'Sizes available',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 18),
                                                      ),
                                                    if (productData[
                                                            'Quantity'] !=
                                                        null)
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                    if (productData[
                                                            'Quantity'] !=
                                                        null)
                                                      const Text(
                                                        'Quantity',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 18),
                                                      ),
                                                    if (productData[
                                                            'Delivery Service'] !=
                                                        null)
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                    if (productData[
                                                            'Delivery Service'] !=
                                                        null)
                                                      const Text(
                                                        'Delivery Service',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 18),
                                                      ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    if (productData[
                                                            'For ages'] !=
                                                        null)
                                                      Text(
                                                          productData[
                                                              'For ages'],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      18)),
                                                    if (productData[
                                                            'Sizes available'] !=
                                                        null)
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                    if (productData[
                                                            'Sizes available'] !=
                                                        null)
                                                      Text(
                                                          productData[
                                                              'Sizes available'],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      18)),
                                                    if (productData[
                                                            'Quantity'] !=
                                                        null)
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                    productData['Quantity'] !=
                                                            null
                                                        ? productData[
                                                                    'Quantity'] ==
                                                                "List as Single item"
                                                            ? const Text(
                                                                "Single Item",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        18))
                                                            : const Text(
                                                                "Stock Available",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        18))
                                                        : const SizedBox(),
                                                    if (productData[
                                                            'Delivery Service'] !=
                                                        null)
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                    if (productData[
                                                            'Delivery Service'] !=
                                                        null)
                                                      Text(
                                                          productData[
                                                              'Delivery Service'],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      18)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (productData['Description'] !=
                                              null)
                                            const SizedBox(
                                              height: 20,
                                            ),
                                          if (productData['Description'] !=
                                              null)
                                            const Text(
                                              'Product Description',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25,
                                              ),
                                              // or TextOverflow.clip, depending on your preference
                                              textAlign: TextAlign
                                                  .justify, // Set the desired text alignment (left, right, center, etc.)
                                            ),
                                          if (productData['Description'] !=
                                              null)
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          if (productData['Description'] !=
                                              null)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                productData['Description'],
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 19.5,
                                                ),
                                                // or TextOverflow.clip, depending on your preference
                                                textAlign: TextAlign
                                                    .justify, // Set the desired text alignment (left, right, center, etc.)
                                              ),
                                            ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Text(
                                            'Owner Details',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,
                                            ),
                                            // or TextOverflow.clip, depending on your preference
                                            textAlign: TextAlign
                                                .justify, // Set the desired text alignment (left, right, center, etc.)
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          ListTile(
                                            tileColor: Colors.grey.shade300,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(13)),
                                            leading: userImage != ''
                                                ? GestureDetector(
                                                    onTap: () {
                                                      _showImageDialog(userData[
                                                          'Profile Picture']);
                                                    },
                                                    child: CachedNetworkImage(
                                                      imageUrl: userData[
                                                          'Profile Picture'],
                                                      placeholder: (context,
                                                              url) =>
                                                          const CupertinoActivityIndicator(),
                                                      errorWidget: (context,
                                                              error, url) =>
                                                          const Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                      ),
                                                      imageBuilder: (context,
                                                          imageProvider) {
                                                        return CircleAvatar(
                                                            radius: 25,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            backgroundImage:
                                                                imageProvider);
                                                      },
                                                    ))
                                                : const CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    backgroundImage: AssetImage(
                                                        'images/user.jpg'),
                                                  ),
                                            title: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (userData['Username'] !=
                                                    null)
                                                  Text(
                                                    userData['Username'],
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 19),
                                                  ),
                                                if (userData['Date Joined'] !=
                                                    null)
                                                  Text(
                                                    'Member Since:${formatDateTime(userData['Date Joined'])}',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  )
                                              ],
                                            ),
                                            trailing: GestureDetector(
                                              onTap: () {
                                                if (user!.uid ==
                                                    userData['uid']) {
                                                  Get.snackbar("Error",
                                                      "you are the owner of this product",
                                                      colorText: Colors.white,
                                                      backgroundColor:
                                                          Colors.red,
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      duration: const Duration(
                                                          seconds: 2));
                                                } else {
                                                  String usersChatID = ChatId(
                                                      user!.uid, widget.ID);
                                                  FirebaseFirestore.instance
                                                      .collection("Users")
                                                      .doc(user!.uid)
                                                      .update({
                                                    "ChatIds":
                                                        FieldValue.arrayUnion(
                                                            [usersChatID]),
                                                  });
                                                  FirebaseFirestore.instance
                                                      .collection("Users")
                                                      .doc(productData[
                                                          'Uploader Id'])
                                                      .update({
                                                    "ChatIds":
                                                        FieldValue.arrayUnion(
                                                            [usersChatID]),
                                                  });

                                                  Get.to(() => ChatScreen(
                                                      ProductName: productData[
                                                          'Product name'],
                                                      ChatID: usersChatID,
                                                      RecieverEmail:
                                                          userData['Email'],
                                                      RecieverID: productData[
                                                          'Uploader Id'],
                                                      SenderEmail:
                                                          user!.email ?? '',
                                                      SenderID: user!.uid));
                                                }
                                              },
                                              child: FaIcon(FontAwesomeIcons.solidCommentDots,color: Colors.green,),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Divider(
                                                    thickness: 0.7,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 2, right: 2),
                                                  child: Text(
                                                    'Other Products',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Divider(
                                                    thickness: 0.7,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            height: 220,
                                            child: GridView.builder(
                                                itemCount: Allproducts.length,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 1,
                                                        mainAxisSpacing: 5,
                                                        crossAxisSpacing: 5),
                                                itemBuilder: (context, i) {
                                                  return Helper(
                                                      doc: Allproducts[i]);
                                                }),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        });
                  }
                  return const SizedBox();
                });
          }
          return const SizedBox();
        });
  }

  void _showImageDialog(String ImageUrl) {
    Get.dialog(
      Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: CachedNetworkImage(
          imageUrl: ImageUrl,
          placeholder: (context, url) =>
              const Center(child: CupertinoActivityIndicator()),
          errorWidget: (context, error, url) => const Center(
            child: Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
          imageBuilder: (context, imageProvider) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(ImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
