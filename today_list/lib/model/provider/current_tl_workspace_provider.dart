import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../external/tl_pref.dart';
import '../todo/tl_todo.dart';
import '../tl_workspace.dart';
import 'tl_workspaces_provider.dart';
import '../todo/tl_category.dart';
import '../todo/tl_todos.dart';

// currentWorkspaceを提供するProvider
final currentWorkspaceProvider =
    StateNotifierProvider.autoDispose<CurrentTLWorkspaceNotifier, TLWorkspace>(
        (ref) {
  final tlWorkspaces = ref.watch(tlWorkspacesProvider);
  return CurrentTLWorkspaceNotifier(ref, tlWorkspaces);
});

// currentWorkspaceを管理するNotifier
class CurrentTLWorkspaceNotifier extends StateNotifier<TLWorkspace> {
  final Ref ref;
  int currentTLWorkspaceIndex;

  CurrentTLWorkspaceNotifier(this.ref, List<TLWorkspace> tlWorkspaces)
      : currentTLWorkspaceIndex = 0,
        super(tlWorkspaces[0]) {
    // 初期化処理
    _loadCurrentWorkspace(tlWorkspaces);
  }

  Future<void> _loadCurrentWorkspace(List<TLWorkspace> tlWorkspaces) async {
    final pref = await TLPref().getPref;
    currentTLWorkspaceIndex = pref.getInt('currentWorkspaceIndex') ?? 0;
    state = tlWorkspaces[currentTLWorkspaceIndex];
  }

  // 現在のワークスペースインデックスを変更する関数
  Future<void> changeCurrentWorkspaceIndex(
      {required int newCurrentWorkspaceIndex}) async {
    currentTLWorkspaceIndex = newCurrentWorkspaceIndex;
    state = ref.read(tlWorkspacesProvider)[currentTLWorkspaceIndex];
    await TLPref().getPref.then((pref) {
      pref.setInt('currentWorkspaceIndex', newCurrentWorkspaceIndex);
    });
  }

  void reorderWhenToggle({
    required String categoryId,
    required bool ifInToday,
    required int indexOfThisToDoInToDos,
  }) async {
    final toDoArrayOfThisToDo =
        state.copyWith(toDos: state.toDos).toDos[categoryId]![ifInToday];
    final TLToDo toDoCheckStateHasChanged =
        toDoArrayOfThisToDo.removeAt(indexOfThisToDoInToDos);
    final int indexOfCheckedToDo =
        toDoArrayOfThisToDo.indexWhere((todo) => todo.isChecked);
    if (indexOfCheckedToDo == -1) {
      toDoArrayOfThisToDo.add(toDoCheckStateHasChanged);
    } else {
      toDoArrayOfThisToDo.insert(indexOfCheckedToDo, toDoCheckStateHasChanged);
    }
    state = state.copyWith(toDos: state.toDos);
  }

  // 現在のworkspaceの今日でチェック済みtodoを全て削除するための関数
  Future<void> deleteCheckedToDosInTodayInCurrentWorkspace() async {
    final tlWorkspacesNotifier = ref.read(tlWorkspacesProvider.notifier);
    final updatedCurrentTLWorkspace = state;

    for (TLCategory bigCategory in updatedCurrentTLWorkspace.bigCategories) {
      // bigCategoryに関するチェック済みToDoの削除
      deleteAllCheckedToDosInAToDos(
        onlyToday: true,
        selectedWorkspaceIndex: currentTLWorkspaceIndex,
        selectedWorkspace: updatedCurrentTLWorkspace,
        selectedToDos: updatedCurrentTLWorkspace.toDos[bigCategory.id]!,
      );
      for (TLCategory smallCategory
          in updatedCurrentTLWorkspace.smallCategories[bigCategory.id]!) {
        // smallCategoryに関するチェック済みToDoの削除
        deleteAllCheckedToDosInAToDos(
            onlyToday: true,
            selectedWorkspaceIndex: currentTLWorkspaceIndex,
            selectedWorkspace: updatedCurrentTLWorkspace,
            selectedToDos: updatedCurrentTLWorkspace.toDos[smallCategory.id]!);
      }
    }

    // 更新されたワークスペースを保存
    tlWorkspacesNotifier.updateSpecificTLWorkspace(
        specificWorkspaceIndex: currentTLWorkspaceIndex,
        updatedWorkspace: updatedCurrentTLWorkspace);
  }

  // 指定されたToDos内のチェック済みToDoを全て削除する関数
  void deleteAllCheckedToDosInAToDos({
    required bool onlyToday,
    int? selectedWorkspaceIndex,
    TLWorkspace? selectedWorkspace,
    required TLToDos selectedToDos,
  }) {
    // チェックされているToDoを削除
    selectedToDos.toDosInToday.removeWhere((todo) => todo.isChecked);
    if (!onlyToday) {
      selectedToDos.toDosInWhenever.removeWhere((todo) => todo.isChecked);
    }
    // 残っているToDo内のチェックされているステップを削除
    for (TLToDo todo in selectedToDos.toDosInToday) {
      todo.steps.removeWhere((step) => step.isChecked);
    }
    for (TLToDo todo in selectedToDos.toDosInWhenever) {
      todo.steps.removeWhere((step) => step.isChecked);
    }
  }
}
