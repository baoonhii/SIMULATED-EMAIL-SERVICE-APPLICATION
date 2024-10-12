import 'package:flutter/material.dart';

class GmailDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String profileImageUrl;

  GmailDrawer({
    this.userName = 'Email User',
    this.userEmail = 'emailuser@gmail.com',
    this.profileImageUrl = 'https://via.placeholder.com/150',
  });

  @override
  Widget build(BuildContext context) {
    // Use the theme colors to adapt to dark mode and light mode
    Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    Color iconColor = Theme.of(context).iconTheme.color!;
    Color drawerHeaderColor = Theme.of(context).primaryColor;
    Color dividerColor = Theme.of(context).dividerColor;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
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
                  Navigator.pushNamed(context, '/editProfile');
                },
              ),
            ],
          ),
          _buildDrawerItem(
              Icons.inbox, 'Chính', '/inbox', context, textColor, iconColor),
          _buildDrawerItem(Icons.local_offer, 'Quảng cáo', '/promotions',
              context, textColor, iconColor),
          _buildDrawerItem(Icons.people, 'Mạng xã hội', '/social', context,
              textColor, iconColor),
          _buildDrawerItem(
              Icons.drafts, 'Drafts', '/drafts', context, textColor, iconColor),
          _buildDrawerItem(
              Icons.send, 'Đã gửi', '/sent', context, textColor, iconColor),
          _buildDrawerItem(Icons.info, 'Cập nhật', '/updates', context,
              textColor, iconColor),
          Divider(color: dividerColor),
          _buildDrawerItem(Icons.star, 'Có gắn dấu sao', '/starred', context,
              textColor, iconColor),
          _buildDrawerItem(
              Icons.delete, 'Thư rác', '/spam', context, textColor, iconColor),
          _buildDrawerItem(Icons.all_inbox, 'Tất cả thư', '/allMail', context,
              textColor, iconColor),
          Divider(color: dividerColor),
          _buildDrawerItem(Icons.settings, 'Cài đặt', '/settings', context,
              textColor, iconColor),
        ],
      ),
    );
  }

  // Helper method to create Drawer items
  ListTile _buildDrawerItem(IconData icon, String title, String route,
      BuildContext context, Color textColor, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
