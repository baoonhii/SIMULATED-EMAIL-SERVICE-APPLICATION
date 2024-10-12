import 'package:flutter/material.dart';

class GmailDraftsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final draft = ModalRoute.of(context)?.settings.arguments as Map?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Drafts'),
      ),
      body: draft != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('To: ${draft['to']}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Subject: ${draft['subject']}'),
                  SizedBox(height: 10),
                  Text('Body: ${draft['body']}'),
                  SizedBox(height: 20),
                  Text('Attachments:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8.0,
                    children: (draft['attachments'] as List<String>)
                        .map((attachment) => Chip(label: Text(attachment)))
                        .toList(),
                  ),
                ],
              ),
            )
          : Center(child: Text('No drafts available')),
    );
  }
}
