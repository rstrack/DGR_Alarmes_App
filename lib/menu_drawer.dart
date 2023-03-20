import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'theme_controller.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  final auth = FirebaseAuth.instance;

  late final ValueNotifier<bool> _darkThemeNotifier;

  @override
  void initState() {
    super.initState();
    _darkThemeNotifier = ValueNotifier(ThemeController.instance.isDarkTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: const Text("Nome"),
                  accountEmail: Text('${auth.currentUser!.email}'),
                  currentAccountPicture: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Column(
              children: <Widget>[
                const Divider(),
                const ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Configurações')),
                ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    title: const Text('Sair'),
                    onTap: () => auth.signOut()),
                ValueListenableBuilder<bool>(
                  valueListenable: _darkThemeNotifier,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return SwitchListTile(
                      title: const Text('Tema escuro'),
                      value: value,
                      onChanged: (bool newValue) {
                        _darkThemeNotifier.value = newValue;
                        ThemeController.instance.changeTheme();
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
