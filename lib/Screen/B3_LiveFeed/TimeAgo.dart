import 'package:intl/intl.dart';

class TimeAgo{
  static String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    try {
      DateTime notificationDate = DateTime.parse(
          dateString); //DateFormat("dd-MM-yyyy h:mma").parse(dateString);
      final date2 = DateTime.now();
      final difference = date2.difference(notificationDate);

      if (difference.inDays > 8) {
        return dateString;
      } else if ((difference.inDays / 7).floor() >= 1) {
        return (numericDates) ? '1w ago' : 'Last week';
      } else if (difference.inDays >= 2) {
        return '${difference.inDays}d ago';
      } else if (difference.inDays >= 1) {
        return (numericDates) ? '1d ago' : 'Yesterday';
      } else if (difference.inHours >= 2) {
        return '${difference.inHours}h ago';
      } else if (difference.inHours >= 1) {
        return (numericDates) ? '1h' : 'An hour ago';
      } else if (difference.inMinutes >= 2) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inMinutes >= 1) {
        return (numericDates) ? '1m ago' : 'A minute ago';
      } else if (difference.inSeconds >= 3) {
        return '${difference.inSeconds}s ago';
      } else {
        return 'Just now';
      }
    } on Exception catch (_) {
      print('');
    }
    return '';
  }
}