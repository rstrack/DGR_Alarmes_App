import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:DGR_alarmes/providers/device_provider.dart';

class AlarmStatus extends ConsumerWidget {
  const AlarmStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceNotifier = ref.watch(deviceProvider);
    final iconData = deviceNotifier.device!.triggered
        ? Icons.notification_important
        : deviceNotifier.device!.active
            ? Icons.security
            : Icons.security;

    final iconColor = deviceNotifier.device!.triggered
        ? Colors.red
        : deviceNotifier.device!.active
            ? Colors.green
            : Colors.blueGrey;

    final statusText = deviceNotifier.device!.triggered
        ? 'DISPARADO'
        : deviceNotifier.device!.active
            ? 'ATIVO'
            : 'DESATIVADO';

    final textStyle = deviceNotifier.device!.triggered
        ? Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.red)
        : deviceNotifier.device!.active
            ? Theme.of(context)
                .textTheme
                .headlineMedium!
                .apply(color: Colors.green)
            : Theme.of(context).textTheme.headlineMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            iconData,
            color: iconColor,
            size: 100,
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'O dispositivo está',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Text(
                statusText,
                style: textStyle,
              ),
            ],
          )
        ],
      ),
    );
  }
}
