import 'package:flutter/material.dart';
import 'change_workspace_card/change_workspace_card.dart';
import '../../../components/for_ui/tl_sliver_appbar.dart';
import '../../../constants/theme.dart';
import '../../../constants/global_keys.dart';
import '../../../model/user/setting_data.dart';
import '../../../model/workspace/tl_workspace.dart';
import '../../../model/workspace/tl_workspaces.dart';
import '../content_views/content_card.dart';
import '../../../view/home_page/content_views/manage_workspace/manage_workspace_page.dart';
import './add_workspace_button.dart';

class WorkspaceDrawer extends StatefulWidget {
  final bool isContentMode;
  const WorkspaceDrawer({required Key key, required this.isContentMode})
      : super(key: key);

  @override
  State<WorkspaceDrawer> createState() => _WorkspaceDrawerState();
}

class _WorkspaceDrawerState extends State<WorkspaceDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          // 背景色
          Container(
              color: theme[SettingData.shared.selectedTheme]!.backgroundColor),
          CustomScrollView(
            slivers: [
              TLSliverAppBar(
                  pageTitle:
                      SettingData.shared.englishMode ? "Workspace" : "作業場",
                  leadingButtonOnPressed: null,
                  leadingIcon: Container(),
                  trailingButtonOnPressed: null,
                  trailingIcon: null),
              SliverList(
                  delegate: SliverChildListDelegate([
                // 現在のworkspace
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 16, 3, 5),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: theme[SettingData.shared.selectedTheme]!
                            .panelBorderColor),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                            child: Text(
                              SettingData.shared.englishMode
                                  ? "current workspace"
                                  : "現在の作業場",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.4),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          ChangeWorkspaceCard(
                            isInDrawerList: false,
                            workspaceName: TLWorkspace.currentWorkspace.name,
                            indexInWorkspaces:
                                TLWorkspace.currentWorkspaceIndex,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // workspaceを選ぶ
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 3, 3, 0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: theme[SettingData.shared.selectedTheme]!
                            .panelBorderColor),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          // カードの表示
                          child: Column(
                            children: [
                              for (int indexInWorkspaces = 0;
                                  indexInWorkspaces < tlworkspaces.length;
                                  indexInWorkspaces++)
                                GestureDetector(
                                  key: Key(UniqueKey().toString()),
                                  // デフォルトワークスペースの並び替え阻止
                                  onLongPress:
                                      indexInWorkspaces == 0 ? () {} : null,
                                  child: ChangeWorkspaceCard(
                                    isInDrawerList: true,
                                    workspaceName:
                                        tlworkspaces[indexInWorkspaces]
                                            ["name"]!,
                                    indexInWorkspaces: indexInWorkspaces,
                                  ),
                                ),
                              // 新しくworkspaceを追加する,
                              const AddWorkspaceButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // コンテンツビューを選ぶ
                if (!widget.isContentMode)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(3, 16, 3, 5),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: theme[SettingData.shared.selectedTheme]!
                              .panelBorderColor),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.only(top: 8.0, bottom: 5),
                            //   child: Text(
                            //     "content",
                            //     style: TextStyle(
                            //         color: Colors.black.withOpacity(0.4),
                            //         fontSize: 18,
                            //         fontWeight: FontWeight.w700),
                            //   ),
                            // ),
                            // all todos in today
                            // ContentCard(
                            //     onTap: () {
                            //       Navigator.pop(context);
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               fullscreenDialog: true,
                            //               builder: (context) {
                            //                 return AllToDosInTodayPage(
                            //                     key: allToDosInTodayPageKey);
                            //               }));
                            //     },
                            //     contentName: "All ToDos in Today"),
                            // manage workspace
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 8.0),
                            //   child: ContentCard(
                            //       onTap: () {
                            //         Navigator.pop(context);
                            //         Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //             fullscreenDialog: true,
                            //             builder: (context) {
                            //               return ManageWorkspacePage(
                            //                 key: manageWorkspacePageKey,
                            //               );
                            //             },
                            //           ),
                            //         );
                            //       },
                            //       contentName: "Manage Workspace"),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 250,
                )
              ]))
            ],
          ),
        ],
      ),
    );
  }
}
