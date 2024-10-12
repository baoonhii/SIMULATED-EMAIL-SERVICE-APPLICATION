import 'package:flutter/material.dart';

class GmailPasswordScreen extends StatefulWidget {
  final String email;

  GmailPasswordScreen({required this.email});

  @override
  _GmailPasswordScreenState createState() => _GmailPasswordScreenState();
}

class _GmailPasswordScreenState extends State<GmailPasswordScreen> {
  bool _obscureText = true;
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Google',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chào mừng',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(widget.email,
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Nhập mật khẩu của bạn',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child:
                  Text('Thử cách khác', style: TextStyle(color: Colors.blue)),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/welcome',
                    arguments: widget.email);
              },
              child: Text('Tiếp theo'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
