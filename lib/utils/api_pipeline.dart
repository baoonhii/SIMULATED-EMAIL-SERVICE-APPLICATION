import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart';

Future<dynamic> fetchData({
  required Uri url,
  required String method,
  Map<String, String>? headers,
  Map<String, dynamic>? body,
  bool requiresAuth = true,
}) async {
  try {
    // Prepare headers
    final preparedHeaders = <String, String>{
      'Content-Type': 'application/json',
      ...?headers,
    };

    // Add authorization if required
    if (requiresAuth) {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('session_token');
      if (storedToken == null) {
        throw Exception('No session token available');
      }
      preparedHeaders['Authorization'] = storedToken;
    }

    // Perform the request based on method
    http.Response response;
    switch (method.toUpperCase()) {
      case 'GET':
        response = await http.get(url, headers: preparedHeaders);
        break;
      case 'POST':
        response = await http.post(
          url,
          headers: preparedHeaders,
          body: body != null ? json.encode(body) : null,
        );
        break;
      case 'PUT':
        response = await http.put(
          url,
          headers: preparedHeaders,
          body: body != null ? json.encode(body) : null,
        );
        break;
      case 'PATCH':
        response = await http.patch(
          url,
          headers: preparedHeaders,
          body: body != null ? json.encode(body) : null,
        );
        break;
      default:
        throw UnsupportedError('Unsupported HTTP method: $method');
    }

    // Handle response
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['detail'] ?? 'API request failed');
    }
  } catch (e) {
    print('API Error: $e');
    rethrow;
  }
}

// Multipart file upload method
Future<dynamic> uploadImage({
  required Uri url,
  required Map<String, String> fields,
  File? fileToUpload,
  Uint8List? fileBytes,
  String fileFieldName = 'file',
}) async {
  try {
    const uuid = Uuid();
    var request = http.MultipartRequest('PUT', url);

    // Add session token
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('session_token');
    request.headers['Authorization'] = storedToken!;

    // Add text fields
    request.fields.addAll(fields);

    // Add file
    if (fileToUpload != null) {
      request.files.add(await http.MultipartFile.fromPath(
        fileFieldName,
        fileToUpload.path,
        filename: '${uuid.v4()}.jpg',
      ));
    } else if (fileBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        fileFieldName,
        fileBytes,
        filename: '${uuid.v4()}.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    // Send the request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['detail'] ?? 'File upload failed');
    }
  } catch (e) {
    print('File Upload Error: $e');
    rethrow;
  }
}
