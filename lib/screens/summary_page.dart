import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:DGR_alarmes/providers/log_provider.dart';
import 'package:DGR_alarmes/providers/device_provider.dart';
import 'package:DGR_alarmes/widgets/alarm_action_button.dart';
import 'package:DGR_alarmes/widgets/alarm_status.dart';

class SummaryPage extends ConsumerStatefulWidget {
  const SummaryPage({super.key});

  @override
  ConsumerState<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends ConsumerState<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    final device = ref.watch(deviceProvider);
    final log = ref.watch(logProvider(10));
    // print(device.macAddress);
    return Scaffold(
      body: device.device != null
          ? Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: AlarmStatus(),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Container(color: Colors.grey[300], height: 2),
                const AlarmActionButton(),
                const SizedBox(
                  height: 20,
                ),
                // Container(color: Colors.grey[300], height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Histórico recente',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/events_page',
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Ver histórico completo'),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 24.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(color: Colors.grey[300], height: 2),
                log.when(
                  data: (data) => Expanded(
                      child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      if (data.isNotEmpty) {
                        final item = data[index];
                        final typeText = item.type == 0
                            ? "Alarme ativado"
                            : item.type == 1
                                ? "Alarme desativado"
                                : "Alarme disparado";
                        final icon = item.type == 0
                            ? const Icon(
                                Icons.power_settings_new,
                                color: Colors.green,
                              )
                            : item.type == 1
                                ? const Icon(
                                    Icons.power_settings_new,
                                    color: Colors.blueGrey,
                                  )
                                : const Icon(
                                    Icons.notification_important,
                                    color: Colors.red,
                                  );
                        final time = DateTime.fromMillisecondsSinceEpoch(
                            item.time * 1000);
                        final formattedTime =
                            DateFormat('dd/MM/yyyy HH:mm').format(time);
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.grey[300]!),
                              bottom: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          child: ListTile(
                            leading: icon,
                            title: Text(typeText),
                            subtitle: Text(formattedTime),
                          ),
                        );
                      }
                      return null;
                    },
                  )),
                  error: (error, stackTrace) => const Text(""),
                  loading: () => const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
