import 'package:flutter/material.dart';
import '../view/component/dialog/common/tl_single_option_dialog.dart';
import 'tl_pref.dart';
import '../main.dart';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TLAdsService {
  static RewardedAd? rewardedAd;
  static DateFormat dateFormater = DateFormat('yyyy/MM/dd');

  // Passの期限
  static String limitOfPass =
      dateFormater.format(DateTime.now().add(const Duration(days: -1)));
  // 最後に動画広告を見た日付
  static String lastWatchedAdDate = '2020/01/01';

  // passがactiveか確認する
  static bool get isPassActive => (() {
        final DateTime inputDate =
            dateFormater.parse(TLAdsService.limitOfPass); // 文字列を日付に変換
        final DateTime today = DateTime.now(); // 現在の日付

        return !inputDate.isBefore(today); // 今日より前でないならtrue
      }());

  // 今日初めて見たか確認して初めてだったら多めに数字を返す
  // static int daysIfFirstWatchAdsToday({
  //   required int notFirstAmount,
  //   required int firstAmount,
  // }) {
  //   final String today = dateFormater.format(DateTime.now());
  //   if (TLAds.lastWatchedAdDate == today) {
  //     return notFirstAmount;
  //   } else {
  //     TLAds.lastWatchedAdDate = today;
  //     SharedPreferences.getInstance().then((pref) {
  //       pref.setString("lastWatchedAdDate", today);
  //     });
  //     return firstAmount;
  //   }
  // }

  static Future<void> initializeTLAds() async {
    await MobileAds.instance.initialize();
    // Passの起源を読み込む
    await TLPrefService().getPref.then((pref) async {
      final roadedLimit = pref.getString("limitOfPass");
      // passLimitが存在するか
      if (roadedLimit != null) {
        TLAdsService.limitOfPass = roadedLimit;
      } else {
        await TLAdsService.saveLimitOfPass();
      }
      // lastShowedDateが存在するか
      final loadedLastWatchedAdDate = pref.getString("lastWatchedAdDate");
      if (loadedLastWatchedAdDate != null) {
        lastWatchedAdDate = loadedLastWatchedAdDate;
      }
    });
    // passをわざと切らす
    // TLAds.limitOfPass = "2020/01/01";
  }

  static Future<void> saveLimitOfPass() async {
    await TLPrefService().getPref.then((pref) {
      pref.setString("limitOfPass", TLAdsService.limitOfPass);
    });
  }

  static void extendLimitOfPassReward({required int howManyDays}) {
    DateTime today = DateTime.now();
    DateTime limitDate = dateFormater.parse(TLAdsService.limitOfPass);
    if (limitDate.isBefore(today)) {
      // 今日より前なら2日後の日付
      TLAdsService.limitOfPass =
          dateFormater.format(today.add(Duration(days: howManyDays - 1)));
    } else {
      // 今日かそれ以降なら3日後の日付
      TLAdsService.limitOfPass =
          dateFormater.format(limitDate.add(Duration(days: howManyDays)));
    }
    TLAdsService.saveLimitOfPass();
  }

  static Future<void> showRewardedAd(
      {required BuildContext context, required Function rewardAction}) async {
    if (TLAdsService.rewardedAd != null) {
      await TLAdsService.rewardedAd!.show(onUserEarnedReward: (_, reward) {
        rewardAction();
      });
    } else {
      // ロードできてなかった時再ロード
      loadRewardedAd().then((_) async {
        if (TLAdsService.rewardedAd != null) {
          await TLAdsService.rewardedAd!.show(onUserEarnedReward: (_, reward) {
            rewardAction(_, reward);
          });
        } else {
          // それでも無理だったらエラーを出す
          showDialog(
              context: context,
              builder: ((context) {
                return TLSingleOptionDialog(
                  title: "エラー",
                  message: "インターネット環境の調子が悪いようです...",
                );
              }));
        }
      });
    }
  }

  static Future<void> loadRewardedAd() async {
    return RewardedAd.load(
      adUnitId: TLAdsService.rewardedAdUnitId(isTestMode: kAdTestMode),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              TLAdsService.rewardedAd = null;
              loadRewardedAd();
            },
          );

          TLAdsService.rewardedAd = ad;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  // ad unit id
  static String editPageBannerAdUnitId({required bool isTestMode}) {
    if (isTestMode) {
      return Platform.isIOS
          ? dotenv.env['IOS_BANNER_AD_UNIT_ID_TEST']!
          : dotenv.env['ANDROID_BANNER_AD_UNIT_ID_TEST']!;
    } else {
      return Platform.isIOS
          ? dotenv.env['IOS_BANNER_AD_UNIT_ID_TEST']!
          : dotenv.env['ANDROID_BANNER_AD_UNIT_ID_TEST']!;
    }
  }

  static String setFeaturesBannerAdUnitId({required bool isTestMode}) {
    if (isTestMode) {
      return Platform.isIOS
          ? dotenv.env['IOS_BANNER_AD_UNIT_ID_TEST']!
          : dotenv.env['ANDROID_BANNER_AD_UNIT_ID_TEST']!;
    } else {
      return Platform.isIOS
          ? dotenv.env['IOS_BANNER_AD_UNIT_ID_TEST']!
          : dotenv.env['ANDROID_BANNER_AD_UNIT_ID_TEST']!;
    }
  }

  static String rewardedAdUnitId({required bool isTestMode}) {
    if (isTestMode) {
      return Platform.isIOS
          ? dotenv.env['IOS_REWARDED_AD_UNIT_ID_TEST']!
          : dotenv.env['ANDROID_REWARDED_AD_UNIT_ID_TEST']!;
    } else {
      return Platform.isIOS
          ? dotenv.env['IOS_REWARDED_AD_UNIT_ID_TEST']!
          : dotenv.env['ANDROID_REWARDED_AD_UNIT_ID_TEST']!;
    }
  }
}
