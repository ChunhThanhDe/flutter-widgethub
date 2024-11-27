import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterui/app/core/app.dart';
import 'package:flutterui/app/core/config.dart';
import 'package:flutterui/app/shared/presentation/helpers/observers/bloc_observer.dart';
import 'package:flutterui/app/core/service_locators.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutterui/debug_tool/log_helper.dart';

void main() async {
  const tag = "main";
  WidgetsFlutterBinding.ensureInitialized();

  LogHelper.d(tag, "usePathUrlStrategy start");
  usePathUrlStrategy();

  AppConfig.instance.init(env: AppEnv.DEV);

  LogHelper.d(tag, "ServiceLocators start");
  await ServiceLocators.register();

  LogHelper.d(tag, "Bloc.observer start");
  Bloc.observer = SimpleBlocObserver();

  runApp(const MyApp());
}
