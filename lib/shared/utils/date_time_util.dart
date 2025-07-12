import 'package:intl/intl.dart';

class DateTimeUtil {
  static String formatTimestamp(DateTime timestamp) {
    return DateFormat('h:mm a').format(timestamp);
  }
}
