import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../GridViewHelper/Helper.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String search = '';
  List<DocumentSnapshot> allData = [];
  List<DocumentSnapshot> filtered = [];
  TextEditingController sTav=TextEditingController();
  void dispose(){
    sTav.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: sTav,
                decoration: InputDecoration(
                  hintText: "Search by Product Name or Category",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    search = value;
                    filtered = allData.where((doc) {
                      // Filter logic: search by Product Name or Category
                     return doc['Product name']
                          .toString()
                          .toLowerCase()
                          .contains(search.toLowerCase());
                    }).toList();
                  });
                },
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  sTav.clear();
                  search = '';
                  filtered.clear();
                });
              },
              icon: FaIcon(FontAwesomeIcons.circleXmark,color: Colors.black,)
            ),
          ],
        ),
      ),
      body: search.isEmpty
          ? const Center(
              child: Text("Your searches will appear here"),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Products')
                        .doc('All products')
                        .collection('All Products')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      allData = snapshot.data!.docs;
                      return filtered.isEmpty
                          ? Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height*.2,),
                              const Center(
                                  child: Text("Nothing found"),
                                ),
                            ],
                          )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              primary: true,
                              itemCount: filtered.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.9,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                              itemBuilder: (context, i) {
                                return Helper(doc: filtered[i]);
                              },
                            );
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
