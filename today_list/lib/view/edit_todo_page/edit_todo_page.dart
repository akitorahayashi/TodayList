import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../view/edit_todo_page/components_for_edit/input_field/step_title_input_field.dart';
import '../../view/edit_todo_page/components_for_edit/input_field/todo_title_input_field.dart';
import '../../view/edit_todo_page/components_for_edit/select_today_or_whenever_button.dart';
import 'components_for_edit/select_category_dropdown/select_big_category_dropdown.dart';
import 'components_for_edit/added_steps_column.dart';
import '../../components/dialog/common/tl_yes_no_dialog.dart';
import '../../components/common_ui_part/tl_sliver_appbar.dart';
import '../../model/design/tl_theme.dart';
import '../../model/editting_provider/editting_todo_provider.dart';
import './already_exists/already_exists.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class EditToDoPage extends ConsumerStatefulWidget {
  final bool ifInToday;
  final String selectedBigCategoryID;
  final String? selectedSmallCategoryID;
  final int? indexOfEdittedTodo;
  const EditToDoPage({
    super.key,
    required this.ifInToday,
    required this.selectedBigCategoryID,
    required this.selectedSmallCategoryID,
    required this.indexOfEdittedTodo,
  });

  @override
  ConsumerState<EditToDoPage> createState() => EditToDoPageState();
}

class EditToDoPageState extends ConsumerState<EditToDoPage> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd?.load();

    // ウィジェットツリーが構築された後に状態を変更
    Future.microtask(() {
      final EditingToDoNotifier edittingToDoNotifier =
          ref.read(edittingToDoProvider.notifier);

      if (widget.indexOfEdittedTodo == null) {
        edittingToDoNotifier.setInitialValue();
      } else {
        edittingToDoNotifier.setEditedToDo(
          ifInToday: widget.ifInToday,
          selectedBigCategoryID: widget.selectedBigCategoryID,
          selectedSmallCategoryID: widget.selectedSmallCategoryID,
          indexOfEditingToDo: widget.indexOfEdittedTodo!,
        );
      }
    });
  }

  @override
  void dispose() {
    ref.read(edittingToDoProvider.notifier).disposeValue();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TLThemeData tlThemeData = TLTheme.of(context);
    // provider
    final EdittingTodo edittingToDo = ref.watch(edittingToDoProvider);
    return Scaffold(
      body: Stack(
        children: [
          // 背景色
          Container(
              decoration: BoxDecoration(color: tlThemeData.backgroundColor),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height),

          CustomScrollView(
            slivers: [
              TLSliverAppBar(
                pageTitle: "ToDo",
                leadingButtonOnPressed: () async {
                  if (edittingToDo.toDoTitleInputController?.text.isEmpty ??
                      true) {
                    // 元のページに戻る
                    Navigator.pop(context);
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => TLYesNoDialog(
                            title: "本当に戻りますか？",
                            message: "ToDoは + から保存できます",
                            yesAction: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }));
                  }
                },
                leadingIcon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                trailingButtonOnPressed: null,
                trailingIcon: null,
              ),
              // 入力部分の本体
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 10),
                    // 入力部分
                    GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: const Column(children: [
                          // ビッグカテゴリーを選択してsmallCategory選択のためのdropdownを更新する
                          SelectBigCategoryDropDown(),

                          // スモールカテゴリーを選択する
                          SelectBigCategoryDropDown(),

                          // 今日かいつでもか選択する
                          SelectTodayOrWheneverButton(),

                          // ToDoのタイトルを入力するTextFormField
                          ToDoTitleInputField(),

                          // 入力したstepsを表示
                          AddedStepsColumn(),

                          // steps入力のtextFormField
                          StepTitleInputField(),

                          SizedBox(height: 45),
                        ]),
                      ),
                    ),
                    // 広告
                    if (_bannerAd != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: _bannerAd!.size.width.toDouble(),
                            height: _bannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd!),
                          ),
                        ),
                      ),
                    // already exists
                    AlreadyExists(
                        ifInToday: edittingToDo.ifInToday,
                        bigCategoryID: edittingToDo.bigCatgoeyID,
                        smallCategoryID: edittingToDo.smallCategoryID,
                        tapToEditAction: () async {
                          Navigator.pop(context);
                        }),
                    const SizedBox(
                      height: 250,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
