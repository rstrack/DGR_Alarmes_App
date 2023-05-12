import 'package:DGR_alarmes/models/log.dart';
import 'package:DGR_alarmes/providers/device_provider.dart';
import 'package:DGR_alarmes/providers/log_provider.dart';
import 'package:DGR_alarmes/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});
  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  int? _select = 9;

  @override
  Widget build(BuildContext context) {
    final device = ref.watch(deviceProvider);
    var log = ref.watch(logProvider(30));
    List<Log> filteredData;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Histórico - ${device.userDevices.firstWhere((element) => element.idDevice == device.macAddress).nickname}",
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.filter_list_alt),
            tooltip: "Filtrar",
            onSelected: (value) {
              setState(() {
                _select = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 9,
                child: Text('Todos'),
              ),
              const PopupMenuItem<int>(
                value: 0,
                child: Text('Ativado'),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Desativado'),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text('Disparado'),
              ),
            ],
          ),
        ],
      ),
      drawer: MenuDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          log = await ref.refresh(logProvider(30));
        },
        child: device.device != null
            ? log.when(
                data: (data) {
                  if (_select == 9) {
                    filteredData = data;
                  } else {
                    filteredData =
                        data.where((item) => item.type == _select).toList();
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            if (filteredData.isNotEmpty) {
                              final item = filteredData[index];
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
                                    bottom:
                                        BorderSide(color: Colors.grey[300]!),
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
                        ),
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) => const Text("Erro"),
                loading: () => const Center(child: CircularProgressIndicator()),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
