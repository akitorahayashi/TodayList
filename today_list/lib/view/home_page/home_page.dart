import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_list/view/home_page/num_todos_card.dart';
import 'package:today_list/view/home_page/todos_block.dart';
import '../../component/common_ui_part/today_list_bottom_navbar/center_button_of_bottom_navbar.dart';
import '../../component/common_ui_part/today_list_bottom_navbar/today_list_bottom_navbar.dart';
import '../../component/dialog/common/tl_single_option_dialog.dart';
import '../../component/dialog/common/tl_yes_no_dialog.dart';
import '../../component/common_ui_part/tl_sliver_appbar.dart';
import '../../model/design/tl_theme.dart';
import '../../model/tl_workspace.dart';
import '../../model/external/tl_vibration.dart';
import '../../model/provider/current_tl_workspace_provider.dart';
import '../edit_todo_page/edit_todo_page.dart';
import '../category_list_page/category_list_page.dart';
import '../setting_page/setting_page.dart';
import './workspace_drawer/workspace_drawer.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _accetColorIsChanged = false;
  final GlobalKey<ScaffoldState> homePageScaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // 画面の描画が終わったタイミングで処理
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_accetColorIsChanged) {
        _accetColorIsChanged = true;
        // accetColor is changed
        setState(() {});
        FlutterNativeSplash.remove();
      }
      // if (settingData.isFirstEntry) {
      //   Navigator.push(context, MaterialPageRoute(builder: (context) {
      //     return const ShowTutorialPage();
      //   }));
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TLThemeData tlThemeData = TLTheme.of(context);
    final TLWorkspace currentTLWorkspace = ref.watch(currentWorkspaceProvider);
    final currentTLWorkspaceNotifier =
        ref.read(currentWorkspaceProvider.notifier);
    final int currentTLWorkspaceIndex =
        currentTLWorkspaceNotifier.currentWorkspaceIndex;

    return Scaffold(
      key: homePageScaffoldKey,
      drawer: const TLWorkspaceDrawer(isContentMode: false),
      body: Stack(children: [
        // 背景色
        Container(color: tlThemeData.backgroundColor),
        // 本体
        CustomScrollView(
          slivers: [
            TLSliverAppBar(
              pageTitle: currentTLWorkspaceIndex == 0
                  ? "Today List"
                  : currentTLWorkspace.name,
              // drawerを表示するボタン
              leadingButtonOnPressed: () =>
                  homePageScaffoldKey.currentState!.openDrawer(),
              leadingIcon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              // setting pageへ移動するボタン
              trailingButtonOnPressed: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return const SettingPage();
                }));
              },
              trailingIcon: const Icon(Icons.settings, color: Colors.white),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              const SizedBox(
                height: 10,
              ),
              NumToDosCard(
                  ifInToday: true,
                  numTodos: currentTLWorkspace.getNumOfToDo(ifInToday: true)),
              TodosBlock(
                  ifInToday: true, currentTLWorkspace: currentTLWorkspace),
              // Wheneverに分類されている方も同じように表示したい
              // モジュール化、ファイル分けして簡略化してほしい
              if (currentTLWorkspace.getNumOfToDo(ifInToday: false) != 0)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    children: [
                      NumToDosCard(
                          ifInToday: false,
                          numTodos: currentTLWorkspace.getNumOfToDo(
                              ifInToday: false)),
                      TodosBlock(
                          ifInToday: false,
                          currentTLWorkspace: currentTLWorkspace),
                    ],
                  ),
                ),

              // スペーサー
              const SizedBox(height: 250)
            ])),
          ],
        ),
        // 今日のチェック済みtodoを全て削除するボタン, カテゴリーリストに移動するボタン
        TodayListBottomNavbar(
          leadingIconData: FontAwesomeIcons.squareCheck,
          //　今日のチェック済みtodoを全て削除するボタン
          leadingButtonOnPressed: () => showDialog(
            context: context,
            builder: ((context) => TLYesNoDialog(
                  title: "チェック済みToDoを\n削除しますか?",
                  message: null,
                  yesAction: () async {
                    Navigator.pop(context);
                    await currentTLWorkspaceNotifier
                        .deleteCheckedToDosInTodayInCurrentWorkspace();
                    if (context.mounted) {
                      todo
                      showDialog(
                        context: context,
                        builder: (context) => const TLSingleOptionDialog(
                          title: "削除が完了しました！",
                          message: null,
                        ),
                      );
                    }
                    TLVibration.vibrate();
                  },
                )),
          ),
          trailingIconData: FontAwesomeIcons.list,
          // カテゴリーリストに移動するボタン
          tralingButtonOnPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const CategoryListPage();
            }));
          },
        ),
        // 新たにtodoを追加するボタン
        CenterButtonOfBottomNavBar(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return EditToDoPage(
                ifInToday: true,
                selectedBigCategoryID: currentTLWorkspace.bigCategories[0].id,
                selectedSmallCategoryID: null,
                editedToDoTitle: null,
                indexOfEdittedTodo: null,
              );
            }));
          },
        ),
      ]),
    );
  }
}
