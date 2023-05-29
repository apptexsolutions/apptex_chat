// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  String imgUrl;
  FullScreenImage({
    Key? key,
    required this.imgUrl,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size devSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.only(left: 8),
            margin: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.5),
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 25,
              ),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Hero(
          tag: imgUrl,
          transitionOnUserGestures: true,
          child: Image(
            width: devSize.width,
            fit: BoxFit.fitWidth,
            image: CachedNetworkImageProvider(
              imgUrl,
            ),
          ),
        ),
      ),
    );
  }
}
