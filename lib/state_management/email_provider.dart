import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../data_classes.dart';

class EmailsProvider extends ChangeNotifier {
  List<Email> _emails = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  // Getters
  List<Email> get emails => _emails;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  Future<void> fetchMails() async {
    try {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
      notifyListeners();

      // String jsonString = await rootBundle.loadString('mock.json');
      // Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      // List<dynamic> emailsJson = jsonMap['emails'];

      // _emails = emailsJson.map((json) => Email.fromJson(json)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = 'Error fetching emails: $e';
      print(_errorMessage);
      notifyListeners();
    }
  }
}