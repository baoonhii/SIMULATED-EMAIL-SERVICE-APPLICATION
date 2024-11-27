import 'package:flutter/material.dart';

ListTile buildDrawerItem(
  IconData icon,
  String title,
  String route,
  BuildContext context,
  Color textColor,
  Color iconColor,
) {
  return ListTile(
    leading: Icon(icon, color: iconColor),
    title: Text(title, style: TextStyle(color: textColor)),
    onTap: () {
      Navigator.pushNamed(context, route);
    },
  );
}
