class MockEmail {
  final String sender;
  final String recipient;
  final String subject;
  final String body;
  final DateTime sentTime;
  final bool isStarred;
  final bool isRead;

  MockEmail({
    required this.sender,
    required this.recipient,
    required this.subject,
    required this.body,
    required this.sentTime,
    this.isStarred = false,
    this.isRead = false,
  });

  MockEmail copyWith({
    String? sender,
    String? recipient,
    String? subject,
    String? body,
    DateTime? sentTime,
    bool? isStarred,
    bool? isRead,
  }) {
    return MockEmail(
      sender: sender ?? this.sender,
      recipient: recipient ?? this.recipient,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      sentTime: sentTime ?? this.sentTime,
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
      sentTime: DateTime.now().subtract(Duration(hours: 1)),
    ),
    MockEmail(
      sender: 'Jane Smith',
      recipient: 'you@gmail.com',
      subject: 'Project Update',
      body: 'Here is the latest progress on the project.',
      sentTime: DateTime.now().subtract(Duration(hours: 3)),
      isRead: true,
    ),
    MockEmail(
      sender: 'Bob Johnson',
      recipient: 'you@gmail.com',
      subject: 'Lunch Invitation',
      body: 'Would you like to join me for lunch today?',
      sentTime: DateTime.now().subtract(Duration(hours: 5)),
    ),
    MockEmail(
      sender: 'Alice Brown',
      recipient: 'you@gmail.com',
      subject: 'Weekend Plans',
      body: 'Are you free this weekend? Let\'s catch up!',
      sentTime: DateTime.now().subtract(Duration(days: 1)),
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
      sentTime: DateTime.now().subtract(Duration(hours: 2)),
    ),
    MockEmail(
      sender: 'you@gmail.com',
      recipient: 'marketing@company.com',
      subject: 'Marketing Campaign Update',
      body: 'Please find attached the latest marketing metrics.',
      sentTime: DateTime.now().subtract(Duration(days: 1)),
      isStarred: true,
    ),
    MockEmail(
      sender: 'you@gmail.com',
      recipient: 'team@startup.com',
      subject: 'Weekly Team Meeting Notes',
      body: 'Summary of our discussion from today\'s meeting.',
      sentTime: DateTime.now().subtract(Duration(days: 2)),
    ),
    MockEmail(
      sender: 'you@gmail.com',
      recipient: 'client@bigcorp.com',
      subject: 'Invoice for Services',
      body: 'Please find attached the invoice for this month\'s services.',
      sentTime: DateTime.now().subtract(Duration(days: 3)),
    ),
  ];
}

// Helper function to format the sent time
String formatSentTime(DateTime sentTime) {
  final now = DateTime.now();
  final difference = now.difference(sentTime);

  if (difference.inDays == 0) {
    return 'Hôm nay, ${sentTime.hour.toString().padLeft(2, '0')}:${sentTime.minute.toString().padLeft(2, '0')}';
  } else if (difference.inDays == 1) {
    return 'Hôm qua';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} ngày trước';
  } else {
    return '${sentTime.day}/${sentTime.month}/${sentTime.year}';
  }
}