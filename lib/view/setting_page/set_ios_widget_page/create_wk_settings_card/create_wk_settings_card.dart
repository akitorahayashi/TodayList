import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_list/component/common_ui_part/tl_double_card.dart';
import 'package:today_list/model/external/tl_vibration.dart';
import 'package:today_list/model/tl_theme.dart';
import 'package:today_list/model/todo/tl_category.dart';
import 'package:today_list/model/widget_kit_setting/widget_kit_setting.dart';
import 'package:today_list/model/widget_kit_setting/wks_provider.dart';
import 'package:today_list/model/workspace/provider/tl_workspaces_provider.dart';
import 'package:today_list/model/workspace/tl_workspace.dart';
import 'package:today_list/view/setting_page/set_ios_widget_page/component/wks_header.dart';

class CreateWKSettingsCard extends ConsumerStatefulWidget {
  final VoidCallback showAddWKSButtonAction;
  const CreateWKSettingsCard({super.key, required this.showAddWKSButtonAction});

  @override
  CreateWKSettingsCardState createState() => CreateWKSettingsCardState();
}

class CreateWKSettingsCardState extends ConsumerState<CreateWKSettingsCard> {
  // textControllerに関するメンバー
  final TextEditingController _wksInputController = TextEditingController();
  // 自動入力
  bool _ifUserHasEntered = false;
  // 選んでいるWorkspaceのindex
  int _selectedWorkspaceIndex = 0;
  // 選んでいるcategoryのID
  late TLCategory _selectedBigCategory;
  TLCategory? _selectedSmallCategory;

  TLCategory get _initialBigCategory =>
      ref.read(tlWorkspacesProvider)[_selectedWorkspaceIndex].bigCategories[0];

  // 選んでいる項目を全てデフォルトの値に戻す関数
  void _initialize() {
    _wksInputController.clear();
    _ifUserHasEntered = false;
    _selectedWorkspaceIndex = 0;
    _selectedBigCategory = _initialBigCategory;
    _selectedSmallCategory = null;
  }

  ButtonStyle get controllButtonStyle => (() {
        final themeColor =
            tlThemeDataList[ref.read(selectedThemeIndexProvider)].accentColor;
        return ButtonStyle(
          foregroundColor: WidgetStateProperty.all(themeColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              return themeColor.withOpacity(0.1);
            },
          ),
        );
      })();

  @override
  void initState() {
    super.initState();
    // カテゴリーの初期化
    _selectedBigCategory = _initialBigCategory;
  }

  @override
  void dispose() {
    _wksInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TLThemeData tlThemeData = TLTheme.of(context);
    final double deviceWidth = MediaQuery.of(context).size.width;
    // provider
    final List<TLWorkspace> tlWorkspaces = ref.watch(tlWorkspacesProvider);
    // notifier
    final WidgetKitSettingNotifier wksnotifier =
        ref.read(widgetKitSettingsProvider.notifier);
    return GestureDetector(
      // カードをタップしたらTextFieldからunfocus
      onTap: () => FocusScope.of(context).unfocus(),
      child: TlDoubleCard(
        child: SizedBox(
          width: deviceWidth - 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // wksのtitleを入力する
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextField(
                    autofocus: true,
                    controller: _wksInputController,
                    // ユーザーが自分の手で入力したかどうか
                    onChanged: (t) => {_ifUserHasEntered = true},
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    cursorColor: tlThemeData.accentColor,
                    decoration: InputDecoration(
                      labelText: '- Title -', // ここにラベルのテキストを指定
                      labelStyle: const TextStyle(
                        color: Colors.black45, // ラベルのスタイルを指定
                        fontWeight: FontWeight.bold,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: tlThemeData.accentColor),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: tlThemeData.accentColor),
                      ),
                    ),
                  ),
                ),
                // workspaceを選択する
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WKSHeader(text: "Workspace"),
                      DropdownButton<int>(
                        isExpanded: true,
                        iconEnabledColor: tlThemeData.accentColor,
                        value: _selectedWorkspaceIndex,
                        items: tlWorkspaces.asMap().entries.map((entry) {
                          int idx = entry.key;
                          TLWorkspace workspace = entry.value;
                          return DropdownMenuItem<int>(
                            value: idx,
                            child: Text(workspace.name),
                          );
                        }).toList(),
                        style: const TextStyle(
                            color: Colors.black45, fontWeight: FontWeight.bold),
                        onChanged: (int? newIndex) {
                          if (newIndex == null) return;
                          TLVibration.vibrate();
                          setState(() {
                            if (!_ifUserHasEntered) {
                              _wksInputController.text =
                                  tlWorkspaces[newIndex].name;
                            }
                            _selectedWorkspaceIndex = newIndex;
                            _selectedBigCategory = _initialBigCategory;
                            _selectedSmallCategory = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // bigCategoryを選択する
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WKSHeader(text: "Big category"),
                      DropdownButton<TLCategory>(
                        isExpanded: true,
                        iconEnabledColor: tlThemeData.accentColor,
                        value: _selectedBigCategory,
                        items: tlWorkspaces[_selectedWorkspaceIndex]
                            .bigCategories
                            .map((TLCategory bc) {
                          return DropdownMenuItem<TLCategory>(
                            value: bc,
                            child: Text(bc.title),
                          );
                        }).toList(),
                        style: const TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (TLCategory? newBigCategory) {
                          if (newBigCategory == null) return;
                          TLVibration.vibrate();
                          setState(() {
                            if (!_ifUserHasEntered) {
                              _wksInputController.text =
                                  tlWorkspaces[_selectedWorkspaceIndex]
                                      .bigCategories
                                      .firstWhere(
                                          (bc) => bc.id == newBigCategory.id)
                                      .title;
                            }
                            _selectedBigCategory = newBigCategory;
                            _selectedSmallCategory = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // smallCategoryを選択するを選択する
                AnimatedCrossFade(
                  crossFadeState: tlWorkspaces[_selectedWorkspaceIndex]
                          .smallCategories[_selectedBigCategory.id]!
                          .isEmpty
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 200),
                  firstChild: Container(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WKSHeader(text: "Small category"),
                        DropdownButton<TLCategory>(
                          isExpanded: true,
                          iconEnabledColor: tlThemeData.accentColor,
                          value: _selectedSmallCategory,
                          hint: const Text(
                            "指定なし",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                          items: (tlWorkspaces[_selectedWorkspaceIndex]
                                          .smallCategories[
                                      _selectedBigCategory.id] ??
                                  [])
                              .map((TLCategory sc) {
                            return DropdownMenuItem<TLCategory>(
                              value: sc,
                              child: Text(sc.title),
                            );
                          }).toList(),
                          style: const TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold),
                          onChanged: (TLCategory? newSmallCategory) {
                            if (newSmallCategory == null) return;
                            TLVibration.vibrate();
                            setState(() {
                              if (!_ifUserHasEntered) {
                                _wksInputController.text = tlWorkspaces[
                                        _selectedWorkspaceIndex]
                                    .smallCategories[_selectedBigCategory.id]!
                                    .firstWhere(
                                        (sc) => sc.id == newSmallCategory.id)
                                    .title;
                              }
                              _selectedSmallCategory = newSmallCategory;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // controll buttons
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: OverflowBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _initialize();
                            });
                            widget.showAddWKSButtonAction();
                          },
                          style: controllButtonStyle,
                          child: const Text(
                            "戻る",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      TextButton(
                        onPressed: _wksInputController.text.trim().isEmpty
                            ? null
                            : () {
                                TLVibration.vibrate();
                                // wksのlistに追加、保存
                                wksnotifier.addWidgetKitSettings(
                                    newWidgetKitSettings: WidgetKitSetting(
                                  id: UniqueKey().toString(),
                                  title: _wksInputController.text,
                                  workspaceIdx: _selectedWorkspaceIndex,
                                  selectedBigCategory:
                                      _selectedBigCategory.copyWith(),
                                  selectedSmallCategory:
                                      _selectedSmallCategory?.copyWith(),
                                ));
                                // Card内のコンテンツを初期化
                                setState(() {
                                  _initialize();
                                });
                                // 一覧に戻る
                                widget.showAddWKSButtonAction();
                              },
                        style: controllButtonStyle,
                        child: const Text(
                          "追加",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
