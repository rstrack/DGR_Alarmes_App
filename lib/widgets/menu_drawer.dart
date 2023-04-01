import 'package:DGR_alarmes/providers/device_provider.dart';
import 'package:DGR_alarmes/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';

import 'package:DGR_alarmes/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuDrawer extends ConsumerStatefulWidget {
  const MenuDrawer({super.key});

  @override
  ConsumerState<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends ConsumerState<MenuDrawer> {
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ref.watch(themeProvider);
    final user = ref.watch(userProvider);
    final device = ref.watch(deviceProvider);
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: user.when(
                    data: (user) {
                      return Text(user.name);
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stackTrace) {
                      return Text('$error');
                    },
                  ),
                  accountEmail: Text('${auth.currentUser!.email}'),
                  currentAccountPicture: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
                // ------------ DROPDOWN ------------ //
                DropdownButton<String>(
                  value: device.device?.macAddress,
                  items: device.userDevices
                      .map((userDevice) => DropdownMenuItem(
                          value: userDevice.idDevice,
                          child: Text(userDevice.nickname)))
                      .toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      print(value);

                      ref.read(deviceProvider.notifier).getDevice(value);
                    }
                  },
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
                    onTap: () {
                      auth.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login_page', (route) => false);
                    }),
                SwitchListTile(
                  title: const Text('Tema escuro'),
                  value: isDarkMode,
                  onChanged: (bool newValue) {
                    ref.read(themeProvider.notifier).toggle();
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
