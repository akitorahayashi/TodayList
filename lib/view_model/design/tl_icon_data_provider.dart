import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../service/tl_pref.dart';
import '../../model/design/tl_icon_data.dart';
import 'dart:convert';

final tlIconDataProvider =
    StateNotifierProvider<TLIconDataNotifier, TLIconData>(
  (ref) => TLIconDataNotifier(),
);

class TLIconDataNotifier extends StateNotifier<TLIconData> {
  TLIconDataNotifier()
      : super(TLIconData(
          category: 'Default',
          rarity: 'Common',
          name: 'box',
        )) {
    _loadSelectedIconData();
  }

  Future<void> setSelectedIconData(TLIconData tlIconData) async {
    state = tlIconData;
    await _saveSelectedIconData();
  }

  Future<void> _saveSelectedIconData() async {
    final prefs = await TLPrefService().getPref;
    final jsonString = jsonEncode(state.toJson());
    await prefs.setString('selectedIconData', jsonString);
  }

  Future<void> _loadSelectedIconData() async {
    final prefs = await TLPrefService().getPref;
    final jsonString = prefs.getString('selectedIconData');
    if (jsonString != null) {
      final jsonData = jsonDecode(jsonString);
      state = TLIconData.fromJson(jsonData);
    }
  }
}
