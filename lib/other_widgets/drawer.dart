import 'package:flutter/material.dart';

ListTile buildDrawerItem(
  IconData icon, 
  String title, 
  String route,
  BuildContext context, 
  Color textColor, 
  Color iconColor, 
  Object? arguments,
  {isReplacement = false}
) {
  print('buildDrawerItem called with:');
  print('  route: $route');
  print('  arguments: $arguments');
  print('  arguments type: ${arguments.runtimeType}');

  return ListTile(
    leading: Icon(icon, color: iconColor),
    title: Text(title, style: TextStyle(color: textColor)),
    onTap: () {
      print('Tapped drawer item:');
      print('  Route: $route');
      print('  Arguments: $arguments');
      
      if (isReplacement) {
        Navigator.pushReplacementNamed(context, route, arguments: arguments);
      } else {
        Navigator.pushNamed(context, route, arguments: arguments);
      }
    },
  );
}