import 'package:flutter/material.dart';
import 'gmail_base_screen.dart';
import 'mock_data.dart';
import 'package:intl/intl.dart';

class GmailInboxScreen extends StatefulWidget {
  @override
  _GmailInboxScreenState createState() => _GmailInboxScreenState();
}

class _GmailInboxScreenState extends State<GmailInboxScreen> {
  late List<MockEmail> emails;

  @override
  void initState() {
    super.initState();
    emails = generateMockEmails(); // important here
  }

  @override
  Widget build(BuildContext context) {
    return GmailBaseScreen(
      title: 'Inbox',
      appBarWidget: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm trong thư',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: emails.length,
        itemBuilder: (context, index) {
          final email = emails[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.pink,
              child: Text(email.sender[0]),
            ),
            title: Text(
              email.subject,
              style: TextStyle(
                fontWeight: email.isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Text(email.sender),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('h:mm a').format(email.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: email.isRead ? Colors.blue : Colors.red,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      emails[index] = email.copyWith(isStarred: !email.isStarred);
                    });
                  },
                  child: Icon(
                    email.isStarred ? Icons.star : Icons.star_border,
                    color: email.isStarred ? Colors.yellow : Colors.white,
                  ),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                emails[index] = email.copyWith(isRead: true);
              });
              Navigator.pushNamed(context, '/emailDetail', arguments: email);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/compose');
        },
        label: Text('Soạn thư'),
        icon: Icon(Icons.edit),
      ),
    );
  }
}
