import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project_ecommerce/Screens/AdminPanel/AdminPanel.dart';

class ChatScreen extends StatefulWidget {
  String ChatID;
  String SenderID;
  String RecieverID;
  String SenderEmail;
  String RecieverEmail;
  String ProductName;

  ChatScreen({
    required this.ProductName,
    required this.ChatID,
    required this.RecieverEmail,
    required this.RecieverID,
    required this.SenderEmail,
    required this.SenderID,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: false,
        title: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(widget.RecieverID)
              .snapshots(),
          builder: (context, userSNAP) {
            if (userSNAP.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            }
            if (userSNAP.hasData) {
              Map<String, dynamic> userdata =
                  userSNAP.data!.data() as Map<String, dynamic>;
              String status = userdata['Status'] ?? "";

              return Column(
                children: [
                  Text(
                    userdata['Username'],
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  status == "" || status == 'Offline'
                      ? userdata['Last Seen'] != null
                          ? Text(
                              formatDateTime(userdata['Last Seen']),
                              style: const TextStyle(fontSize: 14),
                            )
                          : const Text("Offline",
                              style: TextStyle(fontSize: 14))
                      : status == 'Online'
                          ? Text(status, style: const TextStyle(fontSize: 14))
                          : Text(formatDateTime(userdata['Last Seen']),
                              style: const TextStyle(fontSize: 14))
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("ChatRooms")
                  .doc(widget.ChatID)
                  .collection("Messages")
                  .orderBy('TimeStamp', descending: true)
                  .snapshots(),
              builder: (context, messageSnapshot) {
                if (messageSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: SizedBox());
                }
                if (messageSnapshot.hasError) {
                  return Center(
                    child: Text(messageSnapshot.error.toString()),
                  );
                }
                if (!messageSnapshot.hasData) {
                  return const Center(
                    child: Text('An error has occured'),
                  );
                }

                if (messageSnapshot.hasData ||
                    messageSnapshot.data!.docs.isNotEmpty) {
                  List<DocumentSnapshot> messages = messageSnapshot.data!.docs;
                  if (messages.isEmpty) {
                    return const Center(
                      child: Text(
                          'Start a positive Conversation with the owner of this product'),
                    );
                  }
                  return ListView.builder(
                    reverse: true, // Set reverse property to true
                    itemCount: messages.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      bool isSender = messages[i]['Sender ID'] == user!.uid;
                      return Align(
                        alignment: isSender
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: isSender
                                    ? [
                                        Colors.brown,
                                        Colors.black87,
                                      ]
                                    : [Colors.green, Colors.blueGrey]),
                            borderRadius: isSender
                                ? const BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30))
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30)),
                          ),
                          child: Column(
                            crossAxisAlignment: isSender
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   messages[i]['Sender Email'],
                              //   style: TextStyle(
                              //       color:
                              //           isSender ? Colors.white : Colors.white),
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              if(messages[i]['Message']!=null)
                              Text(
                                messages[i]['Message'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                                textAlign: TextAlign.justify,
                                maxLines: null,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if(messages[i]['TimeStamp']!=null)
                              Text(
                                formatDateTime(messages[i]['TimeStamp']),
                                style: TextStyle(
                                    color:
                                        isSender ? Colors.white : Colors.black,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value){
                      color.isTextFieldEmpty.value=value.isEmpty;
                    },
                    controller: _messageController,
                    maxLines: null, // Set maxLines to null for multiline input
                    keyboardType:
                        TextInputType.multiline, // Enable multiline keyboard
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Obx(() => CircleAvatar(
                        backgroundColor: color.isTextFieldEmpty.value
                            ? Colors.grey
                            : Colors.green,
                        radius: 26,
                        child: IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            // Handle sending the message logic here
                            String message = _messageController.text;
                            if (message.isNotEmpty) {
                              FirebaseFirestore.instance
                                  .collection("ChatRooms")
                                  .doc(widget.ChatID)
                                  .collection("Messages")
                                  .doc()
                                  .set({
                                'Product Name': widget.ProductName,
                                'Sender ID': user!.uid,
                                'ChatID': widget.ChatID,
                                "Reciever Id": widget.RecieverID,
                                'Sender Email': user!.email,
                                "Reciever Email": widget.RecieverEmail,
                                'Message': _messageController.text,
                                "TimeStamp": DateTime.now(),
                              });
                              _messageController.clear();
                            }
                          },
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextFieldColor color = Get.put(TextFieldColor());
}

class TextFieldColor extends GetxController {
  var isTextFieldEmpty = true.obs;
}
