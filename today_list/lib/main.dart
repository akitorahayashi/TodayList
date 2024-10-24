import 'package:flutter/material.dart';
import 'package:today_list/model/externals/tl_connectivity.dart';
import 'package:today_list/model/externals/tl_vibration.dart';
import 'model/workspace/tl_workspace.dart';
import './constants/global_keys.dart';
import 'model/user/setting_data.dart';
import 'model/externals/tl_ads.dart';
import './app.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

bool kAdTestMode = true;
bool kDebugMode = true;

enum LanguageType { ja, en }

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await TLWorkspace.readWorkspaces();
  await TLAds.initializeTLAds();
  await SettingData.shared.readSettings();
  await TLVibration.initVibrate();
  await TLConnectivity.initializeConnectivity();
  // await todayListUser.initializeFirebase();
  runApp(TodayList(key: todayListAppKey));
}
