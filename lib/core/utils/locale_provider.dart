import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Default language English ('en') rahegi
final localeProvider = StateProvider<Locale>((ref) {
  return const Locale('en');
});
