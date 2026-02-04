import 'package:flutter/material.dart';

List<String> generateTimeSlots({
  required TimeOfDay start,
  required TimeOfDay end,
  int intervalMinutes = 30,
}) {
  final slots = <String>[];

  int startMinutes = start.hour * 60 + start.minute;
  int endMinutes = end.hour * 60 + end.minute;

  for (
    int minutes = startMinutes;
    minutes <= endMinutes;
    minutes += intervalMinutes
  ) {
    final hour = minutes ~/ 60;
    final minute = minutes % 60;
    slots.add(_formatTime(TimeOfDay(hour: hour, minute: minute)));
  }

  return slots;
}

String _formatTime(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:$minute $period';
}

String formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}
