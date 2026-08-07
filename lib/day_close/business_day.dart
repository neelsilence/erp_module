class BusinessDayRange {
  const BusinessDayRange({
    required this.key,
    required this.start,
    required this.end,
  });

  final String key;
  final DateTime start;
  final DateTime end;
}

class BusinessDay {
  const BusinessDay({this.cutoffHour = 0});

  final int cutoffHour;

  BusinessDayRange resolve({DateTime? at}) {
    final moment = at ?? DateTime.now();
    final normalized = DateTime(moment.year, moment.month, moment.day);
    final cutoffToday = normalized.add(Duration(hours: cutoffHour));

    final DateTime start;
    if (moment.isBefore(cutoffToday)) {
      start = cutoffToday.subtract(const Duration(days: 1));
    } else {
      start = cutoffToday;
    }

    final end =
        start.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    final key = _formatKey(start);

    return BusinessDayRange(key: key, start: start, end: end);
  }

  BusinessDayRange forKey(String businessDayKey) {
    final parts = businessDayKey.split('-');
    if (parts.length != 3) {
      throw ArgumentError('Invalid business day key: $businessDayKey');
    }
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);
    final start = DateTime(year, month, day, cutoffHour);
    final end =
        start.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    return BusinessDayRange(key: businessDayKey, start: start, end: end);
  }

  String _formatKey(DateTime start) {
    final y = start.year.toString().padLeft(4, '0');
    final m = start.month.toString().padLeft(2, '0');
    final d = start.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
