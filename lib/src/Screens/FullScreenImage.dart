// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:apptex_chat/src/Controllers/contants.dart';
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
      backgroundColor: Colors.white,
      body: SizedBox(
        height: devSize.height,
        child: Stack(
          children: [
            Center(
              child: Hero(
                  tag: imgUrl,
                  child: Image(
                      width: devSize.width,
                      fit: BoxFit.contain,
                      image: NetworkImage(
                        imgUrl,
                      ))),
            ),
            Positioned(
              top: devSize.height * 0.07,
              child: GestureDetector(
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
                    color: Colors.black.withOpacity(0.34),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
