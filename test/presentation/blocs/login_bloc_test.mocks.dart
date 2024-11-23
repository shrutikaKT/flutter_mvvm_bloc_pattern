// Mocks generated by Mockito 5.4.4 from annotations
// in flutter_bloc_advance/test/presentation/blocs/login_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:flutter_bloc_advance/data/models/jwt_token.dart' as _i4;
import 'package:flutter_bloc_advance/data/models/user_jwt.dart' as _i5;
import 'package:flutter_bloc_advance/data/repository/login_repository.dart'
    as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [LoginRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoginRepository extends _i1.Mock implements _i2.LoginRepository {
  MockLoginRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.JWTToken?> authenticate(_i5.UserJWT? userJWT) =>
      (super.noSuchMethod(
        Invocation.method(
          #authenticate,
          [userJWT],
        ),
        returnValue: _i3.Future<_i4.JWTToken?>.value(),
      ) as _i3.Future<_i4.JWTToken?>);

  @override
  _i3.Future<void> logout() => (super.noSuchMethod(
        Invocation.method(
          #logout,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
