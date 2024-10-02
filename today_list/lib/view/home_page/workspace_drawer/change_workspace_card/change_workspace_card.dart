import 'package:flutter/material.dart';
import 'package:today_list/model/externals/tl_vibration.dart';
import '../../../../model/user/setting_data.dart';
import '../../../../model/workspace/workspace.dart';
import '../../../../model/workspace/id_to_jsonworkspaceList.dart';
import '../../../../constants/theme.dart';
import '../../../../constants/global_keys.dart';
import 'notify_current_workspace_is_changed.dart';
import 'slidable_for_workspace_card.dart';

class ChangeWorkspaceCard extends StatefulWidget {
  final bool isInDrawerList;
  final String workspaceName;
  final int indexOfWorkspaceCategory;
  final int indexInStringWorkspaces;
  const ChangeWorkspaceCard({
    super.key,
    required this.isInDrawerList,
    required this.workspaceName,
    required this.indexOfWorkspaceCategory,
    required this.indexInStringWorkspaces,
  });

  @override
  State<ChangeWorkspaceCard> createState() => _ChangeWorkspaceCardState();
}

class _ChangeWorkspaceCardState extends State<ChangeWorkspaceCard> {
  String get workspaceCategoryIdOfThisCard =>
      workspaceCategories[widget.indexOfWorkspaceCategory].id;

  bool get isCurrentWorkspace =>
      workspaceCategoryIdOfThisCard == currentWorkspaceCategoryId &&
      widget.indexInStringWorkspaces == currentWorkspaceIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          5, 1, 5, (isCurrentWorkspace && !widget.isInDrawerList) ? 5 : 0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 70),
        child: Card(
          color: theme[settingData.selectedTheme]!.panelColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GestureDetector(
                onTap: () async {
                  if (isCurrentWorkspace) {
                    Navigator.pop(context);
                  } else {
                    currentWorkspace.changeCurrentWorkspace(
                        selectedWorkspaceCategoryId:
                            workspaceCategoryIdOfThisCard,
                        newWorkspaceIndex: widget.indexInStringWorkspaces);
                    TLVibration.vibrate();
                    Navigator.pop(context);
                    // ignore: invalid_use_of_protected_member
                    homePageKey.currentState?.setState(() {});
                    manageWorkspacePageKey.currentState?.setState(() {});
                    notifyCurrentWorkspaceIsChanged(
                        context: context,
                        newWorkspaceName: currentWorkspace.name);
                  }
                },
                child: SlidableForWorkspaceCard(
                  isInDrawerList: true,
                  isCurrentWorkspace: isCurrentWorkspace,
                  workspaceCategoryOfThisCard:
                      workspaceCategories[widget.indexOfWorkspaceCategory],
                  indexInStringWorkspaces: widget.indexInStringWorkspaces,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Text(
                          (isCurrentWorkspace && widget.isInDrawerList
                                  ? "☆ "
                                  : "") +
                              (isCurrentWorkspace
                                  ? currentWorkspace.name
                                  : widget.workspaceName) +
                              ((isCurrentWorkspace && widget.isInDrawerList)
                                  ? "   "
                                  : ""),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color:
                                  theme[settingData.selectedTheme]!.accentColor,
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