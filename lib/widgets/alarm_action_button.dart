import 'package:DGR_alarmes/controllers/device_controller.dart';
import 'package:DGR_alarmes/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:DGR_alarmes/providers/device_provider.dart';

class AlarmActionButton extends ConsumerStatefulWidget {
  const AlarmActionButton({super.key});

  @override
  ConsumerState<AlarmActionButton> createState() => _AlarmActionButtonState();
}

class _AlarmActionButtonState extends ConsumerState<AlarmActionButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final deviceNotifier = ref.watch(deviceProvider);
    final buttonText = deviceNotifier.device!.triggered
        ? 'Interromper'
        : deviceNotifier.device!.active
            ? 'Desativar'
            : 'Ativar';

    final onPressed = deviceNotifier.device!.triggered
        ? () => ref
            .read(deviceProvider.notifier)
            .disableBuzzer() //Se disparado, ao pressionar desabilita o buzzer, se não muda estado
        : () async {
            setState(() {
              _isLoading = true;
            });
            ref.read(deviceProvider.notifier).setListening(false);
            bool response = await DeviceController.instance
                .changeDeviceState(deviceNotifier.device!);
            ref.read(deviceProvider.notifier).setListening(false);
            setState(() {
              _isLoading = false;
            });

            if (!response && mounted) {
              showCustomSnackbar(
                  context: context,
                  text:
                      "Não foi possível conectar-se ao alarme. Verifique se ele está ligado");
            }
          };

    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(80, 40))),
      child: _isLoading
          ? const CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
          : Text(buttonText),
    );
  }
}
