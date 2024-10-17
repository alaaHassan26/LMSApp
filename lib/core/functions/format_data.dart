import 'package:flutter/material.dart';

String formatDate(DateTime date, BuildContext context) {
  final now = DateTime.now();
  final difference = now.difference(date);

  // Check if the date is in the future
  if (difference.isNegative) {
    return ' منذ 1 ثانية'; // Example message for future date
  }

  if (difference.inDays >= 30) {
    return 'منذ ${difference.inDays ~/ 30} شهر';
  } else if (difference.inDays >= 7) {
    return 'منذ ${difference.inDays ~/ 7} اسبوع';
  } else if (difference.inDays > 0) {
    return 'منذ ${difference.inDays} يوم';
  } else if (difference.inHours > 0) {
    return 'منذ ${difference.inHours} ساعة';
  } else if (difference.inMinutes > 0) {
    return 'منذ ${difference.inMinutes} دقيقة';
  } else {
    return 'منذ ${difference.inSeconds} ثواني';
  }
}
