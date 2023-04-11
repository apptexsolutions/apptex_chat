

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: must_be_immutable
class ProfilePic extends StatelessWidget {
  ProfilePic(this.url, {this.size = 48, this.radius = 100, Key? key})
      : super(key: key);
  String url;

  final double size;
  final double radius;
  @override
  Widget build(BuildContext context) {
    url = url.length <= 7 ? "" : url;
    bool isNotUrl = url.length <= 7;

    double imsix = size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: isNotUrl
          ? Container(
              color: Theme.of(context).colorScheme.primary,
              width: imsix,
              height: imsix,
              child: const Icon(
                Icons.person,
                size: 20,
              ))
          : Container(
              width: imsix,
              height: imsix,
              color: Colors.grey.shade300,
              child: Image(
                image: CachedNetworkImageProvider(
                  url,
                ),
                alignment: Alignment.center,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
