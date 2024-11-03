import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../components/dialog/common/single_option_dialog.dart';
import '../../../model/provider/current_tl_workspace_provider.dart';
import '../../../model/external/tl_vibration.dart';
import '../../../model/tl_workspace.dart';
import '../../../model/provider/tl_workspaces_provider.dart';
import '../../../model/design/tl_theme.dart';
import '../../../components/slidables/slidable_for_workspace_card.dart';

class ChangeWorkspaceCard extends ConsumerWidget {
  final bool isInDrawerList;
  final int indexInWorkspaces;
  const ChangeWorkspaceCard({
    Key? key,
    required this.isInDrawerList,
    required this.indexInWorkspaces,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TLThemeData _tlThemeData = TLTheme.of(context);
    // provider
    final List<TLWorkspace> _tlWorkspaces = ref.watch(tlWorkspacesProvider);
    final TLWorkspace _currentTLWorkspace =
        ref.watch(currentTLWorkspaceProvider);
    // notifier
    final CurrentTLWorkspaceNotifier _currentTLWorkspaceNotifier =
        ref.read(currentTLWorkspaceProvider.notifier);
    // other
    final int _currentTLWorkspaceIndex =
        _currentTLWorkspaceNotifier.currentTLWorkspaceIndex;
    final bool _isCurrentWorkspace =
        indexInWorkspaces == _currentTLWorkspaceIndex;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          5, 1, 5, (_isCurrentWorkspace && !isInDrawerList) ? 5 : 0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 70),
        child: Card(
          color: _tlThemeData.panelColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GestureDetector(
                onTap: () async {
                  if (_isCurrentWorkspace) {
                    Navigator.pop(context);
                  } else {
                    _currentTLWorkspaceNotifier.changeCurrentWorkspaceIndex(
                        newCurrentWorkspaceIndex: indexInWorkspaces);
                    TLVibration.vibrate();
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) => SingleOptionDialog(
                            title: _currentTLWorkspace.name,
                            message: "workspaceを変更しました！"));
                  }
                },
                child: SlidableForWorkspaceCard(
                  isCurrentWorkspace: _isCurrentWorkspace,
                  indexInTLWorkspaces: indexInWorkspaces,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Text(
                          _isCurrentWorkspace && isInDrawerList
                              ? ("☆ " + _currentTLWorkspace.name + "   ")
                              : _tlWorkspaces[indexInWorkspaces].name,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _tlThemeData.accentColor,
                              letterSpacing: 1)),
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
