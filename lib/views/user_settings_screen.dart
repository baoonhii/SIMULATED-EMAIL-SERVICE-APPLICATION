import 'package:flutter/material.dart';

class UserSettingsScreen extends StatelessWidget {
  final VoidCallback onThemeToggle;

  UserSettingsScreen({required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt người dùng'),
      ),
      body: ListView(
        children: [
          Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Icon(Icons.account_circle, color: Colors.blue),
              title: Text('Chỉnh sửa hồ sơ'),
              subtitle: Text('Cập nhật tên và ảnh đại diện của bạn'),
              trailing: Icon(Icons.edit),
              onTap: () {
                Navigator.pushNamed(context, '/editProfile');
              },
            ),
          ),
          Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Icon(Icons.lock, color: Colors.blue),
              title: Text('Đổi mật khẩu'),
              subtitle: Text('Cập nhật mật khẩu của bạn'),
              trailing: Icon(Icons.lock_open),
              onTap: () {},
            ),
          ),
          Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Icon(Icons.notifications, color: Colors.blue),
              title: Text('Cài đặt thông báo'),
              subtitle: Text('Chỉnh sửa sở thích thông báo của bạn'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.pushNamed(context, '/notificationSettings');
              },
            ),
          ),
          Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Icon(Icons.reply, color: Colors.blue),
              title: Text('Trả lời tự động'),
              subtitle: Text('Cài đặt tin nhắn tự động khi bạn vắng mặt'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.pushNamed(context, '/autoReplySettings');
              },
            ),
          ),
          Card(
            margin: EdgeInsets.all(8),
            child: SwitchListTile(
              title: Text('Chế độ tối (Dark Mode)'),
              secondary: Icon(Icons.brightness_6, color: Colors.blue),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                onThemeToggle();
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout'),
            onTap: () {
              // Handle logout functionality here
            },
          ),
        ],
      ),
    );
  }
}
