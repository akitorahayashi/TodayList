import 'package:flutter/material.dart';
import '../../model/tl_category.dart';
import '../../model/todo/tl_todo.dart';
import '../../model/todo/tl_step.dart';
import '../../model/workspace/tl_workspace.dart';
import '../../model/externals/tl_vibration.dart';
import 'notify_todo_or_step_is_edited.dart';

void addOrEditToDoAction({
  required BuildContext context,
  required int? indexOfEditedToDo,
  required String? oldCategoryId,
  required bool ifInToday,
  required TLCategory bigCategoryOfToDo,
  required TLCategory? smallCategoryOfToDo,
  required TextEditingController toDoInputController,
  required List<TLStep> addedSteps,
}) {
  final createdToDo = TLToDo(
    id: UniqueKey().toString(),
    title: toDoInputController.text,
    steps: addedSteps,
  );
  final TLCategory categoryOfThisToDo =
      smallCategoryOfToDo ?? bigCategoryOfToDo;
  final List<TLToDo> toDoArray = TLWorkspace
      .currentWorkspace.toDos[categoryOfThisToDo.id]!
      .getToDoArray(inToday: ifInToday);
  // add action
  // 元の場所に戻す
  if (indexOfEditedToDo != null) {
    // edit action - 過去のものを消す
    TLWorkspace.currentWorkspace.toDos[oldCategoryId]!
        .getToDoArray(inToday: ifInToday)
        .removeAt(indexOfEditedToDo);
    toDoArray.insert(indexOfEditedToDo, createdToDo);
  } else {
    // 新しく追加する
    // isCheckedがtrueのToDoがあるか
    int indexOfCheckedToDo =
        toDoArray.indexWhere((element) => element.isChecked);
    if (indexOfCheckedToDo != -1) {
      toDoArray.insert(indexOfCheckedToDo, createdToDo);
    } else {
      toDoArray.add(createdToDo);
    }
  }
  toDoInputController.clear();
  TLVibration.vibrate();
  notifyToDoOrStepIsEditted(
    context: context,
    newName: createdToDo.title,
    newCheckedState: createdToDo.isChecked,
    quickChangeToToday: null,
  );
  TLWorkspace.saveSelectedWorkspace(
      selectedWorkspaceIndex: TLWorkspace.currentWorkspaceIndex);
}
