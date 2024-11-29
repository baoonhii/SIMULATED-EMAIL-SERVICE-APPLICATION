import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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

void showSnackBar(BuildContext context, String message) {
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
