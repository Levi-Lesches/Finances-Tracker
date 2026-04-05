import "package:finances/data.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";

Widget moneyInput(
  TextEditingController controller, {
  VoidCallback? onDone,
  bool autofocus = false,
}) => SizedBox(
  width: 100,
  child: TextField(
    controller: controller,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    autofocus: autofocus,
    decoration: const InputDecoration(prefixIcon: Icon(Icons.attach_money)),
    onSubmitted: (_) => onDone?.call(),
  ),
);

Future<Money?> showMoneyDialog(BuildContext context) async {
  final controller = TextEditingController();
  return showDialog<Money?>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Enter amount"),
      content: moneyInput(
        controller,
        autofocus: true,
        onDone: () => context.pop(Money.tryParse(controller.text)),
      ),
      actions: [
        TextButton(child: const Text("Cancel"), onPressed: () => context.pop()),
        FilledButton(
          child: const Text("OK"),
          onPressed: () => context.pop(Money.tryParse(controller.text)),
        ),
      ],
    ),
  );
}
