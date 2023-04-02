import 'package:DGR_alarmes/providers/device_provider.dart';
import 'package:DGR_alarmes/providers/user_provider.dart';
import 'package:DGR_alarmes/widgets/device_dropdown_button.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';

import 'package:DGR_alarmes/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuDrawer extends ConsumerWidget {
  final auth = FirebaseAuth.instance;

  MenuDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkMode = ref.watch(themeProvider);
    final user = ref.watch(userProvider);
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
                Container(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                  color: Colors.indigo,
                  width: double.infinity,
                  child: const DeviceDropdownButton(),
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
