import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads/utils/helper.dart';

class PostCardImage extends StatelessWidget {
  final String url;
  const PostCardImage({required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: context.height * 0.3, maxWidth: context.width * 0.8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          getS3Url(url),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
