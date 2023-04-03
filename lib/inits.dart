import 'package:dev_task/constants/hive_keys.dart';
import 'package:dev_task/utils/hive_helper.dart';
import 'package:hive_flutter/adapters.dart';

Future initHive() async {
  await Hive.initFlutter();
  // Hive.registerAdapter(CustomerModelAdapter());

  await HiveHelper(HiveKeys.githubRepo).openBox();
}
