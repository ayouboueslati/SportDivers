import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CardPicture extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;

  const CardPicture({
    Key? key,
    this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        width: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: imagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(imagePath!),
                  fit: BoxFit.cover,
                ),
              )
            : Icon(
                Icons.add_a_photo,
                size: 50,
                color: Colors.grey[400],
              ),
      ),
    );
  }
}
