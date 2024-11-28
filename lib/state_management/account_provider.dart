import 'package:flutter/foundation.dart';
import '../data_classes.dart';

class AccountProvider extends ChangeNotifier {
  Account? _currentAccount;

  // Getter for the current account
  Account? get currentAccount => _currentAccount;

  // Method to set the current account
  void setCurrentAccount(Account account) {
    _currentAccount = account;
    print("Set account to $_currentAccount");
    notifyListeners();
  }

  // Method to clear the current account (e.g., on logout)
  void clearCurrentAccount() {
    _currentAccount = null;
    notifyListeners();
  }

  // Optional: Check if an account is currently set
  bool get hasCurrentAccount => _currentAccount != null;
}