import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_advance/configuration/local_storage.dart';

import '../../../configuration/routes.dart';
import '../../../generated/l10n.dart';
import '../../common_blocs/account/account.dart';
import 'drawer_bloc/drawer_bloc.dart';

class ApplicationDrawer extends StatelessWidget {
  const ApplicationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: _buildBlocListener(context),
      child: BlocBuilder<DrawerBloc, DrawerState>(
        builder: (context, state) {
          var parentMenus = [];
          if (state.menus.isEmpty) {
            return Container();
          }
          parentMenus = state.menus.where((element) => element.level == 1).toList();
          parentMenus.sort((a, b) => a.orderPriority.compareTo(b.orderPriority));

          return Drawer(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildMenuList(parentMenus, state),
                  const SizedBox(height: 20),
                  const ThemeSwitchButton(),
                  const SizedBox(height: 20),
                  const LanguageSwitchButton(),
                  const SizedBox(height: 20),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Padding _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(elevation: 0),
            onPressed: () => logOutDialog(context),
            child: Text(S.of(context).logout, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }

  ListView _buildMenuList(List<dynamic> parentMenus, DrawerState state) {
    return ListView.builder(
      itemCount: parentMenus.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
          return _buildMenuListListTile(parentMenus, index, context);
        }
    );
  }

  ListTile _buildMenuListListTile(List<dynamic> parentMenus, int index, BuildContext context) {
    return ListTile(
      title: Text(S.of(context).translate_menu_title(parentMenus[index].name), style: Theme.of(context).textTheme.bodyMedium),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, parentMenus[index].url);
      },
    );
  }

  _buildBlocListener(BuildContext context) {
    return [
      BlocListener<DrawerBloc, DrawerState>(
        listener: (context, state) {
          if (state.isLogout) {
            Navigator.popUntil(context, ModalRoute.withName(ApplicationRoutes.login));
            Navigator.pushNamed(context, ApplicationRoutes.login);
          }
        },
      ),
      BlocListener<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state.status == AccountStatus.failure) {
            Navigator.popUntil(context, ModalRoute.withName(ApplicationRoutes.login));
            Navigator.pushNamed(context, ApplicationRoutes.login);
          }
        },
      ),
    ];
  }

  Future logOutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).logout),
          content: Text(S.of(context).logout_sure),
          actions: [
            TextButton(
              onPressed: () => onLogout(context),
              child: Text(S.of(context).yes),
            ),
            TextButton(
              onPressed: () => onCancel(context),
              child: Text(S.of(context).no),
            ),
          ],
        );
      },
    );
  }

  void onLogout(context) {
    BlocProvider.of<DrawerBloc>(context).add(Logout());
    Navigator.pushNamedAndRemoveUntil(context, ApplicationRoutes.login, (route) => false);
  }

  void onCancel(context) {
    Navigator.pop(context);
  }
}

class ThemeSwitchButton extends StatelessWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AdaptiveTheme.of(context).mode.isDark;

    return SwitchListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
        ],
      ),
      value: isDarkMode,
      onChanged: (value) {
        if (value) {
          AdaptiveTheme.of(context).setDark();
        } else {
          AdaptiveTheme.of(context).setLight();
        }
      },
    );
  }
}

class LanguageSwitchButton extends StatefulWidget {
  const LanguageSwitchButton({super.key});

  @override
  LanguageSwitchButtonState createState() => LanguageSwitchButtonState();
}

class LanguageSwitchButtonState extends State<LanguageSwitchButton> {
  bool isTurkish = true;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final lang = await AppLocalStorage().read(StorageKeys.language.name);
    setState(() {
      isTurkish = lang == 'tr';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(isTurkish ? S.of(context).turkish : S.of(context).english),
        ],
      ),
      value: isTurkish,
      onChanged: (value) async {
        isTurkish = value;

        final lang = isTurkish ? 'tr' : 'en';
        await AppLocalStorage().save(StorageKeys.language.name, lang);
        await S.load(Locale(isTurkish ? 'tr' : 'en'));
        if (mounted) {
          setState(() {
            Navigator.pushNamed(context, ApplicationRoutes.home);
          });
        }
      },
    );
  }
}
