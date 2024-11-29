import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants.dart';
import '../other_widgets/email.dart';
import '../state_management/email_provider.dart';
import 'gmail_base_screen.dart';

class GmailInboxScreen extends StatefulWidget {
  const GmailInboxScreen({super.key});

  @override
  State<GmailInboxScreen> createState() => _GmailInboxScreenState();
}

class _GmailInboxScreenState extends State<GmailInboxScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch emails when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmailsProvider>(context, listen: false).fetchMails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GmailBaseScreen(
      title: AppLocalizations.of(context)!.inbox,
      appBarWidget: TextField(
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.findInMail,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      body: Consumer<EmailsProvider>(
        builder: (context, emailsProvider, child) {
          if (emailsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (emailsProvider.hasError) {
            return Center(child: Text(emailsProvider.errorMessage));
          }

          if (emailsProvider.emails.isEmpty) {
            return Center(child: Text("Inbox is empty"));
          }

          return ListView.builder(
            itemCount: emailsProvider.emails.length,
            itemBuilder: (context, index) {
              final email = emailsProvider.emails[index];
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
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, MailRoutes.COMPOSE.value);
        },
        label: Text(AppLocalizations.of(context)!.composeMail),
        icon: const Icon(Icons.edit),
      ),
    );
  }
}
