import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'gmail_base_screen.dart';

class AutoReplySettingsScreen extends StatefulWidget {
  const AutoReplySettingsScreen({super.key});

  @override
  State<AutoReplySettingsScreen> createState() =>
      _AutoReplySettingsScreenState();
}

class _AutoReplySettingsScreenState extends State<AutoReplySettingsScreen> {
  bool autoReplyEnabled = false;
  final TextEditingController _autoReplyMessageController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GmailBaseScreen(
      title: AppLocalizations.of(context)!.autoRepSetting,
      addDrawer: false,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.turnOnAutoRep),
            value: autoReplyEnabled,
            onChanged: (value) {
              setState(() {
                autoReplyEnabled = value;
              });
            },
            secondary: const Icon(Icons.reply, color: Colors.blue),
          ),
          if (autoReplyEnabled)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _autoReplyMessageController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.autoRepMessage,
                    hintText: AppLocalizations.of(context)!.autoRepMessageHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.saveSettingChanges),
          ),
        ],
      ),
    );
  }
}
