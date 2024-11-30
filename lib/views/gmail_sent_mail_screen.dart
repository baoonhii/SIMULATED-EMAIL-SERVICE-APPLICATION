import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../other_widgets/email.dart';
import '../state_management/email_provider.dart';
import 'gmail_base_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class GmailSentScreen extends StatefulWidget {
  const GmailSentScreen({super.key});

  @override
  State<GmailSentScreen> createState() => _GmailSentScreenState();
}

class _GmailSentScreenState extends State<GmailSentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmailsProvider>(context, listen: false)
          .fetchEmails(mailbox: 'sent');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GmailBaseScreen(
      title: AppLocalizations.of(context)!.sentMail,
      body: Consumer<EmailsProvider>(
        builder: (context, emailsProvider, child) {
          if (emailsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (emailsProvider.hasError) {
            return Center(child: Text(emailsProvider.errorMessage));
          }
          if (emailsProvider.sentEmails.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noSentEmails),
            );
          }
          return ListView.builder(
            itemCount: emailsProvider.sentEmails.length,
            itemBuilder: (context, index) {
              final email = emailsProvider.sentEmails[index];
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