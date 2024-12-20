import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../view_model/todo/tl_workspaces_state.dart';
import '../../../../model/design/tl_theme.dart';
import '../../../../model/todo/tl_workspace.dart';
import '../../../../model/todo/tl_todo.dart';
import '../../../../model/todo/tl_todos.dart';
import 'model_of_todo_card.dart';

class AlreadyExist extends ConsumerWidget {
  final String bigCategoryID;
  final String? smallCategoryID;
  final bool ifInToday;
  final Function tapToEditAction;
  const AlreadyExist({
    super.key,
    required this.bigCategoryID,
    required this.smallCategoryID,
    required this.ifInToday,
    required this.tapToEditAction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TLThemeData tlThemeData = TLTheme.of(context);
    // provider
    final tlWorkspacesState = ref.watch(tlWorkspacesStateProvider);
    final TLWorkspace currentWorkspace = tlWorkspacesState.currentWorkspace;
    // others
    final String categoryOfThisToDo = smallCategoryID ?? bigCategoryID;
    final List<TLToDo> toDoArrayOfThisBlock = currentWorkspace
            .categoryIDToToDos[categoryOfThisToDo]
            ?.getToDos(ifInToday) ??
        [];
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
                        "Already Exist",
                        style: TextStyle(
                          color: tlThemeData.accentColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Column(
                children: [
                  for (int indexOfThisToDoInToDos = 0;
                      indexOfThisToDoInToDos < toDoArrayOfThisBlock.length;
                      indexOfThisToDoInToDos++)
                    ModelOfToDoCard(
                      key: ValueKey(
                          toDoArrayOfThisBlock[indexOfThisToDoInToDos].id),
                      // todoのメンバー
                      corrTLToDo: toDoArrayOfThisBlock[indexOfThisToDoInToDos],
                      ifInToday: ifInToday,
                      bigCategoryID: bigCategoryID,
                      smallCategoryID: smallCategoryID,
                      indexOfThisToDoInToDoArrray: indexOfThisToDoInToDos,
                      // 編集系のメンバー
                      indexOfEditingToDo: indexOfThisToDoInToDos,
                      tapToEditAction: tapToEditAction,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
