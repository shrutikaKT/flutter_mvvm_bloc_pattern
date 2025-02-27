import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../../data/models/user.dart';
import '../../../../../generated/l10n.dart';
import 'edit_form_widget.dart';

class EditUserScreen extends StatelessWidget {
  final User user;

  EditUserScreen({super.key, required this.user});

  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(S.of(context).edit_user),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  _buildBody(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(minWidth: 300, maxWidth: 700),
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: <Widget>[
                EditFormLoginName(user: user),
                EditFormFirstName(user: user),
                EditFormLastname(user: user),
                EditFormEmail(user: user),
                // EditFormPhoneNumber(user: user),
                EditFormActive(user: user),
                const SizedBox(height: 20),
                SubmitButton(context, user: user, formKey: formKey)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
