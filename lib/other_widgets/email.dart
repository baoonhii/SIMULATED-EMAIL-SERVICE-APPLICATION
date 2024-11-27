import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../data_classes.dart';

ListTile getEmailTile(Email email, GestureTapCallback onTap, BuildContext context) {
  return ListTile(
    leading: CircleAvatar(
      backgroundColor: _getColorForSender(email.senderAddress),
      child: Text(
        email.senderAddress[0].toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    title: RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: email.contentSubject,
            style: TextStyle(
              fontWeight: email.isRead ? FontWeight.normal : FontWeight.bold,
              color: email.isRead ? Colors.grey[600] : Colors.black,
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
            text: email.senderAddress,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w300,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
    subtitle: Text(
      email.contentBody,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: Colors.grey[700]),
    ),
    trailing: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatTimeSent(email.timeSent, context),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Icon(
          email.isRead ? Icons.star_border : Icons.star,
          color: email.isRead ? Colors.grey : Colors.amber,
          size: 20,
        ),
      ],
    ),
    onTap: onTap,
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
  final yesterday = today.subtract(const Duration(days: 1));

  if (timeSent.isAfter(today)) {
    return DateFormat('HH:mm').format(timeSent.toLocal());
  } else if (timeSent.isAfter(yesterday)) {
    return AppLocalizations.of(context)!.yesterday;
  } else {
    return DateFormat('MM/dd').format(timeSent.toLocal());
  }
}