import 'package:flutter/material.dart';
import '../../alerts/common/simple_alert.dart';
import '../../constants/theme.dart';
import '../../model/tl_category.dart';
import '../../model/workspace/id_to_jsonworkspaceList.dart';
import '../../model/workspace/workspace.dart';
import '../../model/user/setting_data.dart';
import '../../model/externals/tl_vibration.dart';
import '../../styles.dart';

Future<void> confirmToDeleteThisCategory({
  required BuildContext context,
  // bigCategoryはworkspace categoryでは適当に
  required int? indexOfWorkspaceCategory,
  required int indexOfBigCategory,
  required int? indexOfSmallCategory,
}) async {
  // 本当に削除するか確認するアラート
  final TLCategory categoryThisBelongsTo = indexOfSmallCategory == null
      ? currentWorkspace.bigCategories[indexOfBigCategory]
      : currentWorkspace.smallCategories[currentWorkspace
          .bigCategories[indexOfBigCategory].id]![indexOfSmallCategory];
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: theme[settingData.selectedTheme]!.alertColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                  child: Text(
                    "本当にこのカテゴリーを\n削除しますか？",
                    style: TextStyle(
                        color: theme[settingData.selectedTheme]!.accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    indexOfWorkspaceCategory == null
                        ? "※関連するToDoやCategoryが\n一緒に削除されます"
                        : "※関連するWorkspaceが\n一緒に削除されます",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        style: alertButtonStyle(),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("いいえ")),
                    TextButton(
                        style: alertButtonStyle(),
                        onPressed: () async {
                          if (indexOfWorkspaceCategory == null) {
                            if (indexOfSmallCategory != null) {
                              // このカテゴリーがsmallCategoryの場合
                              // カテゴリーのリストから削除する
                              currentWorkspace.smallCategories[currentWorkspace
                                      .bigCategories[indexOfBigCategory].id]!
                                  .removeWhere(((TLCategory smallCategory) =>
                                      smallCategory.id ==
                                      categoryThisBelongsTo.id));
                              // toDosに入っているものを消す
                              currentWorkspace.toDos
                                  .remove(categoryThisBelongsTo.id);
                            } else {
                              // このカテゴリーがbigCategoryの場合
                              // bigCategoryのsmallCategoryでtoDosに入っているものを消す
                              for (TLCategory smallCategory
                                  in currentWorkspace.smallCategories[
                                      currentWorkspace
                                          .bigCategories[indexOfBigCategory]
                                          .id]!) {
                                currentWorkspace.toDos.remove(smallCategory.id);
                              } // toDosに入っているものを消す
                              currentWorkspace.toDos
                                  .remove(categoryThisBelongsTo.id);
                              // カテゴリーのリストからbigCategoryとsmallCategoryを削除する
                              currentWorkspace.bigCategories
                                  .removeAt(indexOfBigCategory);
                              currentWorkspace.smallCategories
                                  .remove(categoryThisBelongsTo.id);
                            }

                            // categoriesとtoDosを保存する
                            if (indexOfSmallCategory == null) {
                              TLCategory.saveBigCategories();
                            } else {
                              TLCategory.saveSmallCategories();
                            }
                            Workspace.saveSelectedWorkspace(
                              selectedWorkspaceCategoryId:
                                  currentWorkspaceCategoryId,
                              selectedWorkspaceIndex: currentWorkspaceIndex,
                              selectedWorkspace: currentWorkspace,
                            );
                            Navigator.pop(context);
                          } else {
                            // workspace category
                            idToJsonWorkspaceList.remove(
                                workspaceCategories[indexOfWorkspaceCategory]
                                    .id);
                            workspaceCategories
                                .removeAt(indexOfWorkspaceCategory);
                            TLCategory.saveWorkspaceCategories();
                            Workspace.saveStringWorkspaces();
                          }
                          // アラートを消す
                          Navigator.pop(context);
                          TLVibration.vibrate();
                          // 知らせるアラート
                          simpleAlert(
                            context: context,
                            title: "削除することに成功しました!",
                            message: null,
                            buttonText: "OK",
                          );
                        },
                        child: const Text("はい")),
                  ],
                )
              ],
            ),
          ),
        );
      });
}
