import 'package:flutter/material.dart';
import 'package:lms/core/utils/appstyles.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.labelText,
    this.isPassword = false,
    this.controller,
    this.errorText,
    this.onChanged,
    this.hintText,
    this.sizeTextFiled,
  });

  final String? labelText;
  final bool isPassword;
  final TextEditingController? controller;
  final String? errorText;
  final Function(String)? onChanged;
  final String? hintText;
  final double? sizeTextFiled;

  @override
  State<StatefulWidget> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(() {
      if (widget.onChanged != null) {
        widget.onChanged!(widget.controller!.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && !isPasswordVisible,
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding: EdgeInsets.all(widget.sizeTextFiled ?? 20),
            labelText: widget.labelText,
            labelStyle: AppStyles.styleMedium20(context),
            suffixIcon: widget.isPassword
                ? Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.errorText!,
                style: AppStyles.styleRegular14(context),
              ),
            ),
          ),
      ],
    );
  }
}
