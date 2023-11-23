import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project_ecommerce/Screens/AdminPanel/AdminPanel.dart';
import 'package:mad_project_ecommerce/Screens/AdminPanel/uploadedproduct/Deleting/UploadedDeleting.dart';

class UploadedHelper extends StatelessWidget {
  DocumentSnapshot doc;
  UploadedHelper({required this.doc});
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> myDATA = doc.data() as Map<String, dynamic>;
    List<String> dataImages = List<String>.from(myDATA['Product Images']);
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: ListTile(
        leading: Image.network(dataImages.first),
        title: Text(
          myDATA['Product name'],
          style: TextStyle(
              color: CupertinoDynamicColor.withBrightness(
                  color: Colors.black, darkColor: Colors.purple),
              fontSize: 18),
        ),
        subtitle: Text(formatDateTime(myDATA['Uploaded on'])),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () async {
            if (myDATA['Category'] == 'Clothing' ||
                myDATA['Category'] == 'Footwear') {
              Get.defaultDialog(
                  title: "Alert",
                  content: Text(
                      'Are you sure you want to Delete this product permenently?'),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Get.back();
                        },
                        child: Text("No")),
                    TextButton(
                        onPressed: () async {
                          Get.back();
                          await Deletedata().DeleteCloths(
                              doc.id, myDATA['Category'], myDATA['For ages']);
                        },
                        child: Text('Yes'))
                  ]);
            } else {
              Get.defaultDialog(
                  title: "Alert",

                  content: Text(
                      'Are you sure you want to Delete this product permenently?'),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Get.back();
                        },
                        child: Text("No")),
                    TextButton(
                        onPressed: () async {
                          Get.back();
                          await Deletedata().DeleteSimple(doc.id, myDATA['Category']);

                        },
                        child: Text('Yes'))
                  ]);

            }
          },
        ),
      ),
    );
  }
}
