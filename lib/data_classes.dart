// ignore_for_file: non_constant_identifier_names

class EmailAttachment {
  final int file_id;
  final String filename;
  final String file_url;

  EmailAttachment({
    required this.file_id,
    required this.filename,
    required this.file_url,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': file_id,
      'filename': filename,
      'file_url': file_url,
    };
  }

  factory EmailAttachment.fromJson(Map<String, dynamic> json) {
    return EmailAttachment(
      file_id: json['id'],
      filename: json['filename'],
      file_url: json['file_url'],
    );
  }
}

class Email {
  final int message_id;
  final String sender;
  final List<String> recipients;
  final List<String> cc;
  final List<String> bcc;
  final String subject;
  final String body;
  final List<EmailAttachment> attachments;
  final DateTime sent_at;
  final bool is_read;
  final bool is_starred;
  final bool is_draft;
  final bool is_trashed;
  final bool is_auto_replied;

  @override
  String toString() {
    return 'Mail ID: $message_id - Sent by $sender @ $sent_at. Subject: $subject';
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'message_id': message_id,
  //     'sender': sender,
  //     'recipients': recipients,
  //     'cc': cc,
  //     'bcc': bcc,
  //     'subject': subject,
  //     'body': body,
  //     'attachments': attachments,
  //     'sent_at': sent_at.toIso8601String(),
  //     'is_read': is_read,
  //     'is_starred': is_starred,
  //     'is_draft': is_draft,
  //     'is_trashed': is_trashed,
  //     'is_auto_replied': is_auto_replied,
  //   };
  // }

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      message_id: json["id"],
      sender: json["sender"],
      recipients: List<String>.from(json['recipients'] ?? []),
      cc: List<String>.from(json['cc'] ?? []),
      bcc: List<String>.from(json['bcc'] ?? []),
      subject: json["subject"],
      body: json["body"],
      attachments: (json['attachments'] as List?)
          ?.map((item) => EmailAttachment.fromJson(item))
          .toList() ?? [],
      sent_at: DateTime.parse(json["sent_at"]),
      is_read: json["is_read"] ?? false,
      is_starred: json["is_starred"] ?? false,
      is_draft: json["is_draft"] ?? false,
      is_trashed: json["is_trashed"] ?? false,
      is_auto_replied: json["is_auto_replied"] ?? false,
    );
  }

  Email({
    required this.message_id,
    required this.sender,
    required this.recipients,
    required this.cc,
    required this.bcc,
    required this.subject,
    required this.body,
    required this.attachments,
    required this.sent_at,
    required this.is_read,
    required this.is_starred,
    required this.is_draft,
    required this.is_trashed,
    required this.is_auto_replied,
  });
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

  UserProfile({
    required this.bio,
    required this.birthdate,
    required this.two_factor_enabled,
  });

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
