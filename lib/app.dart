import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'view/home_page/home_page.dart';
import 'model/tl_theme.dart';

class TodayListApp extends ConsumerWidget {
  const TodayListApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int selectedThemeIndex = ref.watch(selectedThemeIndexProvider);
    return TLTheme(
      data: tlThemeDataList[selectedThemeIndex],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Today List",
          // ライト用テーマ
          theme: ThemeData(
            primarySwatch: tlThemeDataList[selectedThemeIndex].accentColor,
          ),
          home: const HomePage()),
    );
  }
}