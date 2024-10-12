import 'package:flutter/material.dart';
import 'gmail_base_screen.dart';

class GmailSentMailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GmailBaseScreen(
      title: 'Sent Mail',
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.send, color: Colors.white),
            ),
            title: Text(
              'Người nhận $index',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Đây là nội dung của thư đã gửi $index'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Hôm nay, 14:30', style: TextStyle(color: Colors.grey)),
                Icon(Icons.star_border, color: Colors.grey),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/emailDetail');
            },
          );
        },
      ),
    );
  }
}
