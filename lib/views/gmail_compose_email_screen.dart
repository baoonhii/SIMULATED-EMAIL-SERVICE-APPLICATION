import 'package:flutter/material.dart';

class GmailComposeEmailScreen extends StatefulWidget {
  @override
  _GmailComposeEmailScreenState createState() =>
      _GmailComposeEmailScreenState();
}

class _GmailComposeEmailScreenState extends State<GmailComposeEmailScreen> {
  List<String> attachedFiles = [];
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  void _attachFile() {
    setState(() {
      attachedFiles.add('mock_file_${attachedFiles.length + 1}.txt');
    });
  }

  void _saveDraft() {
    final draft = {
      'to': _toController.text,
      'subject': _subjectController.text,
      'body': _bodyController.text,
      'attachments': attachedFiles,
    };
    // Navigate to the drafts screen with the draft data
    Navigator.pushNamed(context, '/drafts', arguments: draft);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soạn thư'),
        actions: [
          IconButton(icon: Icon(Icons.attach_file), onPressed: _attachFile),
          IconButton(icon: Icon(Icons.save), onPressed: _saveDraft),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                // Sending email logic goes here
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _toController,
              decoration: InputDecoration(labelText: 'To'),
            ),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            Expanded(
              child: TextField(
                controller: _bodyController,
                decoration: InputDecoration(labelText: 'Compose email'),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
            if (attachedFiles.isNotEmpty) ...[
              Divider(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tệp đính kèm:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: attachedFiles.map((file) {
                  return Chip(
                    label: Text(file),
                    deleteIcon: Icon(Icons.close),
                    onDeleted: () {
                      setState(() {
                        attachedFiles.remove(file);
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
