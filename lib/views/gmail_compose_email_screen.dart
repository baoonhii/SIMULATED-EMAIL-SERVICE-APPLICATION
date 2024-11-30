import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../other_widgets/general.dart';
import '../state_management/email_compose_provider.dart';
import '../constants.dart';

class EmailComposeScreen extends StatefulWidget {
  const EmailComposeScreen({super.key});

  @override
  State<EmailComposeScreen> createState() => _EmailComposeScreenState();
}

class _EmailComposeScreenState extends State<EmailComposeScreen> {
  final _recipientsController = TextEditingController();
  final _ccController = TextEditingController();
  final _bccController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();

  List<dynamic> _attachments = [];

  @override
  void initState() {
    super.initState();
  }

  void _pickAttachments() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        if (kIsWeb) {
          // For web, convert PlatformFile to custom WebAttachment
          _attachments = result.files
              .map((platformFile) => WebAttachment(
                    name: platformFile.name,
                    bytes: platformFile.bytes!,
                  ))
              .toList();
        } else {
          // For mobile/desktop, use File paths as before
          _attachments = result.paths.map((path) => File(path!)).toList();
        }
      });
    }
  }

  void _sendEmail() {
    // Split recipients by comma and trim
    final recipients = _recipientsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final cc = _ccController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final bcc = _bccController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    Provider.of<EmailComposeProvider>(context, listen: false).sendEmail(
      recipients: recipients,
      ccRecipients: cc.isNotEmpty ? cc : null,
      bccRecipients: bcc.isNotEmpty ? bcc : null,
      subject: _subjectController.text,
      body: _bodyController.text,
      attachments: _attachments.isNotEmpty ? _attachments : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compose Email'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendEmail,
          ),
        ],
      ),
      body: Consumer<EmailComposeProvider>(
        builder: (context, composeProvider, child) {
          print('EmailComposeScreen: isLoading: ${composeProvider.isLoading}');
          print('EmailComposeScreen: isSuccess: ${composeProvider.isSuccess}');
          print(
              'EmailComposeScreen: errorMessage: ${composeProvider.errorMessage}');
          if (composeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (composeProvider.isSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showSnackBar(context, 'Email sent successfully!');
              // Mark that we've navigated after success
              composeProvider.markNavigatedAfterSuccess();
              Navigator.of(context)
                  .pushReplacementNamed(MailRoutes.INBOX.value);
            });
          }

          if (composeProvider.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showSnackBar(context, composeProvider.errorMessage!);
            });
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _recipientsController,
                    decoration: const InputDecoration(
                      labelText: 'To',
                      hintText: 'Comma-separated email addresses',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _ccController,
                    decoration: const InputDecoration(
                      labelText: 'CC',
                      hintText: 'Comma-separated email addresses (Optional)',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _bccController,
                    decoration: const InputDecoration(
                      labelText: 'BCC',
                      hintText: 'Comma-separated email addresses (Optional)',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _bodyController,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickAttachments,
                        icon: const Icon(Icons.attach_file),
                        label: const Text('Add Attachments'),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${_attachments.length} file(s) selected',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
