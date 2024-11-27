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