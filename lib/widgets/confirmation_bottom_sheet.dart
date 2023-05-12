import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmationBottomSheet extends ConsumerStatefulWidget {
  final String? text;
  final VoidCallback onConfirming;
  const ConfirmationBottomSheet(
      {super.key, this.text, required this.onConfirming});

  @override
  ConsumerState<ConfirmationBottomSheet> createState() =>
      _ConfirmationBottomSheetState();
}

class _ConfirmationBottomSheetState
    extends ConsumerState<ConfirmationBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 32,
        children: [
          Text(
            widget.text ?? 'Tem certeza?',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: widget.onConfirming,
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red)),
                child: const Text('Confirmar'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
