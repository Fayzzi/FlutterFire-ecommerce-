import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  final String imagel;
  ProfileView({required this.imagel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Hero(
        tag: "PROF",
        child: CachedNetworkImage(
          imageUrl: imagel,
          errorWidget: (context, error, url) => Center(
              child: Icon(
            Icons.error,
            color: Colors.red,
          )),
          placeholder: (context, url) => Center(
            child: CupertinoActivityIndicator(),
          ),
          imageBuilder: (context, imageProvider) {
            return Container(
              decoration:
                  BoxDecoration(image: DecorationImage(image: imageProvider)),
            );
          },
        ),
      ),
    );
  }
}
