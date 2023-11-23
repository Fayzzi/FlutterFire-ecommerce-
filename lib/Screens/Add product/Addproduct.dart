
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mad_project_ecommerce/Screens/Add%20product/Controllers/Controllers.dart';
import 'package:mad_project_ecommerce/Screens/Add%20product/uploadProductToFirebase/uploader.dart';
import 'package:permission_handler/permission_handler.dart';

class imagepicking extends GetxController {
  List<File> images = <File>[].obs;
  List<String> downloadurls = [];
}

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  loadingmaster load = Get.put(loadingmaster());
  imagepicking picker = Get.put(imagepicking());
  TextEditingController _pname = TextEditingController();
  TextEditingController _des = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _price = TextEditingController();
  category selecter = Get.put(category());

  size sizeSelector = Get.put(size());
  age ageSlector = Get.put(age());
  quantity qSelector = Get.put(quantity());
  delivery dSelector = Get.put(delivery());
  condition condSelector = Get.put(condition());
  User? user = FirebaseAuth.instance.currentUser;
  Future Ipicker() async {
    final XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (file != null) {
      picker.images.add(File(file.path));
    }
  }

  void dispose() {
    _pname.dispose();
    _phone.dispose();
    _des.dispose();
    _price.dispose();
    super.dispose();
  }

  Future<void> getDownloadUrls() async {
    try {
      for (File file in picker.images) {
        String id = DateTime.now().microsecondsSinceEpoch.toString();
        Reference ref = FirebaseStorage.instance
            .ref("Users")
            .child(user!.uid)
            .child('Uploaded product')
            .child(id + " " + picker.images.indexOf(file).toString());

        await ref.putFile(file);
        String url = await ref.getDownloadURL();
        picker.downloadurls.add(url);
      }
    } catch (e) {
      print('Error uploading file: $e');
      // Handle the error, maybe show a message to the user
    } finally {
      // Clear the images list after uploading
      picker.images.clear();
    }
  }

  Future uploadProduct() async {
    if (selecter.c_selected.value == "Footwear" ||
        selecter.c_selected.value == "Clothing") {
      if (_pname.text == "" ||
          _price.text == "" ||
          _des.text == "" ||
          _phone.text == "" ||
          sizeSelector.size_selected.value == "" ||
          ageSlector.age_selected.value == "" ||
          qSelector.q_selected.value == "" ||
          dSelector.d_selected.value == "" ||
          condSelector.cond_selected.value == "") {
        Get.snackbar('', '',
            titleText: const Text(
              'Failed',
              style: TextStyle(color: Colors.white),
            ),
            messageText: Text(
              "All Fields are required!!",
              style: const TextStyle(color: Colors.white),
            ),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            snackStyle: SnackStyle.GROUNDED);
      } else if (picker.images.length < 1) {
        Get.snackbar('', '',
            titleText: const Text(
              'Failed',
              style: TextStyle(color: Colors.white),
            ),
            messageText: Text(
              'Atlease add one Image',
              style: const TextStyle(color: Colors.white),
            ),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            snackStyle: SnackStyle.GROUNDED);
      } else {
        load.lood.value = true;
        try {
          await getDownloadUrls();
          await uploadtoFirebase().clothsProduct(
              _pname.text,
              _price.text,
              _phone.text,
              _des.text,
              selecter.c_selected.value,
              ageSlector.age_selected.value,
              sizeSelector.size_selected.value,
              condSelector.cond_selected.value,
              picker.downloadurls,
              qSelector.q_selected.value,
              dSelector.d_selected.value);

          setState(() {
            _phone.clear();
            _pname.clear();
            _des.clear();
            _price.clear();
            condSelector.cond_selected.value = '';
            selecter.c_selected.value = "";
            ageSlector.age_selected.value = "";
            sizeSelector.size_selected.value = "";
            picker.images.clear();
            picker.downloadurls.clear();
            qSelector.q_selected.value = "";
            dSelector.d_selected.value = "";
            FocusScope.of(context).unfocus();
          });
          load.lood.value = false;
          Get.snackbar('', '',
              titleText: const Text(
                'Success',
                style: TextStyle(color: Colors.white),
              ),
              messageText: const Text(
                "Product upload Successfull",
                style: TextStyle(color: Colors.white),
              ),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              duration: const Duration(seconds: 3),
              snackStyle: SnackStyle.GROUNDED);
        } catch (e) {
          Get.snackbar('', '',
              titleText: const Text(
                'Failed',
                style: TextStyle(color: Colors.white),
              ),
              messageText: Text(
                e.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              snackStyle: SnackStyle.GROUNDED);
        }
        load.lood.value = false;
      }
    } else {
      if (_pname.text == "" ||
          _price.text == "" ||
          _des.text == "" ||
          _phone.text == "" ||
          qSelector.q_selected.value == "" ||
          dSelector.d_selected.value == "" ||
          condSelector.cond_selected.value == "") {
        Get.snackbar('', '',
            titleText: const Text(
              'Failed',
              style: TextStyle(color: Colors.white),
            ),
            messageText: Text(
              "All Fields are required!!",
              style: const TextStyle(color: Colors.white),
            ),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            snackStyle: SnackStyle.GROUNDED);
      } else if (picker.images.length < 1) {
        Get.snackbar('', '',
            titleText: const Text(
              'Failed',
              style: TextStyle(color: Colors.white),
            ),
            messageText: Text(
              "Atleast add One Image!!",
              style: const TextStyle(color: Colors.white),
            ),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            snackStyle: SnackStyle.GROUNDED);
      } else {
        try {
          load.lood.value = true;
          await getDownloadUrls();
          await uploadtoFirebase().simple(
              _pname.text,
              _price.text,
              _phone.text,
              _des.text,
              selecter.c_selected.value,
              picker.downloadurls,
              qSelector.q_selected.value,
              dSelector.d_selected.value,
              condSelector.cond_selected.value);
          setState(() {
            _phone.clear();
            _pname.clear();
            _des.clear();
            _price.clear();
            condSelector.cond_selected.value = '';
            selecter.c_selected.value = "";
            ageSlector.age_selected.value = "";
            sizeSelector.size_selected.value = "";
            picker.images.clear();
            picker.downloadurls.clear();
            qSelector.q_selected.value = "";
            dSelector.d_selected.value = "";
            FocusScope.of(context).unfocus();
          });
          load.lood.value = false;
          Get.snackbar('', '',
              titleText: const Text(
                'Success',
                style: TextStyle(color: Colors.white),
              ),
              messageText: const Text(
                "Product uploaded Successfully",
                style: TextStyle(color: Colors.white),
              ),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              duration: const Duration(seconds: 3),
              snackStyle: SnackStyle.GROUNDED);
        } catch (e) {
          Get.snackbar('', '',
              titleText: const Text(
                'Failed',
                style: TextStyle(color: Colors.white),
              ),
              messageText: Text(
                e.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              snackStyle: SnackStyle.GROUNDED);
        }
        load.lood.value = false;
      }
    }
  }


  Future<void> handelPermission() async {
    var status = await Permission.storage.status;

    if (status.isGranted) {
      // Permission is granted, call the function to pick photos
      Ipicker();
    } else if (status.isDenied) {
      // Permission is denied, request the permission from the user
      var result = await Permission.storage.request();
      if (result.isGranted) {
        // User granted the permission, call the function to pick photos
        Ipicker();
      } else {
        // User denied the permission, show a snackbar with a message
        Get.snackbar('Failed', 'Permission denied by the user');
      }
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied, open app settings to allow the user to enable the permission
      await openAppSettings();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add product",
          style: TextStyle(color: Colors.black, fontSize: 23),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Obx(
          () => AbsorbPointer(
            absorbing: load.lood.value ? true : false,
            child: Column(
              children: [
                Container(
                    height: 250,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: picker.images.length < 5
                          ? picker.images.length + 1
                          : 5, // Limit to 5 images
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        if (i < picker.images.length) {
                          // Display selected images
                          return Container(
                            height: 200,
                            alignment: Alignment.topRight,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(picker.images[i]),
                                    fit: BoxFit.cover)),
                            child: GestureDetector(
                                onTap: () async {
                                  picker.images.removeAt(i);
                                },
                                child: FaIcon(FontAwesomeIcons.solidTrashCan,color: Colors.red,size: 20,)),
                          );
                        } else {
                          return GestureDetector(
                            onTap: handelPermission,
                            child: Container(
                              color: Colors.grey.shade400,
                              height: 200,
                              width: 100,
                              child: const Icon(
                                Icons.add,
                                size: 80,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1, mainAxisSpacing: 5),
                    )),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.7,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2, right: 2),
                        child: Text(
                          "All fields must to be filled",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.7,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextField(
                    controller: _pname,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    maxLength: 50,
                    decoration: InputDecoration(
                      labelText: 'Product name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextField(
                    controller: _price,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Product Price',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: DropdownButtonFormField(
                      value: selecter.c_selected.value.isNotEmpty
                          ? selecter.c_selected.value
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Select Category',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      items: const [
                        DropdownMenuItem(
                          child: Text("Accessories"),
                          value: "Accessories",
                        ),
                        DropdownMenuItem(
                          child: Text("Footwear"),
                          value: "Footwear",
                        ),
                        DropdownMenuItem(
                          child: Text("Clothing"),
                          value: "Clothing",
                        ),
                        DropdownMenuItem(
                          child: Text("Tools"),
                          value: "Tools",
                        ),
                        DropdownMenuItem(
                          child: Text("Gadgets"),
                          value: "Gadgets",
                        ),
                        DropdownMenuItem(
                          child: Text("Furniture"),
                          value: "Furniture",
                        ),
                      ],
                      onChanged: (value) {
                        selecter.c_selected.value = value.toString();
                      }),
                ),
                if (selecter.c_selected.value == "Footwear" ||
                    selecter.c_selected.value == "Clothing")
                  const SizedBox(
                    height: 20,
                  ),
                if (selecter.c_selected.value == "Footwear" ||
                    selecter.c_selected.value == "Clothing")
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: DropdownButtonFormField(
                        value: ageSlector.age_selected.value.isNotEmpty
                            ? ageSlector.age_selected.value
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Select age',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        items: const [
                          DropdownMenuItem(
                            child: Text("childrens"),
                            value: "childrens",
                          ),
                          DropdownMenuItem(
                            child: Text("Gents"),
                            value: "Gents",
                          ),
                          DropdownMenuItem(
                            child: Text("Ladies"),
                            value: "Ladies",
                          ),
                          DropdownMenuItem(
                            child: Text("All"),
                            value: "All",
                          ),
                        ],
                        onChanged: (value) {
                          ageSlector.age_selected.value = value.toString();
                        }),
                  ),
                if (selecter.c_selected.value == "Footwear" ||
                    selecter.c_selected.value == "Clothing")
                  const SizedBox(
                    height: 20,
                  ),
                if (selecter.c_selected.value == "Footwear" ||
                    selecter.c_selected.value == "Clothing")
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: DropdownButtonFormField(
                        value: sizeSelector.size_selected.value.isNotEmpty
                            ? sizeSelector.size_selected.value
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Select Size',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        items: const [
                          DropdownMenuItem(
                            child: Text("Small"),
                            value: "Small",
                          ),
                          DropdownMenuItem(
                            child: Text("Medium"),
                            value: "Medium",
                          ),
                          DropdownMenuItem(
                            child: Text("Large"),
                            value: "Large",
                          ),
                          DropdownMenuItem(
                            child: Text("X-Large"),
                            value: "X-Large",
                          ),
                          DropdownMenuItem(
                            child: Text("All sizes"),
                            value: "All sizes",
                          ),
                        ],
                        onChanged: (value) {
                          sizeSelector.size_selected.value = value.toString();
                        }),
                  ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: DropdownButtonFormField(
                      value: qSelector.q_selected.value.isNotEmpty
                          ? qSelector.q_selected.value
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Select Quantity',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      items: const [
                        DropdownMenuItem(
                          child: Text("List as Single item"),
                          value: "List as Single item",
                        ),
                        DropdownMenuItem(
                          child: Text("List as a stock"),
                          value: "List as a stock",
                        ),
                      ],
                      onChanged: (value) {
                        qSelector.q_selected.value = value.toString();
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: DropdownButtonFormField(
                      value: dSelector.d_selected.value.isNotEmpty
                          ? dSelector.d_selected.value
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Delivery Services',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      items: const [
                        DropdownMenuItem(
                          child: Text("Available"),
                          value: "Available",
                        ),
                        DropdownMenuItem(
                          child: Text("Not available"),
                          value: "Not available",
                        ),
                      ],
                      onChanged: (value) {
                        dSelector.d_selected.value = value.toString();
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: DropdownButtonFormField(
                      value: condSelector.cond_selected.value.isNotEmpty
                          ? condSelector.cond_selected.value
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Select Condition',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      items: const [
                        DropdownMenuItem(
                          child: Text("New"),
                          value: "New",
                        ),
                        DropdownMenuItem(
                          child: Text("Used-like new"),
                          value: "Used-like new",
                        ),
                        DropdownMenuItem(
                          child: Text("Used-like good"),
                          value: "Used-like good",
                        ),
                        DropdownMenuItem(
                          child: Text("Used-like fair"),
                          value: "Used-like fair",
                        ),
                      ],
                      onChanged: (value) {
                        condSelector.cond_selected.value = value.toString();
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: IntlPhoneField(
                    controller: _phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      helperText:
                          "Customers will contact you by this provided contact number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    initialCountryCode: 'PK',
                    onChanged: (phone) {
                      print(phone.completeNumber);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextField(
                    minLines: 8,
                    maxLines: 20,
                    controller: _des,
                    decoration: InputDecoration(
                        hintText: "Description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21))),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: load.lood.value
                      ? const CircularProgressIndicator(
                          color: Colors.green,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: uploadProduct,
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(21)),
                                child: const Center(
                                  child: Text(
                                    'Upload Product',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.green,
                              child: IconButton(
                                icon: Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                            )
                          ],
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
