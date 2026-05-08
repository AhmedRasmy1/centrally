import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;

  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  final List<String>? autofillHints;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.nextFocusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      focusNode: focusNode,
      validator: validator,
      onChanged: onChanged,
      textAlign: TextAlign.start,
      style: theme.textTheme.bodyMedium,
      autofillHints: autofillHints,

      onFieldSubmitted: (_) {
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        } else {
          FocusScope.of(context).unfocus();
        }
      },

      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,

        filled: true,
        fillColor: ColorManager.grey100,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p12,
        ),

        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(color: ColorManager.primary, width: 1.5),

        errorBorder: _border(color: ColorManager.error),
        focusedErrorBorder: _border(color: ColorManager.error, width: 1.5),
      ),
    );
  }

  OutlineInputBorder _border({Color? color, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.r12),
      borderSide: BorderSide(color: color ?? ColorManager.border, width: width),
    );
  }
}
