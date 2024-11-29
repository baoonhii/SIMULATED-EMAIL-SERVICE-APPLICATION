import 'package:flutter/foundation.dart';
import '../constants.dart';
import '../data_classes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountProvider extends ChangeNotifier {
  Account? _currentAccount;
  String? _sessionToken;

  // Getter for the current account
  Account? get currentAccount => _currentAccount;

  // Getter for session token
  String? get sessionToken => _sessionToken;

  // Method to set the current account
  void setCurrentAccount(Account account) {
    _currentAccount = account;
    print("Set account to $_currentAccount");
    notifyListeners();
  }

  // Method to clear the current account (e.g., on logout)
  void clearCurrentAccount() async {
    _currentAccount = null;
    _sessionToken = null;

    // Clear stored session token
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token');

    notifyListeners();
  }

  // Optional: Check if an account is currently set
  bool get hasCurrentAccount => _currentAccount != null;

  // Check if session token is valid
  Future<bool> isSessionValid() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('session_token');

    if (storedToken == null) return false;

    // Optional: Add an API call to validate the token on the backend
    try {
      final url = Uri.parse(API_Endpoints.AUTH_VALIDATE_TOKEN.value);
      final response = await http.post(
        url,
        body: json.encode({'session_token': storedToken}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Token is valid, load the user data
        final responseData = json.decode(response.body);
        final user = Account.fromJson(responseData['user']);
        setCurrentAccount(user);
        _sessionToken = storedToken;
        return true;
      }
      return false;
    } catch (e) {
      print('Error validating session: $e');
      return false;
    }
  }

  Future<void> login(
      String phoneNumber, String password, VoidCallback onSuccess) async {
    final url = Uri.parse(API_Endpoints.AUTH_LOGIN.value);
    final body = json.encode({
      'phone_number': phoneNumber,
      'password': password,
    });
    print(body);

    try {
      final response = await http.post(
        url,
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        final user = Account.fromJson(responseData['user']);
        final sessionToken = responseData['session_token'];

        // Store session token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('session_token', sessionToken);

        setCurrentAccount(user);
        _sessionToken = sessionToken;

        // Call the success callback
        onSuccess();
      } else {
        final errorData = json.decode(response.body);
        print('Login failed: $errorData');
        throw Exception(errorData);
      }
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    final url = Uri.parse(API_Endpoints.AUTH_LOGOUT.value);

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('session_token');

      if (storedToken != null) {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': storedToken,
          },
        );

        // Always clear the account, regardless of logout request success
        clearCurrentAccount();

        if (response.statusCode != 200) {
          print(
              'Logout request failed with status code: ${response.statusCode}');
        }
      } else {
        // If no stored token, just clear the account
        clearCurrentAccount();
      }
    } catch (e) {
      print('Error during logout: $e');
      // Ensure account is cleared even if there's a network error
      clearCurrentAccount();
    }
  }

  // Method to register
  Future<void> register(
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String password,
    String password2,
  ) async {
    final url = Uri.parse(API_Endpoints.AUTH_REGISTER.value);

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'username': phoneNumber,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone_number': phoneNumber,
          'password': password,
          'password2': password2,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('Registration successful: $responseData');
      } else {
        final errorData = json.decode(response.body);
        print('Registration failed: $errorData');
        throw Exception(errorData);
      }
    } catch (e) {
      print('Error during registration: $e');
      rethrow;
    }
  }
}
