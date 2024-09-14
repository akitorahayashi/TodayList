import 'package:flutter/material.dart';
import '../../alerts/common/simple_alert.dart';
import '../../constants/theme.dart';
import '../../model/tl_category.dart';
import '../../model/workspace/workspace.dart';
import '../../model/workspace/id_to_jsonworkspaceList.dart';
import '../../model/user/setting_data.dart';
import '../../model/externals/tl_vibration.dart';
import '../../styles.dart';

Widget renameCategoryDialog({
  required BuildContext context,
  required int? indexOfWorkspaceCategory,
  required int indexOfBigCategory,
  required int? indexOfSmallCategory,
}) {
  final TLCategory oldCategory = indexOfWorkspaceCategory == null
      ? indexOfSmallCategory == null
          ? currentWorkspace.bigCategories[indexOfBigCategory]
          : currentWorkspace.smallCategories[currentWorkspace
              .bigCategories[indexOfBigCategory].id]![indexOfSmallCategory]
      : workspaceCategories[indexOfWorkspaceCategory];
  // textFieldに改名する準備をする
  String? newCategoryName = oldCategory.title;
  TextEditingController controllerForRename =
      TextEditingController(text: oldCategory.title);
  return AlertDialog(
    backgroundColor: theme[settingData.selectedTheme]!.alertColor,
    title: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: Text("元のカテゴリー名",
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.black.withOpacity(0.5),
                  fontWeight: FontWeight.w600)),
        ),
        Text(
          oldCategory.title,
          style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontWeight: FontWeight.w600),
        )
      ],
    ),
    content: SizedBox(
      height: 160,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 新しいカテゴリー名を入力するTextFormField
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: SizedBox(
                width: 230,
                child: TextFormField(
                  autofocus: true,
                  controller: controllerForRename,
                  cursorColor: theme[settingData.selectedTheme]!.accentColor,
                  onChanged: (String? enteredCategoryName) {
                    if (enteredCategoryName != null &&
                        enteredCategoryName.trim() != "") {
                      newCategoryName = enteredCategoryName;
                    } else {
                      newCategoryName = null;
                    }
                  },
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.w600),
                  decoration: tlInputDecoration(
                      labelText: "新しいカテゴリー名", icon: null, suffixIcon: null),
                ),
              ),
            ),
            // 戻す、完了ボタン
            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 戻すボタン
                TextButton(
                  onPressed: () {
                    newCategoryName = null;
                    Navigator.pop(context);
                  },
                  child: Text(
                    "戻す",
                    style: TextStyle(
                        color: theme[settingData.selectedTheme]!.accentColor),
                  ),
                ),
                // 完了ボタン
                TextButton(
                  // なかったらdisable
                  onPressed: () {
                    if (newCategoryName == null) {
                      Navigator.pop(context);
                    } else {
                      if (indexOfWorkspaceCategory == null) {
                        // todo category
                        if (indexOfSmallCategory != null) {
                          // smallの場合、タイトルを変える
                          currentWorkspace
                              .smallCategories[currentWorkspace
                                  .bigCategories[indexOfBigCategory]
                                  .id]![indexOfSmallCategory]
                              .title = newCategoryName!;
                          TLCategory.saveSmallCategories();
                        } else {
                          // bigCategoryを更新
                          currentWorkspace.bigCategories[indexOfBigCategory]
                              .title = newCategoryName!;
                          TLCategory.saveBigCategories();
                        }
                        // alert → all page → category list
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        // workspace category
                        workspaceCategories[indexOfWorkspaceCategory].title =
                            newCategoryName!;
                        TLCategory.saveWorkspaceCategories();
                        Navigator.pop(context);
                      }
                      TLVibration.vibrate();
                      simpleAlert(
                          context: context,
                          title: "変更することに\n成功しました!",
                          message: null,
                          buttonText: "OK");
                    }
                  },
                  child: Text(
                    "完了",
                    style: TextStyle(
                        color: theme[settingData.selectedTheme]!.accentColor),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}
