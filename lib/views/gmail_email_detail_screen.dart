import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'mock_data.dart';

class GmailEmailDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết email'),
        actions: [
          IconButton(icon: Icon(Icons.archive), onPressed: () {}),
          IconButton(icon: Icon(Icons.delete), onPressed: () {}),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('From: sender@example.com',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('To: you@example.com'),
            SizedBox(height: 16),
            Text(
              'This is the detailed content of the email.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
