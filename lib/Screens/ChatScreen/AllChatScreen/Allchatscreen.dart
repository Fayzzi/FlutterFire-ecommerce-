import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project_ecommerce/Screens/ChatScreen/ChatScreen.dart';

class AllChatScreen extends StatefulWidget {
  const AllChatScreen({super.key});

  @override
  State<AllChatScreen> createState() => _AllChatScreenState();
}

class _AllChatScreenState extends State<AllChatScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  void _showProfilePicture(String Imageurl) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(Imageurl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Chats",
          style: TextStyle(color: Colors.black, fontSize: 23),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(user!.uid)
            .snapshots(),
        builder: (context, userData) {
          if (userData.connectionState == ConnectionState.waiting) {
            return const Center(child: SizedBox());
          }
          if (userData.hasError) {
            return Center(
              child: Text(userData.error.toString()),
            );
          }
          if (!userData.hasData && !userData.data!.exists) {
            return const Center(
              child: Text('An error has occurred'),
            );
          }
          if (userData.hasData && userData.data!.exists) {
            Map<String, dynamic> User =
                userData.data!.data() as Map<String, dynamic>;
            List<String> chatIds = List<String>.from(User['ChatIds']);
            return ListView.builder(
              itemCount: chatIds.length,
              itemBuilder: (context, i) {
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("ChatRooms")
                      .doc(chatIds[i])
                      .collection('Messages')
                      .orderBy('TimeStamp', descending: true)
                      .limit(1)
                      .snapshots(),
                  builder: (context, chatSnap) {
                    if (chatSnap.connectionState == ConnectionState.waiting) {
                      return const Center(child: SizedBox());
                    }
                    if (chatSnap.hasError) {
                      return Center(
                        child: Text(chatSnap.error.toString()),
                      );
                    }
                    if (!chatSnap.hasData || chatSnap.data!.docs.isEmpty) {
                      return const SizedBox(); // No data available, return an empty container
                    }
                   if(chatSnap.hasData || chatSnap.data!.docs.isNotEmpty){
                     var latestMessage = chatSnap.data!.docs.first;
                     return ListTile(
                       onTap: () {
                         Get.to(() => ChatScreen(
                             ProductName: latestMessage['Product Name'],
                             ChatID: latestMessage['ChatID'],
                             RecieverEmail:
                             user!.email == latestMessage['Reciever Email']
                                 ? latestMessage['Sender Email']
                                 : latestMessage['Reciever Email'],
                             RecieverID:
                             user!.uid == latestMessage['Reciever Id']
                                 ? latestMessage['Sender ID']
                                 : latestMessage['Reciever Id'],
                             SenderEmail: user!.email ?? '',
                             SenderID: user!.uid));
                       },
                       leading: user!.uid == latestMessage['Sender ID']
                           ? StreamBuilder(
                         stream: FirebaseFirestore.instance
                             .collection("Users")
                             .doc(latestMessage['Reciever Id'])
                             .snapshots(),
                         builder: (context, notOwner) {
                           if (notOwner.connectionState ==
                               ConnectionState.waiting) {
                             return const SizedBox();
                           }
                           if (notOwner.hasError) {
                             return const Text(
                                 'Error loading profile picture');
                           }

                           if (notOwner.hasData && notOwner.data!.exists) {
                             Map<String, dynamic> receiveData =
                             notOwner.data!.data()
                             as Map<String, dynamic>;
                             String profilePictureUrl =
                                 receiveData['Profile Picture'] ?? "";

                             if (profilePictureUrl.isNotEmpty) {
                               return CachedNetworkImage(
                                 imageUrl: profilePictureUrl,
                                 placeholder: (context, url) =>
                                     CupertinoActivityIndicator(),
                                 errorWidget: (context, error, url) =>
                                     Icon(
                                       Icons.error,
                                       color: Colors.red,
                                     ),
                                 imageBuilder: (context, imageProvider) {
                                   return GestureDetector(
                                     onTap: () {
                                       _showProfilePicture(
                                           profilePictureUrl);
                                     },
                                     child: CircleAvatar(
                                       radius: 27,
                                       backgroundColor: Colors.transparent,
                                       backgroundImage: imageProvider,
                                     ),
                                   );
                                 },
                               );
                             } else {
                               return const CircleAvatar(
                                 radius: 27,
                                 backgroundColor: Colors.transparent,
                                 backgroundImage:
                                 AssetImage('images/user.jpg'),
                               );
                             }
                           }

                           return const SizedBox();
                         },
                       )
                           : StreamBuilder(
                         stream: FirebaseFirestore.instance
                             .collection("Users")
                             .doc(latestMessage['Sender ID'])
                             .snapshots(),
                         builder: (context, owner) {
                           if (owner.connectionState ==
                               ConnectionState.waiting) {
                             return const SizedBox();
                           }
                           if (owner.hasError) {
                             return const Text(
                                 'Error loading profile picture');
                           }

                           if (owner.hasData && owner.data!.exists) {
                             Map<String, dynamic> receiveData = owner.data!
                                 .data() as Map<String, dynamic>;
                             String profilePictureUrl =
                                 receiveData['Profile Picture'] ?? "";

                             if (profilePictureUrl.isNotEmpty) {
                               return CachedNetworkImage(
                                 imageUrl: profilePictureUrl,
                                 placeholder: (context, url) =>
                                     CupertinoActivityIndicator(),
                                 errorWidget: (context, error, url) =>
                                     Icon(
                                       Icons.error,
                                       color: Colors.red,
                                     ),
                                 imageBuilder: (context, imageProvider) {
                                   return GestureDetector(
                                     onTap: () {
                                       _showProfilePicture(
                                           profilePictureUrl);
                                     },
                                     child: CircleAvatar(
                                       radius: 27,
                                       backgroundColor: Colors.transparent,
                                       backgroundImage: imageProvider,
                                     ),
                                   );
                                 },
                               );
                             } else {
                               return const CircleAvatar(
                                 radius: 27,
                                 backgroundColor: Colors.transparent,
                                 backgroundImage:
                                 AssetImage('images/user.jpg'),
                               );
                             }
                           }

                           return const SizedBox();
                         },
                       ),
                       title: latestMessage['Reciever Id'] == user!.uid
                           ? Text(
                         "${latestMessage['Sender Email']} -- ${latestMessage['Product Name']}",
                         style: const TextStyle(
                             overflow: TextOverflow.ellipsis),
                       )
                           : Text(
                           "${latestMessage['Reciever Email']} -- ${latestMessage['Product Name']}",
                           style: const TextStyle(
                               overflow: TextOverflow.ellipsis)),
                       subtitle: latestMessage['Sender ID'] == user!.uid
                           ? Text(
                         'Me: ${latestMessage['Message']}',
                         overflow: TextOverflow
                             .ellipsis, // Assuming there is a 'message' field in your chat data
                         style: const TextStyle(color: Colors.grey),
                       )
                           : Text(
                         '${latestMessage['Message']}',
                         overflow: TextOverflow
                             .ellipsis, // Assuming there is a 'message' field in your chat data
                         style: const TextStyle(color: Colors.grey),
                       ),
                       trailing: const Icon(Icons.arrow_forward_ios),
                     );
                   }
                   return SizedBox();
                  },
                );
              },
            );
          }
          return const SizedBox(); // Return an empty container if no user data is available
        },
      ),
    );
  }
}
