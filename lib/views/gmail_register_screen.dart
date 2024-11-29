import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../state_management/account_provider.dart';

class GmailRegisterScreen extends StatefulWidget {
  const GmailRegisterScreen({super.key});

  @override
  State<GmailRegisterScreen> createState() => _GmailRegisterScreenState();
}

class _GmailRegisterScreenState extends State<GmailRegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createAccount),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                getRegistrationTitle(context),
                const SizedBox(height: 20),
                getEmailField(),
                const SizedBox(height: 16),
                getPasswordField(context),
                const SizedBox(height: 16),
                getConfirmPasswordField(context),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    final firstName = _nameController.text;
                    final lastName =
                        _surnameController.text; // Add surname TextField
                    final email = _emailController.text;
                    final phoneNumber = _phoneController
                        .text; // Make sure you have a phone number field
                    final password = _passwordController.text;
                    final password2 = _confirmPasswordController
                        .text; // Add confirm password field
                    Provider.of<AccountProvider>(context, listen: false)
                        .register(
                      firstName,
                      lastName,
                      email,
                      phoneNumber,
                      password,
                      password2,
                    );

                    if (Provider.of<AccountProvider>(
                          context,
                          listen: false,
                        ).currentAccount !=
                        null) {
                      Navigator.pushNamed(context, '/');
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text(AppLocalizations.of(context)!.invalidAuth),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text(AppLocalizations.of(context)!.continueNext),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField getConfirmPasswordField(BuildContext context) {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.rePassword,
        border: const OutlineInputBorder(),
      ),
      obscureText: true,
    );
  }

  TextField getPasswordField(BuildContext context) {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.password,
        border: const OutlineInputBorder(),
      ),
      obscureText: true,
    );
  }

  TextField getEmailField() {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
    );
  }

  Text getRegistrationTitle(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.hello,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}
