import 'package:intl/intl.dart';

import '../network/CaccoNetwork.dart';
import 'NotificationService.dart';

class ScheduledFunction {
  @pragma('vm:entry-point')
  static void checkLastCacco() async {
    var makeCacco = true;
    var lastCacco = await CaccoNetwork.getLastCacco();

    if (lastCacco != null) {
      makeCacco = lastCacco[0];
    }

    if (makeCacco) {
      NotificationService.showNotification(title: 'Hei non fai un cacco da un  un po\'. Tutto bene?',
          body: 'Ricordati di fare un cacco al giorno!');
    }
  }


  static bool checkData(String data) {
    int diff;

    DateTime now = DateTime.now();
    DateTime date = DateFormat('dd/MM/yyyy').parse(data);
    now.isAfter(date) ? diff = 0 : diff = now
        .difference(date)
        .inDays;

    int daysBetween(DateTime now, DateTime date) {
      now = DateTime(now.year, now.month, now.day);
      date = DateTime(date.year, date.month, date.day);
      return (date
          .difference(now)
          .inHours / 24).round();
    }
    diff = daysBetween(now, date);

    if (diff < 0) {
      return true;
    } else if (diff <= 1 && diff > 0) {
      return true;
    }

    return false;
  }

}