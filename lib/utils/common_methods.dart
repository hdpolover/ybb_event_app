import 'package:intl/intl.dart';

class CommonMethods {
  getEventDate(DateTime start, DateTime end) {
    // format the date to be like "August 10 - 12, 2021"
    String formattedDate = "";

    if (start.month == end.month) {
      // get the month name
      String monthName = DateFormat('MMMM').format(start);

      formattedDate = "$monthName ${start.day} - ${end.day}, ${start.year}";
    } else {
      // get the month name
      String startMonthName = DateFormat('MMMM').format(start);
      String endMonthName = DateFormat('MMMM').format(end);

      formattedDate =
          "$startMonthName ${start.day} - $endMonthName ${end.day}, ${start.year}";
    }

    return formattedDate;
  }
}
