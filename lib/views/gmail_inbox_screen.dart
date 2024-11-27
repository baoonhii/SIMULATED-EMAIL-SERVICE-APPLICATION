import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../data_classes.dart';
import '../other_widgets/email.dart';
import 'gmail_base_screen.dart';

class GmailInboxScreen extends StatefulWidget {
  const GmailInboxScreen({super.key});

  @override
  State<GmailInboxScreen> createState() => _GmailInboxScreenState();
}

class _GmailInboxScreenState extends State<GmailInboxScreen> {
  late List<Email> emails;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchMails();
  }

  void fetchMails() async {
    try {
      String jsonString = await rootBundle.loadString('mock.json');
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      List<dynamic> emailsJson = jsonMap['emails'];
      emails = emailsJson.map((json) => Email.fromJson(json)).toList();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = 'Error fetching emails: $e';
      });
      print(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GmailBaseScreen(
      title: 'Inbox',
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: emails.length,
                  itemBuilder: (context, index) {
                    final email = emails[index];
                    return getEmailTile(
                      emails[index],
                      () {
                        print(email);
                        Navigator.pushNamed(context, '/emailDetail', arguments: email);
                      },
                      context,
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/compose');
        },
        label: Text(AppLocalizations.of(context)!.composeMail),
        icon: const Icon(Icons.edit),
      ),
    );
  }
}
