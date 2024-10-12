import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {'title': 'New Email', 'subtitle': 'You have a new email from John Doe'},
    {'title': 'Meeting Reminder', 'subtitle': 'Meeting with team at 3 PM'},
    {
      'title': 'Profile Update',
      'subtitle': 'Don\'t forget to update your profile'
    },
    {'title': 'Auto-Reply Enabled', 'subtitle': 'Auto-reply is now active'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Icon(Icons.notifications, color: Colors.blue),
              title: Text(notifications[index]['title']!),
              subtitle: Text(notifications[index]['subtitle']!),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
