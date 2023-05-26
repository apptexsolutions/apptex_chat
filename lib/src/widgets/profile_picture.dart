import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic(this.url,
      {this.size = 28, this.radius = 100, Key? key, this.iconSize = 24})
      : super(key: key);
  final String url;

  final double size;
  final double radius;
  final double iconSize;
  @override
  Widget build(BuildContext context) {
    // url = url.length <= 7 ? "" : url;
    bool isNotUrl = url.length <= 7;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: isNotUrl
          ? Container(
              color: Theme.of(context).colorScheme.primary,
              width: size,
              height: size,
              child: const Icon(
                Icons.person,
                size: 20,
                color: Colors.white,
              ))
          : Container(
              width: size,
              height: size,
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
