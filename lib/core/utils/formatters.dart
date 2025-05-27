// lib/core/utils/formatters.dart
import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(
    double amount, {
    String symbol = '\$',
    int decimalPlaces = 2,
  }) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalPlaces,
    );
    return formatter.format(amount);
  }

  static String formatDate(
    String dateString, {
    String format = 'MMM dd, yyyy',
  }) {
    final DateTime date = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat(format);
    return formatter.format(date);
  }

  static String formatDateTime(
    String dateTimeString, {
    String format = 'MMM dd, yyyy HH:mm',
  }) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat(format);
    return formatter.format(dateTime);
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Format phone number to (XXX) XXX-XXXX for US numbers
    // or return the original for other formats
    if (phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6)}';
    }
    return phoneNumber;
  }

  static String getTimeAgo(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} ${(difference.inDays / 365).floor() == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ${(difference.inDays / 30).floor() == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
