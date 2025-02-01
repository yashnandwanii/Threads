import 'dart:io';
import 'package:flutter/material.dart';
import 'package:threads/utils/helper.dart';

class CircleImage extends StatelessWidget {
  final double radius;
  final String? imageUrl;
  final File? filePath;

  const CircleImage({
    super.key,
    this.radius = 20.0,
    this.imageUrl,
    this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (filePath != null)
          CircleAvatar(
            radius: radius,
            backgroundImage: FileImage(filePath!),
          )
        else if (imageUrl != null)
          CircleAvatar(
            backgroundImage: NetworkImage(getS3Url(imageUrl!)),
            radius: radius,
          )
        else
          CircleAvatar(
            radius: radius,
            backgroundImage: const AssetImage("assets/images/avatar.png"),
          )
      ],
    );
  }
}
