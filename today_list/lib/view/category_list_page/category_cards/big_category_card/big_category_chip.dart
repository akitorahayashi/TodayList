import 'package:flutter/material.dart';
import '../../../../model/design/tl_theme.dart';
import '../../../../model/todo/tl_category.dart';
import '../../../../model/workspace/tl_workspace.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BigCategoryChip extends StatelessWidget {
  final int indexOfBigCategory;
  const BigCategoryChip({super.key, required this.indexOfBigCategory});

  TLCategory get bigCategoryInThisChip =>
      TLWorkspace.currentWorkspace.bigCategories[indexOfBigCategory];

  @override
  Widget build(BuildContext context) {
    final TLThemeData _tlThemeData = TLTheme.of(context);
    final int numberOfToDosInThisCategory =
        bigCategoryInThisChip.getNumberOfToDosInThisCategory();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 80,
        child: InputChip(
          backgroundColor: _tlThemeData.bigCategoryChipColor,
          avatar: const Icon(FontAwesomeIcons.rectangleList),
          label: SizedBox(
            height: 35,
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      bigCategoryInThisChip.title,
                    ),
                  ),
                ),
                if (numberOfToDosInThisCategory != 0)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text("$numberOfToDosInThisCategory"),
                  )
              ],
            ),
          ),
          labelStyle: const TextStyle(
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white),
          pressElevation: 3,
          elevation: 3,
          // TODO カテゴリーを編集するDialogを表示
          onPressed: () => {},
        ),
      ),
    );
  }
}
