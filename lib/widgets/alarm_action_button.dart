import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:DGR_alarmes/providers/device_provider.dart';

class AlarmActionButton extends ConsumerWidget {
  const AlarmActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceNotifier = ref.watch(deviceProvider);
    final buttonText = deviceNotifier.device!.triggered
        ? 'Interromper'
        : deviceNotifier.device!.active
            ? 'Desativar'
            : 'Ativar';

    final onPressed = deviceNotifier.device!.triggered
        ? () => ref.watch(deviceProvider.notifier).disableBuzzer()
        : () => ref.watch(deviceProvider.notifier).changeDeviceState();

    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.indigo),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
