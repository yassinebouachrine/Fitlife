import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? prefix;
  final Widget? suffix;
  final bool obscure;
  final TextEditingController? controller;
  final TextInputType? keyboard;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.prefix,
    this.suffix,
    this.obscure = false,
    this.controller,
    this.keyboard,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: cs.onSurface.withOpacity(0.55),
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboard,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: cs.onSurface,
            letterSpacing: 0.1,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefix != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 14, right: 10),
                    child: Icon(prefix, size: 18),
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}