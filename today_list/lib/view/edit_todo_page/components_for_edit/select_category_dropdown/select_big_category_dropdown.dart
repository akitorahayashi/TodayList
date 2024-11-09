import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_list/components/dialog/for_category/add_category_dialog.dart';
import 'package:today_list/model/provider/current_tl_workspace_provider.dart';
import 'package:today_list/model/editing_provider/editing_todo_provider.dart';
import 'package:today_list/model/provider/tl_workspaces_provider.dart';
import 'package:today_list/model/todo/tl_category.dart';
import '../../../../../model/design/tl_theme.dart';

class SelectBigCategoryDropDown extends ConsumerWidget {
  const SelectBigCategoryDropDown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TLThemeData tlThemeData = TLTheme.of(context);
    // provider
    final EditingTodo edittingTodo = ref.watch(edittingToDoProvider);
    final currentWorkspace = ref.watch(currentWorkspaceProvider);
    // notifier
    final EditingToDoNotifier edittingToDoNotifier =
        ref.watch(edittingToDoProvider.notifier);
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: DropdownButton(
          iconEnabledColor: tlThemeData.accentColor,
          isExpanded: true,
          // hint text
          hint: Text(
            edittingTodo.bigCatgoeyID == noneID
                ? "大カテゴリー"
                : currentWorkspace.bigCategories
                    .where((oneOfBigCategory) =>
                        oneOfBigCategory.id == edittingTodo.bigCatgoeyID)
                    .first
                    .title,
            style: const TextStyle(
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: const TextStyle(
            color: Colors.black45,
            fontWeight: FontWeight.bold,
          ),
          // list of big categories
          items: [
            ...currentWorkspace.bigCategories,
            TLCategory(id: "---createBigCategory", title: "新しく作る"),
          ].map((TLCategory oneOfBigCategory) {
            return DropdownMenuItem(
              value: oneOfBigCategory,
              child: Text(
                oneOfBigCategory.title,
                style: oneOfBigCategory.id == edittingTodo.bigCatgoeyID
                    ? TextStyle(
                        color: tlThemeData.accentColor,
                        fontWeight: FontWeight.bold)
                    : TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),

          // カテゴリー変更
          onChanged: (TLCategory? selectedBigCategory) async {
            if (selectedBigCategory == null) return;
            edittingToDoNotifier.updateEdittingTodo(smallCategoryID: null);
            if (selectedBigCategory.id == "---createBigCategory") {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return const AddCategoryDialog();
                  });
            } else {
              edittingToDoNotifier.updateEdittingTodo(
                  bigCatgoeyID: selectedBigCategory.id);
            }
          }),
    );
  }
}
