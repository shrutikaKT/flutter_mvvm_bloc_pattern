import 'package:flutter_bloc_advance/configuration/environment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileConstants', () {
    test('setEnvironment sets dev environment', () {
      ProfileConstants.setEnvironment(Environment.dev);
      expect(ProfileConstants.isDevelopment, true);
      expect(ProfileConstants.api, "mock");
    });

    test('setEnvironment sets test environment', () {
      ProfileConstants.setEnvironment(Environment.test);
      expect(ProfileConstants.isDevelopment, false);
      expect(ProfileConstants.isProduction, false);
      expect(ProfileConstants.api, "assets/mock");
    });

    test('setEnvironment sets prod environment', () {
      ProfileConstants.setEnvironment(Environment.prod);
      expect(ProfileConstants.isProduction, true);
      expect(ProfileConstants.api, "https://dhw-api.onrender.com/api");
    });
  });
}