import 'package:DGR_alarmes/providers/auth_provider.dart';
import 'package:DGR_alarmes/providers/device_provider.dart';
import 'package:DGR_alarmes/providers/user_provider.dart';
import 'package:DGR_alarmes/providers/theme_provider.dart';
import 'package:DGR_alarmes/widgets/device_dropdown_button.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuDrawer extends ConsumerWidget {
  final auth = FirebaseAuth.instance;

  MenuDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkMode = ref.watch(themeProvider);
    final device = ref.watch(deviceProvider);
    final user = ref.watch(userProvider);
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            margin: EdgeInsets.zero,
            accountName: user.when(
              data: (user) {
                return Text(user.name);
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) {
                return Text('$error');
              },
            ),
            accountEmail: Text('${auth.currentUser?.email}'),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          if (device.userDevices.isNotEmpty) ...[
            Container(
              color: Colors.indigo,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const DeviceDropdownButton(),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.indigo),
              title: const Text(
                'Tela inicial',
                style: TextStyle(color: Colors.indigo),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              // minLeadingWidth: 0,
              horizontalTitleGap: 0,
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  '/',
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.device_hub, color: Colors.indigo),
              title: const Text(
                'Dispositivos',
                style: TextStyle(color: Colors.indigo),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              // minLeadingWidth: 0,
              horizontalTitleGap: 0,
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  '/devices_page',
                );
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.summarize_outlined, color: Colors.indigo),
              title: const Text(
                'Histórico',
                style: TextStyle(color: Colors.indigo),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              // minLeadingWidth: 0,
              horizontalTitleGap: 0,
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  '/events_page',
                );
              },
            )
          ],
          const Expanded(child: SizedBox()),
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
                      ref
                          .read(deviceProvider.notifier)
                          .cancelListen()
                          .whenComplete(() {
                        ref.read(authProvider.notifier).signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login_page', (route) => false);
                      });
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
