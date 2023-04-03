import 'dart:developer';

import 'package:cron/cron.dart';
import 'package:dev_task/constants/hive_keys.dart';
import 'package:dev_task/data/github/git_hub_local_datasource.dart';
import 'package:dev_task/inits.dart';
import 'package:dev_task/presentation/screens/home_screen.dart';
import 'package:dev_task/utils/bloc_observer.dart';
import 'package:dev_task/utils/hive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  await initHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
