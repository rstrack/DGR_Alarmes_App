import 'package:DGR_alarmes/providers/device_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SummaryPage extends ConsumerStatefulWidget {
  const SummaryPage({super.key});

  @override
  ConsumerState<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends ConsumerState<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    final device = ref.watch(deviceProvider);
    bool alarmTriggered = device.device!.triggered == true ? true : false;
    bool alarmStatus = device.device!.active == true ? true : false;
    return Scaffold(
      body: device.device != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: alarmTriggered
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.add_alert_sharp,
                                color: Colors.red,
                                size: 100,
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("O dispositivo está",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                  const SizedBox(height: 20),
                                  Text("DISPARADO",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .apply(color: Colors.red)),
                                ],
                              )
                            ],
                          )
                        : alarmStatus
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.security,
                                    color: Colors.green,
                                    size: 100,
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("O dispositivo está",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge),
                                      const SizedBox(height: 20),
                                      Text("ATIVO",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .apply(color: Colors.green)),
                                    ],
                                  )
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.security,
                                    color: Colors.blueGrey,
                                    size: 100,
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("O dispositivo está",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge),
                                      const SizedBox(height: 20),
                                      Text("DESATIVADO",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium),
                                    ],
                                  )
                                ],
                              ),
                  ),
                  alarmTriggered
                      ? TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.indigo,
                            ),
                          ),
                          onPressed: () {
                            ref.read(deviceProvider).disableBuzzer();
                          },
                          child: const Text("Interromper",
                              style: TextStyle(color: Colors.white)))
                      : alarmStatus == true
                          ? TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.indigo,
                                ),
                              ),
                              onPressed: () {
                                ref.read(deviceProvider).changeDeviceState();
                              },
                              child: const Text(
                                "Desativar",
                                style: TextStyle(color: Colors.white),
                              ))
                          : TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.indigo,
                                ),
                              ),
                              onPressed: () {
                                ref.read(deviceProvider).changeDeviceState();
                              },
                              child: const Text("Ativar",
                                  style: TextStyle(color: Colors.white))),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          // var type = 0;
                          // color: type == 0 ? Colors.green : Colors.red,
                          // color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.grey[300]!),
                              bottom: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          child: ListTile(
                            // textColor: type == 0 ? Colors.green : Colors.red,
                            leading: const Icon(Icons.power_settings_new),
                            iconColor: alarmStatus ? Colors.green : Colors.red,
                            title: Text(
                              ref.read(deviceProvider).device!.macAddress,
                            ),
                            subtitle: Text("Tempo"),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
