import 'package:flutter/material.dart';
import 'gmail_base_screen.dart';
import 'mock_data.dart';

class GmailSentMailScreen extends StatefulWidget {
  @override
  _GmailSentMailScreenState createState() => _GmailSentMailScreenState();
}

class _GmailSentMailScreenState extends State<GmailSentMailScreen> {
  late List<MockEmail> sentEmails;

  @override
  void initState() {
    super.initState();
    sentEmails = generateMockSentEmails();git 
  }

  @override
  Widget build(BuildContext context) {
    return GmailBaseScreen(
      title: 'Sent Mail',
      body: ListView.builder(
        itemCount: sentEmails.length,
        itemBuilder: (context, index) {
          final email = sentEmails[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.send, color: Colors.white),
            ),
            title: Text(
              email.recipient,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${email.subject}\n${email.body}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formatSentTime(email.sentTime),
                  style: TextStyle(color: Colors.grey),
                ),
                Icon(
                  email.isStarred ? Icons.star : Icons.star_border,
                  color: email.isStarred ? Colors.yellow : Colors.grey,
                ),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/emailDetail',
                arguments: email,
              );
            },
            onLongPress: () {
              setState(() {
                sentEmails[index] = email.copyWith(
                  isStarred: !email.isStarred,
                );
              });
            },
          );
        },
      ),
    );
  }
}