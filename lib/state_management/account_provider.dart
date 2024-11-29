import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../data_classes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart';

class AccountProvider extends ChangeNotifier {
  Account? _currentAccount;
  String? _sessionToken;
  UserProfile? _userProfile;

  // Getters
  Account? get currentAccount => _currentAccount;
  String? get sessionToken => _sessionToken;
  UserProfile? get userProfile => _userProfile;

  // Method to set the current account
  void setCurrentAccount(Account account) {
    _currentAccount = account;
    print("Set account to $_currentAccount");
    notifyListeners();
  }

  void setUserProfile(UserProfile userProfile) {
    _userProfile = userProfile;
    print("Set user Profile to $_userProfile");
    notifyListeners();
  }

  Future<void> fetchUserProfile() async {
    final url = Uri.parse(API_Endpoints.USER_PROFILE.value);

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('session_token');
      print('Stored token: $storedToken');

      final response = await http.get(
        url,
        headers: {
          'Authorization': storedToken!,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        final userProfile = UserProfile.fromJson(responseData);
        setUserProfile(userProfile);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['detail'] ?? 'Failed to fetch profile');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow; // Re-throw the error so the UI can handle it
    }
  }

  // Method to clear the current account (e.g., on logout)
  void clearCurrentAccount() async {
    _currentAccount = null;
    _sessionToken = null;
    _userProfile = null;

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
            'Logout request failed with status code: ${response.statusCode}',
          );
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

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    String? bio,
    DateTime? birthdate, // Add birthdate parameter
    File? profilePicture, // For mobile/desktop
    Uint8List? profilePictureBytes, // For web
  }) async {
    final url = Uri.parse(API_Endpoints.USER_PROFILE.value);
    const uuid = Uuid();

    try {
      var request = http.MultipartRequest('PUT', url);

      // Add session token to headers
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('session_token');
      request.headers['Authorization'] = storedToken!;

      // Add text fields
      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['email'] = email;

      if (bio != null) {
        request.fields['bio'] = bio;
      }

      // Add birthdate if provided
      if (birthdate != null) {
        request.fields['birthdate'] =
            DateFormat('yyyy-MM-dd').format(birthdate);
      }

      // Handle profile picture
      if (profilePicture != null) {
        // For mobile/desktop
        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          profilePicture.path,
          filename: '${uuid.v4()}.jpg', // Random file name
        ));
      } else if (profilePictureBytes != null) {
        // For web
        request.files.add(http.MultipartFile.fromBytes(
          'profile_picture',
          profilePictureBytes,
          filename: '${uuid.v4()}.jpg', // Random file name
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Update both the account and user profile data
        final updatedUser = Account.fromJson(responseData['user']);
        final updatedProfile = UserProfile.fromJson(
          responseData['user_profile'] ?? responseData,
        );
        // Handle cases where the API may return the profile directly under "user" or as "user_profile".

        setCurrentAccount(updatedUser);
        setUserProfile(updatedProfile); // Update the user profile
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['detail'] ?? 'Failed to update profile');
      }
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }
}
