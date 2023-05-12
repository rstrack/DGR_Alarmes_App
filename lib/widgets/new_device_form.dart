import 'package:DGR_alarmes/controllers/user_device_controller.dart';
import 'package:DGR_alarmes/providers/device_provider.dart';
import 'package:DGR_alarmes/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewDeviceForm extends ConsumerStatefulWidget {
  final String macAddress;
  const NewDeviceForm({super.key, required this.macAddress});

  @override
  ConsumerState<NewDeviceForm> createState() => _NewDeviceFormState();
}

class _NewDeviceFormState extends ConsumerState<NewDeviceForm> {
  final _formKey = GlobalKey<FormState>();
  String nickname = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 16,
            children: [
              const Text('Vincular novo alarme',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.indigo)),
              TextFormField(
                decoration: const InputDecoration(hintText: "Nome do alarme"),
                maxLength: 20,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entre com um nome válido!';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    nickname = newValue;
                  }
                },
              ),
              FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await UserDeviceController.instance
                          .createUserDevice(widget.macAddress, nickname);
                      if (mounted) {
                        Navigator.pop(context);
                        showCustomSnackbar(
                            context: context,
                            text: 'Dispositivo adicionado com sucesso!');
                        ref.invalidate(deviceProvider);
                      }
                    }
                  },
                  child: const Text('Enviar'))
            ],
          ),
        ),
      ),
    );
  }
}
