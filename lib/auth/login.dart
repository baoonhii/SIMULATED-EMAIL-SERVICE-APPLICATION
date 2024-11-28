import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_email/data_classes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../state_management/account_provider.dart';
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
  List<Account> _mockDatabase = [];

  @override
  void initState() {
    super.initState();
    _loadMockDatabase();
  }

  Future<void> _loadMockDatabase() async {
    try {
      String jsonString = await rootBundle.loadString('mock.json');
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      List<dynamic> accountsJson = jsonMap['accounts'];

      setState(() {
        _mockDatabase =
            accountsJson.map((json) => Account.fromJson(json)).toList();
      });
    } catch (e) {
      print('Error loading mock database: $e');
    }
  }

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

        // Mock authentication
        Account? account = _authenticateUser(
          _emailController.text,
          _passwordController.text,
        );

        if (account != null) {
          
          // Navigate to next screen or show success
          if (mounted) {
            final accountProvider = Provider.of<AccountProvider>(context, listen: false);
            accountProvider.setCurrentAccount(account);
            Navigator.pushReplacementNamed(
              context,
              MailRoutes.INBOX.value,
            );
          }
        } else {
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.invalidAuth),
              ),
            );
          }
        }
      });
    }
  }

  Account? _authenticateUser(String email, String password) {
    // Simulate checking the email and password against the mock database
    for (var account in _mockDatabase) {
      if (account.email == email
          //  && password == "password123"
          ) {
        // Return the account if the email and password match
        return account;
      }
    }
    return null;
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
        title: Text(AppLocalizations.of(context)!.signin),
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
                  getRegisterButton(),
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
          : Text(AppLocalizations.of(context)!.signin),
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
        labelText: AppLocalizations.of(context)!.password,
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

  TextButton getRegisterButton() {
    return TextButton(
      onPressed: () {
        // Create account logic
        Navigator.pushNamed(context, AuthRoutes.REGISTER.value);
      },
      child: Text(AppLocalizations.of(context)!.createAccount),
    );
  }

  TextButton getForgetPasswordButton() {
    return TextButton(
      onPressed: () {
        // Forgot password logic
      },
      child: Text("${AppLocalizations.of(context)!.forgotPassword}?"),
    );
  }
}
