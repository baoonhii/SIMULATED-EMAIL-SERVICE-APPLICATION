import 'package:flutter/material.dart';
import 'gmail_drawer.dart';

class GmailBaseScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? appBarWidget;
  final FloatingActionButton? floatingActionButton;

  GmailBaseScreen({
    required this.title,
    required this.body,
    this.appBarWidget,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarWidget ?? Text(title),
      ),
      drawer: GmailDrawer(),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
