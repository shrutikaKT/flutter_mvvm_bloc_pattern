import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_advance/utils/app_constants.dart';

import '../../../configuration/routes.dart';
import '../../../data/repository/login_repository.dart';
import '../../../data/repository/menu_repository.dart';
import '../../common_blocs/account/account.dart';
import '../../common_widgets/drawer/drawer_bloc/drawer_bloc.dart';
import '../../common_widgets/drawer/drawer_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.status == AccountStatus.failure) {
          Navigator.pushNamedAndRemoveUntil(context, ApplicationRoutes.login, (route) => false);
        }
      },
      child: BlocBuilder<AccountBloc, AccountState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          if (state.status == AccountStatus.success) {
            return Scaffold(
              appBar: AppBar(title: const Text(AppConstants.appName)),
              key: _scaffoldKey,
              body: const Center(child: Column(children: [])),
              drawer: _buildDrawer(context),
            );
          }
          return Container();
        },
      ),
    );
  }

  _buildDrawer(BuildContext context) {
    return BlocProvider<DrawerBloc>(
      create: (context) => DrawerBloc(loginRepository: LoginRepository(), menuRepository: MenuRepository())..add(LoadMenus()),
      child: const ApplicationDrawer(),
    );
  }
}
