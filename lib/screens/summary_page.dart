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
    return Scaffold(
      body: device.device != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  device.device!.triggered == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.add_alert_sharp,
                              color: Colors.red,
                              size: 100,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("O dispositivo está",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                const SizedBox(height: 20),
                                Text("DISPARADO",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                              ],
                            )
                          ],
                        )
                      : device.device!.active == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.security,
                                  color: Colors.green,
                                  size: 100,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("O dispositivo está",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    const SizedBox(height: 20),
                                    Text("ATIVO",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium),
                                  ],
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.security,
                                  color: Colors.blueGrey,
                                  size: 100,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("O dispositivo está",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    const SizedBox(height: 20),
                                    Text("DESATIVADO",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium),
                                  ],
                                )
                              ],
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
