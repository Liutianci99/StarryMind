import 'package:flutter/material.dart';
import 'package:starry_mind/app/starry_mind_app.dart';
import 'package:starry_mind/core/storage/hive_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveStorage.init();
  runApp(const StarryMindApp());
}
