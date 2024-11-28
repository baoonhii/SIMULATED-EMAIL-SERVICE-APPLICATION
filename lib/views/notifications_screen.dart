import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../other_widgets/notif.dart';
import '../state_management/notif_provider.dart';
import 'gmail_base_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch notifications when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotifsProvider>(context, listen: false).fetchNotifs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GmailBaseScreen(
      title: AppLocalizations.of(context)!.notifications,
      body: Consumer<NotifsProvider>(
        builder: (context, notifsProvider, child) {
          if (notifsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notifsProvider.hasError) {
            return Center(child: Text(notifsProvider.errorMessage));
          }

          return ListView.builder(
            itemCount: notifsProvider.notifs.length,
            itemBuilder: (context, index) {
              final notif = notifsProvider.notifs[index];
              return getNotifTile(
                notif,
                () {},
                context,
              );
            },
          );
        },
      ),
    );
  }
}
