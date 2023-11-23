import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewer extends StatefulWidget {
  final List<String> images;
  final int index;

  ImageViewer({required this.images, required this.index});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late int currentIndex;

  @override
  void initState() {
    currentIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Image ${currentIndex+1} of ${widget.images.length}",style: TextStyle(
          color: Colors.white,fontSize: 23
        ),),
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: PhotoViewGallery.builder(
          itemCount: widget.images.length,
          backgroundDecoration: BoxDecoration(
            color: Colors.black,
          ),
          pageController: PageController(initialPage: currentIndex),
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          builder: (context, i) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.images[i]),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          scrollPhysics: BouncingScrollPhysics(),

        ),
      ),
      // bottomNavigationBar:
      // BottomAppBar(
      //   color: Colors.black.withOpacity(0.5),
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget>[
      //         Text(
      //           '${currentIndex + 1} of ${widget.images.length}',
      //           style: TextStyle(color: Colors.white),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
