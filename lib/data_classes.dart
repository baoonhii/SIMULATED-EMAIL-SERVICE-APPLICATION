// ignore_for_file: non_constant_identifier_names

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
  final String phone_number;
  final String email;
  final String first_name;
  final String last_name;
  final String profile_picture;
  final bool is_phone_verified;

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      phone_number: json['phone_number'],
      email: json['email'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      profile_picture: json['profile_picture'],
      is_phone_verified: json['is_phone_verified'],
    );
  }

  Account({
    required this.phone_number,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.profile_picture,
    required this.is_phone_verified,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phone_number,
      'email': email,
      'first_name': first_name,
      'last_name': last_name,
      'profile_picture': profile_picture,
      'is_phone_verified': is_phone_verified,
    };
  }

  @override
  String toString() {
    return 'phone_number: $phone_number - email: $email by first_name: $first_name';
  }
}

class UserProfile {
  final String? bio;
  final String? birthdate;
  final bool two_factor_enabled;

  UserProfile(
      {required this.bio,
      required this.birthdate,
      required this.two_factor_enabled});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      bio: json['bio'],
      birthdate: json['birthdate'],
      two_factor_enabled: json['two_factor_enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'birthdate': birthdate,
      'two_factor_enabled': two_factor_enabled,
    };
  }

  @override
  String toString() {
    return 'bio: $bio - birthdate: $birthdate - two_factor_enabled: $two_factor_enabled';
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
  final bool notifications_enabled;
  final int font_size;
  final String font_family;
  final bool dark_mode;
  final bool auto_reply_enabled;
  final String? auto_reply_message;
  final String? auto_reply_start_date;
  final String? auto_reply_end_date;

  UserSetting({
    required this.notifications_enabled,
    required this.font_size,
    required this.font_family,
    required this.dark_mode,
    required this.auto_reply_enabled,
    required this.auto_reply_message,
    required this.auto_reply_start_date,
    required this.auto_reply_end_date,
  });

  factory UserSetting.fromJson(Map<String, dynamic> json) {
    return UserSetting(
      notifications_enabled: json['notifications_enabled'],
      font_size: json['font_size'],
      font_family: json['font_family'],
      dark_mode: json['dark_mode'],
      auto_reply_enabled: json['auto_reply_enabled'],
      auto_reply_message: json['auto_reply_message'],
      auto_reply_start_date: json['auto_reply_start_date'],
      auto_reply_end_date: json['auto_reply_end_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications_enabled': notifications_enabled,
      'font_size': font_size,
      'font_family': font_family,
      'dark_mode': dark_mode,
      'auto_reply_enabled': auto_reply_enabled,
      'auto_reply_message': auto_reply_message,
      'auto_reply_start_date': auto_reply_start_date,
      'auto_reply_end_date': auto_reply_end_date,
    };
  }
}
