import 'package:flutter/services.dart';

class AppConstants {
  static const String appKey = "flutter_bloc_advanced";
  static const String appName = "FlutterTemplate";
  static const String appVersion = "1.0.0";
  static const String appDescription = "Flutter Template with BLOC and Clean Architecture";
    static const String stripeSecretKey = 'sk_test_51QXfE4FERNU5vmX412jw32gvAFdcSY3NmfP70lQTEBMBUU0hPv8MRJH78WI8Lwrxd0USH1sAQDD31C7CyN2LYF9L00Fu8P4Qzg';
    static const String stripePublishableKey = 'pk_test_51QXfE4FERNU5vmX4tDMkmjhM20pUmyGSfU1fBPO09Bso2SEEauyD3njOQS68PvpYMPLHgz0A1ZZrCQSxX6TU5H9Z00MeUIS9lS';
    }

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
