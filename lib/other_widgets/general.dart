import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../constants.dart';
import '../data_classes.dart';

TextField getTextField(
  TextEditingController controller,
  String labelText, {
  int? maxLines,
}) {
  return TextField(
    controller: controller,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: labelText,
      border: const OutlineInputBorder(),
    ),
  );
}

TextField getTextFieldHint(
  TextEditingController controller,
  String labelText,
  String hintText, {
  int? maxLines,
}) {
  return TextField(
    controller: controller,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      border: const OutlineInputBorder(),
    ),
  );
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

ImageProvider<Object> getImageFromAccount(Account currentAccount) {
  return CachedNetworkImageProvider(
    getUserProfileImageURL(
      currentAccount.profile_picture,
    ),
  );
}

ElevatedButton getSaveButton(
  BuildContext context,
  VoidCallback onPressed,
  String displayText,
) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    child: Text(displayText),
  );
}

ElevatedButton getButtonCondition(
  BuildContext context,
  VoidCallback onPressed,
  bool condition,
  String displayTrue,
  String displayFalse,
) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Text(condition ? displayTrue : displayFalse),
  );
}

const centerCircleProgress = Center(child: CircularProgressIndicator());