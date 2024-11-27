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