import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_advance/data/repository/account_repository.dart';
import 'package:flutter_bloc_advance/presentation/common_blocs/account/account.dart';
import 'package:flutter_bloc_advance/presentation/screen/register/bloc/register.dart';
import 'package:flutter_bloc_advance/presentation/screen/register/register_screen.dart';
import 'package:flutter_bloc_advance/utils/app_constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../configuration/routes.dart';
import '../../../generated/l10n.dart';
import '../../../utils/message.dart';
import 'bloc/login.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormBuilderState> _loginFormKey = GlobalKey<FormBuilderState>(debugLabel: '__loginFormKey__');

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  _buildAppBar(BuildContext context) => AppBar(title: const Text(AppConstants.appName), leading: Container());

  _buildBody(BuildContext context) {
    return FormBuilder(
      key: _loginFormKey,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _usernameField(context),
              _passwordField(context),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[_submitButton(context)]),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[_register(context)]),
              _validationZone(),
            ],
          ),
        ),
      ),
    );
  }

  _usernameField(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: FormBuilderTextField(
          name: 'username',
          decoration: InputDecoration(labelText: S.of(context).login_user_name),
          validator: FormBuilderValidators.compose(
            [
              FormBuilderValidators.required(errorText: S.of(context).username_required),
              FormBuilderValidators.minLength(4, errorText: S.of(context).username_min_length),
              FormBuilderValidators.maxLength(20, errorText: S.of(context).username_max_length),
              (val) => null,
            ],
          ),
        ),
      );
    });
  }

  _passwordField(BuildContext context) {
    final fieldWidth = MediaQuery.of(context).size.width * 0.6;
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return SizedBox(
        width: fieldWidth,
        child: Row(
          children: [
            Expanded(
              child: FormBuilderTextField(
                name: 'password',
                decoration: InputDecoration(labelText: S.of(context).login_password),
                // when press the enter key, call submit button function
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  if (_loginFormKey.currentState!.saveAndValidate()) {
                    final username = _loginFormKey.currentState!.value['username'];
                    final password = _loginFormKey.currentState!.value['password'];
                    _submitEvent(context, username: username, password: password);
                  }
                },
                obscureText: !state.passwordVisible,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(errorText: S.of(context).required_field),
                    FormBuilderValidators.minLength(4, errorText: S.of(context).password_min_length),
                    FormBuilderValidators.maxLength(20, errorText: S.of(context).password_max_length),
                    (val) => null
                  ],
                ),
              ),
            ),
            IconButton(
                icon: Icon(state.passwordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () => context.read<LoginBloc>().add(const TogglePasswordVisibility())),
          ],
        ),
      );
    });
  }

  Widget _submitButton(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoadingState) {
          Message.getMessage(context: context, title: S.of(context).loading, content: "", duration: const Duration(seconds: 1));
        } else if (state is LoginLoadedState) {
          Message.getMessage(context: context, title: S.of(context).success, content: "");
          Navigator.pushNamedAndRemoveUntil(context, ApplicationRoutes.home, (route) => false);
        } else if (state is LoginErrorState) {
          Message.errorMessage(context: context, title: S.of(context).failed, content: state.message);
        }
      },
      child: SizedBox(
        child: ElevatedButton(
            child: Text(S.of(context).login_button),
            onPressed: () {
              Navigator.pushNamed(context, ApplicationRoutes.payment);
              // if (_loginFormKey.currentState!.saveAndValidate()) {
              //   _submitEvent(context,
              //       username: _loginFormKey.currentState!.value['username'], password: _loginFormKey.currentState!.value['password']);
              // }
            },
          ),
      ),
    );
  }

  void _submitEvent(BuildContext context, {required String username, required String password}) {
    context.read<LoginBloc>().add(LoginFormSubmitted(username: username, password: password));
  }

  _register(BuildContext context) {
    return SizedBox(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<AccountBloc>.value(value: AccountBloc(repository: AccountRepository())),
                  BlocProvider<RegisterBloc>(create: (_) => RegisterBloc(repository: AccountRepository())),
                ],
                child: RegisterScreen(),
              ),
            ),
          );
        },
        child: Text(S.of(context).register),
      ),
    );
  }

  Widget _validationZone() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) {
        if (current is LoginErrorState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return Visibility(
          visible: state is LoginErrorState,
            child: Center(
                child: Text(
              S.of(context).failed,
              style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize, color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            )));
      },
    );
  }
}
