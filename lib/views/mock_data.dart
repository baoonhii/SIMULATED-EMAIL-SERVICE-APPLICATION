import 'package:intl/intl.dart';
 
class MockEmail {
  final String sender;
  final String recipient;
  final String subject;
  final String body;
  final DateTime timestamp;
  final bool isStarred;
  final bool isRead;

  MockEmail({
    required this.sender,
    required this.recipient,
    required this.subject,
    required this.body,
    required this.timestamp,
    this.isStarred = false,
    this.isRead = false,
  });

  MockEmail copyWith({
    String? sender,
    String? recipient,
    String? subject,
    String? body,
    DateTime? timestamp,
    bool? isStarred,
    bool? isRead,
  }) {
    return MockEmail(
      sender: sender ?? this.sender,
      recipient: recipient ?? this.recipient,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isStarred: isStarred ?? this.isStarred,
      isRead: isRead ?? this.isRead,
    );
  }
}

List<MockEmail> generateMockEmails() { //important - link with gmail_inbox_screen.dart
  return [
    MockEmail(
      sender: 'John Doe',
      recipient: 'you@gmail.com',  
      subject: 'Important Meeting',
      body: 'Please join the meeting at 3 PM today.',
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
    ),
    MockEmail(
      sender: 'Jane Smith',
      recipient: 'you@gmail.com',
      subject: 'Project Update',
      body: 'Here is the latest progress on the project.',
      timestamp: DateTime.now().subtract(Duration(hours: 3)),
      isRead: true,
    ),
    MockEmail(
      sender: 'Bob Johnson',
      recipient: 'you@gmail.com',
      subject: 'Lunch Invitation',
      body: 'Would you like to join me for lunch today?',
      timestamp: DateTime.now().subtract(Duration(hours: 5)),
    ),
    MockEmail(
      sender: 'Alice Brown',
      recipient: 'you@gmail.com',
      subject: 'Weekend Plans',
      body: 'Are you free this weekend? Let\'s catch up!',
      timestamp: DateTime.now().subtract(Duration(days: 1)),
    ),
    // Add more mock emails as needed
  ];
}

// Generate mock sent emails
List<MockEmail> generateMockSentEmails() { //important - link with gmail_sent_email_screen.dart
  return [
    MockEmail(
      sender: 'you@gmail.com',
      recipient: 'john.doe@example.com',
      subject: 'Project Proposal',
      body: 'Here is the project proposal we discussed earlier.',
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
    ),
    MockEmail(
      sender: 'you@gmail.com',
      recipient: 'marketing@company.com',
      subject: 'Marketing Campaign Update',
      body: 'Please find attached the latest marketing metrics.',
      timestamp: DateTime.now().subtract(Duration(days: 1)),
      isStarred: true,
    ),
    MockEmail(
      sender: 'you@gmail.com',
      recipient: 'team@startup.com',
      subject: 'Weekly Team Meeting Notes',
      body: 'Summary of our discussion from today\'s meeting.',
      timestamp: DateTime.now().subtract(Duration(days: 2)),
    ),
    MockEmail(
      sender: 'you@gmail.com',
      recipient: 'client@bigcorp.com',
      subject: 'Invoice for Services',
      body: 'Please find attached the invoice for this month\'s services.',
      timestamp: DateTime.now().subtract(Duration(days: 3)),
    ),
  ];
}

// Helper function to format the sent time
// String formatSentTime(DateTime timestamp) {
//   final now = DateTime.now();
//   final difference = now.difference(timestamp);

//   if (difference.inDays == 0) {
//     return 'Hôm nay, ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
//   } else if (difference.inDays == 1) {
//     return 'Hôm qua';
//   } else if (difference.inDays < 7) {
//     return '${difference.inDays} ngày trước';
//   } else {
//     return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
//   }
// }

String formatSentTime(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inDays == 0) {
    // Today: show time
    return DateFormat('HH:mm').format(timestamp);
  } else if (difference.inDays == 1) {
    // Yesterday
    return 'Hôm qua';
  } else if (difference.inDays < 7) {
    // Within a week: show days ago
    return '${difference.inDays} ngày trước'; 
  } else {
    // Older: show date
    return DateFormat('dd/MM/yyyy').format(timestamp);
  }
}