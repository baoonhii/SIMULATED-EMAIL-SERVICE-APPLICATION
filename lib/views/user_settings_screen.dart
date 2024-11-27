import 'package:flutter/material.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt người dùng'),
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.blue),
              title: const Text('Chỉnh sửa hồ sơ'),
              subtitle: const Text('Cập nhật tên và ảnh đại diện của bạn'),
              trailing: const Icon(Icons.edit),
              onTap: () {
                Navigator.pushNamed(context, '/editProfile');
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.lock, color: Colors.blue),
              title: const Text('Đổi mật khẩu'),
              subtitle: const Text('Cập nhật mật khẩu của bạn'),
              trailing: const Icon(Icons.lock_open),
              onTap: () {},
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.notifications, color: Colors.blue),
              title: const Text('Cài đặt thông báo'),
              subtitle: const Text('Chỉnh sửa sở thích thông báo của bạn'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.pushNamed(context, '/notificationSettings');
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.reply, color: Colors.blue),
              title: const Text('Trả lời tự động'),
              subtitle: const Text('Cài đặt tin nhắn tự động khi bạn vắng mặt'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.pushNamed(context, '/autoReplySettings');
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: SwitchListTile(
              title: const Text('Chế độ tối (Dark Mode)'),
              secondary: const Icon(Icons.brightness_6, color: Colors.blue),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                // onThemeToggle();
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {
              // Handle logout functionality here
            },
          ),
        ],
      ),
    );
  }
}
