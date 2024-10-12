import 'package:flutter/material.dart';
import 'gmail_base_screen.dart';

class GmailInboxScreen extends StatelessWidget {
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
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.label, color: Colors.white),
            ),
            title: Text(
              'Người gửi $index',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Đây là nội dung của email $index'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('12:30 PM'),
                Icon(Icons.star_border, color: Colors.white),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/emailDetail');
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
