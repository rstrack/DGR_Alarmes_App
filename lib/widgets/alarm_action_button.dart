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
    var deviceNotifier = ref.watch(deviceProvider);
    final buttonText = deviceNotifier.device!.triggered
        ? 'Interromper'
        : deviceNotifier.device!.active
            ? 'Desativar'
            : 'Ativar';

    changeDeviceState() async {
      setState(() {
        _isLoading = true;
      });
      double unixTime = DateTime.now().millisecondsSinceEpoch / 1000;
      await DeviceController.instance.changeDeviceState(deviceNotifier.device!);
      setState(() {
        _isLoading = false;
      });
      bool logAdded =
          await DeviceController.instance.checkDeviceChange(unixTime);
      if (!logAdded && mounted) {
        showCustomSnackbar(
            context: context,
            text:
                "Não foi encontrado o registro da última atualização do alarme. Verifique se o dispositivo está ligado ou se a conexão com a internet está funcionando.");
      }
    }

    return FilledButton(
      onPressed: changeDeviceState,
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(80, 40))),
      child: _isLoading
          ? const CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
          : Text(buttonText),
    );
  }
}
