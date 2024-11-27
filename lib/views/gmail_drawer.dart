import 'package:flutter/material.dart';
import '../other_widgets/drawer.dart';

class GmailDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String profileImageUrl;

  GmailDrawer({
    this.userName = 'Email User',
    this.userEmail = 'emailuser@gmail.com',
    this.profileImageUrl = 'assets/placeholder.jpg',
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.onPrimary;
    Color iconColor = Theme.of(context).iconTheme.color!;
    Color drawerHeaderColor = Theme.of(context).colorScheme.primary;
    Color dividerColor = Theme.of(context).dividerColor;
    Color drawerTextColor = Theme.of(context).colorScheme.onSurface;

    ListTile drawerItem(
      IconData icon,
      String titleKey,
      String route,
      BuildContext context,
    ) {
      return buildDrawerItem(
        icon,
        titleKey,
        route,
        context,
        drawerTextColor,
        iconColor,
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          getDrawerHeadere(drawerHeaderColor, textColor, context),
          drawerItem(
            Icons.inbox,
            'inbox',
            '/inbox',
            context,
          ),
          drawerItem(
            Icons.local_offer,
            'promotions',
            '/promotions',
            context,
          ),
          drawerItem(
            Icons.people,
            'social',
            '/social',
            context,
          ),
          drawerItem(
            Icons.drafts,
            'drafts',
            '/drafts',
            context,
          ),
          drawerItem(
            Icons.send,
            'sent',
            '/sent',
            context,
          ),
          drawerItem(
            Icons.info,
            'updates',
            '/updates',
            context,
          ),
          Divider(
            color: dividerColor,
          ),
          drawerItem(
            Icons.star,
            'starred',
            '/starred',
            context,
          ),
          drawerItem(
            Icons.delete,
            'spam',
            '/spam',
            context,
          ),
          drawerItem(
            Icons.all_inbox,
            'allMail',
            '/allMail',
            context,
          ),
          Divider(color: dividerColor),
          drawerItem(
            Icons.settings,
            'settings',
            'settings/userSettings',
            context,
          ),
        ],
      ),
    );
  }

  UserAccountsDrawerHeader getDrawerHeadere(
    Color drawerHeaderColor,
    Color textColor,
    BuildContext context,
  ) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: drawerHeaderColor,
      ),
      accountName: Text(
        userName,
        style: TextStyle(color: textColor),
      ),
      accountEmail: Text(
        userEmail,
        style: TextStyle(color: textColor.withOpacity(0.7)),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage(profileImageUrl),
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
