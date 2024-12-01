import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../data_classes.dart';

class GmailEmailDetailScreen extends StatelessWidget {
  final Email email;

  const GmailEmailDetailScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    print(email.body);
    final quillController = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(email.body)),
      selection: const TextSelection.collapsed(offset: 0),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.mailDetail),
        actions: [
          IconButton(icon: const Icon(Icons.archive), onPressed: () {}),
          IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subject: ${email.subject}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'From: ${email.sender}',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            quill.QuillEditor.basic(
              controller: quillController,
              scrollController: ScrollController(),
              configurations: const quill.QuillEditorConfigurations(
                scrollable: true,
                expands: false,
                showCursor: false,
                padding: EdgeInsets.all(16),
                autoFocus: false,
              ),
              focusNode: FocusNode(
                canRequestFocus: false,
              ), // FocusNode(canRequestFocus: false),
            )
          ],
        ),
      ),
    );
  }
}
