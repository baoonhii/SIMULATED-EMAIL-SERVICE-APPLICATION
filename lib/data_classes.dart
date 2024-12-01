// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

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

class EmailLabel {
  final int id;
  final String displayName;
  final Color color;

  EmailLabel({required this.id, required this.displayName, required this.color});

  // Add a method to convert color to hex string
  String get colorHex {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  static EmailLabel fromJson(Map<String, dynamic> json) {
    return EmailLabel(
      id: json['id'],
      displayName: json['name'],
      color: Color(
        int.parse(json['color'].substring(1), radix: 16) + 0xFF000000,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': displayName,
      'color': color,
    };
  }

  @override
  String toString() {
    return "$id $displayName $color";
  }

  bool operator ==(Object other) =>
      other is EmailLabel &&
      other.runtimeType == runtimeType &&
      other.id == id;

  @override
  int get hashCode => id.hashCode;
}

// Updated Email class with labels and additional methods
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
  bool is_read;
  bool is_starred;
  bool is_draft;
  bool is_trashed;
  bool is_auto_replied;
  List<EmailLabel> labels;

  Email({
    required this.message_id,
    required this.sender,
    required this.recipients,
    this.cc = const [],
    this.bcc = const [],
    required this.subject,
    required this.body,
    this.attachments = const [],
    required this.sent_at,
    this.is_read = false,
    this.is_starred = false,
    this.is_draft = false,
    this.is_trashed = false,
    this.is_auto_replied = false,
    this.labels = const [],
  });

  // Factory method to create from JSON
  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      message_id: json['id'],
      sender: json['sender'],
      recipients: List<String>.from(json['recipients'] ?? []),
      cc: List<String>.from(json['cc'] ?? []),
      bcc: List<String>.from(json['bcc'] ?? []),
      subject: json['subject'],
      body: json['body'],
      sent_at: DateTime.parse(json['sent_at']),
      attachments: (json['attachments'] as List?)
              ?.map((attach) => EmailAttachment.fromJson(attach))
              .toList() ??
          [],
      is_read: json['is_read'] ?? false,
      is_starred: json['is_starred'] ?? false,
      is_draft: json['is_draft'] ?? false,
      is_trashed: json['is_trashed'] ?? false,
      is_auto_replied: json['is_auto_replied'] ?? false,
      labels: (json['labels'] as List?)
              ?.map((attach) => EmailLabel.fromJson(attach))
              .toList() ??
          [],
    );
  }

  // Method to toggle read status
  bool toggleReadStatus() {
    is_read = !is_read;
    return is_read;
  }

  // Method to toggle star status
  bool toggleStarStatus() {
    is_starred = !is_starred;
    return is_starred;
  }

  // Method to add a label
  void addLabel(EmailLabel label) {
    if (!labels.contains(label)) {
      labels.add(label);
    }
  }

  // Method to remove a label
  void removeLabel(EmailLabel label) {
    labels.remove(label);
  }

  // Method to move to trash
  void moveToTrash() {
    is_trashed = true;
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

enum EmailAction { markRead, star, moveToTrash }

enum LabelManagementAction { create, edit, delete }
