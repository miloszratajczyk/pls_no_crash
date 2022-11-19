import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:pls_no_crash/game/model/stats.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Creates `ColorScheme` based on a random color
ColorScheme randomColorScheme() {
  final randomColorValue = (math.Random().nextDouble() * 0xFFFFFF).toInt();

  return ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: Color(randomColorValue).withOpacity(1.0),
  );
}

/// Loads `Stats` from `SharedPreferences`
Future<Stats> loadStats() async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getString('stats');
  return data == null ? Stats() : Stats.fromJson(data);
}

/// Saves `Stats` to `SharedPreferences`
Future<void> saveStats(Stats stats) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('stats', stats.toJson());
}
