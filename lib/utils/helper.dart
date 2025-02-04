import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:threads/utils/dotenv.dart';
import 'package:threads/widgets/confirm_dialog.dart';
import 'package:uuid/uuid.dart';

void showSnackBar(
  String message,
  String title,
) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    colorText: Colors.white,
    padding: const EdgeInsets.symmetric(
      vertical: 5,
      horizontal: 10,
    ),
    snackStyle: SnackStyle.GROUNDED,
    backgroundColor: Color(0xff252526),
    margin: const EdgeInsets.all(0.0),
  );
}

Future<File?> pickImageFormGallery() async {
  var uuid = Uuid();
  final ImagePicker picker = ImagePicker();
  final XFile? file = await picker.pickImage(source: ImageSource.gallery);

  if (file == null) {
    return null;
  }
  final dir = Directory.systemTemp;
  final targetPath = "${dir.absolute.path}/${uuid.v1()}.jpg";
  File image = await compressImage(File(file.path), targetPath);
  return image;
}

// compress image
Future<File> compressImage(File file, String targetPath) async {
  final result = await FlutterImageCompress.compressAndGetFile(
    file.path,
    targetPath,
    quality: 70,
  );
  return File(result!.path);
}

// to get s3 url
String getS3Url(String path) {
  return '${Env.supabaseUrl}/storage/v1/object/public/$path';
}

// Confirm Dialog
void confirmDialog(
  String title,
  String message,
  VoidCallback action,
) {
  Get.dialog(
    ConfirmDialog(
      title: title,
      message: message,
      action: action,
    ),
  );
}

// * to format date
String formateDateFromNow(String date) {
  // Parse UTC timestamp string to DateTime
  DateTime utcDateTime = DateTime.parse(date.split('+')[0].trim());

  // Convert UTC to IST (UTC+5:30 for Indian Standard Time)
  DateTime istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30));

  // Format the DateTime using Jiffy
  return Jiffy.parseFromDateTime(istDateTime).fromNow();
}