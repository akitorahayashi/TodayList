import 'package:flutter/material.dart';
import '../../../styles.dart';
import '../../../constants/theme.dart';
import '../../../model/user/setting_data.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TLTextfield extends StatefulWidget {
  final bool isForStep;
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function() onPressed;
  const TLTextfield({
    super.key,
    required this.isForStep,
    required this.controller,
    required this.onChanged,
    required this.onPressed,
  });

  @override
  State<TLTextfield> createState() => _TLTextfieldState();
}

class _TLTextfieldState extends State<TLTextfield> {
  bool get isEntered => widget.controller.text.trim().isNotEmpty;
  @override
  Widget build(BuildContext context) {
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
          cursorColor: theme[SettingData.shared.selectedTheme]!.accentColor,
          decoration: tlInputDecoration(
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
                    color: isEntered
                        ? theme[SettingData.shared.selectedTheme]!.accentColor
                        : Colors.black,
                    size: 25,
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
