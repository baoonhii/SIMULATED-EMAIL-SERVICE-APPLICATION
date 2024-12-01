import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'gmail_base_screen.dart';
import '../constants.dart';
import '../other_widgets/email.dart';
import '../state_management/email_provider.dart';

class MailFolderScreen extends StatefulWidget {
  final String mailbox;
  final String title;
  final String boxEmptyMessage;

  const MailFolderScreen({
    super.key,
    required this.mailbox,
    required this.title,
    required this.boxEmptyMessage,
  });

  @override
  State<MailFolderScreen> createState() => _MailFolderScreenState();
}

class _MailFolderScreenState extends State<MailFolderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmailsProvider>(context, listen: false)
          .fetchEmails(mailbox: widget.mailbox);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GmailBaseScreen(
      title: AppLocalizations.of(context)!.trashMail,
      body: Consumer<EmailsProvider>(builder: getMailFolderBuilder),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, MailRoutes.COMPOSE.value);
        },
        label: Text(AppLocalizations.of(context)!.composeMail),
        icon: const Icon(Icons.edit),
      ),
    );
  }

  Widget getMailFolderBuilder(
    BuildContext context,
    EmailsProvider emailsProvider,
    Widget? child,
  ) {
    if (emailsProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (emailsProvider.hasError) {
      return Center(child: Text(emailsProvider.errorMessage));
    }
    if (emailsProvider.getFolder(widget.mailbox).isEmpty) {
      return Center(
        child: Text(widget.boxEmptyMessage),
      );
    }
    return ListView.builder(
      itemCount: emailsProvider.getFolder(widget.mailbox).length,
      itemBuilder: (context, index) {
        final email = emailsProvider.getFolder(widget.mailbox)[index];
        return getEmailTile(
          email,
          () {
            Navigator.pushNamed(
              context,
              MailRoutes.EMAIL_DETAIL.value,
              arguments: email,
            );
          },
          context,
          emailsProvider,
        );
      },
    );
  }
}

class GmailSentScreen extends StatefulWidget {
  const GmailSentScreen({super.key});

  @override
  State<GmailSentScreen> createState() => _GmailSentScreenState();
}

class _GmailSentScreenState extends State<GmailSentScreen> {
  @override
  Widget build(BuildContext context) {
    return MailFolderScreen(
      mailbox: 'sent',
      title: AppLocalizations.of(context)!.sentMail,
      boxEmptyMessage: AppLocalizations.of(context)!.noSentEmails,
    );
  }
}

class GmailTrashScreen extends StatefulWidget {
  const GmailTrashScreen({super.key});

  @override
  State<GmailTrashScreen> createState() => _GmailTrashScreenState();
}

class _GmailTrashScreenState extends State<GmailTrashScreen> {
  @override
  Widget build(BuildContext context) {
    return MailFolderScreen(
      mailbox: 'trash',
      title: AppLocalizations.of(context)!.trashMail,
      boxEmptyMessage: AppLocalizations.of(context)!.noTrashedEmails,
    );
  }
}
