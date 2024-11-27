import 'package:flutter/material.dart';

import '../utils/validators.dart';

class GmailLoginScreen extends StatefulWidget {
  const GmailLoginScreen({super.key});

  @override
  State<GmailLoginScreen> createState() => _GmailLoginScreenState();
}

class _GmailLoginScreenState extends State<GmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulated login logic (replace with actual authentication)
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
        // Navigate to next screen or show success
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/inbox');
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              getEmailField(),
              const SizedBox(height: 16),
              getPasswordField(),
              const SizedBox(height: 24),
              getLoginButton(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getForgetPasswordButton(),
                  getRegisterButton(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton getLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text('Sign In'),
    );
  }

  TextFormField getEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: emailValidator,
    );
  }

  TextFormField getPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: passwordValidator,
    );
  }

  TextButton getRegisterButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Create account logic
        Navigator.pushNamed(context, '/register');
      },
      child: const Text('Create account'),
    );
  }

  TextButton getForgetPasswordButton() {
    return TextButton(
      onPressed: () {
        // Forgot password logic
      },
      child: const Text('Forgot password?'),
    );
  }
}
