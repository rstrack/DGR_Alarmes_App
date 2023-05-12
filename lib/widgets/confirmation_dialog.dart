import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmationDialog extends ConsumerStatefulWidget {
  final String? text;
  final VoidCallback onConfirming;
  const ConfirmationDialog({super.key, this.text, required this.onConfirming});

  @override
  ConsumerState<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends ConsumerState<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Atenção"),
      content: Text(widget.text ?? "Você tem certeza?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: widget.onConfirming,
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
