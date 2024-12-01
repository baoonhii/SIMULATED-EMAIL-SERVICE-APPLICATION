import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants.dart';
import '../utils/other.dart';
import '../utils/parsers.dart';
import '../other_widgets/general.dart';
import '../state_management/email_compose_provider.dart';

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

  final _quillController = quill.QuillController.basic();

  final List<dynamic> _attachments = [];

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
          _attachments.addAll(
            result.files.map(WebAttachment.fromPlatformFile).toList(),
          );
        } else {
          // For mobile/desktop, use File paths as before
          _attachments.addAll(result.paths.map((path) => File(path!)).toList());
        }
      });
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  void _sendEmail() {
    // Split recipients by comma and trim
    final List<String> recipients = parseSeparatedFields(_recipientsController);
    final List<String> cc = parseSeparatedFields(_ccController);
    final List<String> bcc = parseSeparatedFields(_bccController);

    final content = jsonEncode(_quillController.document.toDelta().toJson());
    print(content);

    Provider.of<EmailComposeProvider>(context, listen: false).sendEmail(
      recipients: recipients,
      ccRecipients: cc.isNotEmpty ? cc : null,
      bccRecipients: bcc.isNotEmpty ? bcc : null,
      subject: _subjectController.text,
      body: content,
      attachments: _attachments.isNotEmpty ? _attachments : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.composeMail),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendEmail,
          ),
        ],
      ),
      body: Consumer<EmailComposeProvider>(
        builder: (context, composeProvider, child) {
          if (composeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (composeProvider.isSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showSnackBar(
                context,
                AppLocalizations.of(context)!.emailSentSuccess,
              );
              // Mark that we've navigated after success
              composeProvider.markNavigatedAfterSuccess();
              Navigator.of(context).pushReplacementNamed(
                MailRoutes.INBOX.value,
              );
            });
          }

          if (composeProvider.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showSnackBar(context, composeProvider.errorMessage!);
            });
          }

          String optionalHint =
              '${AppLocalizations.of(context)!.hintCommaSepEmailAddrs} (${AppLocalizations.of(context)!.optional})';

          return SingleChildScrollView(
            child: getEmailComposer(context, optionalHint),
          );
        },
      ),
    );
  }

  Padding getEmailComposer(BuildContext context, String optionalHint) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          getTextFieldHint(
            _recipientsController,
            'To',
            AppLocalizations.of(context)!.hintCommaSepEmailAddrs,
          ),
          const SizedBox(height: 10),
          getTextFieldHint(_ccController, 'CC', optionalHint),
          const SizedBox(height: 10),
          getTextFieldHint(_bccController, 'BCC', optionalHint),
          const SizedBox(height: 10),
          TextField(
            controller: _subjectController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.emailSubject,
            ),
          ),
          const SizedBox(height: 10),
          getQuillToolbar(),
          getQuillEditor(),
          const SizedBox(height: 10),
          getAttachmentAddButton(context),
          const SizedBox(height: 10),
          if (_attachments.isNotEmpty) getAttachmentManagerBox(),
        ],
      ),
    );
  }

  Column getAttachmentManagerBox() {
    return Column(
      children: _attachments.asMap().entries.map((entry) {
        int idx = entry.key;
        dynamic attachment = entry.value;
        String name = kIsWeb
            ? (attachment as WebAttachment).name
            : (attachment as File).path.split('/').last;
        return ListTile(
          leading: const Icon(Icons.attachment),
          title: Text(name),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle),
            onPressed: () => _removeAttachment(idx),
          ),
        );
      }).toList(),
    );
  }

  Row getAttachmentAddButton(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: _pickAttachments,
          icon: const Icon(Icons.attach_file),
          label: Text(
            AppLocalizations.of(context)!.addAttachments,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '${AppLocalizations.of(context)!.selected}: ${_attachments.length} ${AppLocalizations.of(context)!.files}',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Container getQuillEditor() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: quill.QuillEditor(
        controller: _quillController,
        scrollController: ScrollController(),
        focusNode: FocusNode(),
        configurations: const quill.QuillEditorConfigurations(
          scrollable: true,
          expands: true,
          padding: EdgeInsets.all(8.0),
        ),
      ),
    );
  }

  quill.QuillSimpleToolbar getQuillToolbar() {
    return quill.QuillToolbar.simple(
      controller: _quillController,
      configurations: const quill.QuillSimpleToolbarConfigurations(
        showFontFamily: true,
        showFontSize: true,
        showAlignmentButtons: true,
        showBoldButton: true,
        showItalicButton: true,
        showUnderLineButton: true,
        showStrikeThrough: true,
        fontFamilyValues: {
          "Monospace": "monospace",
          "Serif": "serif",
          "Sans Serif": "sans-serif",
          "Ibarra real nova": "ibarra-real-nova",
          "SquarePeg": "square-peg",
          "Nunito": "nunito",
          "Pacifico": "pacifico",
          "Roboto Mono": "roboto-mono",
        },
      ),
    );
  }
}
