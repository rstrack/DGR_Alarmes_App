import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:DGR_alarmes/providers/theme_provider.dart';

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
    _darkThemeNotifier = ValueNotifier(ThemeProvider.instance.isDarkTheme);
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
                ListTile(
                    leading: const Icon(Icons.airplay_rounded),
                    title: const Text('Devices'),
                    onTap: () {
                      Navigator.of(context).pushNamed('/devices_page');
                    }),
                const Divider(),
                const ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Configurações')),
                ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    title: const Text('Sair'),
                    onTap: () {
                      auth.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login_page', (route) => false);
                    }),
                ValueListenableBuilder<bool>(
                  valueListenable: _darkThemeNotifier,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return SwitchListTile(
                      title: const Text('Tema escuro'),
                      value: value,
                      onChanged: (bool newValue) {
                        _darkThemeNotifier.value = newValue;
                        ThemeProvider.instance.changeTheme();
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
