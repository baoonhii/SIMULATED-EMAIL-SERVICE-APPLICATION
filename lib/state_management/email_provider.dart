import 'package:flutter/foundation.dart';

import '../constants.dart';
import '../data_classes.dart';
import '../utils/api_pipeline.dart';

class EmailsProvider extends ChangeNotifier {
  List<Email> _emails = [];
  List<Email> _sentEmails = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  // Getters
  List<Email> get emails => _emails;
  List<Email> get sentEmails => _sentEmails;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  Future<void> fetchEmails({String mailbox = 'inbox'}) async {
    print("Fetching $mailbox");
    try {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
      notifyListeners();

      final responseData = await makeAPIRequest(
        url: Uri.parse('${API_Endpoints.EMAIL_LIST.value}?mailbox=$mailbox'),
        method: 'GET',
      );

      if (mailbox == 'inbox') {
        _emails = (responseData as List)
            .map((json) => Email.fromJson(json))
            .toList();
      } else if (mailbox == 'sent') {
        _sentEmails = (responseData as List)
            .map((json) {
              return Email.fromJson(json);
            })
            .toList();
      }

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
