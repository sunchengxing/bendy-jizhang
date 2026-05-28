class DateUtil {
  static String today() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  static String nowTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';
  }

  static String weekStart() {
    final now = DateTime.now();
    final weekday = now.weekday;
    final monday = now.subtract(Duration(days: weekday - 1));
    return '${monday.year.toString().padLeft(4, '0')}-'
        '${monday.month.toString().padLeft(2, '0')}-'
        '${monday.day.toString().padLeft(2, '0')}';
  }

  static String monthStart() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-01';
  }

  static String yearStart() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-01-01';
  }

  static String displayDate(String date) {
    final parts = date.split('-');
    if (parts.length != 3) return date;
    return '${parts[0]}年${int.parse(parts[1])}月${int.parse(parts[2])}日';
  }

  static String displayMonth(String date) {
    final parts = date.split('-');
    if (parts.length < 2) return date;
    return '${parts[0]}年${int.parse(parts[1])}月';
  }
}
