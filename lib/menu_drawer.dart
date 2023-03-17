import 'package:flutter/material.dart';

import 'theme_controller.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
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
              children: const [
                UserAccountsDrawerHeader(
                  accountName: Text("Nome"),
                  accountEmail: Text("Email@email.com"),
                  currentAccountPicture: CircleAvatar(
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
