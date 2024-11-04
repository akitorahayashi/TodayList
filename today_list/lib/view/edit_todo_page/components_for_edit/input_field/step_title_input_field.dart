import 'package:flutter/material.dart';
import '../../../../styles/styles.dart';
import '../../../../model/design/tl_theme.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StepTitleInputField extends StatefulWidget {
  const StepTitleInputField({super.key});

  @override
  State<StepTitleInputField> createState() => _StepTitleInputFieldState();
}

class _StepTitleInputFieldState extends State<StepTitleInputField> {
  bool get isEntered => widget.controller.text.trim().isNotEmpty;
  @override
  Widget build(BuildContext context) {
    final TLThemeData tlThemeData = TLTheme.of(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width - 50,
      child: Padding(
        padding: widget.isForStep
            ? const EdgeInsets.only(left: 16)
            : EdgeInsets.zero,
        child: TextField(
          autofocus: true,
          controller: widget.controller,
          onChanged: widget.onChanged,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.6)),
          cursorColor: tlThemeData.accentColor,
          decoration: tlInputDecoration(
              context: context,
              labelText: widget.isForStep ? "Step" : "ToDo",
              icon: Icon(
                FontAwesomeIcons.square,
                color: Colors.black.withOpacity(0.35),
              ),
              suffixIcon: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isEntered ? 1 : 0.25,
                child: TextButton(
                  onPressed: widget.onPressed,
                  child: Icon(
                    Icons.add,
                    color: isEntered ? tlThemeData.accentColor : Colors.black,
                    size: 25,
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
