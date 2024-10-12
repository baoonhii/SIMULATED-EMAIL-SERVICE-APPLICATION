import 'package:flutter/material.dart';
import 'gmail_password_screen.dart';

class GmailLoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('Google',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Đăng nhập',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              'Sử dụng Tài khoản Google của bạn.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email hoặc số điện thoại',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: Text('Bạn quên địa chỉ email?',
                  style: TextStyle(color: Colors.blue)),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/password',
                    arguments: _emailController.text);
              },
              child: Text('Tiếp theo'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child:
                  Text('Tạo tài khoản', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
