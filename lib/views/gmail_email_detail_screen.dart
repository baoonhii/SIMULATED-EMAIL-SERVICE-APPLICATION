import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../data_classes.dart';
import '../other_widgets/general.dart';
import '../state_management/email_provider.dart';
import '../state_management/label_provider.dart';

class GmailEmailDetailScreen extends StatefulWidget {
  final Email email;

  const GmailEmailDetailScreen({super.key, required this.email});

  @override
  State<GmailEmailDetailScreen> createState() => _GmailEmailDetailScreenState();
}

class _GmailEmailDetailScreenState extends State<GmailEmailDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch emails when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LabelProvider>(context, listen: false).fetchLabels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final quillController = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(widget.email.body)),
      selection: const TextSelection.collapsed(offset: 0),
    );
    final emailsProvider = Provider.of<EmailsProvider>(context);
    final labelsProvider = Provider.of<LabelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.mailDetail),
        actions: [
          // Mark as Read/Unread
          IconButton(
            icon: Icon(
              widget.email.is_read
                  ? Icons.mark_email_unread
                  : Icons.mark_email_read,
            ),
            onPressed: () {
              emailsProvider.performEmailAction(
                widget.email,
                EmailAction.markRead,
              );
              print("is read?");
              setState(() {});
            },
          ),
          // Star/Unstar
          IconButton(
            icon: Icon(
              widget.email.is_starred ? Icons.star : Icons.star_border,
            ),
            onPressed: () => emailsProvider.performEmailAction(
              widget.email,
              EmailAction.star,
            ),
          ),
          // Move to Trash
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => emailsProvider.performEmailAction(
              widget.email,
              EmailAction.moveToTrash,
            ),
          ),
          // Label Dropdown
          PopupMenuButton<EmailLabel>(
            icon: const Icon(Icons.label),
            onSelected: (EmailLabel label) {
              // Toggle label
              emailsProvider.updateEmailLabels(
                email: widget.email,
                label: label,
              );
            },
            itemBuilder: (BuildContext context) => labelsProvider.labels.map(
              (EmailLabel label) {
                bool isLabeled = widget.email.labels.contains(label);
                return PopupMenuItem<EmailLabel>(
                  value: label,
                  child: Row(
                    children: [
                      Checkbox(
                        value: isLabeled,
                        onChanged: (bool? newValue) {
                          emailsProvider.updateEmailLabels(
                            email: widget.email,
                            label: label,
                          );
                          Navigator.of(context).pop(); // Close the popup menu
                        },
                      ),
                      Text(label.displayName),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metadata section
            _buildMetadataSection(context),
            const SizedBox(height: 10),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            // Email body
            Expanded(
              child: quill.QuillEditor.basic(
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
                ),
              ),
            ),
            // Attachments section
            if (widget.email.attachments.isNotEmpty) _buildAttachmentsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subject: ${widget.email.subject}',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.person, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'From: ${widget.email.sender}',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.people, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'To: ${widget.email.recipients.join(", ")}',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Colors.grey[700],
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (widget.email.labels.isNotEmpty) const SizedBox(height: 8),
        if (widget.email.labels.isNotEmpty)
          Wrap(
            spacing: 8,
            children: widget.email.labels
                .map((label) => Chip(
                      label: Text(label.displayName),
                      backgroundColor: label.color,
                    ))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildAttachmentsSection() {
    return ExpansionTile(
      title: Text('Attachments (${widget.email.attachments.length})'),
      children: widget.email.attachments.map((attachment) {
        return ListTile(
          leading: getAttachmentIcon(attachment),
          title: Text(attachment.filename),
          trailing: IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              print("Trying to download attachment");
            },
          ),
        );
      }).toList(),
    );
  }
}
