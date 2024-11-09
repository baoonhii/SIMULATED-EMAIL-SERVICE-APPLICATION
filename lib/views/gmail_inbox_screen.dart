import 'package:flutter/material.dart';
import 'gmail_base_screen.dart';
import 'mock_data.dart';

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
              backgroundColor: Colors.red,
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
                Text('12:30 PM'),
                Icon(
                  email.isRead ? Icons.star_border : Icons.star,
                  color: Colors.white,
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
