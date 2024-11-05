import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_list/model/design/tl_theme.dart';
import 'package:today_list/model/provider/editting_todo_provider.dart';

class SelectTodayOrWheneverButton extends ConsumerStatefulWidget {
  const SelectTodayOrWheneverButton({super.key});

  @override
  ConsumerState<SelectTodayOrWheneverButton> createState() =>
      _SelectTodayOrWheneverButtonState();
}

class _SelectTodayOrWheneverButtonState
    extends ConsumerState<SelectTodayOrWheneverButton> {
  @override
  Widget build(BuildContext context) {
    final TLThemeData tlThemeData = TLTheme.of(context);
    // notifier
    final EditingToDoNotifier edittingToDoNotifier =
        ref.read(edittingToDoProvider.notifier);
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: ToggleButtons(
        // 大きさ
        constraints: BoxConstraints(
          minHeight: 35,
          minWidth: (MediaQuery.of(context).size.width - 50) / 2,
        ),
        // 背景色
        fillColor: tlThemeData.toggleButtonsBackgroundColor,
        // 文字色
        selectedColor: tlThemeData.accentColor,
        color: tlThemeData.accentColor,
        // splashColor
        splashColor: tlThemeData.toggleButtonsBackgroundSplashColor,
        // isSelected
        isSelected: [
          edittingToDoNotifier.ifInToday,
          !edittingToDoNotifier.ifInToday,
        ],
        onPressed: (int index) {
          setState(() {
            edittingToDoNotifier.ifInToday = index == 0;
          });
        },
        children: const [
          Text("今日"),
          Text(" いつでも "),
        ],
      ),
    );
  }
}