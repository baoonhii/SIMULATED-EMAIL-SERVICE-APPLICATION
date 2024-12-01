import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants.dart';
import '../utils/validators.dart';
import '../other_widgets/general.dart';
import '../views/gmail_base_screen.dart';
import '../state_management/account_provider.dart';

class GmailLoginScreen extends StatefulWidget {
  const GmailLoginScreen({super.key});

  @override
  State<GmailLoginScreen> createState() => _GmailLoginScreenState();
}

class _GmailLoginScreenState extends State<GmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isCheckingSession = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final accountProvider =
        Provider.of<AccountProvider>(context, listen: false);

    try {
      final isValid = await accountProvider.isSessionValid();

      if (isValid) {
        // Session is valid, navigate to inbox
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            MailRoutes.INBOX.value,
          );
        }
      } else {
        // Session is not valid, proceed with login screen
        setState(() {
          _isCheckingSession = false;
        });
      }
    } catch (e) {
      // Handle session check error
      setState(() {
        _isCheckingSession = false;
      });
      print('Session check error: $e');
    }
  }

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final phoneNumber = _emailController.text;
      final password = _passwordController.text;

      try {
        await Provider.of<AccountProvider>(context, listen: false).login(
          phoneNumber,
          password,
          () {
            // Callback on success
            print("Navigating to inbox");
            if (mounted) {
              Navigator.pushReplacementNamed(
                context,
                MailRoutes.INBOX.value,
              );
            }
          },
        );
      } catch (e) {
        // Show error message
        if (mounted) {
          showSnackBar(
            context,
            'Login failed: ${e.toString()}',
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GmailBaseScreen(
      title: AppLocalizations.of(context)!.signin,
      addDrawer: false,
      body: _isCheckingSession
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
