import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants.dart';
import '../data_classes.dart';
import 'email_provider.dart';
import 'notification_provider.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final EmailsProvider _emailsProvider;
  final UserNotificationProvider _notificationProvider;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int MAX_RECONNECT_ATTEMPTS = 5;

  WebSocketService(this._emailsProvider, this._notificationProvider);

  Future<void> connect() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionToken = prefs.getString('session_token');

    print('Session Token: $sessionToken'); // Debug print session token
    _reconnectAttempts++;

    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://$ROOT/ws/emails/?token=$sessionToken'),
      );

      print('WebSocket connection established'); // Confirm connection
      _reconnectAttempts =
          0; // Reset reconnect attempts on successful connection

      _channel!.stream.listen((message) {
        print("Received WebSocket message: $message");
        try {
          final data = json.decode(message);
          print("Decoded message: $data");
          _handleWebSocketMessage(data);
        } catch (e) {
          print('Error decoding WebSocket message: $e');
        }
      }, onDone: () {
        print('WebSocket connection closed');
        _reconnect();
      }, onError: (error) {
        print('WebSocket error: $error');
        _reconnect();
      });
    } catch (e) {
      print('WebSocket connection failed: $e');
      _reconnect();
    }
  }

  void _handleWebSocketMessage(Map<String, dynamic> data) {
    print('Handling WebSocket message: $data');
    try {
      if (data['type'] == 'email_notification') {
        print("\n\n");
        print('Email notification received');
        print("Processing email");
        print("\n\n");
        final newEmail = Email.fromJson(data['email']);

        // Determine the appropriate mailbox based on email properties
        String? mailbox = _determineMailboxForEmail(newEmail);

        // Add new email to cache
        _emailsProvider.addNewEmailToCache(newEmail,
            mailbox: mailbox ?? 'inbox');

        print("Processing notification");
        // Handle notification
        print("\n\n");
        print(data['notification']);
        print("\n");

        final newNotification = UserNotification.fromJson(data['notification']);
        _notificationProvider.addNotification(newNotification);
      } else if (data['type'] == 'email_update') {
        // Handle email updates (read status, labels, etc.)
        final updatedEmail = Email.fromJson(data['email']);
        _emailsProvider.updateEmailInCache(updatedEmail);
      } else {
        print('Unknown message type: ${data['type']}');
      }
    } catch (e) {
      print('Error handling WebSocket message: $e');
    }
  }

  String? _determineMailboxForEmail(Email email) {
    if (email.is_trashed) return 'trash';
    if (email.is_starred) return 'starred';
    if (email.is_draft) return 'drafts';
    return 'inbox'; // Default mailbox
  }

  void _reconnect() {
    // Cancel any existing timer
    _reconnectTimer?.cancel();

    // Check if max reconnect attempts reached
    if (_reconnectAttempts > MAX_RECONNECT_ATTEMPTS) {
      print('Max reconnect attempts reached. Stopping reconnection.');
      return;
    }

    // Exponential backoff reconnection strategy
    final duration = Duration(seconds: pow(2, _reconnectAttempts).toInt());

    print('Attempting to reconnect in ${duration.inSeconds} seconds');

    _reconnectTimer = Timer(duration, () {
      connect();
    });
  }

  void dispose() {
    _reconnectTimer?.cancel();
    _channel?.sink.close();
  }
}
