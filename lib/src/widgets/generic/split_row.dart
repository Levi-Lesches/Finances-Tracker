import "package:finances/widgets.dart";
import "package:flutter/material.dart";

class SplitRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  final String title;
  final String? subtitle;
  const SplitRow({required this.left, required this.right, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(title, style: context.textTheme.headlineMedium),
      if (subtitle != null)
        Text(subtitle!, style: context.textTheme.bodyLarge?.copyWith(fontStyle: .italic)),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: .center,
        children: [
          const SizedBox(width: 8),
          Expanded(child: left),
          const SizedBox(height: 72, child: VerticalDivider()),
          Expanded(child: right),
          const SizedBox(width: 8),
        ],
      ),
    ],
  );
}
