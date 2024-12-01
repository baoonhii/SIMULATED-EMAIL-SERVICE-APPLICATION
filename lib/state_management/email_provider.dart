import 'package:flutter/foundation.dart';

import '../constants.dart';
import '../data_classes.dart';
import '../utils/api_pipeline.dart';

class EmailsProvider extends ChangeNotifier {
  List<Email> _emails = [];
  List<Email> _sentEmails = [];
  List<Email> _trashedEmails = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  // Getters
  List<Email> get emails => _emails;
  List<Email> get sentEmails => _sentEmails;
  List<Email> get trashedEmails => _trashedEmails;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  List<Email> getFolder(String folderName) {
    switch (folderName) {
      case 'sent':
        return sentEmails;
      case 'trash':
        return trashedEmails;
      default:
        throw Exception("Unknown folder");
    }
  }

  Future<void> performEmailAction(Email email, EmailAction action) async {
    bool originalState;

    // Optimistically update the local state first
    switch (action) {
      case EmailAction.markRead:
        originalState = email.is_read;
        email.toggleReadStatus();
        break;
      case EmailAction.star:
        originalState = email.is_starred;
        email.toggleStarStatus();
        break;
      case EmailAction.moveToTrash:
        originalState = email.is_trashed;
        email.moveToTrash();
        break;
    }

    // Immediately notify listeners to update UI
    notifyListeners();

    try {
      final body = {
        'message_id': email.message_id,
        'action': _mapActionToString(action),
      };

      final responseData = await makeAPIRequest(
        url: Uri.parse(API_Endpoints.EMAIL_ACTION.value),
        method: 'POST',
        body: body,
      );

      // Update local email object with server response
      final updatedEmail = Email.fromJson(responseData);

      _updateEmailInList(updatedEmail);

      notifyListeners();
      print(email);
    } catch (e) {
      // Revert to original state if API call fails
      switch (action) {
        case EmailAction.markRead:
          email.is_read = originalState;
          break;
        case EmailAction.star:
          email.is_starred = originalState;
          break;
        case EmailAction.moveToTrash:
          email.is_trashed = originalState;
          break;
      }

      print('Error performing email action: $e');
      notifyListeners();

      // Optional: show error to user
      // showSnackBar(context, 'Failed to perform action');
    }
  }

  void _updateEmailInList(Email updatedEmail) {
    // Update in inbox
    final inboxIndex = _emails.indexWhere(
      (e) => e.message_id == updatedEmail.message_id,
    );
    if (inboxIndex != -1) {
      _emails[inboxIndex] = updatedEmail;
    }

    // Update in sent emails
    final sentIndex = _sentEmails.indexWhere(
      (e) => e.message_id == updatedEmail.message_id,
    );
    if (sentIndex != -1) {
      _sentEmails[sentIndex] = updatedEmail;
    }
  }

  Future<void> updateEmailLabels({
    required Email email,
    required EmailLabel label,
  }) async {
    // Keep track of original labels
    final originalLabels = List<EmailLabel>.from(email.labels);
    print(originalLabels);
    bool shouldAdd = false;
    if (!originalLabels.contains(label)) {
      email.addLabel(label);
      shouldAdd = true;
    } else {
      email.removeLabel(label);
    }

    print("Should add: $shouldAdd");

    // Immediately notify listeners to update UI
    notifyListeners();

    try {
      final body = {
        'message_id': email.message_id,
        'label_id': label.id,
        'action': shouldAdd ? 'add_label' : 'remove_label',
      };

      final responseData = await makeAPIRequest(
        url: Uri.parse(API_Endpoints.EMAIL_LABEL.value),
        method: 'POST',
        body: body,
      );

      // Update local email object with server response
      final updatedEmail = Email.fromJson(responseData);

      _updateEmailInList(updatedEmail);

      notifyListeners();
    } catch (e) {
      // Revert to original labels if API call fails
      email.labels = originalLabels;

      print('Error updating email labels: $e');
      notifyListeners();

      // Optional: show error to user
      throw Exception('Failed to update email labels');
    }
  }

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
            .map(
              (json) => Email.fromJson(json),
            )
            .toList();
      } else if (mailbox == 'sent') {
        _sentEmails = (responseData as List).map((json) {
          return Email.fromJson(json);
        }).toList();
      } else if (mailbox == 'trash') {
        _trashedEmails = (responseData as List).map((json) {
          return Email.fromJson(json);
        }).toList();
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

  String _mapActionToString(EmailAction action) {
    switch (action) {
      case EmailAction.markRead:
        return 'mark_read';
      case EmailAction.star:
        return 'star';
      case EmailAction.moveToTrash:
        return 'move_to_trash';
    }
  }
}
