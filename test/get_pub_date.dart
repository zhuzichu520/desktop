void main() {
  var now = DateTime.now();
  var weekdayAbbreviations = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  var monthAbbreviations = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  var timezoneOffset = now.timeZoneOffset;
  var timezoneOffsetHours = timezoneOffset.inHours.abs().toString().padLeft(2, '0');
  var timezoneOffsetMinutes = (timezoneOffset.inMinutes % 60).abs().toString().padLeft(2, '0');
  var timezoneOffsetSign = timezoneOffset.isNegative ? '-' : '+';
  var formattedDate = '${weekdayAbbreviations[now.weekday - 1]}, '
      '${now.day.toString().padLeft(2, '0')} '
      '${monthAbbreviations[now.month - 1]} '
      '${now.year.toString()} '
      '${now.hour.toString().padLeft(2, '0')}:'
      '${now.minute.toString().padLeft(2, '0')}:'
      '${now.second.toString().padLeft(2, '0')} '
      '$timezoneOffsetSign$timezoneOffsetHours$timezoneOffsetMinutes';
  print(formattedDate);
}
