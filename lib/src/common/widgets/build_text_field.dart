import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homestay_app/src/themes/extensions.dart';

class BuildTextFormField extends StatelessWidget {
  const BuildTextFormField({
    super.key,
    required this.controller,
    this.validator,
    this.labelText = 'Label',
    this.hintText = '',
    this.textInputType,
    this.textInputAction,
    this.isEnabled = true,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String labelText;
  final String hintText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final bool isEnabled;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        enabled: isEnabled,
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}

class BuildPasswordTextFormField extends StatefulWidget {
  const BuildPasswordTextFormField({
    super.key,
    required this.controller,
    this.validator,
    this.labelText = 'Label',
    this.hintText = 'Enter password',
    this.textInputType,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String labelText;
  final String hintText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;

  @override
  State<BuildPasswordTextFormField> createState() =>
      _BuildPasswordTextFormFieldState();
}

class _BuildPasswordTextFormFieldState
    extends State<BuildPasswordTextFormField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.textInputType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isObscure = !isObscure;
            });
          },
          icon: Icon(
            isObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: isObscure ? Colors.grey.shade400 : context.theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class BuildTextField extends StatelessWidget {
  const BuildTextField({
    super.key,
    required this.controller,
    this.validator,
    this.labelText = '',
    this.hintText = '',
    this.textInputType,
    this.textInputAction,
    this.suffixIconButton,
    this.maxLine,
    this.autoFocus = false,
    this.isEnabled = true,
    this.alignLabelToTop,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String labelText;
  final String hintText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final IconButton? suffixIconButton;
  final int? maxLine;
  final bool? alignLabelToTop;
  final bool autoFocus;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    /// return text form field because we need validator
    return TextFormField(
      enabled: isEnabled,
      autofocus: autoFocus,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      validator: validator,
      maxLines: maxLine,
      obscureText: false,
      decoration: InputDecoration(
        alignLabelWithHint: alignLabelToTop,
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIconButton,
      ),
    );
  }
}
