import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_list/model/workspace/current_tl_workspace_provider.dart';
import 'package:today_list/model/workspace/tl_workspaces_provider.dart';
import '../../../model/tl_theme.dart';
import '../../../model/todo/tl_todo.dart';
import '../../../model/todo/tl_category.dart';
import '../../../model/workspace/tl_workspace.dart';
import './model_of_todo_card.dart';

import 'package:reorderables/reorderables.dart';

class AlreadyExists extends ConsumerWidget {
  final TLCategory bigCategoryOfThisToDo;
  final TLCategory? smallCategoryOfThisToDo;
  final bool ifInToday;
  final Function tapToEditAction;
  const AlreadyExists({
    super.key,
    required this.bigCategoryOfThisToDo,
    required this.smallCategoryOfThisToDo,
    required this.ifInToday,
    required this.tapToEditAction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TLThemeData _tlThemeData = TLTheme.of(context);
    // provider
    final TLWorkspace _currentWorkspace = ref.watch(currentTLWorkspaceProvider);
    // notifier
    final CurrentTLWorkspaceNotifier _currentWorkspaceNotifier =
        ref.read(currentTLWorkspaceProvider.notifier);
    final TLWorkspacesNotifier _tlWorkspacesNotifier =
        ref.read(tlWorkspacesProvider.notifier);
    // others
    final TLCategory categoryOfThisToDo =
        smallCategoryOfThisToDo ?? bigCategoryOfThisToDo;
    final List<TLToDo> toDoArrayOfThisBlock =
        _currentWorkspace.toDos[categoryOfThisToDo.id]![ifInToday];
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // 文字
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Already Exists",
                        style: TextStyle(
                          color: _tlThemeData.accentColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              ReorderableColumn(
                  children: [
                    for (int indexOfThisToDoInToDos = 0;
                        indexOfThisToDoInToDos < toDoArrayOfThisBlock.length;
                        indexOfThisToDoInToDos++)
                      ModelOfToDoCard(
                        key: ValueKey(
                            toDoArrayOfThisBlock[indexOfThisToDoInToDos].id),
                        // todoのメンバー
                        toDoData: toDoArrayOfThisBlock[indexOfThisToDoInToDos],
                        ifInToday: ifInToday,
                        bigCategoryOfThisToDo: bigCategoryOfThisToDo,
                        smallCategoryOfThisToDo: smallCategoryOfThisToDo,
                        indexOfThisToDoInToDoArrray: indexOfThisToDoInToDos,
                        // 編集系のメンバー
                        indexOfEditingToDo: indexOfThisToDoInToDos,
                        tapToEditAction: tapToEditAction,
                      ),
                  ],
                  onReorder: (oldIndex, newIndex) {
                    List<TLToDo> corrToDoArray = _currentWorkspace
                        .toDos[categoryOfThisToDo.id]![ifInToday];
                    final int indexOfCheckedToDo =
                        corrToDoArray.indexWhere((todo) => todo.isChecked);
                    // チェック済みToDoよりも下に移動させない
                    if (indexOfCheckedToDo == -1 ||
                        newIndex < indexOfCheckedToDo) {
                      final TLToDo reorderedToDo =
                          corrToDoArray.removeAt(oldIndex);
                      corrToDoArray.insert(newIndex, reorderedToDo);
                      // toDosを保存する
                      _tlWorkspacesNotifier.updateSpecificTLWorkspace(
                          specificWorkspaceIndex:
                              _currentWorkspaceNotifier.currentTLWorkspaceIndex,
                          updatedWorkspace: _currentWorkspace);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
