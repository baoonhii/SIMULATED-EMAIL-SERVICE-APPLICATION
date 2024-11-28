import 'package:flutter/material.dart';
import 'package:flutter_email/views/gmail_base_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return GmailBaseScreen(
      title: AppLocalizations.of(context)!.userSettings,
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.blue),
              title: Text(AppLocalizations.of(context)!.changeProfile),
              subtitle: Text(AppLocalizations.of(context)!.updateNamePic),
              trailing: const Icon(Icons.edit),
              onTap: () {
                Navigator.pushNamed(context, SettingsRoutes.EDITPROFILE.value);
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.lock, color: Colors.blue),
              title: Text(AppLocalizations.of(context)!.changePassword),
              trailing: const Icon(Icons.lock_open),
              onTap: () {},
            ),
          ),
          // Card(
          //   margin: const EdgeInsets.all(8),
          //   child: ListTile(
          //     leading: const Icon(Icons.notifications, color: Colors.blue),
          //     title: Text(AppLocalizations.of(context)!.notifSettings),
          //     trailing: const Icon(Icons.arrow_forward),
          //     onTap: () {
          //       Navigator.pushNamed(context, SettingsRoutes.NOTIF.value);
          //     },
          //   ),
          // ),
          Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.reply, color: Colors.blue),
              title: Text(AppLocalizations.of(context)!.autoRepSetting),
              subtitle: Text(AppLocalizations.of(context)!.autoRepDesc),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.pushNamed(context, SettingsRoutes.AUTOREP.value);
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: SwitchListTile(
              title: Text(AppLocalizations.of(context)!.darkModeToggle),
              secondary: const Icon(Icons.brightness_6, color: Colors.blue),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                // onThemeToggle();
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(AppLocalizations.of(context)!.logout),
            onTap: () {
              // Handle logout functionality here
            },
          ),
        ],
      ),
    );
  }
}
