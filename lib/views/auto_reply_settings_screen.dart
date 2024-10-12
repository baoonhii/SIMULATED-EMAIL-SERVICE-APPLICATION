import 'package:flutter/material.dart';

class AutoReplySettingsScreen extends StatefulWidget {
  @override
  _AutoReplySettingsScreenState createState() =>
      _AutoReplySettingsScreenState();
}

class _AutoReplySettingsScreenState extends State<AutoReplySettingsScreen> {
  bool autoReplyEnabled = false;
  final TextEditingController _autoReplyMessageController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt trả lời tự động'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text('Bật trả lời tự động'),
            value: autoReplyEnabled,
            onChanged: (value) {
              setState(() {
                autoReplyEnabled = value;
              });
            },
            secondary: Icon(Icons.reply, color: Colors.blue),
          ),
          if (autoReplyEnabled)
            Card(
              margin: EdgeInsets.symmetric(vertical: 16),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _autoReplyMessageController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Tin nhắn tự động',
                    hintText: 'Nhập tin nhắn tự động của bạn ở đây...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Lưu cài đặt'),
          ),
        ],
      ),
    );
  }
}
