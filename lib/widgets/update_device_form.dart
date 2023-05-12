import 'package:DGR_alarmes/controllers/user_device_controller.dart';
import 'package:DGR_alarmes/models/user_device.dart';
import 'package:DGR_alarmes/providers/device_provider.dart';
import 'package:DGR_alarmes/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateDeviceForm extends ConsumerStatefulWidget {
  final UserDevice userDevice;
  const UpdateDeviceForm({super.key, required this.userDevice});

  @override
  ConsumerState<UpdateDeviceForm> createState() => _UpdateDeviceFormState();
}

class _UpdateDeviceFormState extends ConsumerState<UpdateDeviceForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    _nicknameController =
        TextEditingController(text: widget.userDevice.nickname);
  }

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
              const Text('Editar alarme',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.indigo)),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(hintText: "Nome do alarme"),
                maxLength: 20,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entre com um nome válido!';
                  }
                  return null;
                },
              ),
              FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await UserDeviceController.instance.updateUserDevice(
                          widget.userDevice.id,
                          _nicknameController.text.trim());
                      if (mounted) {
                        Navigator.pop(context);
                        showCustomSnackbar(
                            context: context,
                            text: 'Dispositivo editado com sucesso!');
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
