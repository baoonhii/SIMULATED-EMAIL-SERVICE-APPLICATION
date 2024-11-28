class Email {
  final String mailID;
  final String senderAddress;
  final String receiverAddress;
  final String contentSubject;
  final String contentBody;
  final DateTime timeSent;
  bool isStarred = false;
  bool isRead = false;
  bool isSpam = false;

  Email({
    required this.mailID,
    required this.senderAddress,
    required this.receiverAddress,
    required this.contentSubject,
    required this.contentBody,
    required this.timeSent,
  });

  Email copyWith({
    String? mailID,
    String? senderAddress,
    String? receiverAddress,
    String? contentSubject,
    String? contentBody,
    DateTime? timeSent,
  }) {
    return Email(
      mailID: mailID ?? this.mailID,
      senderAddress: senderAddress ?? this.senderAddress,
      receiverAddress: receiverAddress ?? this.receiverAddress,
      contentSubject: contentSubject ?? this.contentSubject,
      contentBody: contentBody ?? this.contentBody,
      timeSent: timeSent ?? this.timeSent,
    );
  }

  @override
  String toString() {
    return 'Mail ID: $mailID - Sent by $senderAddress @ $timeSent. Subject: $contentSubject';
  }

  Map<String, dynamic> toJson() {
    return {
      'mailID': mailID,
      'senderAddress': senderAddress,
      'receiverAddress': receiverAddress,
      'contentSubject': contentSubject,
      'contentBody': contentBody,
      'timeSent': timeSent.toIso8601String(),
      'isStarred': isStarred,
      'isRead': isRead,
      'isSpam': isSpam,
    };
  }

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      mailID: json['mailID'],
      senderAddress: json['senderAddress'],
      receiverAddress: json['receiverAddress'],
      contentSubject: json['contentSubject'],
      contentBody: json['contentBody'],
      timeSent: DateTime.parse(json['timeSent']),
    );
  }
}

class Account {
  final String userID;
  final String email;
  final String userName;

  Account({required this.userID, required this.email, required this.userName});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      userID: json['userID'],
      email: json['email'],
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'email': email,
      'userName': userName,
    };
  }

  @override
  String toString() {
    return 'userID: $userID - email: $email by userName: $userName';
  }
}

class NotificationData {
  final String notifTitle;
  final String notifSubtitle;

  NotificationData({required this.notifTitle, required this.notifSubtitle});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      notifTitle: json['title'],
      notifSubtitle: json['subtitle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': notifTitle,
      'subtitle': notifSubtitle,
    };
  }
}

class UserSetting {
  final String autoReplyMessage;
  final String userProfileURL;

  UserSetting({required this.autoReplyMessage, required this.userProfileURL});
}