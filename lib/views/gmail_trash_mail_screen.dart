import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'gmail_base_screen.dart';
import '../constants.dart';
import '../other_widgets/email.dart';
import '../state_management/email_provider.dart';

class GmailTrashScreen extends StatefulWidget {
  const GmailTrashScreen({super.key});

  @override
  State<GmailTrashScreen> createState() => _GmailTrashScreenState();
}

class _GmailTrashScreenState extends State<GmailTrashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmailsProvider>(context, listen: false)
          .fetchEmails(mailbox: 'trash');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GmailBaseScreen(
      title: AppLocalizations.of(context)!.trashMail,
      body: Consumer<EmailsProvider>(builder: getTrashMailBuilder),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, MailRoutes.COMPOSE.value);
        },
        label: Text(AppLocalizations.of(context)!.composeMail),
        icon: const Icon(Icons.edit),
      ),
    );
  }

  Widget getTrashMailBuilder(
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
    if (emailsProvider.trashedEmails.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noTrashedEmails),
      );
    }
    return ListView.builder(
      itemCount: emailsProvider.trashedEmails.length,
      itemBuilder: (context, index) {
        final email = emailsProvider.trashedEmails[index];
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
