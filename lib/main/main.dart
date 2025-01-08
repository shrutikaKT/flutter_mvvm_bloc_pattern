import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_advance/configuration/app_logger.dart';
import 'package:flutter_bloc_advance/configuration/environment.dart';
import 'package:flutter_bloc_advance/configuration/local_storage.dart';
import 'package:flutter_bloc_advance/utils/app_constants.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'app.dart';
import 'main.mapper.g.dart';
/// IMPORTANT!! run this command to generate main_prod.mapper.g.dart
// dart run build_runner build --delete-conflicting-outputs
// flutter pub run intl_utils:generate
/// main entry point of local computer development
void main() async {
  AppLogger.configure(isProduction: false);
  final log = AppLogger.getLogger("main.dart");

  ProfileConstants.setEnvironment(Environment.dev);

  log.info("Starting App with env: {}", [Environment.dev.name]);
  initializeJsonMapper();
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = AppConstants.stripePublishableKey;

  const defaultLanguage = "en";
  await AppLocalStorage().save(StorageKeys.language.name, defaultLanguage);

  WidgetsFlutterBinding.ensureInitialized();
  const initialTheme = AdaptiveThemeMode.light;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(App(language: defaultLanguage, initialTheme: initialTheme));
  });
  log.info("Started App with local environment language: {} and theme: {}", [defaultLanguage, initialTheme.name]);
}
