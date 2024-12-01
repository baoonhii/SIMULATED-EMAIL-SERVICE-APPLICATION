import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../data_classes.dart';
import '../state_management/email_provider.dart';
import 'general.dart';

ListTile getEmailTile(
  Email email,
  GestureTapCallback onTap,
  BuildContext context,
  EmailsProvider emailsProvider,
) {
  return ListTile(
    leading: getSenderAvatar(email),
    title: getEmailTitle(email, context),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getPlainSubjectText(email),
        if (email.labels.isNotEmpty)
          Wrap(
            spacing: 4,
            children: email.labels
                .map(
                  (label) => Chip(
                    label: Text(label.displayName),
                    backgroundColor: label.color,
                    labelStyle: const TextStyle(fontSize: 10),
                    padding: const EdgeInsets.all(2),
                  ),
                )
                .toList(),
          ),
      ],
    ),
    trailing: getEmailTrailing(email, context, emailsProvider),
    onTap: onTap,
  );
}

CircleAvatar getSenderAvatar(Email email) {
  return CircleAvatar(
    backgroundColor: _getColorForSender(email.sender),
    child: Text(
      email.sender[0].toUpperCase(),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

RichText getEmailTitle(Email email, BuildContext context) {
  return RichText(
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    text: getSenderSpan(email, context),
  );
}

Column getEmailTrailing(
  Email email,
  BuildContext context,
  EmailsProvider emailsProvider,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text(
        _formatTimeSent(email.sent_at, context),
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      const SizedBox(height: 4),
      GestureDetector(
        onTap: () => emailsProvider.performEmailAction(email, EmailAction.star),
        child: Icon(
          email.is_starred ? Icons.star : Icons.star_border,
          color: email.is_starred ? Colors.amber : Colors.grey,
          size: 20,
        ),
      ),
    ],
  );
}

Text getPlainSubjectText(Email email) {
  return Text(
    quill.Document.fromJson(jsonDecode(email.body)).toPlainText(),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(color: Colors.grey[700]),
  );
}

TextSpan getSenderSpan(Email email, BuildContext context) {
  return TextSpan(
    children: [
      TextSpan(
        text: email.subject,
        style: TextStyle(
          fontWeight: email.is_read ? FontWeight.normal : FontWeight.bold,
          color: email.is_read
              ? Colors.grey[600]
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      TextSpan(
        text: ' from ',
        style: TextStyle(
          color: Colors.grey[500],
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
      ),
      TextSpan(
        text: email.sender,
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
      ),
    ],
  );
}

// Helper methods remain the same as in the previous example
Color _getColorForSender(String senderAddress) {
  int hash = senderAddress.hashCode;
  return Color.fromRGBO(
    (hash & 0xFF0000) >> 16,
    (hash & 0x00FF00) >> 8,
    hash & 0x0000FF,
    0.6,
  );
}

String _formatTimeSent(DateTime timeSent, BuildContext context) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  final yesterday = today.subtract(const Duration(days: 1));

  if (timeSent.isAfter(today) && timeSent.isBefore(tomorrow)) {
    return DateFormat('HH:mm').format(timeSent.toLocal());
  } else if (timeSent.isAfter(yesterday) && timeSent.isBefore(today)) {
    return AppLocalizations.of(context)!.yesterday;
  } else {
    final difference = now.difference(timeSent).inDays;
    if (difference >= 365) {
      return DateFormat('MM/dd/yyyy').format(timeSent.toLocal());
    } else {
      return DateFormat('MM/dd').format(timeSent.toLocal());
    }
  }
}
