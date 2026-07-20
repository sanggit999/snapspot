import 'package:flutter/material.dart';

/// Purpose: Reusable Input Field component across SnapSpot.
///
/// Parameters:
/// - [controller]: TextEditingController to manage text state.
/// - [hintText]: Placeholder text.
/// - [labelText]: Optional field label.
/// - [errorText]: Direct error text override.
/// - [obscureText]: Whether text is hidden for passwords.
/// - [prefixIcon]: Icon widget at the start.
/// - [suffixIcon]: Icon widget at the end.
/// - [keyboardType]: Input keyboard type (email, number, text...).
/// - [textInputAction]: Keyboard action button (next, done...).
/// - [validator]: Form validation logic callback.
/// - [maxLines]: Number of lines allowed. Defaults to 1.
/// - [readOnly]: Whether input is disabled for typing.
///
/// Usage:
/// ```dart
/// AppTextField(
///   controller: _emailController,
///   hintText: 'Enter your email',
///   keyboardType: TextInputType.emailAddress,
/// )
/// ```
class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final String? errorText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.errorText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      validator: widget.validator,
      maxLines: widget.maxLines,
      readOnly: widget.readOnly,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.suffixIcon,
      ),
    );
  }
}
