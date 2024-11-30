import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constants.dart';

class WebAttachment {
  final String name;
  final Uint8List bytes;

  WebAttachment({required this.name, required this.bytes});
}

class EmailComposeProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;
  bool _hasNavigatedAfterSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  Future<void> sendEmail({
    required List<String> recipients,
    List<String>? ccRecipients,
    List<String>? bccRecipients,
    required String subject,
    required String body,
    List<dynamic>? attachments,
  }) async {
    // Reset state completely
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    _hasNavigatedAfterSuccess = false;
    notifyListeners();

    try {
      // Prepare multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(API_Endpoints.EMAIL_SEND.value),
      );

      // Add text fields
      request.fields['recipients'] = json.encode(recipients);
      if (ccRecipients != null) {
        request.fields['cc'] = json.encode(ccRecipients);
      }
      if (bccRecipients != null) {
        request.fields['bcc'] = json.encode(bccRecipients);
      }
      request.fields['subject'] = subject;
      request.fields['body'] = body;

      // Add attachments
      if (attachments != null) {
        for (var file in attachments) {
          if (kIsWeb && file is WebAttachment) {
            // For web, use MultipartFile.fromBytes
            request.files.add(
              http.MultipartFile.fromBytes(
                'attachments',
                file.bytes,
                filename: file.name,
              ),
            );
          } else if (!kIsWeb && file is File) {
            // Existing file path logic for mobile/desktop
            request.files.add(
              await http.MultipartFile.fromPath(
                'attachments',
                file.path,
              ),
            );
          }
        }
      }

      // Add authorization header
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('session_token');
      request.headers['Authorization'] = storedToken!;

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _isSuccess = true;
        _isLoading = false;
        notifyListeners();
        return;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['detail'] ?? 'Email sending failed');
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      _isSuccess = false;
      notifyListeners();
      rethrow;
    }
  }

  void markNavigatedAfterSuccess() {
    _isSuccess = false;
    _hasNavigatedAfterSuccess = true;
    notifyListeners();
  }

  // Reset the state for a new email composition
  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();
  }
}
