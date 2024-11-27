import 'package:flutter/material.dart';
import '../constants.dart';
import '../data_classes.dart';
import '../other_widgets/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GmailDrawer extends StatelessWidget {
  final Account currentAccount;

  const GmailDrawer({
    super.key,
    required this.currentAccount,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.onPrimary;
    Color iconColor = Theme.of(context).iconTheme.color!;
    Color drawerHeaderColor = Theme.of(context).colorScheme.primary;
    Color dividerColor = Theme.of(context).dividerColor;
    Color drawerTextColor = Theme.of(context).colorScheme.onSurface;

    ListTile drawerItem({
      required IconData icon,
      required String titleKey,
      required String route,
    }) {
      return buildDrawerItem(
        icon,
        titleKey,
        route,
        context,
        drawerTextColor,
        iconColor,
      );
    }

    Map<String, Map<String, dynamic>> drawerGroup_1 = {
      "inbox": {
        "icon": Icons.inbox,
        "titleKey": AppLocalizations.of(context)!.inbox,
        "route": '/inbox'
      },
      "promotions": {
        "icon": Icons.local_offer,
        "titleKey": AppLocalizations.of(context)!.promotions,
        "route": '/promotions'
      },
      "social": {
        "icon": Icons.people,
        "titleKey": AppLocalizations.of(context)!.social,
        "route": '/social'
      },
      "drafts": {
        "icon": Icons.drafts,
        "titleKey": AppLocalizations.of(context)!.drafts,
        "route": '/drafts'
      },
      "sent": {
        "icon": Icons.send,
        "titleKey": AppLocalizations.of(context)!.sent,
        "route": '/sent'
      },
      "updates": {
        "icon": Icons.info,
        "titleKey": AppLocalizations.of(context)!.updates,
        "route": '/updates'
      },
    };

    Map<String, Map<String, dynamic>> drawerGroup_2 = {
      "starred": {
        "icon": Icons.star,
        "titleKey": AppLocalizations.of(context)!.starred,
        "route": '/starred'
      },
      "spam": {
        "icon": Icons.delete,
        "titleKey": AppLocalizations.of(context)!.spam,
        "route": '/spam'
      },
      "allMail": {
        "icon": Icons.all_inbox,
        "titleKey": AppLocalizations.of(context)!.allMail,
        "route": '/allMail'
      },
    };

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          getDrawerHeader(drawerHeaderColor, textColor, context),
          Divider(
            color: dividerColor,
          ),
          ...drawerGroup_1.values.map((value) {
            return drawerItem(
              icon: value["icon"],
              titleKey: value["titleKey"],
              route: value["route"],
            );
          }),
          Divider(
            color: dividerColor,
          ),
          ...drawerGroup_2.values.map((value) {
            return drawerItem(
              icon: value["icon"],
              titleKey: value["titleKey"],
              route: value["route"],
            );
          }),
          Divider(color: dividerColor),
          drawerItem(
            icon: Icons.settings,
            titleKey: AppLocalizations.of(context)!.settings,
            route: 'settings/userSettings',
          ),
        ],
      ),
    );
  }

  UserAccountsDrawerHeader getDrawerHeader(
    Color drawerHeaderColor,
    Color textColor,
    BuildContext context,
  ) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: drawerHeaderColor,
      ),
      accountName: Text(
        currentAccount.userName,
        style: TextStyle(color: textColor),
      ),
      accountEmail: Text(
        currentAccount.email,
        style: TextStyle(color: textColor.withOpacity(0.7)),
      ),
      currentAccountPicture: const CircleAvatar(
        backgroundImage: NetworkImage(placeholderImage),
      ),
      otherAccountsPictures: [
        IconButton(
          icon: Icon(Icons.edit, color: textColor),
          onPressed: () {
            Navigator.pushNamed(context, 'auth/editProfile');
          },
        ),
      ],
    );
  }
}
