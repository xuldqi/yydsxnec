import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('zh')];

  /// No description provided for @accept_invite.
  ///
  /// In zh, this message translates to:
  /// **'接受邀请'**
  String get accept_invite;

  /// No description provided for @account.
  ///
  /// In zh, this message translates to:
  /// **'账户'**
  String get account;

  /// No description provided for @achieve_all_types_desc.
  ///
  /// In zh, this message translates to:
  /// **'尝试过5种不同的运动类型'**
  String get achieve_all_types_desc;

  /// No description provided for @achieve_all_types_name.
  ///
  /// In zh, this message translates to:
  /// **'全能运动员'**
  String get achieve_all_types_name;

  /// No description provided for @achieve_cal_10000_desc.
  ///
  /// In zh, this message translates to:
  /// **'累计消耗10,000千卡热量'**
  String get achieve_cal_10000_desc;

  /// No description provided for @achieve_cal_10000_name.
  ///
  /// In zh, this message translates to:
  /// **'热量粉碎机'**
  String get achieve_cal_10000_name;

  /// No description provided for @achieve_cal_1000_desc.
  ///
  /// In zh, this message translates to:
  /// **'累计消耗1,000千卡热量'**
  String get achieve_cal_1000_desc;

  /// No description provided for @achieve_cal_1000_name.
  ///
  /// In zh, this message translates to:
  /// **'热量消耗者'**
  String get achieve_cal_1000_name;

  /// No description provided for @achieve_cat_diet.
  ///
  /// In zh, this message translates to:
  /// **'饮食成就'**
  String get achieve_cat_diet;

  /// No description provided for @achieve_cat_mood.
  ///
  /// In zh, this message translates to:
  /// **'心情成就'**
  String get achieve_cat_mood;

  /// No description provided for @achieve_cat_sleep.
  ///
  /// In zh, this message translates to:
  /// **'睡眠成就'**
  String get achieve_cat_sleep;

  /// No description provided for @achieve_cat_sport.
  ///
  /// In zh, this message translates to:
  /// **'运动成就'**
  String get achieve_cat_sport;

  /// No description provided for @achieve_cat_water.
  ///
  /// In zh, this message translates to:
  /// **'饮水成就'**
  String get achieve_cat_water;

  /// No description provided for @achieve_diet_balanced_desc.
  ///
  /// In zh, this message translates to:
  /// **'一天内记录完早中晚三餐'**
  String get achieve_diet_balanced_desc;

  /// No description provided for @achieve_diet_balanced_name.
  ///
  /// In zh, this message translates to:
  /// **'营养均衡'**
  String get achieve_diet_balanced_name;

  /// No description provided for @achieve_diet_first_desc.
  ///
  /// In zh, this message translates to:
  /// **'记录第一次饮食'**
  String get achieve_diet_first_desc;

  /// No description provided for @achieve_diet_first_name.
  ///
  /// In zh, this message translates to:
  /// **'健康开端'**
  String get achieve_diet_first_name;

  /// No description provided for @achieve_diet_goal_desc.
  ///
  /// In zh, this message translates to:
  /// **'连续7天摄入热量在目标范围内'**
  String get achieve_diet_goal_desc;

  /// No description provided for @achieve_diet_goal_name.
  ///
  /// In zh, this message translates to:
  /// **'精准掌控'**
  String get achieve_diet_goal_name;

  /// No description provided for @achieve_diet_low_cal_desc.
  ///
  /// In zh, this message translates to:
  /// **'连续7天摄入热量低于目标'**
  String get achieve_diet_low_cal_desc;

  /// No description provided for @achieve_diet_low_cal_name.
  ///
  /// In zh, this message translates to:
  /// **'轻食主义'**
  String get achieve_diet_low_cal_name;

  /// No description provided for @achieve_diet_streak_30_desc.
  ///
  /// In zh, this message translates to:
  /// **'连续30天记录饮食'**
  String get achieve_diet_streak_30_desc;

  /// No description provided for @achieve_diet_streak_30_name.
  ///
  /// In zh, this message translates to:
  /// **'饮食专家'**
  String get achieve_diet_streak_30_name;

  /// No description provided for @achieve_diet_streak_7_desc.
  ///
  /// In zh, this message translates to:
  /// **'连续7天记录饮食'**
  String get achieve_diet_streak_7_desc;

  /// No description provided for @achieve_diet_streak_7_name.
  ///
  /// In zh, this message translates to:
  /// **'饮食记录员'**
  String get achieve_diet_streak_7_name;

  /// No description provided for @achieve_distance_100km_desc.
  ///
  /// In zh, this message translates to:
  /// **'累计运动距离达到100公里'**
  String get achieve_distance_100km_desc;

  /// No description provided for @achieve_distance_100km_name.
  ///
  /// In zh, this message translates to:
  /// **'100 公里'**
  String get achieve_distance_100km_name;

  /// No description provided for @achieve_distance_10km_desc.
  ///
  /// In zh, this message translates to:
  /// **'累计运动距离达到10公里'**
  String get achieve_distance_10km_desc;

  /// No description provided for @achieve_distance_10km_name.
  ///
  /// In zh, this message translates to:
  /// **'10 公里'**
  String get achieve_distance_10km_name;

  /// No description provided for @achieve_distance_marathon_desc.
  ///
  /// In zh, this message translates to:
  /// **'累计运动距离达到42.195公里'**
  String get achieve_distance_marathon_desc;

  /// No description provided for @achieve_distance_marathon_name.
  ///
  /// In zh, this message translates to:
  /// **'马拉松'**
  String get achieve_distance_marathon_name;

  /// No description provided for @achieve_early_bird_desc.
  ///
  /// In zh, this message translates to:
  /// **'在凌晨6点前完成运动'**
  String get achieve_early_bird_desc;

  /// No description provided for @achieve_early_bird_name.
  ///
  /// In zh, this message translates to:
  /// **'晨间之鸟'**
  String get achieve_early_bird_name;

  /// No description provided for @achieve_first_workout_desc.
  ///
  /// In zh, this message translates to:
  /// **'完成第一次运动'**
  String get achieve_first_workout_desc;

  /// No description provided for @achieve_first_workout_name.
  ///
  /// In zh, this message translates to:
  /// **'初试身手'**
  String get achieve_first_workout_name;

  /// No description provided for @achieve_mood_first_desc.
  ///
  /// In zh, this message translates to:
  /// **'记录第一次心情'**
  String get achieve_mood_first_desc;

  /// No description provided for @achieve_mood_first_name.
  ///
  /// In zh, this message translates to:
  /// **'记录心情'**
  String get achieve_mood_first_name;

  /// No description provided for @achieve_mood_happy_desc.
  ///
  /// In zh, this message translates to:
  /// **'连续7天保持好心情'**
  String get achieve_mood_happy_desc;

  /// No description provided for @achieve_mood_happy_name.
  ///
  /// In zh, this message translates to:
  /// **'快乐连击'**
  String get achieve_mood_happy_name;

  /// No description provided for @achieve_mood_improve_desc.
  ///
  /// In zh, this message translates to:
  /// **'心情从低落转为快乐'**
  String get achieve_mood_improve_desc;

  /// No description provided for @achieve_mood_improve_name.
  ///
  /// In zh, this message translates to:
  /// **'心态转变'**
  String get achieve_mood_improve_name;

  /// No description provided for @achieve_mood_stable_desc.
  ///
  /// In zh, this message translates to:
  /// **'连续30天没有负面情绪'**
  String get achieve_mood_stable_desc;

  /// No description provided for @achieve_mood_stable_name.
  ///
  /// In zh, this message translates to:
  /// **'情绪稳定'**
  String get achieve_mood_stable_name;

  /// No description provided for @achieve_mood_streak_30_desc.
  ///
  /// In zh, this message translates to:
  /// **'连续30天记录心情'**
  String get achieve_mood_streak_30_desc;

  /// No description provided for @achieve_mood_streak_30_name.
  ///
  /// In zh, this message translates to:
  /// **'心灵导师'**
  String get achieve_mood_streak_30_name;

  /// No description provided for @achieve_mood_streak_7_desc.
  ///
  /// In zh, this message translates to:
  /// **'连续7天记录心情'**
  String get achieve_mood_streak_7_desc;

  /// No description provided for @achieve_mood_streak_7_name.
  ///
  /// In zh, this message translates to:
  /// **'情绪觉察'**
  String get achieve_mood_streak_7_name;

  /// No description provided for @achieve_night_owl_desc.
  ///
  /// In zh, this message translates to:
  /// **'在晚上10点后完成运动'**
  String get achieve_night_owl_desc;

  /// No description provided for @achieve_night_owl_name.
  ///
  /// In zh, this message translates to:
  /// **'深夜之猫'**
  String get achieve_night_owl_name;

  /// No description provided for @achieve_sleep_8hrs_desc.
  ///
  /// In zh, this message translates to:
  /// **'单次睡眠达到8小时'**
  String get achieve_sleep_8hrs_desc;

  /// No description provided for @achieve_sleep_8hrs_name.
  ///
  /// In zh, this message translates to:
  /// **'饱足睡眠'**
  String get achieve_sleep_8hrs_name;

  /// No description provided for @achieve_sleep_early_desc.
  ///
  /// In zh, this message translates to:
  /// **'在晚上10点前入睡'**
  String get achieve_sleep_early_desc;

  /// No description provided for @achieve_sleep_early_name.
  ///
  /// In zh, this message translates to:
  /// **'早睡早起'**
  String get achieve_sleep_early_name;

  /// No description provided for @achieve_sleep_first_desc.
  ///
  /// In zh, this message translates to:
  /// **'记录第一次睡眠'**
  String get achieve_sleep_first_desc;

  /// No description provided for @achieve_sleep_first_name.
  ///
  /// In zh, this message translates to:
  /// **'第一觉'**
  String get achieve_sleep_first_name;

  /// No description provided for @achieve_sleep_quality_desc.
  ///
  /// In zh, this message translates to:
  /// **'睡眠质量分数达到90分'**
  String get achieve_sleep_quality_desc;

  /// No description provided for @achieve_sleep_quality_name.
  ///
  /// In zh, this message translates to:
  /// **'深度睡眠'**
  String get achieve_sleep_quality_name;

  /// No description provided for @achieve_sleep_streak_30_desc.
  ///
  /// In zh, this message translates to:
  /// **'连续30天记录睡眠'**
  String get achieve_sleep_streak_30_desc;

  /// No description provided for @achieve_sleep_streak_30_name.
  ///
  /// In zh, this message translates to:
  /// **'睡眠大师'**
  String get achieve_sleep_streak_30_name;

  /// No description provided for @achieve_sleep_streak_7_desc.
  ///
  /// In zh, this message translates to:
  /// **'连续7天记录睡眠'**
  String get achieve_sleep_streak_7_desc;

  /// No description provided for @achieve_sleep_streak_7_name.
  ///
  /// In zh, this message translates to:
  /// **'规律作息'**
  String get achieve_sleep_streak_7_name;

  /// No description provided for @achieve_streak_30_desc.
  ///
  /// In zh, this message translates to:
  /// **'连续30天完成运动'**
  String get achieve_streak_30_desc;

  /// No description provided for @achieve_streak_30_name.
  ///
  /// In zh, this message translates to:
  /// **'月度冠军'**
  String get achieve_streak_30_name;

  /// No description provided for @achieve_streak_3_desc.
  ///
  /// In zh, this message translates to:
  /// **'连续3天完成运动'**
  String get achieve_streak_3_desc;

  /// No description provided for @achieve_streak_3_name.
  ///
  /// In zh, this message translates to:
  /// **'三日连胜'**
  String get achieve_streak_3_name;

  /// No description provided for @achieve_streak_7_desc.
  ///
  /// In zh, this message translates to:
  /// **'连续7天完成运动'**
  String get achieve_streak_7_desc;

  /// No description provided for @achieve_streak_7_name.
  ///
  /// In zh, this message translates to:
  /// **'七日连胜'**
  String get achieve_streak_7_name;

  /// No description provided for @achieve_water_8cups_desc.
  ///
  /// In zh, this message translates to:
  /// **'一天内达成8杯饮水目标'**
  String get achieve_water_8cups_desc;

  /// No description provided for @achieve_water_8cups_name.
  ///
  /// In zh, this message translates to:
  /// **'八杯水大师'**
  String get achieve_water_8cups_name;

  /// No description provided for @achieve_water_first_desc.
  ///
  /// In zh, this message translates to:
  /// **'记录第一次饮水'**
  String get achieve_water_first_desc;

  /// No description provided for @achieve_water_first_name.
  ///
  /// In zh, this message translates to:
  /// **'第一口水'**
  String get achieve_water_first_name;

  /// No description provided for @achieve_water_streak_30_desc.
  ///
  /// In zh, this message translates to:
  /// **'连续30天达成饮水目标'**
  String get achieve_water_streak_30_desc;

  /// No description provided for @achieve_water_streak_30_name.
  ///
  /// In zh, this message translates to:
  /// **'水润一月'**
  String get achieve_water_streak_30_name;

  /// No description provided for @achieve_water_streak_7_desc.
  ///
  /// In zh, this message translates to:
  /// **'连续7天达成饮水目标'**
  String get achieve_water_streak_7_desc;

  /// No description provided for @achieve_water_streak_7_name.
  ///
  /// In zh, this message translates to:
  /// **'水润一周'**
  String get achieve_water_streak_7_name;

  /// No description provided for @achieve_water_total_100L_desc.
  ///
  /// In zh, this message translates to:
  /// **'累计饮水达到100升'**
  String get achieve_water_total_100L_desc;

  /// No description provided for @achieve_water_total_100L_name.
  ///
  /// In zh, this message translates to:
  /// **'100升俱乐部'**
  String get achieve_water_total_100L_name;

  /// No description provided for @achieve_water_variety_desc.
  ///
  /// In zh, this message translates to:
  /// **'尝试过10种不同的饮品'**
  String get achieve_water_variety_desc;

  /// No description provided for @achieve_water_variety_name.
  ///
  /// In zh, this message translates to:
  /// **'饮品探索家'**
  String get achieve_water_variety_name;

  /// No description provided for @achieve_workout_100_desc.
  ///
  /// In zh, this message translates to:
  /// **'累计完成100次运动'**
  String get achieve_workout_100_desc;

  /// No description provided for @achieve_workout_100_name.
  ///
  /// In zh, this message translates to:
  /// **'运动之星'**
  String get achieve_workout_100_name;

  /// No description provided for @achieve_workout_10_desc.
  ///
  /// In zh, this message translates to:
  /// **'累计完成10次运动'**
  String get achieve_workout_10_desc;

  /// No description provided for @achieve_workout_10_name.
  ///
  /// In zh, this message translates to:
  /// **'坚持不懈'**
  String get achieve_workout_10_name;

  /// No description provided for @achieve_workout_50_desc.
  ///
  /// In zh, this message translates to:
  /// **'累计完成50次运动'**
  String get achieve_workout_50_desc;

  /// No description provided for @achieve_workout_50_name.
  ///
  /// In zh, this message translates to:
  /// **'运动达人'**
  String get achieve_workout_50_name;

  /// No description provided for @achievements_page_subtitle.
  ///
  /// In zh, this message translates to:
  /// **'记录每一次坚持，沉淀你的运动成就'**
  String get achievements_page_subtitle;

  /// No description provided for @achievements_page_title.
  ///
  /// In zh, this message translates to:
  /// **'成就'**
  String get achievements_page_title;

  /// No description provided for @activity_permission_msg.
  ///
  /// In zh, this message translates to:
  /// **'此应用需要健康活动权限以准确追踪步数。点击确认以授予权限。'**
  String get activity_permission_msg;

  /// No description provided for @ad_desc.
  ///
  /// In zh, this message translates to:
  /// **'1.每日奖励数量和金额有限，先到先得。\\n2.获得奖励需看完视频。\\n3.每个用户每天仅可参加1次。\\n4.获得奖励后后将直接进入钱包。'**
  String get ad_desc;

  /// No description provided for @add_health_record.
  ///
  /// In zh, this message translates to:
  /// **'添加健康记录'**
  String get add_health_record;

  /// No description provided for @already_copy.
  ///
  /// In zh, this message translates to:
  /// **'已复制到剪切板'**
  String get already_copy;

  /// No description provided for @already_get_coin.
  ///
  /// In zh, this message translates to:
  /// **'已领取'**
  String get already_get_coin;

  /// No description provided for @already_get_coin_hint.
  ///
  /// In zh, this message translates to:
  /// **'您已领取过奖励啦'**
  String get already_get_coin_hint;

  /// No description provided for @already_luck_reward.
  ///
  /// In zh, this message translates to:
  /// **'今日已抽奖，请明日再来。'**
  String get already_luck_reward;

  /// No description provided for @already_sign.
  ///
  /// In zh, this message translates to:
  /// **'已领取'**
  String get already_sign;

  /// No description provided for @analytics.
  ///
  /// In zh, this message translates to:
  /// **'数据分析'**
  String get analytics;

  /// No description provided for @app_name.
  ///
  /// In zh, this message translates to:
  /// **'微步运动'**
  String get app_name;

  /// No description provided for @apr.
  ///
  /// In zh, this message translates to:
  /// **'4月'**
  String get apr;

  /// No description provided for @aug.
  ///
  /// In zh, this message translates to:
  /// **'8月'**
  String get aug;

  /// No description provided for @auth.
  ///
  /// In zh, this message translates to:
  /// **'允许'**
  String get auth;

  /// No description provided for @beverage_beer.
  ///
  /// In zh, this message translates to:
  /// **'啤酒'**
  String get beverage_beer;

  /// No description provided for @beverage_coconut_water.
  ///
  /// In zh, this message translates to:
  /// **'椰子水'**
  String get beverage_coconut_water;

  /// No description provided for @beverage_coffee.
  ///
  /// In zh, this message translates to:
  /// **'咖啡'**
  String get beverage_coffee;

  /// No description provided for @beverage_cola.
  ///
  /// In zh, this message translates to:
  /// **'可乐'**
  String get beverage_cola;

  /// No description provided for @beverage_honey_water.
  ///
  /// In zh, this message translates to:
  /// **'蜂蜜水'**
  String get beverage_honey_water;

  /// No description provided for @beverage_juice.
  ///
  /// In zh, this message translates to:
  /// **'果汁'**
  String get beverage_juice;

  /// No description provided for @beverage_lemon_water.
  ///
  /// In zh, this message translates to:
  /// **'柠檬水'**
  String get beverage_lemon_water;

  /// No description provided for @beverage_milk.
  ///
  /// In zh, this message translates to:
  /// **'牛奶'**
  String get beverage_milk;

  /// No description provided for @beverage_milk_tea.
  ///
  /// In zh, this message translates to:
  /// **'奶茶'**
  String get beverage_milk_tea;

  /// No description provided for @beverage_mineral_water.
  ///
  /// In zh, this message translates to:
  /// **'矿泉水'**
  String get beverage_mineral_water;

  /// No description provided for @beverage_soda.
  ///
  /// In zh, this message translates to:
  /// **'苏打水'**
  String get beverage_soda;

  /// No description provided for @beverage_soup.
  ///
  /// In zh, this message translates to:
  /// **'汤'**
  String get beverage_soup;

  /// No description provided for @beverage_soy_milk.
  ///
  /// In zh, this message translates to:
  /// **'豆浆'**
  String get beverage_soy_milk;

  /// No description provided for @beverage_sports_drink.
  ///
  /// In zh, this message translates to:
  /// **'运动饮料'**
  String get beverage_sports_drink;

  /// No description provided for @beverage_tea.
  ///
  /// In zh, this message translates to:
  /// **'茶'**
  String get beverage_tea;

  /// No description provided for @beverage_water.
  ///
  /// In zh, this message translates to:
  /// **'白开水'**
  String get beverage_water;

  /// No description provided for @beverage_yogurt.
  ///
  /// In zh, this message translates to:
  /// **'酸奶'**
  String get beverage_yogurt;

  /// No description provided for @blood_glucose.
  ///
  /// In zh, this message translates to:
  /// **'血糖'**
  String get blood_glucose;

  /// No description provided for @blood_pressure.
  ///
  /// In zh, this message translates to:
  /// **'血压'**
  String get blood_pressure;

  /// No description provided for @bp_monitoring.
  ///
  /// In zh, this message translates to:
  /// **'生理指标记录'**
  String get bp_monitoring;

  /// No description provided for @challenge_1_desc.
  ///
  /// In zh, this message translates to:
  /// **'连续7天每天达到10,000步'**
  String get challenge_1_desc;

  /// No description provided for @challenge_1_title.
  ///
  /// In zh, this message translates to:
  /// **'7天万步挑战'**
  String get challenge_1_title;

  /// No description provided for @challenge_2_desc.
  ///
  /// In zh, this message translates to:
  /// **'在周六和周日每天消耗至少500千卡'**
  String get challenge_2_desc;

  /// No description provided for @challenge_2_title.
  ///
  /// In zh, this message translates to:
  /// **'周末燃脂500'**
  String get challenge_2_title;

  /// No description provided for @challenge_3_desc.
  ///
  /// In zh, this message translates to:
  /// **'连续21天每天步行超过5,000步'**
  String get challenge_3_desc;

  /// No description provided for @challenge_3_title.
  ///
  /// In zh, this message translates to:
  /// **'21天习惯养成'**
  String get challenge_3_title;

  /// No description provided for @coin.
  ///
  /// In zh, this message translates to:
  /// **'金币'**
  String get coin;

  /// No description provided for @coin_record_list.
  ///
  /// In zh, this message translates to:
  /// **'金币获取记录'**
  String get coin_record_list;

  /// No description provided for @common_problem.
  ///
  /// In zh, this message translates to:
  /// **'常见问题'**
  String get common_problem;

  /// No description provided for @contact_us.
  ///
  /// In zh, this message translates to:
  /// **'联系我们'**
  String get contact_us;

  /// No description provided for @copy.
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get copy;

  /// No description provided for @create_post_action_post.
  ///
  /// In zh, this message translates to:
  /// **'发布'**
  String get create_post_action_post;

  /// No description provided for @create_post_add_data_title.
  ///
  /// In zh, this message translates to:
  /// **'添加运动数据'**
  String get create_post_add_data_title;

  /// No description provided for @create_post_attach_calories.
  ///
  /// In zh, this message translates to:
  /// **'今日消耗'**
  String get create_post_attach_calories;

  /// No description provided for @create_post_attach_steps.
  ///
  /// In zh, this message translates to:
  /// **'今日步数'**
  String get create_post_attach_steps;

  /// No description provided for @create_post_empty_content.
  ///
  /// In zh, this message translates to:
  /// **'请输入分享内容'**
  String get create_post_empty_content;

  /// No description provided for @create_post_failed.
  ///
  /// In zh, this message translates to:
  /// **'发布失败，请重试'**
  String get create_post_failed;

  /// No description provided for @create_post_hint_content.
  ///
  /// In zh, this message translates to:
  /// **'说点什么吧，分享你的运动心得...'**
  String get create_post_hint_content;

  /// No description provided for @create_post_preview_format.
  ///
  /// In zh, this message translates to:
  /// **'今日数据预览：%1\$d 步 | %2\$d 千卡'**
  String get create_post_preview_format;

  /// No description provided for @create_post_preview_placeholder.
  ///
  /// In zh, this message translates to:
  /// **'今日数据预览：8520 步 | 420 千卡'**
  String get create_post_preview_placeholder;

  /// No description provided for @create_post_success.
  ///
  /// In zh, this message translates to:
  /// **'发布成功！'**
  String get create_post_success;

  /// No description provided for @create_post_title.
  ///
  /// In zh, this message translates to:
  /// **'发布动态'**
  String get create_post_title;

  /// No description provided for @current_coin.
  ///
  /// In zh, this message translates to:
  /// **'当前金币'**
  String get current_coin;

  /// No description provided for @current_money.
  ///
  /// In zh, this message translates to:
  /// **'可提现金额(元)'**
  String get current_money;

  /// No description provided for @data_export_chooser_share_achievement.
  ///
  /// In zh, this message translates to:
  /// **'分享运动成就'**
  String get data_export_chooser_share_achievement;

  /// No description provided for @data_export_chooser_share_data.
  ///
  /// In zh, this message translates to:
  /// **'分享运动数据'**
  String get data_export_chooser_share_data;

  /// No description provided for @data_export_csv_header.
  ///
  /// In zh, this message translates to:
  /// **'日期,运动类型,时长(分钟),步数,热量(千卡),距离(公里)\\n'**
  String get data_export_csv_header;

  /// No description provided for @data_export_failed_format.
  ///
  /// In zh, this message translates to:
  /// **'导出失败：%1\$s'**
  String get data_export_failed_format;

  /// No description provided for @data_export_share_calories_format.
  ///
  /// In zh, this message translates to:
  /// **'消耗 %1\$d 千卡\\n\\n'**
  String get data_export_share_calories_format;

  /// No description provided for @data_export_share_hashtags.
  ///
  /// In zh, this message translates to:
  /// **'#运动打卡 #健康生活'**
  String get data_export_share_hashtags;

  /// No description provided for @data_export_share_title.
  ///
  /// In zh, this message translates to:
  /// **'🏃 我的运动成就 🏃\\n\\n'**
  String get data_export_share_title;

  /// No description provided for @data_export_share_total_duration_format.
  ///
  /// In zh, this message translates to:
  /// **'总时长 %1\$d 分钟\\n'**
  String get data_export_share_total_duration_format;

  /// No description provided for @data_export_share_weekly_count_format.
  ///
  /// In zh, this message translates to:
  /// **'本周运动 %1\$d 次\\n'**
  String get data_export_share_weekly_count_format;

  /// No description provided for @data_export_success_format.
  ///
  /// In zh, this message translates to:
  /// **'导出成功：%1\$s'**
  String get data_export_success_format;

  /// No description provided for @data_export_weekly_success.
  ///
  /// In zh, this message translates to:
  /// **'周报导出成功'**
  String get data_export_weekly_success;

  /// No description provided for @data_fragment_default_target_steps.
  ///
  /// In zh, this message translates to:
  /// **'6000'**
  String get data_fragment_default_target_steps;

  /// No description provided for @data_fragment_set_target_first.
  ///
  /// In zh, this message translates to:
  /// **'请先设置目标步数'**
  String get data_fragment_set_target_first;

  /// No description provided for @data_fragment_target_not_reached.
  ///
  /// In zh, this message translates to:
  /// **'尚未达成目标，继续加油！'**
  String get data_fragment_target_not_reached;

  /// No description provided for @data_fragment_target_reached.
  ///
  /// In zh, this message translates to:
  /// **'恭喜你，目标步数达成！'**
  String get data_fragment_target_reached;

  /// No description provided for @data_fragment_target_too_high.
  ///
  /// In zh, this message translates to:
  /// **'目标步数不能大于10000步'**
  String get data_fragment_target_too_high;

  /// No description provided for @data_fragment_target_too_low.
  ///
  /// In zh, this message translates to:
  /// **'目标步数不能小于3000步'**
  String get data_fragment_target_too_low;

  /// No description provided for @data_fragment_today_steps_format.
  ///
  /// In zh, this message translates to:
  /// **'今日步数：%1\$d步'**
  String get data_fragment_today_steps_format;

  /// No description provided for @data_load_failed.
  ///
  /// In zh, this message translates to:
  /// **'数据加载失败'**
  String get data_load_failed;

  /// No description provided for @data_title_1.
  ///
  /// In zh, this message translates to:
  /// **'里程'**
  String get data_title_1;

  /// No description provided for @data_title_2.
  ///
  /// In zh, this message translates to:
  /// **'时长'**
  String get data_title_2;

  /// No description provided for @data_title_3.
  ///
  /// In zh, this message translates to:
  /// **'卡路里'**
  String get data_title_3;

  /// No description provided for @dec.
  ///
  /// In zh, this message translates to:
  /// **'12月'**
  String get dec;

  /// No description provided for @default_user.
  ///
  /// In zh, this message translates to:
  /// **'用户'**
  String get default_user;

  /// No description provided for @deny.
  ///
  /// In zh, this message translates to:
  /// **'拒绝'**
  String get deny;

  /// No description provided for @deny_permission.
  ///
  /// In zh, this message translates to:
  /// **'拒绝权限将导致某些功能无法正常使用,请打开设置到应用详情页打开权限'**
  String get deny_permission;

  /// No description provided for @dialog_ok.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get dialog_ok;

  /// No description provided for @diastolic.
  ///
  /// In zh, this message translates to:
  /// **'舒张压'**
  String get diastolic;

  /// No description provided for @diet_record_added_calories_format.
  ///
  /// In zh, this message translates to:
  /// **'已记录 %1\$d千卡'**
  String get diet_record_added_calories_format;

  /// No description provided for @diet_target_set_format.
  ///
  /// In zh, this message translates to:
  /// **'目标已设置为 %1\$d千卡'**
  String get diet_target_set_format;

  /// No description provided for @doing_sport_unlock_achievement_format.
  ///
  /// In zh, this message translates to:
  /// **'🏆 解锁新成就: %1\$s'**
  String get doing_sport_unlock_achievement_format;

  /// No description provided for @double_coin_fail_hint.
  ///
  /// In zh, this message translates to:
  /// **'奖励已提交，到账后余额自动更新'**
  String get double_coin_fail_hint;

  /// No description provided for @double_coin_hint.
  ///
  /// In zh, this message translates to:
  /// **'奖励已提交，预计到账 +%1\$s 金币，余额会自动更新'**
  String get double_coin_hint;

  /// No description provided for @everyday_target_steps.
  ///
  /// In zh, this message translates to:
  /// **'每日目标步数'**
  String get everyday_target_steps;

  /// No description provided for @exercise.
  ///
  /// In zh, this message translates to:
  /// **'运动'**
  String get exercise;

  /// No description provided for @exercise_performance.
  ///
  /// In zh, this message translates to:
  /// **'运动表现'**
  String get exercise_performance;

  /// No description provided for @exit_app.
  ///
  /// In zh, this message translates to:
  /// **'再点击一次退出程序'**
  String get exit_app;

  /// No description provided for @export_body_success.
  ///
  /// In zh, this message translates to:
  /// **'身体记录已导出'**
  String get export_body_success;

  /// No description provided for @export_workout_success.
  ///
  /// In zh, this message translates to:
  /// **'运动记录已导出'**
  String get export_workout_success;

  /// No description provided for @feb.
  ///
  /// In zh, this message translates to:
  /// **'2月'**
  String get feb;

  /// No description provided for @first_for_user_hint.
  ///
  /// In zh, this message translates to:
  /// **'1.为了能让产品功能正常运行，我们可能会使用存储权限，用于存储您使用中生成的数据，如设置、日志等;\\n\n    2.友盟、头条将需要收集您的设备Mac地址、唯一设备识别码（IMEI/android ID/IDFA/OPENUDID/GUID、SIM卡IMSI信息）以提供统计分析服务，并通过地理位置校准报表数据准确性，提供基础反作弊能力；\\n\n    3.未经您的同意，我们不会从第三方获取或对外提供你的信息；\\n'**
  String get first_for_user_hint;

  /// No description provided for @first_for_user_hint5.
  ///
  /// In zh, this message translates to:
  /// **'查看《用户协议》和'**
  String get first_for_user_hint5;

  /// No description provided for @first_for_user_hint6.
  ///
  /// In zh, this message translates to:
  /// **'《隐私协议》'**
  String get first_for_user_hint6;

  /// No description provided for @first_for_user_hint_title.
  ///
  /// In zh, this message translates to:
  /// **'用户隐私政策须知'**
  String get first_for_user_hint_title;

  /// No description provided for @fri.
  ///
  /// In zh, this message translates to:
  /// **'周五'**
  String get fri;

  /// No description provided for @get_all_money_num.
  ///
  /// In zh, this message translates to:
  /// **'全部提现'**
  String get get_all_money_num;

  /// No description provided for @get_coin.
  ///
  /// In zh, this message translates to:
  /// **'领取金币'**
  String get get_coin;

  /// No description provided for @get_coin_hint.
  ///
  /// In zh, this message translates to:
  /// **'每1500步可以换取80金币'**
  String get get_coin_hint;

  /// No description provided for @get_coin_in_ad.
  ///
  /// In zh, this message translates to:
  /// **'恭喜您获得%1\$s'**
  String get get_coin_in_ad;

  /// No description provided for @get_coin_s.
  ///
  /// In zh, this message translates to:
  /// **'领取金币'**
  String get get_coin_s;

  /// No description provided for @get_money.
  ///
  /// In zh, this message translates to:
  /// **'提现'**
  String get get_money;

  /// No description provided for @get_money_hint.
  ///
  /// In zh, this message translates to:
  /// **'提现成功，请前往支付宝账单查看奖励。'**
  String get get_money_hint;

  /// No description provided for @get_money_num.
  ///
  /// In zh, this message translates to:
  /// **'提现到支付宝'**
  String get get_money_num;

  /// No description provided for @get_money_num_hint.
  ///
  /// In zh, this message translates to:
  /// **'1. 使用支付宝提现，一般两小时到帐，请自行查询账单\\n2. 提现金额包含1元、5元、10元、20元、50元额度，无手续费\\n3. 每日提现次数无限制，可多次提现'**
  String get get_money_num_hint;

  /// No description provided for @get_money_num_title.
  ///
  /// In zh, this message translates to:
  /// **'提现说明'**
  String get get_money_num_title;

  /// No description provided for @get_money_record.
  ///
  /// In zh, this message translates to:
  /// **'提现记录'**
  String get get_money_record;

  /// No description provided for @get_random_coin_reward.
  ///
  /// In zh, this message translates to:
  /// **'获取随机金币'**
  String get get_random_coin_reward;

  /// No description provided for @get_reward_failed.
  ///
  /// In zh, this message translates to:
  /// **'获取失败，请稍后再试'**
  String get get_reward_failed;

  /// No description provided for @get_step_target_reward.
  ///
  /// In zh, this message translates to:
  /// **'领取步数达标奖励'**
  String get get_step_target_reward;

  /// No description provided for @get_sync_step_reward.
  ///
  /// In zh, this message translates to:
  /// **'同步步数成功，前往任务领取奖励'**
  String get get_sync_step_reward;

  /// No description provided for @get_target_reward.
  ///
  /// In zh, this message translates to:
  /// **'领取达成奖励'**
  String get get_target_reward;

  /// No description provided for @go_sign.
  ///
  /// In zh, this message translates to:
  /// **'去签到'**
  String get go_sign;

  /// No description provided for @go_to_achieve.
  ///
  /// In zh, this message translates to:
  /// **'去完成'**
  String get go_to_achieve;

  /// No description provided for @goal_detail_footer_hint.
  ///
  /// In zh, this message translates to:
  /// **'继续保持，稳步达成今日目标'**
  String get goal_detail_footer_hint;

  /// No description provided for @google_fit_client_id.
  ///
  /// In zh, this message translates to:
  /// **'530383953471-7psjpq1s7tv1kj3ckd8orq10rjp8v3ha.apps.googleusercontent.com'**
  String get google_fit_client_id;

  /// No description provided for @health_center.
  ///
  /// In zh, this message translates to:
  /// **'健康概览'**
  String get health_center;

  /// No description provided for @health_center_desc.
  ///
  /// In zh, this message translates to:
  /// **'全面的健康记录与智能分析'**
  String get health_center_desc;

  /// No description provided for @health_chart_axis_exercise_duration.
  ///
  /// In zh, this message translates to:
  /// **'运动时长'**
  String get health_chart_axis_exercise_duration;

  /// No description provided for @health_chart_axis_exercise_intensity.
  ///
  /// In zh, this message translates to:
  /// **'运动强度'**
  String get health_chart_axis_exercise_intensity;

  /// No description provided for @health_chart_desc_glucose_trend.
  ///
  /// In zh, this message translates to:
  /// **'血糖趋势'**
  String get health_chart_desc_glucose_trend;

  /// No description provided for @health_chart_desc_hr_analysis.
  ///
  /// In zh, this message translates to:
  /// **'心率分析'**
  String get health_chart_desc_hr_analysis;

  /// No description provided for @health_chart_label_weight_kg.
  ///
  /// In zh, this message translates to:
  /// **'体重 (kg)'**
  String get health_chart_label_weight_kg;

  /// No description provided for @health_chart_limit_diabetes_diagnosis.
  ///
  /// In zh, this message translates to:
  /// **'糖尿病诊断'**
  String get health_chart_limit_diabetes_diagnosis;

  /// No description provided for @health_chart_limit_fasting_normal_upper.
  ///
  /// In zh, this message translates to:
  /// **'空腹正常上限'**
  String get health_chart_limit_fasting_normal_upper;

  /// No description provided for @health_chart_limit_normal_upper.
  ///
  /// In zh, this message translates to:
  /// **'正常上限'**
  String get health_chart_limit_normal_upper;

  /// No description provided for @health_chart_score_center_text.
  ///
  /// In zh, this message translates to:
  /// **'%1\$d\\n分'**
  String get health_chart_score_center_text;

  /// No description provided for @health_dashboard_action_bp_monitor.
  ///
  /// In zh, this message translates to:
  /// **'血压监测'**
  String get health_dashboard_action_bp_monitor;

  /// No description provided for @health_dashboard_action_data_analysis.
  ///
  /// In zh, this message translates to:
  /// **'数据分析'**
  String get health_dashboard_action_data_analysis;

  /// No description provided for @health_dashboard_action_guided_workout.
  ///
  /// In zh, this message translates to:
  /// **'引导训练'**
  String get health_dashboard_action_guided_workout;

  /// No description provided for @health_dashboard_action_measure_weight.
  ///
  /// In zh, this message translates to:
  /// **'测量体重'**
  String get health_dashboard_action_measure_weight;

  /// No description provided for @health_dashboard_action_today_exercise.
  ///
  /// In zh, this message translates to:
  /// **'今日运动'**
  String get health_dashboard_action_today_exercise;

  /// No description provided for @health_dashboard_category_body_comp.
  ///
  /// In zh, this message translates to:
  /// **'身体成分'**
  String get health_dashboard_category_body_comp;

  /// No description provided for @health_dashboard_category_bp.
  ///
  /// In zh, this message translates to:
  /// **'血压监测'**
  String get health_dashboard_category_bp;

  /// No description provided for @health_dashboard_category_exercise.
  ///
  /// In zh, this message translates to:
  /// **'运动表现'**
  String get health_dashboard_category_exercise;

  /// No description provided for @health_dashboard_category_recovery.
  ///
  /// In zh, this message translates to:
  /// **'恢复状态'**
  String get health_dashboard_category_recovery;

  /// No description provided for @health_dashboard_category_training_plan.
  ///
  /// In zh, this message translates to:
  /// **'训练计划'**
  String get health_dashboard_category_training_plan;

  /// No description provided for @health_dashboard_current_plan.
  ///
  /// In zh, this message translates to:
  /// **'当前计划'**
  String get health_dashboard_current_plan;

  /// No description provided for @health_dashboard_date_pattern.
  ///
  /// In zh, this message translates to:
  /// **'yyyy年MM月dd日 EEEE'**
  String get health_dashboard_date_pattern;

  /// No description provided for @health_dashboard_glucose_unit_mmol.
  ///
  /// In zh, this message translates to:
  /// **'毫摩尔/升'**
  String get health_dashboard_glucose_unit_mmol;

  /// No description provided for @health_dashboard_insight_bp_high.
  ///
  /// In zh, this message translates to:
  /// **'血压偏高，建议咨询医生并调整生活方式'**
  String get health_dashboard_insight_bp_high;

  /// No description provided for @health_dashboard_insight_bp_normal.
  ///
  /// In zh, this message translates to:
  /// **'血压水平正常，继续保持健康生活方式'**
  String get health_dashboard_insight_bp_normal;

  /// No description provided for @health_dashboard_insight_hrv_attention.
  ///
  /// In zh, this message translates to:
  /// **'心率变异性偏低，建议注意休息和恢复'**
  String get health_dashboard_insight_hrv_attention;

  /// No description provided for @health_dashboard_insight_hrv_excellent.
  ///
  /// In zh, this message translates to:
  /// **'心率变异性优秀，身体恢复能力强'**
  String get health_dashboard_insight_hrv_excellent;

  /// No description provided for @health_dashboard_insight_no_exercise.
  ///
  /// In zh, this message translates to:
  /// **'本周尚未运动，建议制定运动计划'**
  String get health_dashboard_insight_no_exercise;

  /// No description provided for @health_dashboard_insight_no_plan.
  ///
  /// In zh, this message translates to:
  /// **'尚未设置训练计划，建议先创建每周计划'**
  String get health_dashboard_insight_no_plan;

  /// No description provided for @health_dashboard_insight_weight_down_format.
  ///
  /// In zh, this message translates to:
  /// **'本周体重下降%.1f公斤，保持良好状态'**
  String get health_dashboard_insight_weight_down_format;

  /// No description provided for @health_dashboard_insight_weight_stable.
  ///
  /// In zh, this message translates to:
  /// **'近期变化平稳，继续保持当前节奏'**
  String get health_dashboard_insight_weight_stable;

  /// No description provided for @health_dashboard_insight_weight_up_format.
  ///
  /// In zh, this message translates to:
  /// **'本周体重上升%.1f公斤，建议关注饮食控制'**
  String get health_dashboard_insight_weight_up_format;

  /// No description provided for @health_dashboard_record_option_bp.
  ///
  /// In zh, this message translates to:
  /// **'血压记录'**
  String get health_dashboard_record_option_bp;

  /// No description provided for @health_dashboard_record_option_exercise.
  ///
  /// In zh, this message translates to:
  /// **'运动记录'**
  String get health_dashboard_record_option_exercise;

  /// No description provided for @health_dashboard_record_option_glucose.
  ///
  /// In zh, this message translates to:
  /// **'血糖记录'**
  String get health_dashboard_record_option_glucose;

  /// No description provided for @health_dashboard_record_option_hr.
  ///
  /// In zh, this message translates to:
  /// **'心率记录'**
  String get health_dashboard_record_option_hr;

  /// No description provided for @health_dashboard_schedule_duration_format.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s · %2\$d分钟'**
  String get health_dashboard_schedule_duration_format;

  /// No description provided for @health_dashboard_schedule_pending.
  ///
  /// In zh, this message translates to:
  /// **'待完成'**
  String get health_dashboard_schedule_pending;

  /// No description provided for @health_dashboard_schedule_training_task.
  ///
  /// In zh, this message translates to:
  /// **'训练任务'**
  String get health_dashboard_schedule_training_task;

  /// No description provided for @health_dashboard_score_head_good.
  ///
  /// In zh, this message translates to:
  /// **'综合评分（满分100）'**
  String get health_dashboard_score_head_good;

  /// No description provided for @health_dashboard_score_head_need_improve.
  ///
  /// In zh, this message translates to:
  /// **'需要改善（满分100）'**
  String get health_dashboard_score_head_need_improve;

  /// No description provided for @health_dashboard_score_item_body.
  ///
  /// In zh, this message translates to:
  /// **'身体成分/BMI'**
  String get health_dashboard_score_item_body;

  /// No description provided for @health_dashboard_score_item_bp.
  ///
  /// In zh, this message translates to:
  /// **'血压'**
  String get health_dashboard_score_item_bp;

  /// No description provided for @health_dashboard_score_item_exercise.
  ///
  /// In zh, this message translates to:
  /// **'运动'**
  String get health_dashboard_score_item_exercise;

  /// No description provided for @health_dashboard_score_item_hrv.
  ///
  /// In zh, this message translates to:
  /// **'HRV'**
  String get health_dashboard_score_item_hrv;

  /// No description provided for @health_dashboard_score_line_missing.
  ///
  /// In zh, this message translates to:
  /// **'• %1\$s：未参与评分（缺少数据）'**
  String get health_dashboard_score_line_missing;

  /// No description provided for @health_dashboard_score_line_value.
  ///
  /// In zh, this message translates to:
  /// **'• %1\$s：%2\$d/25（%3\$s）'**
  String get health_dashboard_score_line_value;

  /// No description provided for @health_dashboard_score_rule_bmi.
  ///
  /// In zh, this message translates to:
  /// **'BMI区间评分'**
  String get health_dashboard_score_rule_bmi;

  /// No description provided for @health_dashboard_score_rule_bp.
  ///
  /// In zh, this message translates to:
  /// **'收缩压/舒张压评分'**
  String get health_dashboard_score_rule_bp;

  /// No description provided for @health_dashboard_score_rule_exercise.
  ///
  /// In zh, this message translates to:
  /// **'按本周运动次数评分'**
  String get health_dashboard_score_rule_exercise;

  /// No description provided for @health_dashboard_score_rule_hrv.
  ///
  /// In zh, this message translates to:
  /// **'按RMSSD恢复能力评分'**
  String get health_dashboard_score_rule_hrv;

  /// No description provided for @health_dashboard_score_suggestion_format.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s\\n建议：%2\$s'**
  String get health_dashboard_score_suggestion_format;

  /// No description provided for @health_dashboard_weight_status_bmi_format.
  ///
  /// In zh, this message translates to:
  /// **'BMI %1\$.1f · %2\$s'**
  String get health_dashboard_weight_status_bmi_format;

  /// No description provided for @health_dashboard_weight_status_stable.
  ///
  /// In zh, this message translates to:
  /// **'状态稳定'**
  String get health_dashboard_weight_status_stable;

  /// No description provided for @health_insights.
  ///
  /// In zh, this message translates to:
  /// **'健康洞察'**
  String get health_insights;

  /// No description provided for @health_records_title.
  ///
  /// In zh, this message translates to:
  /// **'健康记录'**
  String get health_records_title;

  /// No description provided for @health_score.
  ///
  /// In zh, this message translates to:
  /// **'健康评分'**
  String get health_score;

  /// No description provided for @health_str.
  ///
  /// In zh, this message translates to:
  /// **'健康'**
  String get health_str;

  /// No description provided for @health_viz_category_bp_monitoring.
  ///
  /// In zh, this message translates to:
  /// **'血压监测'**
  String get health_viz_category_bp_monitoring;

  /// No description provided for @health_viz_category_exercise_performance.
  ///
  /// In zh, this message translates to:
  /// **'运动表现'**
  String get health_viz_category_exercise_performance;

  /// No description provided for @health_viz_category_weight_management.
  ///
  /// In zh, this message translates to:
  /// **'体重管理'**
  String get health_viz_category_weight_management;

  /// No description provided for @health_viz_chart_desc_bp_trend.
  ///
  /// In zh, this message translates to:
  /// **'血压趋势'**
  String get health_viz_chart_desc_bp_trend;

  /// No description provided for @health_viz_chart_desc_exercise_type_distribution.
  ///
  /// In zh, this message translates to:
  /// **'运动类型分布'**
  String get health_viz_chart_desc_exercise_type_distribution;

  /// No description provided for @health_viz_chart_desc_exercise_volume.
  ///
  /// In zh, this message translates to:
  /// **'运动量统计'**
  String get health_viz_chart_desc_exercise_volume;

  /// No description provided for @health_viz_chart_desc_glucose_change.
  ///
  /// In zh, this message translates to:
  /// **'血糖变化'**
  String get health_viz_chart_desc_glucose_change;

  /// No description provided for @health_viz_chart_desc_hr_change.
  ///
  /// In zh, this message translates to:
  /// **'心率变化'**
  String get health_viz_chart_desc_hr_change;

  /// No description provided for @health_viz_chart_desc_weight_trend.
  ///
  /// In zh, this message translates to:
  /// **'体重趋势'**
  String get health_viz_chart_desc_weight_trend;

  /// No description provided for @health_viz_insight_bp_normal.
  ///
  /// In zh, this message translates to:
  /// **'血压正常'**
  String get health_viz_insight_bp_normal;

  /// No description provided for @health_viz_insight_exercise_frequency_good.
  ///
  /// In zh, this message translates to:
  /// **'运动频率良好'**
  String get health_viz_insight_exercise_frequency_good;

  /// No description provided for @health_viz_insight_weight_stable.
  ///
  /// In zh, this message translates to:
  /// **'体重控制稳定'**
  String get health_viz_insight_weight_stable;

  /// No description provided for @health_viz_label_aerobic_exercise.
  ///
  /// In zh, this message translates to:
  /// **'有氧运动'**
  String get health_viz_label_aerobic_exercise;

  /// No description provided for @health_viz_label_avg_heart_rate.
  ///
  /// In zh, this message translates to:
  /// **'平均心率'**
  String get health_viz_label_avg_heart_rate;

  /// No description provided for @health_viz_label_ball_sports.
  ///
  /// In zh, this message translates to:
  /// **'球类运动'**
  String get health_viz_label_ball_sports;

  /// No description provided for @health_viz_label_diastolic.
  ///
  /// In zh, this message translates to:
  /// **'舒张压'**
  String get health_viz_label_diastolic;

  /// No description provided for @health_viz_label_exercise_duration_min.
  ///
  /// In zh, this message translates to:
  /// **'运动时长 (分钟)'**
  String get health_viz_label_exercise_duration_min;

  /// No description provided for @health_viz_label_flexibility_training.
  ///
  /// In zh, this message translates to:
  /// **'柔韧性训练'**
  String get health_viz_label_flexibility_training;

  /// No description provided for @health_viz_label_glucose_value.
  ///
  /// In zh, this message translates to:
  /// **'血糖值'**
  String get health_viz_label_glucose_value;

  /// No description provided for @health_viz_label_hrv.
  ///
  /// In zh, this message translates to:
  /// **'心率变异性'**
  String get health_viz_label_hrv;

  /// No description provided for @health_viz_label_no_data.
  ///
  /// In zh, this message translates to:
  /// **'暂无数据'**
  String get health_viz_label_no_data;

  /// No description provided for @health_viz_label_strength_training.
  ///
  /// In zh, this message translates to:
  /// **'力量训练'**
  String get health_viz_label_strength_training;

  /// No description provided for @health_viz_label_systolic.
  ///
  /// In zh, this message translates to:
  /// **'收缩压'**
  String get health_viz_label_systolic;

  /// No description provided for @health_viz_label_weight_kg.
  ///
  /// In zh, this message translates to:
  /// **'体重（公斤）'**
  String get health_viz_label_weight_kg;

  /// No description provided for @health_viz_range_month.
  ///
  /// In zh, this message translates to:
  /// **'近一月'**
  String get health_viz_range_month;

  /// No description provided for @health_viz_range_quarter.
  ///
  /// In zh, this message translates to:
  /// **'近三月'**
  String get health_viz_range_quarter;

  /// No description provided for @health_viz_range_week.
  ///
  /// In zh, this message translates to:
  /// **'近一周'**
  String get health_viz_range_week;

  /// No description provided for @health_viz_range_year.
  ///
  /// In zh, this message translates to:
  /// **'近一年'**
  String get health_viz_range_year;

  /// No description provided for @health_viz_report_exercise_title.
  ///
  /// In zh, this message translates to:
  /// **'运动表现分析'**
  String get health_viz_report_exercise_title;

  /// No description provided for @health_viz_report_vitals_desc.
  ///
  /// In zh, this message translates to:
  /// **'血压、心率等生命体征数据分析'**
  String get health_viz_report_vitals_desc;

  /// No description provided for @health_viz_report_vitals_title.
  ///
  /// In zh, this message translates to:
  /// **'生命体征报告'**
  String get health_viz_report_vitals_title;

  /// No description provided for @health_viz_report_weekly_desc.
  ///
  /// In zh, this message translates to:
  /// **'综合分析本周的健康数据表现'**
  String get health_viz_report_weekly_desc;

  /// No description provided for @health_viz_report_weekly_title.
  ///
  /// In zh, this message translates to:
  /// **'周度健康报告'**
  String get health_viz_report_weekly_title;

  /// No description provided for @health_viz_title_bp.
  ///
  /// In zh, this message translates to:
  /// **'血压监控分析'**
  String get health_viz_title_bp;

  /// No description provided for @health_viz_title_exercise.
  ///
  /// In zh, this message translates to:
  /// **'运动数据分析'**
  String get health_viz_title_exercise;

  /// No description provided for @health_viz_title_glucose.
  ///
  /// In zh, this message translates to:
  /// **'血糖控制分析'**
  String get health_viz_title_glucose;

  /// No description provided for @health_viz_title_hr.
  ///
  /// In zh, this message translates to:
  /// **'心率变异分析'**
  String get health_viz_title_hr;

  /// No description provided for @health_viz_title_overview.
  ///
  /// In zh, this message translates to:
  /// **'健康数据总览'**
  String get health_viz_title_overview;

  /// No description provided for @health_viz_title_weight.
  ///
  /// In zh, this message translates to:
  /// **'体重趋势分析'**
  String get health_viz_title_weight;

  /// No description provided for @health_viz_toast_view_report_format.
  ///
  /// In zh, this message translates to:
  /// **'查看报告: %1\$s'**
  String get health_viz_toast_view_report_format;

  /// No description provided for @health_viz_trend_downward.
  ///
  /// In zh, this message translates to:
  /// **'(下降趋势)\\n'**
  String get health_viz_trend_downward;

  /// No description provided for @health_viz_trend_significant_down.
  ///
  /// In zh, this message translates to:
  /// **'(显著下降)\\n'**
  String get health_viz_trend_significant_down;

  /// No description provided for @health_viz_trend_significant_up.
  ///
  /// In zh, this message translates to:
  /// **'(显著上升)\\n'**
  String get health_viz_trend_significant_up;

  /// No description provided for @health_viz_trend_upward.
  ///
  /// In zh, this message translates to:
  /// **'(上升趋势)\\n'**
  String get health_viz_trend_upward;

  /// No description provided for @heart_rate.
  ///
  /// In zh, this message translates to:
  /// **'心率'**
  String get heart_rate;

  /// No description provided for @hydration_factor_format.
  ///
  /// In zh, this message translates to:
  /// **'补水系数 %1\$d%%'**
  String get hydration_factor_format;

  /// No description provided for @icon.
  ///
  /// In zh, this message translates to:
  /// **'头像'**
  String get icon;

  /// No description provided for @invite_friend.
  ///
  /// In zh, this message translates to:
  /// **'邀请好友'**
  String get invite_friend;

  /// No description provided for @jan.
  ///
  /// In zh, this message translates to:
  /// **'1月'**
  String get jan;

  /// No description provided for @jul.
  ///
  /// In zh, this message translates to:
  /// **'7月'**
  String get jul;

  /// No description provided for @jun.
  ///
  /// In zh, this message translates to:
  /// **'6月'**
  String get jun;

  /// No description provided for @kcal_format.
  ///
  /// In zh, this message translates to:
  /// **'%1\$d 千卡'**
  String get kcal_format;

  /// No description provided for @kcal_format_k.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s 千卡'**
  String get kcal_format_k;

  /// No description provided for @label_settext_9de0d246a9.
  ///
  /// In zh, this message translates to:
  /// **'米'**
  String get label_settext_9de0d246a9;

  /// No description provided for @leaderboard_mock_1.
  ///
  /// In zh, this message translates to:
  /// **'奔跑的蜗牛'**
  String get leaderboard_mock_1;

  /// No description provided for @leaderboard_mock_2.
  ///
  /// In zh, this message translates to:
  /// **'燃脂达人'**
  String get leaderboard_mock_2;

  /// No description provided for @leaderboard_mock_3.
  ///
  /// In zh, this message translates to:
  /// **'健身英雄'**
  String get leaderboard_mock_3;

  /// No description provided for @leaderboard_mock_4.
  ///
  /// In zh, this message translates to:
  /// **'李艾力'**
  String get leaderboard_mock_4;

  /// No description provided for @leaderboard_mock_5.
  ///
  /// In zh, this message translates to:
  /// **'健康伙伴'**
  String get leaderboard_mock_5;

  /// No description provided for @leaderboard_mock_6.
  ///
  /// In zh, this message translates to:
  /// **'闲庭信步'**
  String get leaderboard_mock_6;

  /// No description provided for @leaderboard_mock_7.
  ///
  /// In zh, this message translates to:
  /// **'休息大师'**
  String get leaderboard_mock_7;

  /// No description provided for @level_advanced.
  ///
  /// In zh, this message translates to:
  /// **'高级'**
  String get level_advanced;

  /// No description provided for @level_beginner.
  ///
  /// In zh, this message translates to:
  /// **'入门'**
  String get level_beginner;

  /// No description provided for @level_intermediate.
  ///
  /// In zh, this message translates to:
  /// **'中级'**
  String get level_intermediate;

  /// No description provided for @location.
  ///
  /// In zh, this message translates to:
  /// **'所在地'**
  String get location;

  /// No description provided for @luck_reward.
  ///
  /// In zh, this message translates to:
  /// **'幸运大抽奖'**
  String get luck_reward;

  /// No description provided for @luck_reward_times.
  ///
  /// In zh, this message translates to:
  /// **'你还有%1\$s次抽奖机会'**
  String get luck_reward_times;

  /// No description provided for @luck_reward_times_hint.
  ///
  /// In zh, this message translates to:
  /// **'1.用户参与抽奖活动表示同意接受此规则。\\n2.用户每日拥有一次抽奖机会。\\n3.获取奖励后可以通过看视频翻倍。\\n4.奖励可在钱包内奖励记录查看。'**
  String get luck_reward_times_hint;

  /// No description provided for @luck_reward_times_title.
  ///
  /// In zh, this message translates to:
  /// **'抽奖规则'**
  String get luck_reward_times_title;

  /// No description provided for @main_card_data_title_all_sport.
  ///
  /// In zh, this message translates to:
  /// **'全部运动'**
  String get main_card_data_title_all_sport;

  /// No description provided for @main_card_data_title_sport_burn.
  ///
  /// In zh, this message translates to:
  /// **'运动消耗'**
  String get main_card_data_title_sport_burn;

  /// No description provided for @main_card_data_title_step_stats.
  ///
  /// In zh, this message translates to:
  /// **'步数统计'**
  String get main_card_data_title_step_stats;

  /// No description provided for @main_card_data_title_walk_distance.
  ///
  /// In zh, this message translates to:
  /// **'走路距离'**
  String get main_card_data_title_walk_distance;

  /// No description provided for @main_card_data_title_weight_record.
  ///
  /// In zh, this message translates to:
  /// **'体重记录'**
  String get main_card_data_title_weight_record;

  /// No description provided for @main_stats_month_suffix_format.
  ///
  /// In zh, this message translates to:
  /// **'%1\$d月'**
  String get main_stats_month_suffix_format;

  /// No description provided for @main_stats_title_achieved_period_count.
  ///
  /// In zh, this message translates to:
  /// **'达标期数'**
  String get main_stats_title_achieved_period_count;

  /// No description provided for @main_stats_title_active_period_count.
  ///
  /// In zh, this message translates to:
  /// **'活跃期数'**
  String get main_stats_title_active_period_count;

  /// No description provided for @main_stats_title_avg_period_burn.
  ///
  /// In zh, this message translates to:
  /// **'平均每期消耗'**
  String get main_stats_title_avg_period_burn;

  /// No description provided for @main_stats_title_avg_period_count.
  ///
  /// In zh, this message translates to:
  /// **'平均每期次数'**
  String get main_stats_title_avg_period_count;

  /// No description provided for @main_stats_title_avg_period_data.
  ///
  /// In zh, this message translates to:
  /// **'平均每期数据'**
  String get main_stats_title_avg_period_data;

  /// No description provided for @main_stats_title_avg_period_duration.
  ///
  /// In zh, this message translates to:
  /// **'平均每期时长'**
  String get main_stats_title_avg_period_duration;

  /// No description provided for @main_stats_title_history_max.
  ///
  /// In zh, this message translates to:
  /// **'历史最高'**
  String get main_stats_title_history_max;

  /// No description provided for @main_stats_title_history_min.
  ///
  /// In zh, this message translates to:
  /// **'历史最低'**
  String get main_stats_title_history_min;

  /// No description provided for @main_stats_title_longest_month.
  ///
  /// In zh, this message translates to:
  /// **'最长月份'**
  String get main_stats_title_longest_month;

  /// No description provided for @main_stats_title_longest_sport_day.
  ///
  /// In zh, this message translates to:
  /// **'最长运动日'**
  String get main_stats_title_longest_sport_day;

  /// No description provided for @main_stats_title_peak_burn_day.
  ///
  /// In zh, this message translates to:
  /// **'最高消耗日'**
  String get main_stats_title_peak_burn_day;

  /// No description provided for @main_stats_title_peak_month.
  ///
  /// In zh, this message translates to:
  /// **'最高月份'**
  String get main_stats_title_peak_month;

  /// No description provided for @main_stats_title_peak_record.
  ///
  /// In zh, this message translates to:
  /// **'最高纪录'**
  String get main_stats_title_peak_record;

  /// No description provided for @main_stats_title_peak_single_day_count.
  ///
  /// In zh, this message translates to:
  /// **'最高单日次数'**
  String get main_stats_title_peak_single_day_count;

  /// No description provided for @main_stats_title_total_activity_count.
  ///
  /// In zh, this message translates to:
  /// **'总活动次数'**
  String get main_stats_title_total_activity_count;

  /// No description provided for @main_stats_title_total_burn.
  ///
  /// In zh, this message translates to:
  /// **'总消耗'**
  String get main_stats_title_total_burn;

  /// No description provided for @main_stats_title_total_distance.
  ///
  /// In zh, this message translates to:
  /// **'总距离'**
  String get main_stats_title_total_distance;

  /// No description provided for @main_stats_title_total_sport_burn.
  ///
  /// In zh, this message translates to:
  /// **'总运动消耗'**
  String get main_stats_title_total_sport_burn;

  /// No description provided for @main_stats_title_total_sport_duration.
  ///
  /// In zh, this message translates to:
  /// **'总运动时长'**
  String get main_stats_title_total_sport_duration;

  /// No description provided for @main_stats_title_total_steps.
  ///
  /// In zh, this message translates to:
  /// **'总步数'**
  String get main_stats_title_total_steps;

  /// No description provided for @main_stats_unit_count.
  ///
  /// In zh, this message translates to:
  /// **'次'**
  String get main_stats_unit_count;

  /// No description provided for @main_stats_unit_day.
  ///
  /// In zh, this message translates to:
  /// **'天'**
  String get main_stats_unit_day;

  /// No description provided for @main_stats_unit_hour.
  ///
  /// In zh, this message translates to:
  /// **'小时'**
  String get main_stats_unit_hour;

  /// No description provided for @main_stats_unit_kcal.
  ///
  /// In zh, this message translates to:
  /// **'千卡'**
  String get main_stats_unit_kcal;

  /// No description provided for @main_stats_unit_km.
  ///
  /// In zh, this message translates to:
  /// **'公里'**
  String get main_stats_unit_km;

  /// No description provided for @main_stats_unit_minute.
  ///
  /// In zh, this message translates to:
  /// **'分钟'**
  String get main_stats_unit_minute;

  /// No description provided for @main_stats_unit_month.
  ///
  /// In zh, this message translates to:
  /// **'月'**
  String get main_stats_unit_month;

  /// No description provided for @main_stats_unit_second.
  ///
  /// In zh, this message translates to:
  /// **'秒'**
  String get main_stats_unit_second;

  /// No description provided for @main_stats_unit_step.
  ///
  /// In zh, this message translates to:
  /// **'步'**
  String get main_stats_unit_step;

  /// No description provided for @manager_target_str.
  ///
  /// In zh, this message translates to:
  /// **'目标管理'**
  String get manager_target_str;

  /// No description provided for @mar.
  ///
  /// In zh, this message translates to:
  /// **'3月'**
  String get mar;

  /// No description provided for @mason_achievement.
  ///
  /// In zh, this message translates to:
  /// **'成就殿堂'**
  String get mason_achievement;

  /// No description provided for @mason_achievement_hint.
  ///
  /// In zh, this message translates to:
  /// **'成就越高，赚的越多'**
  String get mason_achievement_hint;

  /// No description provided for @mason_get_coin.
  ///
  /// In zh, this message translates to:
  /// **'立刻领取'**
  String get mason_get_coin;

  /// No description provided for @mason_get_first_money.
  ///
  /// In zh, this message translates to:
  /// **'完成第一笔体现奖励'**
  String get mason_get_first_money;

  /// No description provided for @mason_get_first_money_hint.
  ///
  /// In zh, this message translates to:
  /// **'提现红包到微信，零钱花不完'**
  String get mason_get_first_money_hint;

  /// No description provided for @mason_invite_friend.
  ///
  /// In zh, this message translates to:
  /// **'邀请好友赚金币'**
  String get mason_invite_friend;

  /// No description provided for @mason_invite_friend_hint.
  ///
  /// In zh, this message translates to:
  /// **'邀请升级奖励无上限'**
  String get mason_invite_friend_hint;

  /// No description provided for @mason_target_step.
  ///
  /// In zh, this message translates to:
  /// **'目标步数'**
  String get mason_target_step;

  /// No description provided for @mason_target_step_hint.
  ///
  /// In zh, this message translates to:
  /// **'设置步数越多赚的越多'**
  String get mason_target_step_hint;

  /// No description provided for @mason_task_ad.
  ///
  /// In zh, this message translates to:
  /// **'做海量任务领取金币'**
  String get mason_task_ad;

  /// No description provided for @mason_task_ad_hint.
  ///
  /// In zh, this message translates to:
  /// **'完成任务越多赚的越多'**
  String get mason_task_ad_hint;

  /// No description provided for @mason_video.
  ///
  /// In zh, this message translates to:
  /// **'看创意视频赚金币'**
  String get mason_video;

  /// No description provided for @mason_video_hint.
  ///
  /// In zh, this message translates to:
  /// **'海量视频，上不封顶'**
  String get mason_video_hint;

  /// No description provided for @mason_write_code.
  ///
  /// In zh, this message translates to:
  /// **'填写邀请码'**
  String get mason_write_code;

  /// No description provided for @mason_write_code_hint.
  ///
  /// In zh, this message translates to:
  /// **'填写你邀请人的邀请码'**
  String get mason_write_code_hint;

  /// No description provided for @may.
  ///
  /// In zh, this message translates to:
  /// **'5月'**
  String get may;

  /// No description provided for @me.
  ///
  /// In zh, this message translates to:
  /// **'我'**
  String get me;

  /// No description provided for @medal_wall_title.
  ///
  /// In zh, this message translates to:
  /// **'荣誉勋章'**
  String get medal_wall_title;

  /// No description provided for @meditation_pattern_box.
  ///
  /// In zh, this message translates to:
  /// **'箱式呼吸'**
  String get meditation_pattern_box;

  /// No description provided for @meditation_pattern_relaxed.
  ///
  /// In zh, this message translates to:
  /// **'放松呼吸'**
  String get meditation_pattern_relaxed;

  /// No description provided for @meditation_pattern_resonance.
  ///
  /// In zh, this message translates to:
  /// **'谐振呼吸'**
  String get meditation_pattern_resonance;

  /// No description provided for @meditation_sound_fire.
  ///
  /// In zh, this message translates to:
  /// **'篝火'**
  String get meditation_sound_fire;

  /// No description provided for @meditation_sound_off.
  ///
  /// In zh, this message translates to:
  /// **'声音关闭'**
  String get meditation_sound_off;

  /// No description provided for @meditation_sound_rain.
  ///
  /// In zh, this message translates to:
  /// **'雨声'**
  String get meditation_sound_rain;

  /// No description provided for @meditation_sound_waves.
  ///
  /// In zh, this message translates to:
  /// **'海浪'**
  String get meditation_sound_waves;

  /// No description provided for @meditation_summary_format.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s | %2\$d 分钟 | %3\$s'**
  String get meditation_summary_format;

  /// No description provided for @mobile.
  ///
  /// In zh, this message translates to:
  /// **'手机'**
  String get mobile;

  /// No description provided for @mock_delete_account_message.
  ///
  /// In zh, this message translates to:
  /// **'确定要注销此账号吗？注销后您的所有本地运动记录、步数和金币等数据都将被永久清空且不可恢复。'**
  String get mock_delete_account_message;

  /// No description provided for @modify_error.
  ///
  /// In zh, this message translates to:
  /// **'修改失败'**
  String get modify_error;

  /// No description provided for @modify_success.
  ///
  /// In zh, this message translates to:
  /// **'修改成功'**
  String get modify_success;

  /// No description provided for @mon.
  ///
  /// In zh, this message translates to:
  /// **'周一'**
  String get mon;

  /// No description provided for @mood_bad.
  ///
  /// In zh, this message translates to:
  /// **'差'**
  String get mood_bad;

  /// No description provided for @mood_good.
  ///
  /// In zh, this message translates to:
  /// **'好'**
  String get mood_good;

  /// No description provided for @mood_great.
  ///
  /// In zh, this message translates to:
  /// **'极好'**
  String get mood_great;

  /// No description provided for @mood_neutral.
  ///
  /// In zh, this message translates to:
  /// **'一般'**
  String get mood_neutral;

  /// No description provided for @mood_very_bad.
  ///
  /// In zh, this message translates to:
  /// **'极差'**
  String get mood_very_bad;

  /// No description provided for @must_login_error_login_format.
  ///
  /// In zh, this message translates to:
  /// **'登录失败: %1\$s'**
  String get must_login_error_login_format;

  /// No description provided for @must_login_error_register_format.
  ///
  /// In zh, this message translates to:
  /// **'注册失败: %1\$s'**
  String get must_login_error_register_format;

  /// No description provided for @my_coin.
  ///
  /// In zh, this message translates to:
  /// **'我的金币'**
  String get my_coin;

  /// No description provided for @my_info.
  ///
  /// In zh, this message translates to:
  /// **'我的信息'**
  String get my_info;

  /// No description provided for @my_invite_code.
  ///
  /// In zh, this message translates to:
  /// **'我的邀请码'**
  String get my_invite_code;

  /// No description provided for @my_invite_code_hint.
  ///
  /// In zh, this message translates to:
  /// **'注：1. 请勿用违规手段邀请好友，否则平台有权清除奖励。2. 受邀好友需要在下载应用的24小时内在设置中填入邀请码，否则邀请失效。'**
  String get my_invite_code_hint;

  /// No description provided for @my_money.
  ///
  /// In zh, this message translates to:
  /// **'我的钱包'**
  String get my_money;

  /// No description provided for @nick_name.
  ///
  /// In zh, this message translates to:
  /// **'昵称'**
  String get nick_name;

  /// No description provided for @no_sign.
  ///
  /// In zh, this message translates to:
  /// **'未签到'**
  String get no_sign;

  /// No description provided for @no_sign_date.
  ///
  /// In zh, this message translates to:
  /// **'未到时间'**
  String get no_sign_date;

  /// No description provided for @no_video_ad.
  ///
  /// In zh, this message translates to:
  /// **'当前网络不畅，稍后再来'**
  String get no_video_ad;

  /// No description provided for @notification_sync_service_label.
  ///
  /// In zh, this message translates to:
  /// **'智能同步后台'**
  String get notification_sync_service_label;

  /// No description provided for @nov.
  ///
  /// In zh, this message translates to:
  /// **'11月'**
  String get nov;

  /// No description provided for @oct.
  ///
  /// In zh, this message translates to:
  /// **'10月'**
  String get oct;

  /// No description provided for @onboarding_desc_1.
  ///
  /// In zh, this message translates to:
  /// **'自动记录步数和运动路线，让每一步都有意义。'**
  String get onboarding_desc_1;

  /// No description provided for @onboarding_desc_2.
  ///
  /// In zh, this message translates to:
  /// **'一站式追踪饮水、体重和训练计划。'**
  String get onboarding_desc_2;

  /// No description provided for @onboarding_desc_3.
  ///
  /// In zh, this message translates to:
  /// **'达成每日活动目标赚取金币，邀请好友获得更多奖励。'**
  String get onboarding_desc_3;

  /// No description provided for @onboarding_title_1.
  ///
  /// In zh, this message translates to:
  /// **'每日精准计步'**
  String get onboarding_title_1;

  /// No description provided for @onboarding_title_2.
  ///
  /// In zh, this message translates to:
  /// **'全方位健康管理'**
  String get onboarding_title_2;

  /// No description provided for @onboarding_title_3.
  ///
  /// In zh, this message translates to:
  /// **'达成目标赢奖励'**
  String get onboarding_title_3;

  /// No description provided for @outdoor_tracking.
  ///
  /// In zh, this message translates to:
  /// **'户外轨迹'**
  String get outdoor_tracking;

  /// No description provided for @permission.
  ///
  /// In zh, this message translates to:
  /// **'权限设置'**
  String get permission;

  /// No description provided for @plan_meta_format.
  ///
  /// In zh, this message translates to:
  /// **'%1\$d 训练日 | %2\$d 休息日'**
  String get plan_meta_format;

  /// No description provided for @plan_not_created.
  ///
  /// In zh, this message translates to:
  /// **'暂无计划'**
  String get plan_not_created;

  /// No description provided for @plan_reason_prefix.
  ///
  /// In zh, this message translates to:
  /// **'从\\\"%1\$s\\\"开始: %2\$s'**
  String get plan_reason_prefix;

  /// No description provided for @plan_recommendation_title.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s | %2\$s 推荐'**
  String get plan_recommendation_title;

  /// No description provided for @plan_tap_to_create.
  ///
  /// In zh, this message translates to:
  /// **'点击制定你的训练计划'**
  String get plan_tap_to_create;

  /// No description provided for @plan_task_format.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s | %2\$d 分钟'**
  String get plan_task_format;

  /// No description provided for @plan_today_completed.
  ///
  /// In zh, this message translates to:
  /// **'今日训练已完成 ✅'**
  String get plan_today_completed;

  /// No description provided for @plan_today_pending.
  ///
  /// In zh, this message translates to:
  /// **'今日训练待开始 ⏳'**
  String get plan_today_pending;

  /// No description provided for @prof_weight_save_failed.
  ///
  /// In zh, this message translates to:
  /// **'保存失败'**
  String get prof_weight_save_failed;

  /// No description provided for @prof_weight_save_success.
  ///
  /// In zh, this message translates to:
  /// **'保存成功'**
  String get prof_weight_save_success;

  /// No description provided for @prof_weight_update_failed.
  ///
  /// In zh, this message translates to:
  /// **'更新失败'**
  String get prof_weight_update_failed;

  /// No description provided for @prof_weight_update_success.
  ///
  /// In zh, this message translates to:
  /// **'更新成功'**
  String get prof_weight_update_success;

  /// No description provided for @pulse.
  ///
  /// In zh, this message translates to:
  /// **'脉搏'**
  String get pulse;

  /// No description provided for @quick_actions.
  ///
  /// In zh, this message translates to:
  /// **'快捷操作'**
  String get quick_actions;

  /// No description provided for @quick_login.
  ///
  /// In zh, this message translates to:
  /// **'立即登录'**
  String get quick_login;

  /// No description provided for @rate_us.
  ///
  /// In zh, this message translates to:
  /// **'评价我们'**
  String get rate_us;

  /// No description provided for @recovery_status.
  ///
  /// In zh, this message translates to:
  /// **'恢复状态'**
  String get recovery_status;

  /// No description provided for @sat.
  ///
  /// In zh, this message translates to:
  /// **'周六'**
  String get sat;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @sep.
  ///
  /// In zh, this message translates to:
  /// **'9月'**
  String get sep;

  /// No description provided for @set_sport_added_set_format.
  ///
  /// In zh, this message translates to:
  /// **'已添加第%1\$d组'**
  String get set_sport_added_set_format;

  /// No description provided for @set_target.
  ///
  /// In zh, this message translates to:
  /// **'设置目标'**
  String get set_target;

  /// No description provided for @settings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settings;

  /// No description provided for @settings_hint.
  ///
  /// In zh, this message translates to:
  /// **'一些通常的信息'**
  String get settings_hint;

  /// No description provided for @sex.
  ///
  /// In zh, this message translates to:
  /// **'性别'**
  String get sex;

  /// No description provided for @sgin_date.
  ///
  /// In zh, this message translates to:
  /// **'签到记录'**
  String get sgin_date;

  /// No description provided for @sgin_failed.
  ///
  /// In zh, this message translates to:
  /// **'签到失败'**
  String get sgin_failed;

  /// No description provided for @sgin_success.
  ///
  /// In zh, this message translates to:
  /// **'签到成功'**
  String get sgin_success;

  /// No description provided for @sgin_total_money.
  ///
  /// In zh, this message translates to:
  /// **'当前金额:'**
  String get sgin_total_money;

  /// No description provided for @share1.
  ///
  /// In zh, this message translates to:
  /// **'1.发送邀请\\n【分享给好友】'**
  String get share1;

  /// No description provided for @share2.
  ///
  /// In zh, this message translates to:
  /// **'2.下载应用\\n【填写邀请码】'**
  String get share2;

  /// No description provided for @share3.
  ///
  /// In zh, this message translates to:
  /// **'3.获取奖励\\n【查奖励记录】'**
  String get share3;

  /// No description provided for @share_friends.
  ///
  /// In zh, this message translates to:
  /// **'分享给朋友'**
  String get share_friends;

  /// No description provided for @share_page_flow_title.
  ///
  /// In zh, this message translates to:
  /// **'邀请流程'**
  String get share_page_flow_title;

  /// No description provided for @share_page_invite_subtitle.
  ///
  /// In zh, this message translates to:
  /// **'分享邀请码，双方都能获得奖励'**
  String get share_page_invite_subtitle;

  /// No description provided for @share_page_invite_title.
  ///
  /// In zh, this message translates to:
  /// **'邀请好友一起运动'**
  String get share_page_invite_title;

  /// No description provided for @share_to_app_title.
  ///
  /// In zh, this message translates to:
  /// **'快速分享给好友'**
  String get share_to_app_title;

  /// No description provided for @sign.
  ///
  /// In zh, this message translates to:
  /// **'签到'**
  String get sign;

  /// No description provided for @sign_already.
  ///
  /// In zh, this message translates to:
  /// **'今日已签到'**
  String get sign_already;

  /// No description provided for @sign_hint_text.
  ///
  /// In zh, this message translates to:
  /// **'今天还没有签到，要去签到吗？'**
  String get sign_hint_text;

  /// No description provided for @sign_ok.
  ///
  /// In zh, this message translates to:
  /// **'签到成功，奖励到账后余额自动更新'**
  String get sign_ok;

  /// No description provided for @sleep_quality_average.
  ///
  /// In zh, this message translates to:
  /// **'一般 😐'**
  String get sleep_quality_average;

  /// No description provided for @sleep_quality_excellent.
  ///
  /// In zh, this message translates to:
  /// **'极佳 😴'**
  String get sleep_quality_excellent;

  /// No description provided for @sleep_quality_good.
  ///
  /// In zh, this message translates to:
  /// **'良好 😊'**
  String get sleep_quality_good;

  /// No description provided for @sleep_quality_poor.
  ///
  /// In zh, this message translates to:
  /// **'较差 😔'**
  String get sleep_quality_poor;

  /// No description provided for @sleep_quality_very_poor.
  ///
  /// In zh, this message translates to:
  /// **'极差 😫'**
  String get sleep_quality_very_poor;

  /// No description provided for @sleep_record_msg.
  ///
  /// In zh, this message translates to:
  /// **'睡眠时长 %1\$s，质量 %2\$s'**
  String get sleep_record_msg;

  /// No description provided for @sleep_record_saved.
  ///
  /// In zh, this message translates to:
  /// **'已保存'**
  String get sleep_record_saved;

  /// No description provided for @sleep_stat_h_m_format.
  ///
  /// In zh, this message translates to:
  /// **'%1\$dh %2\$dm'**
  String get sleep_stat_h_m_format;

  /// No description provided for @social_mock_content_1.
  ///
  /// In zh, this message translates to:
  /// **'早起晨跑的感觉太棒了！新鲜空气和汗水是开启一天最好的方式。☀️'**
  String get social_mock_content_1;

  /// No description provided for @social_mock_content_2.
  ///
  /// In zh, this message translates to:
  /// **'完成了45分钟深度冥想，身心都焕然一新。'**
  String get social_mock_content_2;

  /// No description provided for @social_mock_content_3.
  ///
  /// In zh, this message translates to:
  /// **'连续100天达成万步目标，坚持就是胜利。🔥'**
  String get social_mock_content_3;

  /// No description provided for @social_mock_content_4.
  ///
  /// In zh, this message translates to:
  /// **'新装备果然动力十足，今天多跑了3公里！'**
  String get social_mock_content_4;

  /// No description provided for @social_mock_user_1.
  ///
  /// In zh, this message translates to:
  /// **'极客跑者'**
  String get social_mock_user_1;

  /// No description provided for @social_mock_user_2.
  ///
  /// In zh, this message translates to:
  /// **'瑜伽之星'**
  String get social_mock_user_2;

  /// No description provided for @social_mock_user_3.
  ///
  /// In zh, this message translates to:
  /// **'自律达人'**
  String get social_mock_user_3;

  /// No description provided for @social_mock_user_4.
  ///
  /// In zh, this message translates to:
  /// **'步数冠军'**
  String get social_mock_user_4;

  /// No description provided for @social_workout_action_meetup.
  ///
  /// In zh, this message translates to:
  /// **'约练'**
  String get social_workout_action_meetup;

  /// No description provided for @social_workout_create_team.
  ///
  /// In zh, this message translates to:
  /// **'创建打卡小队'**
  String get social_workout_create_team;

  /// No description provided for @social_workout_friend_avatar_lin.
  ///
  /// In zh, this message translates to:
  /// **'林'**
  String get social_workout_friend_avatar_lin;

  /// No description provided for @social_workout_friend_avatar_ya.
  ///
  /// In zh, this message translates to:
  /// **'雅'**
  String get social_workout_friend_avatar_ya;

  /// No description provided for @social_workout_friend_lin_name.
  ///
  /// In zh, this message translates to:
  /// **'小林  ·  连续12天'**
  String get social_workout_friend_lin_name;

  /// No description provided for @social_workout_friend_lin_weekly.
  ///
  /// In zh, this message translates to:
  /// **'本周运动 146 分钟'**
  String get social_workout_friend_lin_weekly;

  /// No description provided for @social_workout_friend_status.
  ///
  /// In zh, this message translates to:
  /// **'好友状态'**
  String get social_workout_friend_status;

  /// No description provided for @social_workout_friend_status_hint.
  ///
  /// In zh, this message translates to:
  /// **'看看大家最近的运动打卡情况'**
  String get social_workout_friend_status_hint;

  /// No description provided for @social_workout_friend_ya_name.
  ///
  /// In zh, this message translates to:
  /// **'阿雅  ·  连续7天'**
  String get social_workout_friend_ya_name;

  /// No description provided for @social_workout_friend_ya_weekly.
  ///
  /// In zh, this message translates to:
  /// **'本周运动 92 分钟'**
  String get social_workout_friend_ya_weekly;

  /// No description provided for @social_workout_invite_now.
  ///
  /// In zh, this message translates to:
  /// **'立即邀请'**
  String get social_workout_invite_now;

  /// No description provided for @social_workout_login_required.
  ///
  /// In zh, this message translates to:
  /// **'请先登录...'**
  String get social_workout_login_required;

  /// No description provided for @social_workout_subtitle.
  ///
  /// In zh, this message translates to:
  /// **'组队打卡更容易坚持，每周一起冲刺运动目标'**
  String get social_workout_subtitle;

  /// No description provided for @social_workout_team_coming_soon.
  ///
  /// In zh, this message translates to:
  /// **'打卡小队功能即将上线'**
  String get social_workout_team_coming_soon;

  /// No description provided for @social_workout_title.
  ///
  /// In zh, this message translates to:
  /// **'和好友一起运动'**
  String get social_workout_title;

  /// No description provided for @spend_cal_str.
  ///
  /// In zh, this message translates to:
  /// **'热量消耗'**
  String get spend_cal_str;

  /// No description provided for @sport_cat_ball.
  ///
  /// In zh, this message translates to:
  /// **'球类运动'**
  String get sport_cat_ball;

  /// No description provided for @sport_cat_dance.
  ///
  /// In zh, this message translates to:
  /// **'舞蹈类'**
  String get sport_cat_dance;

  /// No description provided for @sport_cat_fight.
  ///
  /// In zh, this message translates to:
  /// **'格斗武术'**
  String get sport_cat_fight;

  /// No description provided for @sport_cat_gym.
  ///
  /// In zh, this message translates to:
  /// **'健身房'**
  String get sport_cat_gym;

  /// No description provided for @sport_cat_leisure.
  ///
  /// In zh, this message translates to:
  /// **'休闲运动'**
  String get sport_cat_leisure;

  /// No description provided for @sport_cat_other.
  ///
  /// In zh, this message translates to:
  /// **'其他'**
  String get sport_cat_other;

  /// No description provided for @sport_cat_outdoor.
  ///
  /// In zh, this message translates to:
  /// **'户外运动'**
  String get sport_cat_outdoor;

  /// No description provided for @sport_cat_ride.
  ///
  /// In zh, this message translates to:
  /// **'骑行类'**
  String get sport_cat_ride;

  /// No description provided for @sport_cat_run.
  ///
  /// In zh, this message translates to:
  /// **'跑步类'**
  String get sport_cat_run;

  /// No description provided for @sport_cat_walk.
  ///
  /// In zh, this message translates to:
  /// **'步行类'**
  String get sport_cat_walk;

  /// No description provided for @sport_cat_water.
  ///
  /// In zh, this message translates to:
  /// **'水上运动'**
  String get sport_cat_water;

  /// No description provided for @sport_cat_winter.
  ///
  /// In zh, this message translates to:
  /// **'冬季运动'**
  String get sport_cat_winter;

  /// No description provided for @sport_completed_msg.
  ///
  /// In zh, this message translates to:
  /// **'时长%1\$s，消耗%2\$d千卡'**
  String get sport_completed_msg;

  /// No description provided for @sport_completed_title.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s已完成！'**
  String get sport_completed_title;

  /// No description provided for @sport_detail_header_eyebrow.
  ///
  /// In zh, this message translates to:
  /// **'训练入口'**
  String get sport_detail_header_eyebrow;

  /// No description provided for @sport_detail_history_button.
  ///
  /// In zh, this message translates to:
  /// **'历史'**
  String get sport_detail_history_button;

  /// No description provided for @sport_detail_mode_title.
  ///
  /// In zh, this message translates to:
  /// **'记录方式'**
  String get sport_detail_mode_title;

  /// No description provided for @sport_detail_recent_empty.
  ///
  /// In zh, this message translates to:
  /// **'还没有这项运动记录，点击下方开始按钮开启第一条。'**
  String get sport_detail_recent_empty;

  /// No description provided for @sport_detail_recent_title.
  ///
  /// In zh, this message translates to:
  /// **'最近记录'**
  String get sport_detail_recent_title;

  /// No description provided for @sport_detail_start_button.
  ///
  /// In zh, this message translates to:
  /// **'开始运动'**
  String get sport_detail_start_button;

  /// No description provided for @sport_detail_stat_last_seven_days.
  ///
  /// In zh, this message translates to:
  /// **'近7天次数'**
  String get sport_detail_stat_last_seven_days;

  /// No description provided for @sport_detail_stat_total_actions.
  ///
  /// In zh, this message translates to:
  /// **'累计动作'**
  String get sport_detail_stat_total_actions;

  /// No description provided for @sport_detail_stat_total_calories.
  ///
  /// In zh, this message translates to:
  /// **'累计消耗'**
  String get sport_detail_stat_total_calories;

  /// No description provided for @sport_detail_stat_total_distance.
  ///
  /// In zh, this message translates to:
  /// **'累计距离'**
  String get sport_detail_stat_total_distance;

  /// No description provided for @sport_detail_stat_total_duration.
  ///
  /// In zh, this message translates to:
  /// **'累计时长'**
  String get sport_detail_stat_total_duration;

  /// No description provided for @sport_detail_stat_total_rounds.
  ///
  /// In zh, this message translates to:
  /// **'累计局数'**
  String get sport_detail_stat_total_rounds;

  /// No description provided for @sport_detail_stat_total_sessions.
  ///
  /// In zh, this message translates to:
  /// **'累计次数'**
  String get sport_detail_stat_total_sessions;

  /// No description provided for @sport_detail_summary_empty.
  ///
  /// In zh, this message translates to:
  /// **'还没有这项运动记录，先从一次轻量训练开始。'**
  String get sport_detail_summary_empty;

  /// No description provided for @sport_detail_summary_format.
  ///
  /// In zh, this message translates to:
  /// **'累计 %1\$d 次 · 最近一次 %2\$s'**
  String get sport_detail_summary_format;

  /// No description provided for @sport_detail_title.
  ///
  /// In zh, this message translates to:
  /// **'运动概览'**
  String get sport_detail_title;

  /// No description provided for @sport_ended_save.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s已结束。保存记录吗？'**
  String get sport_ended_save;

  /// No description provided for @sport_exit_confirmation.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s正在进行中。确认现在退出吗？'**
  String get sport_exit_confirmation;

  /// No description provided for @sport_history_title_all.
  ///
  /// In zh, this message translates to:
  /// **'运动历史'**
  String get sport_history_title_all;

  /// No description provided for @sport_history_title_format.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s历史'**
  String get sport_history_title_format;

  /// No description provided for @sport_mode_badge_distance.
  ///
  /// In zh, this message translates to:
  /// **'距离模式'**
  String get sport_mode_badge_distance;

  /// No description provided for @sport_mode_badge_score.
  ///
  /// In zh, this message translates to:
  /// **'计分模式'**
  String get sport_mode_badge_score;

  /// No description provided for @sport_mode_badge_set.
  ///
  /// In zh, this message translates to:
  /// **'组数模式'**
  String get sport_mode_badge_set;

  /// No description provided for @sport_mode_badge_step.
  ///
  /// In zh, this message translates to:
  /// **'步数模式'**
  String get sport_mode_badge_step;

  /// No description provided for @sport_mode_badge_time.
  ///
  /// In zh, this message translates to:
  /// **'计时模式'**
  String get sport_mode_badge_time;

  /// No description provided for @sport_mode_badge_track.
  ///
  /// In zh, this message translates to:
  /// **'GPS轨迹'**
  String get sport_mode_badge_track;

  /// No description provided for @sport_mode_distance.
  ///
  /// In zh, this message translates to:
  /// **'距离训练'**
  String get sport_mode_distance;

  /// No description provided for @sport_mode_hint_distance.
  ///
  /// In zh, this message translates to:
  /// **'重点看距离、圈数和配速，适合游泳、器械骑行等距离型训练。'**
  String get sport_mode_hint_distance;

  /// No description provided for @sport_mode_hint_score.
  ///
  /// In zh, this message translates to:
  /// **'重点看局数、得分和结果，适合保龄球、台球等计分记录。'**
  String get sport_mode_hint_score;

  /// No description provided for @sport_mode_hint_set.
  ///
  /// In zh, this message translates to:
  /// **'重点看计划组数、完成组数和次数，适合力量训练和器械训练。'**
  String get sport_mode_hint_set;

  /// No description provided for @sport_mode_hint_step.
  ///
  /// In zh, this message translates to:
  /// **'重点看步数、距离和时长，适合不依赖地图的步行与室内跑。'**
  String get sport_mode_hint_step;

  /// No description provided for @sport_mode_hint_time.
  ///
  /// In zh, this message translates to:
  /// **'重点看时长和热量，适合球类、瑜伽、舞蹈这类计时训练。'**
  String get sport_mode_hint_time;

  /// No description provided for @sport_mode_hint_track.
  ///
  /// In zh, this message translates to:
  /// **'重点看路线、距离和配速，适合需要真实轨迹的户外运动。'**
  String get sport_mode_hint_track;

  /// No description provided for @sport_mode_score.
  ///
  /// In zh, this message translates to:
  /// **'结果记录'**
  String get sport_mode_score;

  /// No description provided for @sport_mode_set.
  ///
  /// In zh, this message translates to:
  /// **'组数训练'**
  String get sport_mode_set;

  /// No description provided for @sport_mode_step.
  ///
  /// In zh, this message translates to:
  /// **'步数记录'**
  String get sport_mode_step;

  /// No description provided for @sport_mode_time.
  ///
  /// In zh, this message translates to:
  /// **'计时训练'**
  String get sport_mode_time;

  /// No description provided for @sport_mode_track.
  ///
  /// In zh, this message translates to:
  /// **'轨迹记录'**
  String get sport_mode_track;

  /// No description provided for @sport_name_0.
  ///
  /// In zh, this message translates to:
  /// **'其他运动'**
  String get sport_name_0;

  /// No description provided for @sport_name_1.
  ///
  /// In zh, this message translates to:
  /// **'户外跑步'**
  String get sport_name_1;

  /// No description provided for @sport_name_10.
  ///
  /// In zh, this message translates to:
  /// **'竞走'**
  String get sport_name_10;

  /// No description provided for @sport_name_11.
  ///
  /// In zh, this message translates to:
  /// **'散步'**
  String get sport_name_11;

  /// No description provided for @sport_name_12.
  ///
  /// In zh, this message translates to:
  /// **'爬楼梯'**
  String get sport_name_12;

  /// No description provided for @sport_name_13.
  ///
  /// In zh, this message translates to:
  /// **'室内骑行'**
  String get sport_name_13;

  /// No description provided for @sport_name_14.
  ///
  /// In zh, this message translates to:
  /// **'山地骑行'**
  String get sport_name_14;

  /// No description provided for @sport_name_15.
  ///
  /// In zh, this message translates to:
  /// **'公路骑行'**
  String get sport_name_15;

  /// No description provided for @sport_name_16.
  ///
  /// In zh, this message translates to:
  /// **'动感单车'**
  String get sport_name_16;

  /// No description provided for @sport_name_17.
  ///
  /// In zh, this message translates to:
  /// **'足球'**
  String get sport_name_17;

  /// No description provided for @sport_name_18.
  ///
  /// In zh, this message translates to:
  /// **'篮球'**
  String get sport_name_18;

  /// No description provided for @sport_name_19.
  ///
  /// In zh, this message translates to:
  /// **'羽毛球'**
  String get sport_name_19;

  /// No description provided for @sport_name_2.
  ///
  /// In zh, this message translates to:
  /// **'室内跑步'**
  String get sport_name_2;

  /// No description provided for @sport_name_20.
  ///
  /// In zh, this message translates to:
  /// **'乒乓球'**
  String get sport_name_20;

  /// No description provided for @sport_name_21.
  ///
  /// In zh, this message translates to:
  /// **'网球'**
  String get sport_name_21;

  /// No description provided for @sport_name_22.
  ///
  /// In zh, this message translates to:
  /// **'排球'**
  String get sport_name_22;

  /// No description provided for @sport_name_23.
  ///
  /// In zh, this message translates to:
  /// **'高尔夫'**
  String get sport_name_23;

  /// No description provided for @sport_name_24.
  ///
  /// In zh, this message translates to:
  /// **'保龄球'**
  String get sport_name_24;

  /// No description provided for @sport_name_25.
  ///
  /// In zh, this message translates to:
  /// **'台球'**
  String get sport_name_25;

  /// No description provided for @sport_name_26.
  ///
  /// In zh, this message translates to:
  /// **'斯诺克'**
  String get sport_name_26;

  /// No description provided for @sport_name_27.
  ///
  /// In zh, this message translates to:
  /// **'美式足球'**
  String get sport_name_27;

  /// No description provided for @sport_name_28.
  ///
  /// In zh, this message translates to:
  /// **'曲棍球'**
  String get sport_name_28;

  /// No description provided for @sport_name_29.
  ///
  /// In zh, this message translates to:
  /// **'橄榄球'**
  String get sport_name_29;

  /// No description provided for @sport_name_3.
  ///
  /// In zh, this message translates to:
  /// **'户外步行'**
  String get sport_name_3;

  /// No description provided for @sport_name_30.
  ///
  /// In zh, this message translates to:
  /// **'棒球'**
  String get sport_name_30;

  /// No description provided for @sport_name_31.
  ///
  /// In zh, this message translates to:
  /// **'板球'**
  String get sport_name_31;

  /// No description provided for @sport_name_32.
  ///
  /// In zh, this message translates to:
  /// **'冲浪'**
  String get sport_name_32;

  /// No description provided for @sport_name_33.
  ///
  /// In zh, this message translates to:
  /// **'帆船'**
  String get sport_name_33;

  /// No description provided for @sport_name_34.
  ///
  /// In zh, this message translates to:
  /// **'帆板'**
  String get sport_name_34;

  /// No description provided for @sport_name_35.
  ///
  /// In zh, this message translates to:
  /// **'皮划艇'**
  String get sport_name_35;

  /// No description provided for @sport_name_36.
  ///
  /// In zh, this message translates to:
  /// **'赛艇'**
  String get sport_name_36;

  /// No description provided for @sport_name_37.
  ///
  /// In zh, this message translates to:
  /// **'水球'**
  String get sport_name_37;

  /// No description provided for @sport_name_38.
  ///
  /// In zh, this message translates to:
  /// **'跳水'**
  String get sport_name_38;

  /// No description provided for @sport_name_39.
  ///
  /// In zh, this message translates to:
  /// **'花样游泳'**
  String get sport_name_39;

  /// No description provided for @sport_name_4.
  ///
  /// In zh, this message translates to:
  /// **'室内步行'**
  String get sport_name_4;

  /// No description provided for @sport_name_40.
  ///
  /// In zh, this message translates to:
  /// **'浮潜'**
  String get sport_name_40;

  /// No description provided for @sport_name_41.
  ///
  /// In zh, this message translates to:
  /// **'滑雪'**
  String get sport_name_41;

  /// No description provided for @sport_name_42.
  ///
  /// In zh, this message translates to:
  /// **'滑冰'**
  String get sport_name_42;

  /// No description provided for @sport_name_43.
  ///
  /// In zh, this message translates to:
  /// **'冰球'**
  String get sport_name_43;

  /// No description provided for @sport_name_44.
  ///
  /// In zh, this message translates to:
  /// **'冰壶'**
  String get sport_name_44;

  /// No description provided for @sport_name_45.
  ///
  /// In zh, this message translates to:
  /// **'雪橇'**
  String get sport_name_45;

  /// No description provided for @sport_name_46.
  ///
  /// In zh, this message translates to:
  /// **'单板滑雪'**
  String get sport_name_46;

  /// No description provided for @sport_name_47.
  ///
  /// In zh, this message translates to:
  /// **'越野滑雪'**
  String get sport_name_47;

  /// No description provided for @sport_name_48.
  ///
  /// In zh, this message translates to:
  /// **'花样滑冰'**
  String get sport_name_48;

  /// No description provided for @sport_name_49.
  ///
  /// In zh, this message translates to:
  /// **'力量训练'**
  String get sport_name_49;

  /// No description provided for @sport_name_5.
  ///
  /// In zh, this message translates to:
  /// **'健走'**
  String get sport_name_5;

  /// No description provided for @sport_name_50.
  ///
  /// In zh, this message translates to:
  /// **'HIIT'**
  String get sport_name_50;

  /// No description provided for @sport_name_51.
  ///
  /// In zh, this message translates to:
  /// **'瑜伽'**
  String get sport_name_51;

  /// No description provided for @sport_name_52.
  ///
  /// In zh, this message translates to:
  /// **'普拉提'**
  String get sport_name_52;

  /// No description provided for @sport_name_53.
  ///
  /// In zh, this message translates to:
  /// **'有氧操'**
  String get sport_name_53;

  /// No description provided for @sport_name_54.
  ///
  /// In zh, this message translates to:
  /// **'杠铃训练'**
  String get sport_name_54;

  /// No description provided for @sport_name_55.
  ///
  /// In zh, this message translates to:
  /// **'哑铃训练'**
  String get sport_name_55;

  /// No description provided for @sport_name_56.
  ///
  /// In zh, this message translates to:
  /// **'壶铃训练'**
  String get sport_name_56;

  /// No description provided for @sport_name_57.
  ///
  /// In zh, this message translates to:
  /// **'弹力带训练'**
  String get sport_name_57;

  /// No description provided for @sport_name_58.
  ///
  /// In zh, this message translates to:
  /// **'划船机'**
  String get sport_name_58;

  /// No description provided for @sport_name_59.
  ///
  /// In zh, this message translates to:
  /// **'椭圆机'**
  String get sport_name_59;

  /// No description provided for @sport_name_6.
  ///
  /// In zh, this message translates to:
  /// **'游泳'**
  String get sport_name_6;

  /// No description provided for @sport_name_60.
  ///
  /// In zh, this message translates to:
  /// **'踏步机'**
  String get sport_name_60;

  /// No description provided for @sport_name_61.
  ///
  /// In zh, this message translates to:
  /// **'拳击'**
  String get sport_name_61;

  /// No description provided for @sport_name_62.
  ///
  /// In zh, this message translates to:
  /// **'跆拳道'**
  String get sport_name_62;

  /// No description provided for @sport_name_63.
  ///
  /// In zh, this message translates to:
  /// **'柔道'**
  String get sport_name_63;

  /// No description provided for @sport_name_64.
  ///
  /// In zh, this message translates to:
  /// **'空手道'**
  String get sport_name_64;

  /// No description provided for @sport_name_65.
  ///
  /// In zh, this message translates to:
  /// **'武术'**
  String get sport_name_65;

  /// No description provided for @sport_name_66.
  ///
  /// In zh, this message translates to:
  /// **'散打'**
  String get sport_name_66;

  /// No description provided for @sport_name_67.
  ///
  /// In zh, this message translates to:
  /// **'摔跤'**
  String get sport_name_67;

  /// No description provided for @sport_name_68.
  ///
  /// In zh, this message translates to:
  /// **'击剑'**
  String get sport_name_68;

  /// No description provided for @sport_name_69.
  ///
  /// In zh, this message translates to:
  /// **'综合格斗'**
  String get sport_name_69;

  /// No description provided for @sport_name_7.
  ///
  /// In zh, this message translates to:
  /// **'户外骑行'**
  String get sport_name_7;

  /// No description provided for @sport_name_70.
  ///
  /// In zh, this message translates to:
  /// **'泰拳'**
  String get sport_name_70;

  /// No description provided for @sport_name_71.
  ///
  /// In zh, this message translates to:
  /// **'街舞'**
  String get sport_name_71;

  /// No description provided for @sport_name_72.
  ///
  /// In zh, this message translates to:
  /// **'芭蕾'**
  String get sport_name_72;

  /// No description provided for @sport_name_73.
  ///
  /// In zh, this message translates to:
  /// **'拉丁舞'**
  String get sport_name_73;

  /// No description provided for @sport_name_74.
  ///
  /// In zh, this message translates to:
  /// **'民间舞'**
  String get sport_name_74;

  /// No description provided for @sport_name_75.
  ///
  /// In zh, this message translates to:
  /// **'现代舞'**
  String get sport_name_75;

  /// No description provided for @sport_name_76.
  ///
  /// In zh, this message translates to:
  /// **'广场舞'**
  String get sport_name_76;

  /// No description provided for @sport_name_77.
  ///
  /// In zh, this message translates to:
  /// **'肚皮舞'**
  String get sport_name_77;

  /// No description provided for @sport_name_78.
  ///
  /// In zh, this message translates to:
  /// **'攀岩'**
  String get sport_name_78;

  /// No description provided for @sport_name_79.
  ///
  /// In zh, this message translates to:
  /// **'滑翔伞'**
  String get sport_name_79;

  /// No description provided for @sport_name_8.
  ///
  /// In zh, this message translates to:
  /// **'马拉松'**
  String get sport_name_8;

  /// No description provided for @sport_name_80.
  ///
  /// In zh, this message translates to:
  /// **'蹦极'**
  String get sport_name_80;

  /// No description provided for @sport_name_81.
  ///
  /// In zh, this message translates to:
  /// **'跳伞'**
  String get sport_name_81;

  /// No description provided for @sport_name_82.
  ///
  /// In zh, this message translates to:
  /// **'定向越野'**
  String get sport_name_82;

  /// No description provided for @sport_name_83.
  ///
  /// In zh, this message translates to:
  /// **'钓鱼'**
  String get sport_name_83;

  /// No description provided for @sport_name_84.
  ///
  /// In zh, this message translates to:
  /// **'射箭'**
  String get sport_name_84;

  /// No description provided for @sport_name_85.
  ///
  /// In zh, this message translates to:
  /// **'飞镖'**
  String get sport_name_85;

  /// No description provided for @sport_name_86.
  ///
  /// In zh, this message translates to:
  /// **'冥想'**
  String get sport_name_86;

  /// No description provided for @sport_name_9.
  ///
  /// In zh, this message translates to:
  /// **'越野跑'**
  String get sport_name_9;

  /// No description provided for @sport_record_action_distance.
  ///
  /// In zh, this message translates to:
  /// **'保存距离记录'**
  String get sport_record_action_distance;

  /// No description provided for @sport_record_action_format.
  ///
  /// In zh, this message translates to:
  /// **'动作：%1\$d 次'**
  String get sport_record_action_format;

  /// No description provided for @sport_record_action_score.
  ///
  /// In zh, this message translates to:
  /// **'保存比赛结果'**
  String get sport_record_action_score;

  /// No description provided for @sport_record_action_set.
  ///
  /// In zh, this message translates to:
  /// **'保存组数记录'**
  String get sport_record_action_set;

  /// No description provided for @sport_record_action_step.
  ///
  /// In zh, this message translates to:
  /// **'保存步数记录'**
  String get sport_record_action_step;

  /// No description provided for @sport_record_action_time.
  ///
  /// In zh, this message translates to:
  /// **'保存计时记录'**
  String get sport_record_action_time;

  /// No description provided for @sport_record_action_track.
  ///
  /// In zh, this message translates to:
  /// **'保存轨迹记录'**
  String get sport_record_action_track;

  /// No description provided for @sport_record_calorie_format.
  ///
  /// In zh, this message translates to:
  /// **'消耗：%1\$s 千卡'**
  String get sport_record_calorie_format;

  /// No description provided for @sport_record_count_format.
  ///
  /// In zh, this message translates to:
  /// **'次数：%1\$d 次'**
  String get sport_record_count_format;

  /// No description provided for @sport_record_distance_text_format.
  ///
  /// In zh, this message translates to:
  /// **'距离：%1\$s'**
  String get sport_record_distance_text_format;

  /// No description provided for @sport_record_duration_format.
  ///
  /// In zh, this message translates to:
  /// **'时长：%1\$d 分钟'**
  String get sport_record_duration_format;

  /// No description provided for @sport_record_mode_text_format.
  ///
  /// In zh, this message translates to:
  /// **'模式：%1\$s'**
  String get sport_record_mode_text_format;

  /// No description provided for @sport_record_round_format.
  ///
  /// In zh, this message translates to:
  /// **'%1\$d 局'**
  String get sport_record_round_format;

  /// No description provided for @sport_record_score_format.
  ///
  /// In zh, this message translates to:
  /// **'%1\$d 分'**
  String get sport_record_score_format;

  /// No description provided for @sport_record_score_text_format.
  ///
  /// In zh, this message translates to:
  /// **'得分：%1\$d 分'**
  String get sport_record_score_text_format;

  /// No description provided for @sport_record_set_format.
  ///
  /// In zh, this message translates to:
  /// **'%1\$d 组'**
  String get sport_record_set_format;

  /// No description provided for @sport_record_speed_format.
  ///
  /// In zh, this message translates to:
  /// **'配速：%1\$s'**
  String get sport_record_speed_format;

  /// No description provided for @sport_record_step_format.
  ///
  /// In zh, this message translates to:
  /// **'步数：%1\$d 步'**
  String get sport_record_step_format;

  /// No description provided for @sport_save_confirmation.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s已完成。保存此记录吗？'**
  String get sport_save_confirmation;

  /// No description provided for @sport_set_save_confirmation.
  ///
  /// In zh, this message translates to:
  /// **'训练结束，共完成%1\$d组。保存此记录吗？'**
  String get sport_set_save_confirmation;

  /// No description provided for @sport_target_reached.
  ///
  /// In zh, this message translates to:
  /// **'您的运动目标已达成'**
  String get sport_target_reached;

  /// No description provided for @sport_training_distance_input_hint_generic.
  ///
  /// In zh, this message translates to:
  /// **'录入距离后自动换算配速与消耗。'**
  String get sport_training_distance_input_hint_generic;

  /// No description provided for @sport_training_distance_input_hint_ride.
  ///
  /// In zh, this message translates to:
  /// **'录入里程后自动换算时速与消耗。'**
  String get sport_training_distance_input_hint_ride;

  /// No description provided for @sport_training_distance_label_generic.
  ///
  /// In zh, this message translates to:
  /// **'已录入距离'**
  String get sport_training_distance_label_generic;

  /// No description provided for @sport_training_distance_label_ride.
  ///
  /// In zh, this message translates to:
  /// **'当前里程'**
  String get sport_training_distance_label_ride;

  /// No description provided for @sport_training_plan_hint_format.
  ///
  /// In zh, this message translates to:
  /// **'每组 %1\$d 次 · %2\$s'**
  String get sport_training_plan_hint_format;

  /// No description provided for @sport_training_plan_hint_idle.
  ///
  /// In zh, this message translates to:
  /// **'设定计划后开始记录组数进度。'**
  String get sport_training_plan_hint_idle;

  /// No description provided for @sport_training_plan_placeholder.
  ///
  /// In zh, this message translates to:
  /// **'未设定'**
  String get sport_training_plan_placeholder;

  /// No description provided for @sport_training_weight_none.
  ///
  /// In zh, this message translates to:
  /// **'无负重'**
  String get sport_training_weight_none;

  /// No description provided for @sport_training_weight_text_format.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s kg'**
  String get sport_training_weight_text_format;

  /// No description provided for @status_high.
  ///
  /// In zh, this message translates to:
  /// **'偏高'**
  String get status_high;

  /// No description provided for @status_low.
  ///
  /// In zh, this message translates to:
  /// **'偏低'**
  String get status_low;

  /// No description provided for @status_normal.
  ///
  /// In zh, this message translates to:
  /// **'正常'**
  String get status_normal;

  /// No description provided for @step.
  ///
  /// In zh, this message translates to:
  /// **'步'**
  String get step;

  /// No description provided for @step_number_record.
  ///
  /// In zh, this message translates to:
  /// **'步行记录'**
  String get step_number_record;

  /// No description provided for @step_sub_doing_sport_hint.
  ///
  /// In zh, this message translates to:
  /// **'已有正在进行的运动，立刻进入？'**
  String get step_sub_doing_sport_hint;

  /// No description provided for @step_sub_target_free.
  ///
  /// In zh, this message translates to:
  /// **'自由'**
  String get step_sub_target_free;

  /// No description provided for @step_sub_target_km_format.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s 公里'**
  String get step_sub_target_km_format;

  /// No description provided for @step_widget_label.
  ///
  /// In zh, this message translates to:
  /// **'微步运动 Widget'**
  String get step_widget_label;

  /// No description provided for @suggest_step_num.
  ///
  /// In zh, this message translates to:
  /// **'建议每日步行范围3000到10000步'**
  String get suggest_step_num;

  /// No description provided for @sun.
  ///
  /// In zh, this message translates to:
  /// **'周日'**
  String get sun;

  /// No description provided for @sure_get_coin.
  ///
  /// In zh, this message translates to:
  /// **'确定领取'**
  String get sure_get_coin;

  /// No description provided for @sync_connected_msg.
  ///
  /// In zh, this message translates to:
  /// **'已连接 %1\$s，今日步数：%2\$d'**
  String get sync_connected_msg;

  /// No description provided for @sync_failed_msg.
  ///
  /// In zh, this message translates to:
  /// **'步数同步失败：%1\$s'**
  String get sync_failed_msg;

  /// No description provided for @sync_google_fit_msg.
  ///
  /// In zh, this message translates to:
  /// **'为了准确追踪您的步数，需要连接 Google Fit 获取步数数据。点击确认以开启 Google 账户授权。'**
  String get sync_google_fit_msg;

  /// No description provided for @sync_health_title.
  ///
  /// In zh, this message translates to:
  /// **'同步健康数据'**
  String get sync_health_title;

  /// No description provided for @sync_task_ad_title.
  ///
  /// In zh, this message translates to:
  /// **'任务成功，获取金币:'**
  String get sync_task_ad_title;

  /// No description provided for @systolic.
  ///
  /// In zh, this message translates to:
  /// **'收缩压'**
  String get systolic;

  /// No description provided for @tab_achievements.
  ///
  /// In zh, this message translates to:
  /// **'成就'**
  String get tab_achievements;

  /// No description provided for @tab_check_in.
  ///
  /// In zh, this message translates to:
  /// **'签到'**
  String get tab_check_in;

  /// No description provided for @tab_daily.
  ///
  /// In zh, this message translates to:
  /// **'日常'**
  String get tab_daily;

  /// No description provided for @tab_sport.
  ///
  /// In zh, this message translates to:
  /// **'运动'**
  String get tab_sport;

  /// No description provided for @tab_step.
  ///
  /// In zh, this message translates to:
  /// **'健康'**
  String get tab_step;

  /// No description provided for @tab_target.
  ///
  /// In zh, this message translates to:
  /// **'目标'**
  String get tab_target;

  /// No description provided for @tab_user.
  ///
  /// In zh, this message translates to:
  /// **'我的'**
  String get tab_user;

  /// No description provided for @target_steps_hint.
  ///
  /// In zh, this message translates to:
  /// **'1.设置每天的目标步数\\n2.达成每日步数领取奖励\\n3.设置越多奖励越多\\n'**
  String get target_steps_hint;

  /// No description provided for @task_ad.
  ///
  /// In zh, this message translates to:
  /// **'做任务领金币'**
  String get task_ad;

  /// No description provided for @task_error.
  ///
  /// In zh, this message translates to:
  /// **'获取任务出错'**
  String get task_error;

  /// No description provided for @task_page_title.
  ///
  /// In zh, this message translates to:
  /// **'任务'**
  String get task_page_title;

  /// No description provided for @thu.
  ///
  /// In zh, this message translates to:
  /// **'周四'**
  String get thu;

  /// No description provided for @today_data.
  ///
  /// In zh, this message translates to:
  /// **'今日数据'**
  String get today_data;

  /// No description provided for @today_mason.
  ///
  /// In zh, this message translates to:
  /// **'今日任务'**
  String get today_mason;

  /// No description provided for @today_schedule.
  ///
  /// In zh, this message translates to:
  /// **'今日计划'**
  String get today_schedule;

  /// No description provided for @today_sgin.
  ///
  /// In zh, this message translates to:
  /// **'签到领取奖励'**
  String get today_sgin;

  /// No description provided for @today_sgin_hint.
  ///
  /// In zh, this message translates to:
  /// **'每日签到'**
  String get today_sgin_hint;

  /// No description provided for @today_steps_str.
  ///
  /// In zh, this message translates to:
  /// **'今日步数'**
  String get today_steps_str;

  /// No description provided for @today_target_steps.
  ///
  /// In zh, this message translates to:
  /// **'今日目标步数'**
  String get today_target_steps;

  /// No description provided for @todo.
  ///
  /// In zh, this message translates to:
  /// **'TODO'**
  String get todo;

  /// No description provided for @total_coin.
  ///
  /// In zh, this message translates to:
  /// **'累计金币'**
  String get total_coin;

  /// No description provided for @total_money.
  ///
  /// In zh, this message translates to:
  /// **'累计奖励'**
  String get total_money;

  /// No description provided for @train_intensity_high.
  ///
  /// In zh, this message translates to:
  /// **'高强度'**
  String get train_intensity_high;

  /// No description provided for @train_intensity_high_interval.
  ///
  /// In zh, this message translates to:
  /// **'高强度间歇'**
  String get train_intensity_high_interval;

  /// No description provided for @train_intensity_low.
  ///
  /// In zh, this message translates to:
  /// **'低强度'**
  String get train_intensity_low;

  /// No description provided for @train_intensity_low_jog.
  ///
  /// In zh, this message translates to:
  /// **'低强度慢跑'**
  String get train_intensity_low_jog;

  /// No description provided for @train_intensity_medium_high.
  ///
  /// In zh, this message translates to:
  /// **'中高强度'**
  String get train_intensity_medium_high;

  /// No description provided for @train_intensity_moderate.
  ///
  /// In zh, this message translates to:
  /// **'中等强度'**
  String get train_intensity_moderate;

  /// No description provided for @train_intensity_moderate_pace.
  ///
  /// In zh, this message translates to:
  /// **'中等配速'**
  String get train_intensity_moderate_pace;

  /// No description provided for @train_plan_desc_build_muscle.
  ///
  /// In zh, this message translates to:
  /// **'以力量训练为主，科学分配肌群训练，促进肌肉生长'**
  String get train_plan_desc_build_muscle;

  /// No description provided for @train_plan_desc_health.
  ///
  /// In zh, this message translates to:
  /// **'均衡的运动安排，保持身体健康状态'**
  String get train_plan_desc_health;

  /// No description provided for @train_plan_desc_lose_weight.
  ///
  /// In zh, this message translates to:
  /// **'以有氧运动为主，配合力量训练，高效燃烧脂肪'**
  String get train_plan_desc_lose_weight;

  /// No description provided for @train_plan_desc_stamina.
  ///
  /// In zh, this message translates to:
  /// **'循序渐进提升心肺功能和运动耐力'**
  String get train_plan_desc_stamina;

  /// No description provided for @train_plan_name_build_muscle.
  ///
  /// In zh, this message translates to:
  /// **'增肌塑形计划'**
  String get train_plan_name_build_muscle;

  /// No description provided for @train_plan_name_health.
  ///
  /// In zh, this message translates to:
  /// **'健康维护计划'**
  String get train_plan_name_health;

  /// No description provided for @train_plan_name_lose_weight.
  ///
  /// In zh, this message translates to:
  /// **'减脂燃卡计划'**
  String get train_plan_name_lose_weight;

  /// No description provided for @train_plan_name_stamina.
  ///
  /// In zh, this message translates to:
  /// **'耐力提升计划'**
  String get train_plan_name_stamina;

  /// No description provided for @train_plan_tip_build_muscle.
  ///
  /// In zh, this message translates to:
  /// **'增肌关键：足够蛋白质(每kg体重1.6-2g)，渐进超负荷，充足休息。'**
  String get train_plan_tip_build_muscle;

  /// No description provided for @train_plan_tip_health.
  ///
  /// In zh, this message translates to:
  /// **'贵在坚持！运动不必追求高强度，每天动一动就是最好的。'**
  String get train_plan_tip_health;

  /// No description provided for @train_plan_tip_lose_weight.
  ///
  /// In zh, this message translates to:
  /// **'减脂关键：保持热量缺口，有氧+力量结合效果最佳。'**
  String get train_plan_tip_lose_weight;

  /// No description provided for @train_plan_tip_stamina.
  ///
  /// In zh, this message translates to:
  /// **'耐力提升关键：循序渐进增加运动量，每周增幅不超过10%。'**
  String get train_plan_tip_stamina;

  /// No description provided for @train_sport_back.
  ///
  /// In zh, this message translates to:
  /// **'背部训练'**
  String get train_sport_back;

  /// No description provided for @train_sport_chest.
  ///
  /// In zh, this message translates to:
  /// **'胸部训练'**
  String get train_sport_chest;

  /// No description provided for @train_sport_cycling.
  ///
  /// In zh, this message translates to:
  /// **'骑行'**
  String get train_sport_cycling;

  /// No description provided for @train_sport_hiit_interval.
  ///
  /// In zh, this message translates to:
  /// **'HIIT高强度间歇'**
  String get train_sport_hiit_interval;

  /// No description provided for @train_sport_interval_run.
  ///
  /// In zh, this message translates to:
  /// **'间歇跑'**
  String get train_sport_interval_run;

  /// No description provided for @train_sport_jogging.
  ///
  /// In zh, this message translates to:
  /// **'慢跑'**
  String get train_sport_jogging;

  /// No description provided for @train_sport_legs.
  ///
  /// In zh, this message translates to:
  /// **'腿部训练'**
  String get train_sport_legs;

  /// No description provided for @train_sport_light_cardio.
  ///
  /// In zh, this message translates to:
  /// **'轻度有氧'**
  String get train_sport_light_cardio;

  /// No description provided for @train_sport_long_slow_run.
  ///
  /// In zh, this message translates to:
  /// **'长距离慢跑'**
  String get train_sport_long_slow_run;

  /// No description provided for @train_sport_rest.
  ///
  /// In zh, this message translates to:
  /// **'休息'**
  String get train_sport_rest;

  /// No description provided for @train_sport_shoulders.
  ///
  /// In zh, this message translates to:
  /// **'肩部训练'**
  String get train_sport_shoulders;

  /// No description provided for @train_tip_aerobic_cardio_health.
  ///
  /// In zh, this message translates to:
  /// **'有氧运动，心肺健康'**
  String get train_tip_aerobic_cardio_health;

  /// No description provided for @train_tip_back_combo.
  ///
  /// In zh, this message translates to:
  /// **'引体向上、划船、下拉'**
  String get train_tip_back_combo;

  /// No description provided for @train_tip_chest_combo.
  ///
  /// In zh, this message translates to:
  /// **'卧推、上斜推举、夹胸'**
  String get train_tip_chest_combo;

  /// No description provided for @train_tip_easy_walk.
  ///
  /// In zh, this message translates to:
  /// **'轻松愉快的步行'**
  String get train_tip_easy_walk;

  /// No description provided for @train_tip_focus_large_muscle.
  ///
  /// In zh, this message translates to:
  /// **'注重大肌群训练，如深蹲、硬拉'**
  String get train_tip_focus_large_muscle;

  /// No description provided for @train_tip_full_body_relax.
  ///
  /// In zh, this message translates to:
  /// **'全身运动，放松身心'**
  String get train_tip_full_body_relax;

  /// No description provided for @train_tip_full_rest.
  ///
  /// In zh, this message translates to:
  /// **'完全休息，让身体恢复'**
  String get train_tip_full_rest;

  /// No description provided for @train_tip_full_rest_nutrition.
  ///
  /// In zh, this message translates to:
  /// **'完全休息，补充营养'**
  String get train_tip_full_rest_nutrition;

  /// No description provided for @train_tip_fun_social_fitness.
  ///
  /// In zh, this message translates to:
  /// **'趣味运动，社交健身'**
  String get train_tip_fun_social_fitness;

  /// No description provided for @train_tip_growth_rest_sleep.
  ///
  /// In zh, this message translates to:
  /// **'肌肉生长发生在休息时，保证充足睡眠'**
  String get train_tip_growth_rest_sleep;

  /// No description provided for @train_tip_hiit_afterburn.
  ///
  /// In zh, this message translates to:
  /// **'短时高效，运动后持续燃脂'**
  String get train_tip_hiit_afterburn;

  /// No description provided for @train_tip_joint_friendly_full_body.
  ///
  /// In zh, this message translates to:
  /// **'全身运动，关节友好'**
  String get train_tip_joint_friendly_full_body;

  /// No description provided for @train_tip_keep_hr_60_70.
  ///
  /// In zh, this message translates to:
  /// **'保持心率在最大心率的60-70%'**
  String get train_tip_keep_hr_60_70;

  /// No description provided for @train_tip_keep_pace_stable.
  ///
  /// In zh, this message translates to:
  /// **'保持稳定配速'**
  String get train_tip_keep_pace_stable;

  /// No description provided for @train_tip_leg_combo.
  ///
  /// In zh, this message translates to:
  /// **'深蹲、腿举、腿弯举、小腿'**
  String get train_tip_leg_combo;

  /// No description provided for @train_tip_low_impact_joint.
  ///
  /// In zh, this message translates to:
  /// **'低冲击有氧，保护关节'**
  String get train_tip_low_impact_joint;

  /// No description provided for @train_tip_promote_recovery.
  ///
  /// In zh, this message translates to:
  /// **'促进恢复，不过度消耗'**
  String get train_tip_promote_recovery;

  /// No description provided for @train_tip_recovery_day.
  ///
  /// In zh, this message translates to:
  /// **'恢复日'**
  String get train_tip_recovery_day;

  /// No description provided for @train_tip_recovery_relax_muscle.
  ///
  /// In zh, this message translates to:
  /// **'恢复性训练，帮助肌肉放松'**
  String get train_tip_recovery_relax_muscle;

  /// No description provided for @train_tip_rest_recover_short.
  ///
  /// In zh, this message translates to:
  /// **'休息恢复'**
  String get train_tip_rest_recover_short;

  /// No description provided for @train_tip_rest_stretch.
  ///
  /// In zh, this message translates to:
  /// **'休息恢复，可以进行拉伸'**
  String get train_tip_rest_stretch;

  /// No description provided for @train_tip_shoulder_combo.
  ///
  /// In zh, this message translates to:
  /// **'推举、侧平举、面拉'**
  String get train_tip_shoulder_combo;

  /// No description provided for @train_tip_stretch_relax.
  ///
  /// In zh, this message translates to:
  /// **'舒展身体，放松心情'**
  String get train_tip_stretch_relax;

  /// No description provided for @trend_down.
  ///
  /// In zh, this message translates to:
  /// **'下降'**
  String get trend_down;

  /// No description provided for @trend_stable.
  ///
  /// In zh, this message translates to:
  /// **'稳定'**
  String get trend_stable;

  /// No description provided for @trend_up.
  ///
  /// In zh, this message translates to:
  /// **'上升'**
  String get trend_up;

  /// No description provided for @tue.
  ///
  /// In zh, this message translates to:
  /// **'周二'**
  String get tue;

  /// No description provided for @ui_auto_aslist_03656661a3.
  ///
  /// In zh, this message translates to:
  /// **'咨询心血管专科医生进行全面评估'**
  String get ui_auto_aslist_03656661a3;

  /// No description provided for @ui_auto_aslist_046c6233e0.
  ///
  /// In zh, this message translates to:
  /// **'最近'**
  String get ui_auto_aslist_046c6233e0;

  /// No description provided for @ui_auto_aslist_06f7d2ec4b.
  ///
  /// In zh, this message translates to:
  /// **'膝盖方向和脚尖一致，站起时收紧臀部'**
  String get ui_auto_aslist_06f7d2ec4b;

  /// No description provided for @ui_auto_aslist_08e5a9932a.
  ///
  /// In zh, this message translates to:
  /// **'月经期间适当调整运动强度'**
  String get ui_auto_aslist_08e5a9932a;

  /// No description provided for @ui_auto_aslist_09f1a8ca6a.
  ///
  /// In zh, this message translates to:
  /// **'双腿均匀拉伸，避免一侧代偿'**
  String get ui_auto_aslist_09f1a8ca6a;

  /// No description provided for @ui_auto_aslist_0b0e9b986a.
  ///
  /// In zh, this message translates to:
  /// **'选择游泳、早晚散步等适合的运动'**
  String get ui_auto_aslist_0b0e9b986a;

  /// No description provided for @ui_auto_aslist_0b29e22e92.
  ///
  /// In zh, this message translates to:
  /// **'每年进行全面体检，包括心血管和代谢筛查'**
  String get ui_auto_aslist_0b29e22e92;

  /// No description provided for @ui_auto_aslist_0d83078816.
  ///
  /// In zh, this message translates to:
  /// **'数据'**
  String get ui_auto_aslist_0d83078816;

  /// No description provided for @ui_auto_aslist_0debf521ea.
  ///
  /// In zh, this message translates to:
  /// **'计划'**
  String get ui_auto_aslist_0debf521ea;

  /// No description provided for @ui_auto_aslist_12a96d8f50.
  ///
  /// In zh, this message translates to:
  /// **'什么是'**
  String get ui_auto_aslist_12a96d8f50;

  /// No description provided for @ui_auto_aslist_15043bfccf.
  ///
  /// In zh, this message translates to:
  /// **'设定健康改善目标'**
  String get ui_auto_aslist_15043bfccf;

  /// No description provided for @ui_auto_aslist_1750f4fb54.
  ///
  /// In zh, this message translates to:
  /// **'调节情绪，预防秋季抑郁'**
  String get ui_auto_aslist_1750f4fb54;

  /// No description provided for @ui_auto_aslist_17f1b7ab61.
  ///
  /// In zh, this message translates to:
  /// **'增加水分摄入，预防脱水'**
  String get ui_auto_aslist_17f1b7ab61;

  /// No description provided for @ui_auto_aslist_183547459a.
  ///
  /// In zh, this message translates to:
  /// **'制定固定的运动时间表'**
  String get ui_auto_aslist_183547459a;

  /// No description provided for @ui_auto_aslist_1bc70beae7.
  ///
  /// In zh, this message translates to:
  /// **'尝试冥想或正念练习，每天10-15分钟'**
  String get ui_auto_aslist_1bc70beae7;

  /// No description provided for @ui_auto_aslist_1bd6489db4.
  ///
  /// In zh, this message translates to:
  /// **'徒手深蹲'**
  String get ui_auto_aslist_1bd6489db4;

  /// No description provided for @ui_auto_aslist_1bf28d15cc.
  ///
  /// In zh, this message translates to:
  /// **'解释异常的健康指标'**
  String get ui_auto_aslist_1bf28d15cc;

  /// No description provided for @ui_auto_aslist_1d5778948a.
  ///
  /// In zh, this message translates to:
  /// **'增加日常活动量，如步行、爬楼梯'**
  String get ui_auto_aslist_1d5778948a;

  /// No description provided for @ui_auto_aslist_1e3ff18ab7.
  ///
  /// In zh, this message translates to:
  /// **'保持规律的有氧运动'**
  String get ui_auto_aslist_1e3ff18ab7;

  /// No description provided for @ui_auto_aslist_204d65fe6b.
  ///
  /// In zh, this message translates to:
  /// **'制定合理的热量缺口（每日减少300-500卡路里）'**
  String get ui_auto_aslist_204d65fe6b;

  /// No description provided for @ui_auto_aslist_207bb3aab5.
  ///
  /// In zh, this message translates to:
  /// **'考虑心电图、心脏超声等检查'**
  String get ui_auto_aslist_207bb3aab5;

  /// No description provided for @ui_auto_aslist_23a732eecc.
  ///
  /// In zh, this message translates to:
  /// **'有问题'**
  String get ui_auto_aslist_23a732eecc;

  /// No description provided for @ui_auto_aslist_242e467a6b.
  ///
  /// In zh, this message translates to:
  /// **'确保充足的恢复时间'**
  String get ui_auto_aslist_242e467a6b;

  /// No description provided for @ui_auto_aslist_26b9c15a52.
  ///
  /// In zh, this message translates to:
  /// **'评估'**
  String get ui_auto_aslist_26b9c15a52;

  /// No description provided for @ui_auto_aslist_294b9f5ec2.
  ///
  /// In zh, this message translates to:
  /// **'学习并练习深呼吸技巧'**
  String get ui_auto_aslist_294b9f5ec2;

  /// No description provided for @ui_auto_aslist_29c0a66c1a.
  ///
  /// In zh, this message translates to:
  /// **'担心'**
  String get ui_auto_aslist_29c0a66c1a;

  /// No description provided for @ui_auto_aslist_2a58569390.
  ///
  /// In zh, this message translates to:
  /// **'规律进行中等强度有氧运动'**
  String get ui_auto_aslist_2a58569390;

  /// No description provided for @ui_auto_aslist_2bfb991872.
  ///
  /// In zh, this message translates to:
  /// **'了解如何改善健康评分'**
  String get ui_auto_aslist_2bfb991872;

  /// No description provided for @ui_auto_aslist_2d10c1bfaf.
  ///
  /// In zh, this message translates to:
  /// **'结合有氧运动和力量训练'**
  String get ui_auto_aslist_2d10c1bfaf;

  /// No description provided for @ui_auto_aslist_2d47912ebf.
  ///
  /// In zh, this message translates to:
  /// **'查看今天的健康数据'**
  String get ui_auto_aslist_2d47912ebf;

  /// No description provided for @ui_auto_aslist_2e606b4e83.
  ///
  /// In zh, this message translates to:
  /// **'获取个性化健康建议'**
  String get ui_auto_aslist_2e606b4e83;

  /// No description provided for @ui_auto_aslist_2f225cf3c9.
  ///
  /// In zh, this message translates to:
  /// **'多食用温热食物，补充能量'**
  String get ui_auto_aslist_2f225cf3c9;

  /// No description provided for @ui_auto_aslist_2f3dc20e06.
  ///
  /// In zh, this message translates to:
  /// **'关注视力和听力健康'**
  String get ui_auto_aslist_2f3dc20e06;

  /// No description provided for @ui_auto_aslist_2fadf1de77.
  ///
  /// In zh, this message translates to:
  /// **'调整作息，适应日照时间变化'**
  String get ui_auto_aslist_2fadf1de77;

  /// No description provided for @ui_auto_aslist_30661a7cb1.
  ///
  /// In zh, this message translates to:
  /// **'交替进行有氧和无氧运动'**
  String get ui_auto_aslist_30661a7cb1;

  /// No description provided for @ui_auto_aslist_30f38042ee.
  ///
  /// In zh, this message translates to:
  /// **'注意防晒，保护皮肤健康'**
  String get ui_auto_aslist_30f38042ee;

  /// No description provided for @ui_auto_aslist_323bf89a32.
  ///
  /// In zh, this message translates to:
  /// **'意思'**
  String get ui_auto_aslist_323bf89a32;

  /// No description provided for @ui_auto_aslist_32459b6693.
  ///
  /// In zh, this message translates to:
  /// **'咨询医生或健康管理师制定个人化计划'**
  String get ui_auto_aslist_32459b6693;

  /// No description provided for @ui_auto_aslist_340cac29e6.
  ///
  /// In zh, this message translates to:
  /// **'增加血压监测频率，每日测量并记录'**
  String get ui_auto_aslist_340cac29e6;

  /// No description provided for @ui_auto_aslist_342de573c8.
  ///
  /// In zh, this message translates to:
  /// **'背部放松到有牵拉感即可'**
  String get ui_auto_aslist_342de573c8;

  /// No description provided for @ui_auto_aslist_34e47d7e3e.
  ///
  /// In zh, this message translates to:
  /// **'控制'**
  String get ui_auto_aslist_34e47d7e3e;

  /// No description provided for @ui_auto_aslist_36e7244ea0.
  ///
  /// In zh, this message translates to:
  /// **'注意花粉过敏，选择合适的运动时间和地点'**
  String get ui_auto_aslist_36e7244ea0;

  /// No description provided for @ui_auto_aslist_38f05712d7.
  ///
  /// In zh, this message translates to:
  /// **'进行适合年龄的阻力训练，保持肌肉量'**
  String get ui_auto_aslist_38f05712d7;

  /// No description provided for @ui_auto_aslist_3da8a7b54e.
  ///
  /// In zh, this message translates to:
  /// **'将运动安排在一天中精力最充沛的时间'**
  String get ui_auto_aslist_3da8a7b54e;

  /// No description provided for @ui_auto_aslist_3ddbb4a510.
  ///
  /// In zh, this message translates to:
  /// **'选择室内运动或温暖时段的户外活动'**
  String get ui_auto_aslist_3ddbb4a510;

  /// No description provided for @ui_auto_aslist_3f9810121c.
  ///
  /// In zh, this message translates to:
  /// **'推荐'**
  String get ui_auto_aslist_3f9810121c;

  /// No description provided for @ui_auto_aslist_42465de230.
  ///
  /// In zh, this message translates to:
  /// **'分析血压变化与生活方式的关联'**
  String get ui_auto_aslist_42465de230;

  /// No description provided for @ui_auto_aslist_4639f5e9e4.
  ///
  /// In zh, this message translates to:
  /// **'运动与心率变异正相关'**
  String get ui_auto_aslist_4639f5e9e4;

  /// No description provided for @ui_auto_aslist_469507dc98.
  ///
  /// In zh, this message translates to:
  /// **'婴儿式'**
  String get ui_auto_aslist_469507dc98;

  /// No description provided for @ui_auto_aslist_4775f47e75.
  ///
  /// In zh, this message translates to:
  /// **'俯身杠铃划船'**
  String get ui_auto_aslist_4775f47e75;

  /// No description provided for @ui_auto_aslist_482d63de47.
  ///
  /// In zh, this message translates to:
  /// **'增加体力活动，每周至少150分钟中等强度运动'**
  String get ui_auto_aslist_482d63de47;

  /// No description provided for @ui_auto_aslist_48f75a24bc.
  ///
  /// In zh, this message translates to:
  /// **'早上好'**
  String get ui_auto_aslist_48f75a24bc;

  /// No description provided for @ui_auto_aslist_49a723099c.
  ///
  /// In zh, this message translates to:
  /// **'关注营养补给，特别是运动前后'**
  String get ui_auto_aslist_49a723099c;

  /// No description provided for @ui_auto_aslist_4a4871febf.
  ///
  /// In zh, this message translates to:
  /// **'加入柔韧性和平衡性训练'**
  String get ui_auto_aslist_4a4871febf;

  /// No description provided for @ui_auto_aslist_4b4c50af60.
  ///
  /// In zh, this message translates to:
  /// **'定期记录体重、血压等关键指标'**
  String get ui_auto_aslist_4b4c50af60;

  /// No description provided for @ui_auto_aslist_4bde0c73d5.
  ///
  /// In zh, this message translates to:
  /// **'如血压持续升高，及时就医调整药物'**
  String get ui_auto_aslist_4bde0c73d5;

  /// No description provided for @ui_auto_aslist_4ce5ce0c12.
  ///
  /// In zh, this message translates to:
  /// **'查看最近的健康数据'**
  String get ui_auto_aslist_4ce5ce0c12;

  /// No description provided for @ui_auto_aslist_4eeba18b67.
  ///
  /// In zh, this message translates to:
  /// **'分析我的整体健康状况'**
  String get ui_auto_aslist_4eeba18b67;

  /// No description provided for @ui_auto_aslist_54007112dc.
  ///
  /// In zh, this message translates to:
  /// **'保持健康的社交关系'**
  String get ui_auto_aslist_54007112dc;

  /// No description provided for @ui_auto_aslist_54511c42ba.
  ///
  /// In zh, this message translates to:
  /// **'躯干保持一条直线，胸部主动发力'**
  String get ui_auto_aslist_54511c42ba;

  /// No description provided for @ui_auto_aslist_54850410f1.
  ///
  /// In zh, this message translates to:
  /// **'血压偏高'**
  String get ui_auto_aslist_54850410f1;

  /// No description provided for @ui_auto_aslist_54c01d94d5.
  ///
  /// In zh, this message translates to:
  /// **'定期进行认知功能评估'**
  String get ui_auto_aslist_54c01d94d5;

  /// No description provided for @ui_auto_aslist_55964636fb.
  ///
  /// In zh, this message translates to:
  /// **'定期进行妇科检查和乳腺检查'**
  String get ui_auto_aslist_55964636fb;

  /// No description provided for @ui_auto_aslist_563e8b64c8.
  ///
  /// In zh, this message translates to:
  /// **'练习深呼吸或冥想放松技巧'**
  String get ui_auto_aslist_563e8b64c8;

  /// No description provided for @ui_auto_aslist_5766c02d4c.
  ///
  /// In zh, this message translates to:
  /// **'选择喜欢的运动类型提高坚持性'**
  String get ui_auto_aslist_5766c02d4c;

  /// No description provided for @ui_auto_aslist_593fbc7f62.
  ///
  /// In zh, this message translates to:
  /// **'使用智能设备辅助数据收集'**
  String get ui_auto_aslist_593fbc7f62;

  /// No description provided for @ui_auto_aslist_59c4e26fd7.
  ///
  /// In zh, this message translates to:
  /// **'补充叶酸，特别是育龄期女性'**
  String get ui_auto_aslist_59c4e26fd7;

  /// No description provided for @ui_auto_aslist_59e12aef7f.
  ///
  /// In zh, this message translates to:
  /// **'核心稳定，速度匀速，不要塌腰'**
  String get ui_auto_aslist_59e12aef7f;

  /// No description provided for @ui_auto_aslist_5bfaa980d3.
  ///
  /// In zh, this message translates to:
  /// **'培养兴趣爱好，增加生活乐趣'**
  String get ui_auto_aslist_5bfaa980d3;

  /// No description provided for @ui_auto_aslist_5c49090ecc.
  ///
  /// In zh, this message translates to:
  /// **'控制晚餐份量，避免睡前进食'**
  String get ui_auto_aslist_5c49090ecc;

  /// No description provided for @ui_auto_aslist_5db61226f3.
  ///
  /// In zh, this message translates to:
  /// **'保持充足的维生素D摄入'**
  String get ui_auto_aslist_5db61226f3;

  /// No description provided for @ui_auto_aslist_6061203a46.
  ///
  /// In zh, this message translates to:
  /// **'评价'**
  String get ui_auto_aslist_6061203a46;

  /// No description provided for @ui_auto_aslist_60e67efb4a.
  ///
  /// In zh, this message translates to:
  /// **'BMI指数代表什么？'**
  String get ui_auto_aslist_60e67efb4a;

  /// No description provided for @ui_auto_aslist_623d56f64d.
  ///
  /// In zh, this message translates to:
  /// **'睡前1小时避免使用电子设备'**
  String get ui_auto_aslist_623d56f64d;

  /// No description provided for @ui_auto_aslist_629427cdb3.
  ///
  /// In zh, this message translates to:
  /// **'记录运动日志，追踪进展'**
  String get ui_auto_aslist_629427cdb3;

  /// No description provided for @ui_auto_aslist_63e9449ad9.
  ///
  /// In zh, this message translates to:
  /// **'适当减少高强度训练频率'**
  String get ui_auto_aslist_63e9449ad9;

  /// No description provided for @ui_auto_aslist_6564093322.
  ///
  /// In zh, this message translates to:
  /// **'收操'**
  String get ui_auto_aslist_6564093322;

  /// No description provided for @ui_auto_aslist_65d9ea821f.
  ///
  /// In zh, this message translates to:
  /// **'定期进行糖化血红蛋白检测'**
  String get ui_auto_aslist_65d9ea821f;

  /// No description provided for @ui_auto_aslist_65ee856938.
  ///
  /// In zh, this message translates to:
  /// **'记录饮食和运动日志'**
  String get ui_auto_aslist_65ee856938;

  /// No description provided for @ui_auto_aslist_6663b6ffa0.
  ///
  /// In zh, this message translates to:
  /// **'主练'**
  String get ui_auto_aslist_6663b6ffa0;

  /// No description provided for @ui_auto_aslist_67bb7ba813.
  ///
  /// In zh, this message translates to:
  /// **'合理安排工作和休息时间'**
  String get ui_auto_aslist_67bb7ba813;

  /// No description provided for @ui_auto_aslist_67db1c36f7.
  ///
  /// In zh, this message translates to:
  /// **'上背部拉伸'**
  String get ui_auto_aslist_67db1c36f7;

  /// No description provided for @ui_auto_aslist_69920badd1.
  ///
  /// In zh, this message translates to:
  /// **'建立放松的睡前仪式（阅读、冥想、轻柔音乐）'**
  String get ui_auto_aslist_69920badd1;

  /// No description provided for @ui_auto_aslist_6ab1f1775c.
  ///
  /// In zh, this message translates to:
  /// **'晚上好'**
  String get ui_auto_aslist_6ab1f1775c;

  /// No description provided for @ui_auto_aslist_6c335b604e.
  ///
  /// In zh, this message translates to:
  /// **'情况'**
  String get ui_auto_aslist_6c335b604e;

  /// No description provided for @ui_auto_aslist_7081f3711b.
  ///
  /// In zh, this message translates to:
  /// **'控制碳水化合物摄入，选择低GI食物'**
  String get ui_auto_aslist_7081f3711b;

  /// No description provided for @ui_auto_aslist_711025b087.
  ///
  /// In zh, this message translates to:
  /// **'必要时寻求专业心理咨询师帮助'**
  String get ui_auto_aslist_711025b087;

  /// No description provided for @ui_auto_aslist_7139a98819.
  ///
  /// In zh, this message translates to:
  /// **'保持规律运动'**
  String get ui_auto_aslist_7139a98819;

  /// No description provided for @ui_auto_aslist_72c677e16f.
  ///
  /// In zh, this message translates to:
  /// **'改善睡眠质量，保证7-8小时睡眠'**
  String get ui_auto_aslist_72c677e16f;

  /// No description provided for @ui_auto_aslist_73f3350bb7.
  ///
  /// In zh, this message translates to:
  /// **'定期进行健康检查，早发现早治疗'**
  String get ui_auto_aslist_73f3350bb7;

  /// No description provided for @ui_auto_aslist_74203850b7.
  ///
  /// In zh, this message translates to:
  /// **'怎么办'**
  String get ui_auto_aslist_74203850b7;

  /// No description provided for @ui_auto_aslist_747b542aca.
  ///
  /// In zh, this message translates to:
  /// **'增加膳食纤维摄入，提高饱腹感'**
  String get ui_auto_aslist_747b542aca;

  /// No description provided for @ui_auto_aslist_7491578e66.
  ///
  /// In zh, this message translates to:
  /// **'从小的生活习惯改变开始'**
  String get ui_auto_aslist_7491578e66;

  /// No description provided for @ui_auto_aslist_74a81a117c.
  ///
  /// In zh, this message translates to:
  /// **'注意保暖，避免感冒'**
  String get ui_auto_aslist_74a81a117c;

  /// No description provided for @ui_auto_aslist_76d2d72001.
  ///
  /// In zh, this message translates to:
  /// **'保持心情愉快，对抗季节性抑郁'**
  String get ui_auto_aslist_76d2d72001;

  /// No description provided for @ui_auto_aslist_7997ee9fa4.
  ///
  /// In zh, this message translates to:
  /// **'加强力量训练，保护肌肉量'**
  String get ui_auto_aslist_7997ee9fa4;

  /// No description provided for @ui_auto_aslist_7b1e0657c7.
  ///
  /// In zh, this message translates to:
  /// **'设定短期可达成的健康目标'**
  String get ui_auto_aslist_7b1e0657c7;

  /// No description provided for @ui_auto_aslist_7b5df123ee.
  ///
  /// In zh, this message translates to:
  /// **'脊柱一节节活动，不要抢节奏'**
  String get ui_auto_aslist_7b5df123ee;

  /// No description provided for @ui_auto_aslist_7e175663eb.
  ///
  /// In zh, this message translates to:
  /// **'适量进补，为冬季储备能量'**
  String get ui_auto_aslist_7e175663eb;

  /// No description provided for @ui_auto_aslist_7eca689f0d.
  ///
  /// In zh, this message translates to:
  /// **'你好'**
  String get ui_auto_aslist_7eca689f0d;

  /// No description provided for @ui_auto_aslist_8069c673ed.
  ///
  /// In zh, this message translates to:
  /// **'增加钙和维生素D的摄入，预防骨质疏松'**
  String get ui_auto_aslist_8069c673ed;

  /// No description provided for @ui_auto_aslist_80904b8d1c.
  ///
  /// In zh, this message translates to:
  /// **'运动对健康有什么好处？'**
  String get ui_auto_aslist_80904b8d1c;

  /// No description provided for @ui_auto_aslist_80ff8146a9.
  ///
  /// In zh, this message translates to:
  /// **'中握距卧推'**
  String get ui_auto_aslist_80ff8146a9;

  /// No description provided for @ui_auto_aslist_8172e43bd7.
  ///
  /// In zh, this message translates to:
  /// **'每次拉伸 20 秒以上，呼吸要平稳'**
  String get ui_auto_aslist_8172e43bd7;

  /// No description provided for @ui_auto_aslist_82b45de06c.
  ///
  /// In zh, this message translates to:
  /// **'给我一些健康建议'**
  String get ui_auto_aslist_82b45de06c;

  /// No description provided for @ui_auto_aslist_83a991d77c.
  ///
  /// In zh, this message translates to:
  /// **'激活'**
  String get ui_auto_aslist_83a991d77c;

  /// No description provided for @ui_auto_aslist_84165bea77.
  ///
  /// In zh, this message translates to:
  /// **'解释我的异常数据'**
  String get ui_auto_aslist_84165bea77;

  /// No description provided for @ui_auto_aslist_85f8c03413.
  ///
  /// In zh, this message translates to:
  /// **'建立规律的睡眠时间，每天同一时间上床睡觉'**
  String get ui_auto_aslist_85f8c03413;

  /// No description provided for @ui_auto_aslist_88a432cd57.
  ///
  /// In zh, this message translates to:
  /// **'关注心理健康，平衡工作和生活'**
  String get ui_auto_aslist_88a432cd57;

  /// No description provided for @ui_auto_aslist_8b9b30343c.
  ///
  /// In zh, this message translates to:
  /// **'猫式拉伸'**
  String get ui_auto_aslist_8b9b30343c;

  /// No description provided for @ui_auto_aslist_8bd806398b.
  ///
  /// In zh, this message translates to:
  /// **'根据季节变化调整运动项目'**
  String get ui_auto_aslist_8bd806398b;

  /// No description provided for @ui_auto_aslist_8bd9d0432c.
  ///
  /// In zh, this message translates to:
  /// **'定期监测空腹血糖和餐后血糖'**
  String get ui_auto_aslist_8bd9d0432c;

  /// No description provided for @ui_auto_aslist_8c9bdf7d38.
  ///
  /// In zh, this message translates to:
  /// **'下午好'**
  String get ui_auto_aslist_8c9bdf7d38;

  /// No description provided for @ui_auto_aslist_8e7f7c4339.
  ///
  /// In zh, this message translates to:
  /// **'每周尝试一种新的运动方式'**
  String get ui_auto_aslist_8e7f7c4339;

  /// No description provided for @ui_auto_aslist_8ee806b903.
  ///
  /// In zh, this message translates to:
  /// **'准备运动装备，减少运动障碍'**
  String get ui_auto_aslist_8ee806b903;

  /// No description provided for @ui_auto_aslist_91b97bb24e.
  ///
  /// In zh, this message translates to:
  /// **'加强肺部保健，预防呼吸道疾病'**
  String get ui_auto_aslist_91b97bb24e;

  /// No description provided for @ui_auto_aslist_94ed6e558b.
  ///
  /// In zh, this message translates to:
  /// **'增加户外运动时间，享受温和阳光'**
  String get ui_auto_aslist_94ed6e558b;

  /// No description provided for @ui_auto_aslist_9aaf967bde.
  ///
  /// In zh, this message translates to:
  /// **'第2步'**
  String get ui_auto_aslist_9aaf967bde;

  /// No description provided for @ui_auto_aslist_9b2401c732.
  ///
  /// In zh, this message translates to:
  /// **'减重'**
  String get ui_auto_aslist_9b2401c732;

  /// No description provided for @ui_auto_aslist_9e5e027ada.
  ///
  /// In zh, this message translates to:
  /// **'管理压力，学习放松技巧'**
  String get ui_auto_aslist_9e5e027ada;

  /// No description provided for @ui_auto_aslist_a067a9057c.
  ///
  /// In zh, this message translates to:
  /// **'建立日常健康数据记录习惯'**
  String get ui_auto_aslist_a067a9057c;

  /// No description provided for @ui_auto_aslist_a0cd3f42f3.
  ///
  /// In zh, this message translates to:
  /// **'考虑瑜伽、太极等恢复性运动'**
  String get ui_auto_aslist_a0cd3f42f3;

  /// No description provided for @ui_auto_aslist_a1f2c14edf.
  ///
  /// In zh, this message translates to:
  /// **'低强度进入状态，先把呼吸找回来'**
  String get ui_auto_aslist_a1f2c14edf;

  /// No description provided for @ui_auto_aslist_a38e35968f.
  ///
  /// In zh, this message translates to:
  /// **'从每周增加1次运动开始'**
  String get ui_auto_aslist_a38e35968f;

  /// No description provided for @ui_auto_aslist_a527282e96.
  ///
  /// In zh, this message translates to:
  /// **'建立规律的运动习惯，预防代谢疾病'**
  String get ui_auto_aslist_a527282e96;

  /// No description provided for @ui_auto_aslist_aa07c3f6b6.
  ///
  /// In zh, this message translates to:
  /// **'增加训练多样性，避免运动适应'**
  String get ui_auto_aslist_aa07c3f6b6;

  /// No description provided for @ui_auto_aslist_aaba43333f.
  ///
  /// In zh, this message translates to:
  /// **'控制体重，BMI维持在18.5-23.9'**
  String get ui_auto_aslist_aaba43333f;

  /// No description provided for @ui_auto_aslist_aafc522132.
  ///
  /// In zh, this message translates to:
  /// **'如何建立运动习惯'**
  String get ui_auto_aslist_aafc522132;

  /// No description provided for @ui_auto_aslist_ace1a5af77.
  ///
  /// In zh, this message translates to:
  /// **'如何理解心率变异性？'**
  String get ui_auto_aslist_ace1a5af77;

  /// No description provided for @ui_auto_aslist_aef5ccf3ff.
  ///
  /// In zh, this message translates to:
  /// **'什么是正常的血压范围？'**
  String get ui_auto_aslist_aef5ccf3ff;

  /// No description provided for @ui_auto_aslist_b034f9da2f.
  ///
  /// In zh, this message translates to:
  /// **'如何'**
  String get ui_auto_aslist_b034f9da2f;

  /// No description provided for @ui_auto_aslist_b0e7abd4a4.
  ///
  /// In zh, this message translates to:
  /// **'查看详细的风险分析'**
  String get ui_auto_aslist_b0e7abd4a4;

  /// No description provided for @ui_auto_aslist_b169949bb6.
  ///
  /// In zh, this message translates to:
  /// **'每次运动30-45分钟'**
  String get ui_auto_aslist_b169949bb6;

  /// No description provided for @ui_auto_aslist_b5316613f7.
  ///
  /// In zh, this message translates to:
  /// **'腘绳肌拉伸'**
  String get ui_auto_aslist_b5316613f7;

  /// No description provided for @ui_auto_aslist_b56f534cd7.
  ///
  /// In zh, this message translates to:
  /// **'多食用新鲜蔬菜，补充维生素'**
  String get ui_auto_aslist_b56f534cd7;

  /// No description provided for @ui_auto_aslist_b6b9ceb50b.
  ///
  /// In zh, this message translates to:
  /// **'解释'**
  String get ui_auto_aslist_b6b9ceb50b;

  /// No description provided for @ui_auto_aslist_b6dc4a01fb.
  ///
  /// In zh, this message translates to:
  /// **'如何理解'**
  String get ui_auto_aslist_b6dc4a01fb;

  /// No description provided for @ui_auto_aslist_b893442b37.
  ///
  /// In zh, this message translates to:
  /// **'综合评估血压、血糖、血脂、腰围指标'**
  String get ui_auto_aslist_b893442b37;

  /// No description provided for @ui_auto_aslist_b9e9328c02.
  ///
  /// In zh, this message translates to:
  /// **'我想减重5公斤'**
  String get ui_auto_aslist_b9e9328c02;

  /// No description provided for @ui_auto_aslist_bb17ff328b.
  ///
  /// In zh, this message translates to:
  /// **'第3步'**
  String get ui_auto_aslist_bb17ff328b;

  /// No description provided for @ui_auto_aslist_bb725f7b61.
  ///
  /// In zh, this message translates to:
  /// **'放松'**
  String get ui_auto_aslist_bb725f7b61;

  /// No description provided for @ui_auto_aslist_bc210a18f9.
  ///
  /// In zh, this message translates to:
  /// **'制定血压控制计划'**
  String get ui_auto_aslist_bc210a18f9;

  /// No description provided for @ui_auto_aslist_bc2a6098f1.
  ///
  /// In zh, this message translates to:
  /// **'增加蛋白质摄入比例至总热量的25-30%'**
  String get ui_auto_aslist_bc2a6098f1;

  /// No description provided for @ui_auto_aslist_bc378fd942.
  ///
  /// In zh, this message translates to:
  /// **'监测身体成分变化，不仅关注体重'**
  String get ui_auto_aslist_bc378fd942;

  /// No description provided for @ui_auto_aslist_be2c31ecb6.
  ///
  /// In zh, this message translates to:
  /// **'单臂哑铃划船'**
  String get ui_auto_aslist_be2c31ecb6;

  /// No description provided for @ui_auto_aslist_bef7bf664c.
  ///
  /// In zh, this message translates to:
  /// **'登山者'**
  String get ui_auto_aslist_bef7bf664c;

  /// No description provided for @ui_auto_aslist_bf3971dc42.
  ///
  /// In zh, this message translates to:
  /// **'收尾'**
  String get ui_auto_aslist_bf3971dc42;

  /// No description provided for @ui_auto_aslist_bf420e1efb.
  ///
  /// In zh, this message translates to:
  /// **'学习应对中年期生理和心理变化'**
  String get ui_auto_aslist_bf420e1efb;

  /// No description provided for @ui_auto_aslist_bfde964498.
  ///
  /// In zh, this message translates to:
  /// **'希望'**
  String get ui_auto_aslist_bfde964498;

  /// No description provided for @ui_auto_aslist_c39d23e383.
  ///
  /// In zh, this message translates to:
  /// **'管理工作和生活压力'**
  String get ui_auto_aslist_c39d23e383;

  /// No description provided for @ui_auto_aslist_c679f933f6.
  ///
  /// In zh, this message translates to:
  /// **'确保蛋白质摄入充足（每公斤体重1.2-1.6g）'**
  String get ui_auto_aslist_c679f933f6;

  /// No description provided for @ui_auto_aslist_c6be50b134.
  ///
  /// In zh, this message translates to:
  /// **'想要'**
  String get ui_auto_aslist_c6be50b134;

  /// No description provided for @ui_auto_aslist_c6d0958e31.
  ///
  /// In zh, this message translates to:
  /// **'快速跳绳'**
  String get ui_auto_aslist_c6d0958e31;

  /// No description provided for @ui_auto_aslist_c7dcc54596.
  ///
  /// In zh, this message translates to:
  /// **'定期监测血压、血脂、血糖'**
  String get ui_auto_aslist_c7dcc54596;

  /// No description provided for @ui_auto_aslist_c8e923d5bf.
  ///
  /// In zh, this message translates to:
  /// **'关注钙质补充，预防骨质疏松'**
  String get ui_auto_aslist_c8e923d5bf;

  /// No description provided for @ui_auto_aslist_cbc6d7e093.
  ///
  /// In zh, this message translates to:
  /// **'椭圆机'**
  String get ui_auto_aslist_cbc6d7e093;

  /// No description provided for @ui_auto_aslist_cc49c9b42f.
  ///
  /// In zh, this message translates to:
  /// **'保持室内通风，预防中暑'**
  String get ui_auto_aslist_cc49c9b42f;

  /// No description provided for @ui_auto_aslist_cddabcbdb5.
  ///
  /// In zh, this message translates to:
  /// **'限制钠盐摄入（每日&lt;6g）'**
  String get ui_auto_aslist_cddabcbdb5;

  /// No description provided for @ui_auto_aslist_ce9f742216.
  ///
  /// In zh, this message translates to:
  /// **'参加团体运动或课程'**
  String get ui_auto_aslist_ce9f742216;

  /// No description provided for @ui_auto_aslist_cf2e53fbee.
  ///
  /// In zh, this message translates to:
  /// **'划船机'**
  String get ui_auto_aslist_cf2e53fbee;

  /// No description provided for @ui_auto_aslist_cf73f8670e.
  ///
  /// In zh, this message translates to:
  /// **'评估当前训练强度是否合适'**
  String get ui_auto_aslist_cf73f8670e;

  /// No description provided for @ui_auto_aslist_cf9e991128.
  ///
  /// In zh, this message translates to:
  /// **'为什么'**
  String get ui_auto_aslist_cf9e991128;

  /// No description provided for @ui_auto_aslist_d0172de84c.
  ///
  /// In zh, this message translates to:
  /// **'心血管疾病'**
  String get ui_auto_aslist_d0172de84c;

  /// No description provided for @ui_auto_aslist_d03e75558c.
  ///
  /// In zh, this message translates to:
  /// **'先收肩胛再拉肘，不要耸肩借力'**
  String get ui_auto_aslist_d03e75558c;

  /// No description provided for @ui_auto_aslist_d0571ca3cd.
  ///
  /// In zh, this message translates to:
  /// **'寻求家人朋友的支持'**
  String get ui_auto_aslist_d0571ca3cd;

  /// No description provided for @ui_auto_aslist_d0e2a0089d.
  ///
  /// In zh, this message translates to:
  /// **'确保充足的铁元素摄入，预防缺铁性贫血'**
  String get ui_auto_aslist_d0e2a0089d;

  /// No description provided for @ui_auto_aslist_d18a5bfd68.
  ///
  /// In zh, this message translates to:
  /// **'创造良好的睡眠环境（温度18-22°C，安静黑暗）'**
  String get ui_auto_aslist_d18a5bfd68;

  /// No description provided for @ui_auto_aslist_d1d62def9d.
  ///
  /// In zh, this message translates to:
  /// **'设定阶段性减重目标（每月1-2公斤）'**
  String get ui_auto_aslist_d1d62def9d;

  /// No description provided for @ui_auto_aslist_d2324fb1ea.
  ///
  /// In zh, this message translates to:
  /// **'分析我的健康状况'**
  String get ui_auto_aslist_d2324fb1ea;

  /// No description provided for @ui_auto_aslist_d52e9fdabc.
  ///
  /// In zh, this message translates to:
  /// **'制定个性化的饮食和运动计划'**
  String get ui_auto_aslist_d52e9fdabc;

  /// No description provided for @ui_auto_aslist_d61a721dd0.
  ///
  /// In zh, this message translates to:
  /// **'先热身再上强度，降低受伤风险'**
  String get ui_auto_aslist_d61a721dd0;

  /// No description provided for @ui_auto_aslist_dab1949d2e.
  ///
  /// In zh, this message translates to:
  /// **'杯式深蹲'**
  String get ui_auto_aslist_dab1949d2e;

  /// No description provided for @ui_auto_aslist_dcc8446e1c.
  ///
  /// In zh, this message translates to:
  /// **'怎么样'**
  String get ui_auto_aslist_dcc8446e1c;

  /// No description provided for @ui_auto_aslist_e14116bcda.
  ///
  /// In zh, this message translates to:
  /// **'站姿腿后侧与小腿拉伸'**
  String get ui_auto_aslist_e14116bcda;

  /// No description provided for @ui_auto_aslist_e194c6489a.
  ///
  /// In zh, this message translates to:
  /// **'优化睡眠质量，保持规律作息'**
  String get ui_auto_aslist_e194c6489a;

  /// No description provided for @ui_auto_aslist_e2b69c8ab5.
  ///
  /// In zh, this message translates to:
  /// **'状况'**
  String get ui_auto_aslist_e2b69c8ab5;

  /// No description provided for @ui_auto_aslist_e2e27a8725.
  ///
  /// In zh, this message translates to:
  /// **'严重'**
  String get ui_auto_aslist_e2e27a8725;

  /// No description provided for @ui_auto_aslist_e2e9b71b21.
  ///
  /// In zh, this message translates to:
  /// **'制定地中海饮食或DASH饮食计划'**
  String get ui_auto_aslist_e2e9b71b21;

  /// No description provided for @ui_auto_aslist_e32e86c1dc.
  ///
  /// In zh, this message translates to:
  /// **'考虑调整训练频率和强度'**
  String get ui_auto_aslist_e32e86c1dc;

  /// No description provided for @ui_auto_aslist_e40417dcf2.
  ///
  /// In zh, this message translates to:
  /// **'想要改善心血管健康'**
  String get ui_auto_aslist_e40417dcf2;

  /// No description provided for @ui_auto_aslist_e451f1a0f5.
  ///
  /// In zh, this message translates to:
  /// **'分析近期饮食变化，识别高热量食物摄入增加'**
  String get ui_auto_aslist_e451f1a0f5;

  /// No description provided for @ui_auto_aslist_e46e84a168.
  ///
  /// In zh, this message translates to:
  /// **'避免在高温时段进行剧烈运动'**
  String get ui_auto_aslist_e46e84a168;

  /// No description provided for @ui_auto_aslist_e4841cb267.
  ///
  /// In zh, this message translates to:
  /// **'胸肩前侧拉伸'**
  String get ui_auto_aslist_e4841cb267;

  /// No description provided for @ui_auto_aslist_e596d49545.
  ///
  /// In zh, this message translates to:
  /// **'每周称重2-3次，监测体重变化'**
  String get ui_auto_aslist_e596d49545;

  /// No description provided for @ui_auto_aslist_e5da151d15.
  ///
  /// In zh, this message translates to:
  /// **'详细记录运动和饮食信息'**
  String get ui_auto_aslist_e5da151d15;

  /// No description provided for @ui_auto_aslist_e5eefb3831.
  ///
  /// In zh, this message translates to:
  /// **'如持续快速下降，咨询营养师或医生'**
  String get ui_auto_aslist_e5eefb3831;

  /// No description provided for @ui_auto_aslist_e98280544f.
  ///
  /// In zh, this message translates to:
  /// **'进行全面体检，为一年的健康打基础'**
  String get ui_auto_aslist_e98280544f;

  /// No description provided for @ui_auto_aslist_ea340b9dda.
  ///
  /// In zh, this message translates to:
  /// **'方法'**
  String get ui_auto_aslist_ea340b9dda;

  /// No description provided for @ui_auto_aslist_ea3d214c49.
  ///
  /// In zh, this message translates to:
  /// **'不正常'**
  String get ui_auto_aslist_ea3d214c49;

  /// No description provided for @ui_auto_aslist_eb246cfe18.
  ///
  /// In zh, this message translates to:
  /// **'保持适量运动，提高免疫力'**
  String get ui_auto_aslist_eb246cfe18;

  /// No description provided for @ui_auto_aslist_eba45ed327.
  ///
  /// In zh, this message translates to:
  /// **'注意保暖，特别是手脚和关节部位'**
  String get ui_auto_aslist_eba45ed327;

  /// No description provided for @ui_auto_aslist_ee92d89371.
  ///
  /// In zh, this message translates to:
  /// **'戒烟限酒，改善生活方式'**
  String get ui_auto_aslist_ee92d89371;

  /// No description provided for @ui_auto_aslist_f05d9d14e0.
  ///
  /// In zh, this message translates to:
  /// **'保持数据记录的连续性和准确性'**
  String get ui_auto_aslist_f05d9d14e0;

  /// No description provided for @ui_auto_aslist_f2cad2a54f.
  ///
  /// In zh, this message translates to:
  /// **'设定运动提醒和奖励机制'**
  String get ui_auto_aslist_f2cad2a54f;

  /// No description provided for @ui_auto_aslist_f34231986b.
  ///
  /// In zh, this message translates to:
  /// **'避免睡前3小时大量进食和饮用咖啡因'**
  String get ui_auto_aslist_f34231986b;

  /// No description provided for @ui_auto_aslist_f6e1a72a89.
  ///
  /// In zh, this message translates to:
  /// **'慢呼吸，每次拉伸保持 20-30 秒'**
  String get ui_auto_aslist_f6e1a72a89;

  /// No description provided for @ui_auto_aslist_f8340dd056.
  ///
  /// In zh, this message translates to:
  /// **'避免过度节食，保持营养均衡'**
  String get ui_auto_aslist_f8340dd056;

  /// No description provided for @ui_auto_aslist_f8c53ab5a0.
  ///
  /// In zh, this message translates to:
  /// **'俯卧撑'**
  String get ui_auto_aslist_f8c53ab5a0;

  /// No description provided for @ui_auto_aslist_fcf3bc749c.
  ///
  /// In zh, this message translates to:
  /// **'应该'**
  String get ui_auto_aslist_fcf3bc749c;

  /// No description provided for @ui_auto_aslist_fe6516d46f.
  ///
  /// In zh, this message translates to:
  /// **'寻找运动伙伴或加入运动群体'**
  String get ui_auto_aslist_fe6516d46f;

  /// No description provided for @ui_auto_aslist_feb455325e.
  ///
  /// In zh, this message translates to:
  /// **'定期评估和调整健康计划'**
  String get ui_auto_aslist_feb455325e;

  /// No description provided for @ui_auto_aslist_ff3a040e90.
  ///
  /// In zh, this message translates to:
  /// **'第4步'**
  String get ui_auto_aslist_ff3a040e90;

  /// No description provided for @ui_auto_bulk_00a629eaaf.
  ///
  /// In zh, this message translates to:
  /// **'60s'**
  String get ui_auto_bulk_00a629eaaf;

  /// No description provided for @ui_auto_bulk_00cecba9ca.
  ///
  /// In zh, this message translates to:
  /// **'还差 9000 步达到目标'**
  String get ui_auto_bulk_00cecba9ca;

  /// No description provided for @ui_auto_bulk_013139ddad.
  ///
  /// In zh, this message translates to:
  /// **'删除计划'**
  String get ui_auto_bulk_013139ddad;

  /// No description provided for @ui_auto_bulk_013167e450.
  ///
  /// In zh, this message translates to:
  /// **'上臂围'**
  String get ui_auto_bulk_013167e450;

  /// No description provided for @ui_auto_bulk_0152872feb.
  ///
  /// In zh, this message translates to:
  /// **'先给预览，再让用户保存'**
  String get ui_auto_bulk_0152872feb;

  /// No description provided for @ui_auto_bulk_025f8a6123.
  ///
  /// In zh, this message translates to:
  /// **'SDNN'**
  String get ui_auto_bulk_025f8a6123;

  /// No description provided for @ui_auto_bulk_02a6889026.
  ///
  /// In zh, this message translates to:
  /// **'累计获得 0 金币'**
  String get ui_auto_bulk_02a6889026;

  /// No description provided for @ui_auto_bulk_03f38597a6.
  ///
  /// In zh, this message translates to:
  /// **'速度'**
  String get ui_auto_bulk_03f38597a6;

  /// No description provided for @ui_auto_bulk_04902e4d1e.
  ///
  /// In zh, this message translates to:
  /// **'超重'**
  String get ui_auto_bulk_04902e4d1e;

  /// No description provided for @ui_auto_bulk_04b71807c4.
  ///
  /// In zh, this message translates to:
  /// **'输入分钟数'**
  String get ui_auto_bulk_04b71807c4;

  /// No description provided for @ui_auto_bulk_04ec5a9d9e.
  ///
  /// In zh, this message translates to:
  /// **'20 分钟'**
  String get ui_auto_bulk_04ec5a9d9e;

  /// No description provided for @ui_auto_bulk_050dd5a4ae.
  ///
  /// In zh, this message translates to:
  /// **'在可恢复范围内把训练密度拉高，重点做体能和代谢双提升。'**
  String get ui_auto_bulk_050dd5a4ae;

  /// No description provided for @ui_auto_bulk_0520faf837.
  ///
  /// In zh, this message translates to:
  /// **'0/0分钟'**
  String get ui_auto_bulk_0520faf837;

  /// No description provided for @ui_auto_bulk_05b997a163.
  ///
  /// In zh, this message translates to:
  /// **'提高消耗，控节奏 · 约25分钟'**
  String get ui_auto_bulk_05b997a163;

  /// No description provided for @ui_auto_bulk_065a9a5efe.
  ///
  /// In zh, this message translates to:
  /// **'如果今天状态差'**
  String get ui_auto_bulk_065a9a5efe;

  /// No description provided for @ui_auto_bulk_07adc59b17.
  ///
  /// In zh, this message translates to:
  /// **'燃脂'**
  String get ui_auto_bulk_07adc59b17;

  /// No description provided for @ui_auto_bulk_08132e0293.
  ///
  /// In zh, this message translates to:
  /// **'0分钟'**
  String get ui_auto_bulk_08132e0293;

  /// No description provided for @ui_auto_bulk_085bd117d6.
  ///
  /// In zh, this message translates to:
  /// **'说些什么...'**
  String get ui_auto_bulk_085bd117d6;

  /// No description provided for @ui_auto_bulk_0951aa57a4.
  ///
  /// In zh, this message translates to:
  /// **'先选高价值参数'**
  String get ui_auto_bulk_0951aa57a4;

  /// No description provided for @ui_auto_bulk_09b095d8fc.
  ///
  /// In zh, this message translates to:
  /// **'音量'**
  String get ui_auto_bulk_09b095d8fc;

  /// No description provided for @ui_auto_bulk_09d44261d7.
  ///
  /// In zh, this message translates to:
  /// **'数据导出'**
  String get ui_auto_bulk_09d44261d7;

  /// No description provided for @ui_auto_bulk_0cab9262b0.
  ///
  /// In zh, this message translates to:
  /// **'本周先练\\n不先练满'**
  String get ui_auto_bulk_0cab9262b0;

  /// No description provided for @ui_auto_bulk_0d0ad79ebc.
  ///
  /// In zh, this message translates to:
  /// **'时间计时'**
  String get ui_auto_bulk_0d0ad79ebc;

  /// No description provided for @ui_auto_bulk_0d3895b4dc.
  ///
  /// In zh, this message translates to:
  /// **'运动类型'**
  String get ui_auto_bulk_0d3895b4dc;

  /// No description provided for @ui_auto_bulk_0d3ee579c8.
  ///
  /// In zh, this message translates to:
  /// **'耐力'**
  String get ui_auto_bulk_0d3ee579c8;

  /// No description provided for @ui_auto_bulk_0d4dd9d9ca.
  ///
  /// In zh, this message translates to:
  /// **'随时能改'**
  String get ui_auto_bulk_0d4dd9d9ca;

  /// No description provided for @ui_auto_bulk_0df6d81ce0.
  ///
  /// In zh, this message translates to:
  /// **'🙁'**
  String get ui_auto_bulk_0df6d81ce0;

  /// No description provided for @ui_auto_bulk_0e19f86e8d.
  ///
  /// In zh, this message translates to:
  /// **'10 分钟'**
  String get ui_auto_bulk_0e19f86e8d;

  /// No description provided for @ui_auto_bulk_0f69017824.
  ///
  /// In zh, this message translates to:
  /// **'因为什么'**
  String get ui_auto_bulk_0f69017824;

  /// No description provided for @ui_auto_bulk_0f7efab97b.
  ///
  /// In zh, this message translates to:
  /// **'不是空白配置页'**
  String get ui_auto_bulk_0f7efab97b;

  /// No description provided for @ui_auto_bulk_105ad7aab5.
  ///
  /// In zh, this message translates to:
  /// **'50 公斤'**
  String get ui_auto_bulk_105ad7aab5;

  /// No description provided for @ui_auto_bulk_108a50c1e0.
  ///
  /// In zh, this message translates to:
  /// **'热量（千卡）'**
  String get ui_auto_bulk_108a50c1e0;

  /// No description provided for @ui_auto_bulk_10eac094ea.
  ///
  /// In zh, this message translates to:
  /// **'记录一次体重、体脂与水分状态后，这里会显示变化趋势。'**
  String get ui_auto_bulk_10eac094ea;

  /// No description provided for @ui_auto_bulk_115f30e39b.
  ///
  /// In zh, this message translates to:
  /// **'运动时长（分钟）'**
  String get ui_auto_bulk_115f30e39b;

  /// No description provided for @ui_auto_bulk_1277801423.
  ///
  /// In zh, this message translates to:
  /// **'当时心情'**
  String get ui_auto_bulk_1277801423;

  /// No description provided for @ui_auto_bulk_130b7dbaf3.
  ///
  /// In zh, this message translates to:
  /// **'通知解析'**
  String get ui_auto_bulk_130b7dbaf3;

  /// No description provided for @ui_auto_bulk_13d063fe23.
  ///
  /// In zh, this message translates to:
  /// **'STEP 1'**
  String get ui_auto_bulk_13d063fe23;

  /// No description provided for @ui_auto_bulk_13f4afff1c.
  ///
  /// In zh, this message translates to:
  /// **'备注和标签'**
  String get ui_auto_bulk_13f4afff1c;

  /// No description provided for @ui_auto_bulk_150162504e.
  ///
  /// In zh, this message translates to:
  /// **'局数'**
  String get ui_auto_bulk_150162504e;

  /// No description provided for @ui_auto_bulk_15a9ab25f8.
  ///
  /// In zh, this message translates to:
  /// **'连接传感器后更准确'**
  String get ui_auto_bulk_15a9ab25f8;

  /// No description provided for @ui_auto_bulk_15d0dc626c.
  ///
  /// In zh, this message translates to:
  /// **'0/0千卡'**
  String get ui_auto_bulk_15d0dc626c;

  /// No description provided for @ui_auto_bulk_15d3c80a93.
  ///
  /// In zh, this message translates to:
  /// **'内脏脂肪等级'**
  String get ui_auto_bulk_15d3c80a93;

  /// No description provided for @ui_auto_bulk_15df591b90.
  ///
  /// In zh, this message translates to:
  /// **'下一项'**
  String get ui_auto_bulk_15df591b90;

  /// No description provided for @ui_auto_bulk_16d956fbf0.
  ///
  /// In zh, this message translates to:
  /// **'正在结合您近期的数据生成个性化的运动趋势分析结果。'**
  String get ui_auto_bulk_16d956fbf0;

  /// No description provided for @ui_auto_bulk_171b7f715d.
  ///
  /// In zh, this message translates to:
  /// **'💡 推荐每日热量目标'**
  String get ui_auto_bulk_171b7f715d;

  /// No description provided for @ui_auto_bulk_17219b6a05.
  ///
  /// In zh, this message translates to:
  /// **'今日任务'**
  String get ui_auto_bulk_17219b6a05;

  /// No description provided for @ui_auto_bulk_1784329107.
  ///
  /// In zh, this message translates to:
  /// **'0/0次'**
  String get ui_auto_bulk_1784329107;

  /// No description provided for @ui_auto_bulk_1818da1415.
  ///
  /// In zh, this message translates to:
  /// **'目标变化后重新推荐'**
  String get ui_auto_bulk_1818da1415;

  /// No description provided for @ui_auto_bulk_19a854115f.
  ///
  /// In zh, this message translates to:
  /// **'身高'**
  String get ui_auto_bulk_19a854115f;

  /// No description provided for @ui_auto_bulk_1a45bab3ca.
  ///
  /// In zh, this message translates to:
  /// **'💧 白水'**
  String get ui_auto_bulk_1a45bab3ca;

  /// No description provided for @ui_auto_bulk_1c07cc7a83.
  ///
  /// In zh, this message translates to:
  /// **'身体围度 (cm)'**
  String get ui_auto_bulk_1c07cc7a83;

  /// No description provided for @ui_auto_bulk_1cf63ae219.
  ///
  /// In zh, this message translates to:
  /// **'500ml'**
  String get ui_auto_bulk_1cf63ae219;

  /// No description provided for @ui_auto_bulk_1dd5946425.
  ///
  /// In zh, this message translates to:
  /// **'先试试引导训练（燃脂 / 增肌 / 恢复）'**
  String get ui_auto_bulk_1dd5946425;

  /// No description provided for @ui_auto_bulk_1fdfcebe4a.
  ///
  /// In zh, this message translates to:
  /// **'空腹时长（小时）'**
  String get ui_auto_bulk_1fdfcebe4a;

  /// No description provided for @ui_auto_bulk_20252d00aa.
  ///
  /// In zh, this message translates to:
  /// **'最高纪录'**
  String get ui_auto_bulk_20252d00aa;

  /// No description provided for @ui_auto_bulk_2108ca1239.
  ///
  /// In zh, this message translates to:
  /// **'你的训练进度'**
  String get ui_auto_bulk_2108ca1239;

  /// No description provided for @ui_auto_bulk_2195e8b3bb.
  ///
  /// In zh, this message translates to:
  /// **'注射后间隔（分钟）'**
  String get ui_auto_bulk_2195e8b3bb;

  /// No description provided for @ui_auto_bulk_21efd88b67.
  ///
  /// In zh, this message translates to:
  /// **'暂无数据'**
  String get ui_auto_bulk_21efd88b67;

  /// No description provided for @ui_auto_bulk_23767abb02.
  ///
  /// In zh, this message translates to:
  /// **'练习时长'**
  String get ui_auto_bulk_23767abb02;

  /// No description provided for @ui_auto_bulk_2432b57515.
  ///
  /// In zh, this message translates to:
  /// **'备注'**
  String get ui_auto_bulk_2432b57515;

  /// No description provided for @ui_auto_bulk_2496af30b6.
  ///
  /// In zh, this message translates to:
  /// **'50%'**
  String get ui_auto_bulk_2496af30b6;

  /// No description provided for @ui_auto_bulk_265060d874.
  ///
  /// In zh, this message translates to:
  /// **'😴 休息'**
  String get ui_auto_bulk_265060d874;

  /// No description provided for @ui_auto_bulk_275877b563.
  ///
  /// In zh, this message translates to:
  /// **'添加喝水记录'**
  String get ui_auto_bulk_275877b563;

  /// No description provided for @ui_auto_bulk_2919fb84ab.
  ///
  /// In zh, this message translates to:
  /// **'表现评分'**
  String get ui_auto_bulk_2919fb84ab;

  /// No description provided for @ui_auto_bulk_294176e470.
  ///
  /// In zh, this message translates to:
  /// **'记录昨晚睡眠'**
  String get ui_auto_bulk_294176e470;

  /// No description provided for @ui_auto_bulk_2a7bd45586.
  ///
  /// In zh, this message translates to:
  /// **'开始生成我的周计划'**
  String get ui_auto_bulk_2a7bd45586;

  /// No description provided for @ui_auto_bulk_2a91c5cf6b.
  ///
  /// In zh, this message translates to:
  /// **'-- bpm'**
  String get ui_auto_bulk_2a91c5cf6b;

  /// No description provided for @ui_auto_bulk_2ab01e418d.
  ///
  /// In zh, this message translates to:
  /// **'一般'**
  String get ui_auto_bulk_2ab01e418d;

  /// No description provided for @ui_auto_bulk_2b3ec5c712.
  ///
  /// In zh, this message translates to:
  /// **'📚 学习'**
  String get ui_auto_bulk_2b3ec5c712;

  /// No description provided for @ui_auto_bulk_2c0cfe2d63.
  ///
  /// In zh, this message translates to:
  /// **'体重趋势'**
  String get ui_auto_bulk_2c0cfe2d63;

  /// No description provided for @ui_auto_bulk_2c373332c4.
  ///
  /// In zh, this message translates to:
  /// **'运动记录'**
  String get ui_auto_bulk_2c373332c4;

  /// No description provided for @ui_auto_bulk_2c825a9900.
  ///
  /// In zh, this message translates to:
  /// **'选择时间'**
  String get ui_auto_bulk_2c825a9900;

  /// No description provided for @ui_auto_bulk_2d1aa98550.
  ///
  /// In zh, this message translates to:
  /// **'显示通知栏'**
  String get ui_auto_bulk_2d1aa98550;

  /// No description provided for @ui_auto_bulk_2e20a7a9c8.
  ///
  /// In zh, this message translates to:
  /// **'中体力劳动（常常运动、每周3-5天）'**
  String get ui_auto_bulk_2e20a7a9c8;

  /// No description provided for @ui_auto_bulk_2ed278fedd.
  ///
  /// In zh, this message translates to:
  /// **'测量条件'**
  String get ui_auto_bulk_2ed278fedd;

  /// No description provided for @ui_auto_bulk_2f192c03bb.
  ///
  /// In zh, this message translates to:
  /// **'血糖管理'**
  String get ui_auto_bulk_2f192c03bb;

  /// No description provided for @ui_auto_bulk_2f56053ac9.
  ///
  /// In zh, this message translates to:
  /// **'今日训练'**
  String get ui_auto_bulk_2f56053ac9;

  /// No description provided for @ui_auto_bulk_301391fc4b.
  ///
  /// In zh, this message translates to:
  /// **'计划描述'**
  String get ui_auto_bulk_301391fc4b;

  /// No description provided for @ui_auto_bulk_307914b4a8.
  ///
  /// In zh, this message translates to:
  /// **'测量时间'**
  String get ui_auto_bulk_307914b4a8;

  /// No description provided for @ui_auto_bulk_3193ca44d6.
  ///
  /// In zh, this message translates to:
  /// **'根据时长估算'**
  String get ui_auto_bulk_3193ca44d6;

  /// No description provided for @ui_auto_bulk_31ca04728a.
  ///
  /// In zh, this message translates to:
  /// **'把下肢循环换成 20 分钟低强度有氧，计划仍然记为完成，但会自动下调本周后两天负荷。'**
  String get ui_auto_bulk_31ca04728a;

  /// No description provided for @ui_auto_bulk_31dcf6e093.
  ///
  /// In zh, this message translates to:
  /// **'最近还没有身体成分记录'**
  String get ui_auto_bulk_31dcf6e093;

  /// No description provided for @ui_auto_bulk_3250972b7e.
  ///
  /// In zh, this message translates to:
  /// **'20000步'**
  String get ui_auto_bulk_3250972b7e;

  /// No description provided for @ui_auto_bulk_3343e5f931.
  ///
  /// In zh, this message translates to:
  /// **'热身'**
  String get ui_auto_bulk_3343e5f931;

  /// No description provided for @ui_auto_bulk_334aaec45f.
  ///
  /// In zh, this message translates to:
  /// **'你好，用户'**
  String get ui_auto_bulk_334aaec45f;

  /// No description provided for @ui_auto_bulk_34a9e4e945.
  ///
  /// In zh, this message translates to:
  /// **'近期饮酒'**
  String get ui_auto_bulk_34a9e4e945;

  /// No description provided for @ui_auto_bulk_36a4908a55.
  ///
  /// In zh, this message translates to:
  /// **'男'**
  String get ui_auto_bulk_36a4908a55;

  /// No description provided for @ui_auto_bulk_37b9d8de53.
  ///
  /// In zh, this message translates to:
  /// **'请输入每日目标热量（千卡）'**
  String get ui_auto_bulk_37b9d8de53;

  /// No description provided for @ui_auto_bulk_37fb6a4fae.
  ///
  /// In zh, this message translates to:
  /// **'预计 145 分钟 / 周 · 包含 2 天恢复安排'**
  String get ui_auto_bulk_37fb6a4fae;

  /// No description provided for @ui_auto_bulk_3a17b7352e.
  ///
  /// In zh, this message translates to:
  /// **'分钟'**
  String get ui_auto_bulk_3a17b7352e;

  /// No description provided for @ui_auto_bulk_3a8869f54a.
  ///
  /// In zh, this message translates to:
  /// **'无体力劳动（几乎不运动）'**
  String get ui_auto_bulk_3a8869f54a;

  /// No description provided for @ui_auto_bulk_3aa3508cf8.
  ///
  /// In zh, this message translates to:
  /// **'记状态'**
  String get ui_auto_bulk_3aa3508cf8;

  /// No description provided for @ui_auto_bulk_3ad28fd7df.
  ///
  /// In zh, this message translates to:
  /// **'💎 矿泉水'**
  String get ui_auto_bulk_3ad28fd7df;

  /// No description provided for @ui_auto_bulk_3babafa028.
  ///
  /// In zh, this message translates to:
  /// **'年龄（岁）'**
  String get ui_auto_bulk_3babafa028;

  /// No description provided for @ui_auto_bulk_3bca6fb348.
  ///
  /// In zh, this message translates to:
  /// **'当前压力水平'**
  String get ui_auto_bulk_3bca6fb348;

  /// No description provided for @ui_auto_bulk_3cd5944a33.
  ///
  /// In zh, this message translates to:
  /// **'骨量 (kg)'**
  String get ui_auto_bulk_3cd5944a33;

  /// No description provided for @ui_auto_bulk_3da59100ac.
  ///
  /// In zh, this message translates to:
  /// **'运动时长'**
  String get ui_auto_bulk_3da59100ac;

  /// No description provided for @ui_auto_bulk_3e1e146d01.
  ///
  /// In zh, this message translates to:
  /// **'身体数据'**
  String get ui_auto_bulk_3e1e146d01;

  /// No description provided for @ui_auto_bulk_3e20450940.
  ///
  /// In zh, this message translates to:
  /// **'总步数'**
  String get ui_auto_bulk_3e20450940;

  /// No description provided for @ui_auto_bulk_3ec2bba02a.
  ///
  /// In zh, this message translates to:
  /// **'距离'**
  String get ui_auto_bulk_3ec2bba02a;

  /// No description provided for @ui_auto_bulk_3f3663e911.
  ///
  /// In zh, this message translates to:
  /// **'帮助与反馈'**
  String get ui_auto_bulk_3f3663e911;

  /// No description provided for @ui_auto_bulk_400cde287f.
  ///
  /// In zh, this message translates to:
  /// **'每组次数'**
  String get ui_auto_bulk_400cde287f;

  /// No description provided for @ui_auto_bulk_401579141e.
  ///
  /// In zh, this message translates to:
  /// **'这里是动作的详细说明...'**
  String get ui_auto_bulk_401579141e;

  /// No description provided for @ui_auto_bulk_409dacafd0.
  ///
  /// In zh, this message translates to:
  /// **'柠檬水'**
  String get ui_auto_bulk_409dacafd0;

  /// No description provided for @ui_auto_bulk_418853708e.
  ///
  /// In zh, this message translates to:
  /// **'0.00 km'**
  String get ui_auto_bulk_418853708e;

  /// No description provided for @ui_auto_bulk_421ae42e13.
  ///
  /// In zh, this message translates to:
  /// **'椰子水'**
  String get ui_auto_bulk_421ae42e13;

  /// No description provided for @ui_auto_bulk_42a6c3ef84.
  ///
  /// In zh, this message translates to:
  /// **'开启声音'**
  String get ui_auto_bulk_42a6c3ef84;

  /// No description provided for @ui_auto_bulk_42ac5dc592.
  ///
  /// In zh, this message translates to:
  /// **'0 分钟'**
  String get ui_auto_bulk_42ac5dc592;

  /// No description provided for @ui_auto_bulk_42f6a2ccfa.
  ///
  /// In zh, this message translates to:
  /// **'记录一次更完整的身体状态'**
  String get ui_auto_bulk_42f6a2ccfa;

  /// No description provided for @ui_auto_bulk_42fc5dcc25.
  ///
  /// In zh, this message translates to:
  /// **'可按设备实际提供的数据补充录入，不需要每项都填写。'**
  String get ui_auto_bulk_42fc5dcc25;

  /// No description provided for @ui_auto_bulk_4332c0684a.
  ///
  /// In zh, this message translates to:
  /// **'偏瘦'**
  String get ui_auto_bulk_4332c0684a;

  /// No description provided for @ui_auto_bulk_44604fd93b.
  ///
  /// In zh, this message translates to:
  /// **'例如 晨跑、核心训练'**
  String get ui_auto_bulk_44604fd93b;

  /// No description provided for @ui_auto_bulk_44ea12be04.
  ///
  /// In zh, this message translates to:
  /// **'去评分'**
  String get ui_auto_bulk_44ea12be04;

  /// No description provided for @ui_auto_bulk_44efd179aa.
  ///
  /// In zh, this message translates to:
  /// **'退出登录'**
  String get ui_auto_bulk_44efd179aa;

  /// No description provided for @ui_auto_bulk_4540466142.
  ///
  /// In zh, this message translates to:
  /// **'计划进度\\n4 / 7'**
  String get ui_auto_bulk_4540466142;

  /// No description provided for @ui_auto_bulk_47afab0496.
  ///
  /// In zh, this message translates to:
  /// **'入睡时间'**
  String get ui_auto_bulk_47afab0496;

  /// No description provided for @ui_auto_bulk_47e25812af.
  ///
  /// In zh, this message translates to:
  /// **'PNN50'**
  String get ui_auto_bulk_47e25812af;

  /// No description provided for @ui_auto_bulk_48188a252d.
  ///
  /// In zh, this message translates to:
  /// **'记录时间'**
  String get ui_auto_bulk_48188a252d;

  /// No description provided for @ui_auto_bulk_48da582a83.
  ///
  /// In zh, this message translates to:
  /// **'重体力劳动（强度运动、长时间运动或体力劳动）'**
  String get ui_auto_bulk_48da582a83;

  /// No description provided for @ui_auto_bulk_490ce35435.
  ///
  /// In zh, this message translates to:
  /// **'徒手下肢循环 · 28 分钟'**
  String get ui_auto_bulk_490ce35435;

  /// No description provided for @ui_auto_bulk_4917957375.
  ///
  /// In zh, this message translates to:
  /// **'开始后会持续更新里程、速度、热量和心率。'**
  String get ui_auto_bulk_4917957375;

  /// No description provided for @ui_auto_bulk_492b4198db.
  ///
  /// In zh, this message translates to:
  /// **'睡眠质量'**
  String get ui_auto_bulk_492b4198db;

  /// No description provided for @ui_auto_bulk_49f7b8052f.
  ///
  /// In zh, this message translates to:
  /// **'减脂 · 初级轻启动'**
  String get ui_auto_bulk_49f7b8052f;

  /// No description provided for @ui_auto_bulk_49fcbce491.
  ///
  /// In zh, this message translates to:
  /// **'按组记录次数和重量，适合力量训练类运动。'**
  String get ui_auto_bulk_49fcbce491;

  /// No description provided for @ui_auto_bulk_4a340f2531.
  ///
  /// In zh, this message translates to:
  /// **'经常运动的人睡眠质量比一般人好 50%'**
  String get ui_auto_bulk_4a340f2531;

  /// No description provided for @ui_auto_bulk_4b1c7e4098.
  ///
  /// In zh, this message translates to:
  /// **'📝 其它'**
  String get ui_auto_bulk_4b1c7e4098;

  /// No description provided for @ui_auto_bulk_4c3699a66a.
  ///
  /// In zh, this message translates to:
  /// **'0 次'**
  String get ui_auto_bulk_4c3699a66a;

  /// No description provided for @ui_auto_bulk_4c8625fc44.
  ///
  /// In zh, this message translates to:
  /// **'建议组数'**
  String get ui_auto_bulk_4c8625fc44;

  /// No description provided for @ui_auto_bulk_4c95a97281.
  ///
  /// In zh, this message translates to:
  /// **'实时追踪'**
  String get ui_auto_bulk_4c95a97281;

  /// No description provided for @ui_auto_bulk_4d09e737b4.
  ///
  /// In zh, this message translates to:
  /// **'语音教练'**
  String get ui_auto_bulk_4d09e737b4;

  /// No description provided for @ui_auto_bulk_4d75379186.
  ///
  /// In zh, this message translates to:
  /// **'睡眠时长'**
  String get ui_auto_bulk_4d75379186;

  /// No description provided for @ui_auto_bulk_4da3fa4e59.
  ///
  /// In zh, this message translates to:
  /// **'STEP 2'**
  String get ui_auto_bulk_4da3fa4e59;

  /// No description provided for @ui_auto_bulk_4ef62706d6.
  ///
  /// In zh, this message translates to:
  /// **'18300步'**
  String get ui_auto_bulk_4ef62706d6;

  /// No description provided for @ui_auto_bulk_4f2f8e3551.
  ///
  /// In zh, this message translates to:
  /// **'3 组 × 40 秒，组间休息 25 秒。'**
  String get ui_auto_bulk_4f2f8e3551;

  /// No description provided for @ui_auto_bulk_510578f618.
  ///
  /// In zh, this message translates to:
  /// **'公众号：微小目标'**
  String get ui_auto_bulk_510578f618;

  /// No description provided for @ui_auto_bulk_51737906c9.
  ///
  /// In zh, this message translates to:
  /// **'引导训练'**
  String get ui_auto_bulk_51737906c9;

  /// No description provided for @ui_auto_bulk_5191e5dafa.
  ///
  /// In zh, this message translates to:
  /// **'计划调整'**
  String get ui_auto_bulk_5191e5dafa;

  /// No description provided for @ui_auto_bulk_51ec39c345.
  ///
  /// In zh, this message translates to:
  /// **'久坐提醒'**
  String get ui_auto_bulk_51ec39c345;

  /// No description provided for @ui_auto_bulk_5353b85698.
  ///
  /// In zh, this message translates to:
  /// **'分享好友'**
  String get ui_auto_bulk_5353b85698;

  /// No description provided for @ui_auto_bulk_53740305d1.
  ///
  /// In zh, this message translates to:
  /// **'25秒'**
  String get ui_auto_bulk_53740305d1;

  /// No description provided for @ui_auto_bulk_5375b0e4d0.
  ///
  /// In zh, this message translates to:
  /// **'🍵 茶'**
  String get ui_auto_bulk_5375b0e4d0;

  /// No description provided for @ui_auto_bulk_54484868bb.
  ///
  /// In zh, this message translates to:
  /// **'湿度 (%)'**
  String get ui_auto_bulk_54484868bb;

  /// No description provided for @ui_auto_bulk_54654583c8.
  ///
  /// In zh, this message translates to:
  /// **'酸奶'**
  String get ui_auto_bulk_54654583c8;

  /// No description provided for @ui_auto_bulk_546d45c241.
  ///
  /// In zh, this message translates to:
  /// **'体水分 (%)'**
  String get ui_auto_bulk_546d45c241;

  /// No description provided for @ui_auto_bulk_547290ffb7.
  ///
  /// In zh, this message translates to:
  /// **'测试前运动描述'**
  String get ui_auto_bulk_547290ffb7;

  /// No description provided for @ui_auto_bulk_55271f08f0.
  ///
  /// In zh, this message translates to:
  /// **'查看我的训练计划'**
  String get ui_auto_bulk_55271f08f0;

  /// No description provided for @ui_auto_bulk_56071ada2a.
  ///
  /// In zh, this message translates to:
  /// **'胸围'**
  String get ui_auto_bulk_56071ada2a;

  /// No description provided for @ui_auto_bulk_57aa91412a.
  ///
  /// In zh, this message translates to:
  /// **'最小心率'**
  String get ui_auto_bulk_57aa91412a;

  /// No description provided for @ui_auto_bulk_5822c21bda.
  ///
  /// In zh, this message translates to:
  /// **'本周安排应该很直观'**
  String get ui_auto_bulk_5822c21bda;

  /// No description provided for @ui_auto_bulk_5858832b73.
  ///
  /// In zh, this message translates to:
  /// **'设备型号'**
  String get ui_auto_bulk_5858832b73;

  /// No description provided for @ui_auto_bulk_58f93d8b3f.
  ///
  /// In zh, this message translates to:
  /// **'例如 138'**
  String get ui_auto_bulk_58f93d8b3f;

  /// No description provided for @ui_auto_bulk_592c595891.
  ///
  /// In zh, this message translates to:
  /// **'开始时间'**
  String get ui_auto_bulk_592c595891;

  /// No description provided for @ui_auto_bulk_59a40b0d0e.
  ///
  /// In zh, this message translates to:
  /// **'平均配速'**
  String get ui_auto_bulk_59a40b0d0e;

  /// No description provided for @ui_auto_bulk_5ad7f5a8b2.
  ///
  /// In zh, this message translates to:
  /// **'结果'**
  String get ui_auto_bulk_5ad7f5a8b2;

  /// No description provided for @ui_auto_bulk_5bdeb41dd8.
  ///
  /// In zh, this message translates to:
  /// **'🥥 椰子水'**
  String get ui_auto_bulk_5bdeb41dd8;

  /// No description provided for @ui_auto_bulk_5c55cae5a8.
  ///
  /// In zh, this message translates to:
  /// **'这份计划会优先帮你建立稳定训练节奏，不会一开始堆太多量。'**
  String get ui_auto_bulk_5c55cae5a8;

  /// No description provided for @ui_auto_bulk_5c59ce4489.
  ///
  /// In zh, this message translates to:
  /// **'3组'**
  String get ui_auto_bulk_5c59ce4489;

  /// No description provided for @ui_auto_bulk_5c8d6d3023.
  ///
  /// In zh, this message translates to:
  /// **'🙂'**
  String get ui_auto_bulk_5c8d6d3023;

  /// No description provided for @ui_auto_bulk_5d6aba637b.
  ///
  /// In zh, this message translates to:
  /// **'体脂率 (%)'**
  String get ui_auto_bulk_5d6aba637b;

  /// No description provided for @ui_auto_bulk_5dbebe543d.
  ///
  /// In zh, this message translates to:
  /// **'盒式呼吸 · 4 吸 / 4 停 / 4 呼 / 4 停'**
  String get ui_auto_bulk_5dbebe543d;

  /// No description provided for @ui_auto_bulk_5e213ddbb7.
  ///
  /// In zh, this message translates to:
  /// **'去开启'**
  String get ui_auto_bulk_5e213ddbb7;

  /// No description provided for @ui_auto_bulk_5ec1ca1461.
  ///
  /// In zh, this message translates to:
  /// **'备选：'**
  String get ui_auto_bulk_5ec1ca1461;

  /// No description provided for @ui_auto_bulk_5f411223ca.
  ///
  /// In zh, this message translates to:
  /// **'返回'**
  String get ui_auto_bulk_5f411223ca;

  /// No description provided for @ui_auto_bulk_5f67003388.
  ///
  /// In zh, this message translates to:
  /// **'室温 (℃)'**
  String get ui_auto_bulk_5f67003388;

  /// No description provided for @ui_auto_bulk_5f6805ff44.
  ///
  /// In zh, this message translates to:
  /// **'训练日'**
  String get ui_auto_bulk_5f6805ff44;

  /// No description provided for @ui_auto_bulk_5fbc58e219.
  ///
  /// In zh, this message translates to:
  /// **'本周运动'**
  String get ui_auto_bulk_5fbc58e219;

  /// No description provided for @ui_auto_bulk_5fbf343679.
  ///
  /// In zh, this message translates to:
  /// **'啤酒'**
  String get ui_auto_bulk_5fbf343679;

  /// No description provided for @ui_auto_bulk_5fc6a99264.
  ///
  /// In zh, this message translates to:
  /// **'😭'**
  String get ui_auto_bulk_5fc6a99264;

  /// No description provided for @ui_auto_bulk_60884051c2.
  ///
  /// In zh, this message translates to:
  /// **'更新推荐计划'**
  String get ui_auto_bulk_60884051c2;

  /// No description provided for @ui_auto_bulk_6090f2507f.
  ///
  /// In zh, this message translates to:
  /// **'✈️ 旅行'**
  String get ui_auto_bulk_6090f2507f;

  /// No description provided for @ui_auto_bulk_614351674f.
  ///
  /// In zh, this message translates to:
  /// **'BMI 指数'**
  String get ui_auto_bulk_614351674f;

  /// No description provided for @ui_auto_bulk_621e55b2b5.
  ///
  /// In zh, this message translates to:
  /// **'完成这项动作后，这里会显示你的训练节奏。'**
  String get ui_auto_bulk_621e55b2b5;

  /// No description provided for @ui_auto_bulk_63339e31a2.
  ///
  /// In zh, this message translates to:
  /// **'今日首条'**
  String get ui_auto_bulk_63339e31a2;

  /// No description provided for @ui_auto_bulk_6396cd72d6.
  ///
  /// In zh, this message translates to:
  /// **'200ml'**
  String get ui_auto_bulk_6396cd72d6;

  /// No description provided for @ui_auto_bulk_6449eb722b.
  ///
  /// In zh, this message translates to:
  /// **'点击添加心率'**
  String get ui_auto_bulk_6449eb722b;

  /// No description provided for @ui_auto_bulk_64a4c9a485.
  ///
  /// In zh, this message translates to:
  /// **'选择日期和时间'**
  String get ui_auto_bulk_64a4c9a485;

  /// No description provided for @ui_auto_bulk_65e5d4e4a1.
  ///
  /// In zh, this message translates to:
  /// **'手动录入'**
  String get ui_auto_bulk_65e5d4e4a1;

  /// No description provided for @ui_auto_bulk_661a960aa5.
  ///
  /// In zh, this message translates to:
  /// **'可乐'**
  String get ui_auto_bulk_661a960aa5;

  /// No description provided for @ui_auto_bulk_663eb46459.
  ///
  /// In zh, this message translates to:
  /// **'肌肉量 (kg)'**
  String get ui_auto_bulk_663eb46459;

  /// No description provided for @ui_auto_bulk_66846af9f7.
  ///
  /// In zh, this message translates to:
  /// **'初级'**
  String get ui_auto_bulk_66846af9f7;

  /// No description provided for @ui_auto_bulk_67755bdf54.
  ///
  /// In zh, this message translates to:
  /// **'点击修改 ›'**
  String get ui_auto_bulk_67755bdf54;

  /// No description provided for @ui_auto_bulk_67d8aec47b.
  ///
  /// In zh, this message translates to:
  /// **'大腿围'**
  String get ui_auto_bulk_67d8aec47b;

  /// No description provided for @ui_auto_bulk_689c823769.
  ///
  /// In zh, this message translates to:
  /// **'体力劳动等级'**
  String get ui_auto_bulk_689c823769;

  /// No description provided for @ui_auto_bulk_68bf118227.
  ///
  /// In zh, this message translates to:
  /// **'强体力劳动（每天运动、每周6-7天）'**
  String get ui_auto_bulk_68bf118227;

  /// No description provided for @ui_auto_bulk_68d5a30144.
  ///
  /// In zh, this message translates to:
  /// **'最大心率'**
  String get ui_auto_bulk_68d5a30144;

  /// No description provided for @ui_auto_bulk_697330e457.
  ///
  /// In zh, this message translates to:
  /// **'生理周期第几天 (女性)'**
  String get ui_auto_bulk_697330e457;

  /// No description provided for @ui_auto_bulk_6a806bafe6.
  ///
  /// In zh, this message translates to:
  /// **'训练负荷'**
  String get ui_auto_bulk_6a806bafe6;

  /// No description provided for @ui_auto_bulk_6b566b91d9.
  ///
  /// In zh, this message translates to:
  /// **'本周'**
  String get ui_auto_bulk_6b566b91d9;

  /// No description provided for @ui_auto_bulk_6b60e22def.
  ///
  /// In zh, this message translates to:
  /// **'前夜睡眠质量'**
  String get ui_auto_bulk_6b60e22def;

  /// No description provided for @ui_auto_bulk_6c47d4c8b2.
  ///
  /// In zh, this message translates to:
  /// **'很差'**
  String get ui_auto_bulk_6c47d4c8b2;

  /// No description provided for @ui_auto_bulk_6d97aa3b98.
  ///
  /// In zh, this message translates to:
  /// **'隐私申明'**
  String get ui_auto_bulk_6d97aa3b98;

  /// No description provided for @ui_auto_bulk_6ddeda0dfa.
  ///
  /// In zh, this message translates to:
  /// **'🏥 健康'**
  String get ui_auto_bulk_6ddeda0dfa;

  /// No description provided for @ui_auto_bulk_6e1f569d48.
  ///
  /// In zh, this message translates to:
  /// **'2000 千卡'**
  String get ui_auto_bulk_6e1f569d48;

  /// No description provided for @ui_auto_bulk_6e9ad1b163.
  ///
  /// In zh, this message translates to:
  /// **'查看动作库（补充今天训练内容）'**
  String get ui_auto_bulk_6e9ad1b163;

  /// No description provided for @ui_auto_bulk_6ea1fe6baa.
  ///
  /// In zh, this message translates to:
  /// **'基础信息'**
  String get ui_auto_bulk_6ea1fe6baa;

  /// No description provided for @ui_auto_bulk_7019a5fb92.
  ///
  /// In zh, this message translates to:
  /// **'周一已经完成有氧唤醒，今天接下肢训练最顺。强度不高，但会明显提升你这周的训练存在感。'**
  String get ui_auto_bulk_7019a5fb92;

  /// No description provided for @ui_auto_bulk_709694416b.
  ///
  /// In zh, this message translates to:
  /// **'环境音'**
  String get ui_auto_bulk_709694416b;

  /// No description provided for @ui_auto_bulk_70a1bf3a03.
  ///
  /// In zh, this message translates to:
  /// **'总运动时长 0 分钟'**
  String get ui_auto_bulk_70a1bf3a03;

  /// No description provided for @ui_auto_bulk_70ca1b342a.
  ///
  /// In zh, this message translates to:
  /// **'0步'**
  String get ui_auto_bulk_70ca1b342a;

  /// No description provided for @ui_auto_bulk_71016fe0fe.
  ///
  /// In zh, this message translates to:
  /// **'胰岛素剂量'**
  String get ui_auto_bulk_71016fe0fe;

  /// No description provided for @ui_auto_bulk_7144946d35.
  ///
  /// In zh, this message translates to:
  /// **'点击添加血糖'**
  String get ui_auto_bulk_7144946d35;

  /// No description provided for @ui_auto_bulk_71908a8a0a.
  ///
  /// In zh, this message translates to:
  /// **'豆浆'**
  String get ui_auto_bulk_71908a8a0a;

  /// No description provided for @ui_auto_bulk_720bd06d03.
  ///
  /// In zh, this message translates to:
  /// **'☕ 咖啡'**
  String get ui_auto_bulk_720bd06d03;

  /// No description provided for @ui_auto_bulk_729b26b8e8.
  ///
  /// In zh, this message translates to:
  /// **'😄'**
  String get ui_auto_bulk_729b26b8e8;

  /// No description provided for @ui_auto_bulk_72a66e4b51.
  ///
  /// In zh, this message translates to:
  /// **'每周训练 5 天，先把节奏养起来，再逐步提高训练量。'**
  String get ui_auto_bulk_72a66e4b51;

  /// No description provided for @ui_auto_bulk_731284d1c7.
  ///
  /// In zh, this message translates to:
  /// **'测量时机'**
  String get ui_auto_bulk_731284d1c7;

  /// No description provided for @ui_auto_bulk_732f6f5589.
  ///
  /// In zh, this message translates to:
  /// **'手动输入'**
  String get ui_auto_bulk_732f6f5589;

  /// No description provided for @ui_auto_bulk_736eaaaec5.
  ///
  /// In zh, this message translates to:
  /// **'添加标签'**
  String get ui_auto_bulk_736eaaaec5;

  /// No description provided for @ui_auto_bulk_73b1fe47d7.
  ///
  /// In zh, this message translates to:
  /// **'根据目标体重'**
  String get ui_auto_bulk_73b1fe47d7;

  /// No description provided for @ui_auto_bulk_745e25a85e.
  ///
  /// In zh, this message translates to:
  /// **'很好'**
  String get ui_auto_bulk_745e25a85e;

  /// No description provided for @ui_auto_bulk_7494e5afee.
  ///
  /// In zh, this message translates to:
  /// **'🎵 播放助眠白噪音'**
  String get ui_auto_bulk_7494e5afee;

  /// No description provided for @ui_auto_bulk_74aaba2d12.
  ///
  /// In zh, this message translates to:
  /// **'谐振式呼吸 · 4 吸 / 4 呼'**
  String get ui_auto_bulk_74aaba2d12;

  /// No description provided for @ui_auto_bulk_74e58b1eec.
  ///
  /// In zh, this message translates to:
  /// **'通常只要 10 秒左右就能选好。'**
  String get ui_auto_bulk_74e58b1eec;

  /// No description provided for @ui_auto_bulk_760bb87ccb.
  ///
  /// In zh, this message translates to:
  /// **'活动次数'**
  String get ui_auto_bulk_760bb87ccb;

  /// No description provided for @ui_auto_bulk_77af587985.
  ///
  /// In zh, this message translates to:
  /// **'5天'**
  String get ui_auto_bulk_77af587985;

  /// No description provided for @ui_auto_bulk_77d0bda4a1.
  ///
  /// In zh, this message translates to:
  /// **'核心稳定'**
  String get ui_auto_bulk_77d0bda4a1;

  /// No description provided for @ui_auto_bulk_785a9c111c.
  ///
  /// In zh, this message translates to:
  /// **'皮下脂肪 (%)'**
  String get ui_auto_bulk_785a9c111c;

  /// No description provided for @ui_auto_bulk_786549d926.
  ///
  /// In zh, this message translates to:
  /// **'补充记录测量背景，比如设备变化、饮食、训练或其他特殊状态。'**
  String get ui_auto_bulk_786549d926;

  /// No description provided for @ui_auto_bulk_78b1739a98.
  ///
  /// In zh, this message translates to:
  /// **'🏃 能量饮'**
  String get ui_auto_bulk_78b1739a98;

  /// No description provided for @ui_auto_bulk_7a5794ace9.
  ///
  /// In zh, this message translates to:
  /// **'牛奶'**
  String get ui_auto_bulk_7a5794ace9;

  /// No description provided for @ui_auto_bulk_7a8f0c40c9.
  ///
  /// In zh, this message translates to:
  /// **'建议固定在同一时段测量，得到更稳定的结果。'**
  String get ui_auto_bulk_7a8f0c40c9;

  /// No description provided for @ui_auto_bulk_7ae7cd1386.
  ///
  /// In zh, this message translates to:
  /// **'💡 睡眠小贴士'**
  String get ui_auto_bulk_7ae7cd1386;

  /// No description provided for @ui_auto_bulk_7b4433b054.
  ///
  /// In zh, this message translates to:
  /// **'AI 健康建议主动推送'**
  String get ui_auto_bulk_7b4433b054;

  /// No description provided for @ui_auto_bulk_7bca8c6314.
  ///
  /// In zh, this message translates to:
  /// **'输入关键指标后，这里会自动给出更容易理解的解释。'**
  String get ui_auto_bulk_7bca8c6314;

  /// No description provided for @ui_auto_bulk_7c8f72d7f1.
  ///
  /// In zh, this message translates to:
  /// **'100ml'**
  String get ui_auto_bulk_7c8f72d7f1;

  /// No description provided for @ui_auto_bulk_7ccda04375.
  ///
  /// In zh, this message translates to:
  /// **'控制动作质量，稳步加量 · 约26分钟'**
  String get ui_auto_bulk_7ccda04375;

  /// No description provided for @ui_auto_bulk_7cf2228054.
  ///
  /// In zh, this message translates to:
  /// **'预计消耗'**
  String get ui_auto_bulk_7cf2228054;

  /// No description provided for @ui_auto_bulk_7df81c9f0a.
  ///
  /// In zh, this message translates to:
  /// **'蜂蜜水'**
  String get ui_auto_bulk_7df81c9f0a;

  /// No description provided for @ui_auto_bulk_7e48034805.
  ///
  /// In zh, this message translates to:
  /// **'同步微信步数'**
  String get ui_auto_bulk_7e48034805;

  /// No description provided for @ui_auto_bulk_7e83123cd7.
  ///
  /// In zh, this message translates to:
  /// **'饮品类型'**
  String get ui_auto_bulk_7e83123cd7;

  /// No description provided for @ui_auto_bulk_7e98196b8c.
  ///
  /// In zh, this message translates to:
  /// **'第1步'**
  String get ui_auto_bulk_7e98196b8c;

  /// No description provided for @ui_auto_bulk_7f8e147d4b.
  ///
  /// In zh, this message translates to:
  /// **'参与运动排行榜'**
  String get ui_auto_bulk_7f8e147d4b;

  /// No description provided for @ui_auto_bulk_8074ee5a29.
  ///
  /// In zh, this message translates to:
  /// **'锻炼时长'**
  String get ui_auto_bulk_8074ee5a29;

  /// No description provided for @ui_auto_bulk_80824ff352.
  ///
  /// In zh, this message translates to:
  /// **'当前计划'**
  String get ui_auto_bulk_80824ff352;

  /// No description provided for @ui_auto_bulk_820945492f.
  ///
  /// In zh, this message translates to:
  /// **'目标体重'**
  String get ui_auto_bulk_820945492f;

  /// No description provided for @ui_auto_bulk_820eb5b696.
  ///
  /// In zh, this message translates to:
  /// **'cm'**
  String get ui_auto_bulk_820eb5b696;

  /// No description provided for @ui_auto_bulk_8240d6b43c.
  ///
  /// In zh, this message translates to:
  /// **'如果今天想练更狠一点'**
  String get ui_auto_bulk_8240d6b43c;

  /// No description provided for @ui_auto_bulk_82421ec511.
  ///
  /// In zh, this message translates to:
  /// **'压力指数'**
  String get ui_auto_bulk_82421ec511;

  /// No description provided for @ui_auto_bulk_834c726346.
  ///
  /// In zh, this message translates to:
  /// **'计划不是一次性配置'**
  String get ui_auto_bulk_834c726346;

  /// No description provided for @ui_auto_bulk_83aca873dd.
  ///
  /// In zh, this message translates to:
  /// **'🍺 啤酒'**
  String get ui_auto_bulk_83aca873dd;

  /// No description provided for @ui_auto_bulk_84c54db3f8.
  ///
  /// In zh, this message translates to:
  /// **'账户与帮助'**
  String get ui_auto_bulk_84c54db3f8;

  /// No description provided for @ui_auto_bulk_8522caadac.
  ///
  /// In zh, this message translates to:
  /// **'目标详细'**
  String get ui_auto_bulk_8522caadac;

  /// No description provided for @ui_auto_bulk_8636accf14.
  ///
  /// In zh, this message translates to:
  /// **'👪 家庭'**
  String get ui_auto_bulk_8636accf14;

  /// No description provided for @ui_auto_bulk_86e5ec937a.
  ///
  /// In zh, this message translates to:
  /// **'自重训练'**
  String get ui_auto_bulk_86e5ec937a;

  /// No description provided for @ui_auto_bulk_8735fb4c2b.
  ///
  /// In zh, this message translates to:
  /// **'建议时长'**
  String get ui_auto_bulk_8735fb4c2b;

  /// No description provided for @ui_auto_bulk_87c835a6b1.
  ///
  /// In zh, this message translates to:
  /// **'女'**
  String get ui_auto_bulk_87c835a6b1;

  /// No description provided for @ui_auto_bulk_87d3471b53.
  ///
  /// In zh, this message translates to:
  /// **'🎮 娱乐'**
  String get ui_auto_bulk_87d3471b53;

  /// No description provided for @ui_auto_bulk_87fa25a9f3.
  ///
  /// In zh, this message translates to:
  /// **'0金币'**
  String get ui_auto_bulk_87fa25a9f3;

  /// No description provided for @ui_auto_bulk_88bcba5cfb.
  ///
  /// In zh, this message translates to:
  /// **'推荐训练节奏'**
  String get ui_auto_bulk_88bcba5cfb;

  /// No description provided for @ui_auto_bulk_89bcf65d93.
  ///
  /// In zh, this message translates to:
  /// **'力量训练组'**
  String get ui_auto_bulk_89bcf65d93;

  /// No description provided for @ui_auto_bulk_89cb65e69e.
  ///
  /// In zh, this message translates to:
  /// **'负重(kg)'**
  String get ui_auto_bulk_89cb65e69e;

  /// No description provided for @ui_auto_bulk_8af66106c5.
  ///
  /// In zh, this message translates to:
  /// **'起床时间'**
  String get ui_auto_bulk_8af66106c5;

  /// No description provided for @ui_auto_bulk_8bc1deebe9.
  ///
  /// In zh, this message translates to:
  /// **'直接看到每天练什么'**
  String get ui_auto_bulk_8bc1deebe9;

  /// No description provided for @ui_auto_bulk_8d8b439b74.
  ///
  /// In zh, this message translates to:
  /// **'记录感受、路线或补充说明'**
  String get ui_auto_bulk_8d8b439b74;

  /// No description provided for @ui_auto_bulk_8e6000c8da.
  ///
  /// In zh, this message translates to:
  /// **'10 千卡'**
  String get ui_auto_bulk_8e6000c8da;

  /// No description provided for @ui_auto_bulk_8f31634b5a.
  ///
  /// In zh, this message translates to:
  /// **'静息时长（分钟）'**
  String get ui_auto_bulk_8f31634b5a;

  /// No description provided for @ui_auto_bulk_9024d26d8e.
  ///
  /// In zh, this message translates to:
  /// **'先记录本次测量的核心信息，后面的身体成分会更有参考价值。'**
  String get ui_auto_bulk_9024d26d8e;

  /// No description provided for @ui_auto_bulk_90293ea702.
  ///
  /// In zh, this message translates to:
  /// **'奶茶'**
  String get ui_auto_bulk_90293ea702;

  /// No description provided for @ui_auto_bulk_9056f92ff6.
  ///
  /// In zh, this message translates to:
  /// **'健身动作'**
  String get ui_auto_bulk_9056f92ff6;

  /// No description provided for @ui_auto_bulk_94099a4f0f.
  ///
  /// In zh, this message translates to:
  /// **'睡眠质量（1-10）'**
  String get ui_auto_bulk_94099a4f0f;

  /// No description provided for @ui_auto_bulk_94191ceb1b.
  ///
  /// In zh, this message translates to:
  /// **'能量饮'**
  String get ui_auto_bulk_94191ceb1b;

  /// No description provided for @ui_auto_bulk_946983a6c2.
  ///
  /// In zh, this message translates to:
  /// **'🥛 酸奶'**
  String get ui_auto_bulk_946983a6c2;

  /// No description provided for @ui_auto_bulk_94a755afe7.
  ///
  /// In zh, this message translates to:
  /// **'果汁'**
  String get ui_auto_bulk_94a755afe7;

  /// No description provided for @ui_auto_bulk_94dd4a05e8.
  ///
  /// In zh, this message translates to:
  /// **'呼吸放松设置'**
  String get ui_auto_bulk_94dd4a05e8;

  /// No description provided for @ui_auto_bulk_94f206f4e3.
  ///
  /// In zh, this message translates to:
  /// **'新增一组'**
  String get ui_auto_bulk_94f206f4e3;

  /// No description provided for @ui_auto_bulk_952681acdb.
  ///
  /// In zh, this message translates to:
  /// **'上一餐碳水（克）'**
  String get ui_auto_bulk_952681acdb;

  /// No description provided for @ui_auto_bulk_9588d525e2.
  ///
  /// In zh, this message translates to:
  /// **'测量设备型号'**
  String get ui_auto_bulk_9588d525e2;

  /// No description provided for @ui_auto_bulk_9749aec07f.
  ///
  /// In zh, this message translates to:
  /// **'昨晚睡眠时长（小时）'**
  String get ui_auto_bulk_9749aec07f;

  /// No description provided for @ui_auto_bulk_97729c4455.
  ///
  /// In zh, this message translates to:
  /// **'已连续执行 8 天。今天不需要重新“配置计划”，你只需要知道现在该练什么。'**
  String get ui_auto_bulk_97729c4455;

  /// No description provided for @ui_auto_bulk_97ac3f44ce.
  ///
  /// In zh, this message translates to:
  /// **'编辑卡片'**
  String get ui_auto_bulk_97ac3f44ce;

  /// No description provided for @ui_auto_bulk_98c0933171.
  ///
  /// In zh, this message translates to:
  /// **'减脂轻启动计划'**
  String get ui_auto_bulk_98c0933171;

  /// No description provided for @ui_auto_bulk_991344b5b2.
  ///
  /// In zh, this message translates to:
  /// **'预计 千卡'**
  String get ui_auto_bulk_991344b5b2;

  /// No description provided for @ui_auto_bulk_9916c3b981.
  ///
  /// In zh, this message translates to:
  /// **'👥 社交'**
  String get ui_auto_bulk_9916c3b981;

  /// No description provided for @ui_auto_bulk_9a31a04187.
  ///
  /// In zh, this message translates to:
  /// **'感觉怎样'**
  String get ui_auto_bulk_9a31a04187;

  /// No description provided for @ui_auto_bulk_9aa3e4b1f8.
  ///
  /// In zh, this message translates to:
  /// **'轻微出汗即可，唤醒心肺与下肢'**
  String get ui_auto_bulk_9aa3e4b1f8;

  /// No description provided for @ui_auto_bulk_9b4f279b4a.
  ///
  /// In zh, this message translates to:
  /// **'根据时长、强度和组数给出负荷与建议。'**
  String get ui_auto_bulk_9b4f279b4a;

  /// No description provided for @ui_auto_bulk_9b80994acb.
  ///
  /// In zh, this message translates to:
  /// **'静息心率'**
  String get ui_auto_bulk_9b80994acb;

  /// No description provided for @ui_auto_bulk_9c6d2f2f45.
  ///
  /// In zh, this message translates to:
  /// **'汤'**
  String get ui_auto_bulk_9c6d2f2f45;

  /// No description provided for @ui_auto_bulk_9dc35a0038.
  ///
  /// In zh, this message translates to:
  /// **'运动名称'**
  String get ui_auto_bulk_9dc35a0038;

  /// No description provided for @ui_auto_bulk_9e75621ec5.
  ///
  /// In zh, this message translates to:
  /// **'核心指标'**
  String get ui_auto_bulk_9e75621ec5;

  /// No description provided for @ui_auto_bulk_9ebe3cb0eb.
  ///
  /// In zh, this message translates to:
  /// **'选择训练模板'**
  String get ui_auto_bulk_9ebe3cb0eb;

  /// No description provided for @ui_auto_bulk_a001ed1cf1.
  ///
  /// In zh, this message translates to:
  /// **'茶'**
  String get ui_auto_bulk_a001ed1cf1;

  /// No description provided for @ui_auto_bulk_a0d0fe6d88.
  ///
  /// In zh, this message translates to:
  /// **'本周可执行'**
  String get ui_auto_bulk_a0d0fe6d88;

  /// No description provided for @ui_auto_bulk_a1394739bb.
  ///
  /// In zh, this message translates to:
  /// **'2021年02月01-2021年02月07'**
  String get ui_auto_bulk_a1394739bb;

  /// No description provided for @ui_auto_bulk_a169f0f866.
  ///
  /// In zh, this message translates to:
  /// **'同一时段、同一设备、相近环境下测量，趋势会更稳定。'**
  String get ui_auto_bulk_a169f0f866;

  /// No description provided for @ui_auto_bulk_a2ba88d339.
  ///
  /// In zh, this message translates to:
  /// **'不用再重新创建'**
  String get ui_auto_bulk_a2ba88d339;

  /// No description provided for @ui_auto_bulk_a2d95b6ebe.
  ///
  /// In zh, this message translates to:
  /// **'组数'**
  String get ui_auto_bulk_a2d95b6ebe;

  /// No description provided for @ui_auto_bulk_a357634b02.
  ///
  /// In zh, this message translates to:
  /// **'RMSSD'**
  String get ui_auto_bulk_a357634b02;

  /// No description provided for @ui_auto_bulk_a3a4e454eb.
  ///
  /// In zh, this message translates to:
  /// **'距离（公里）'**
  String get ui_auto_bulk_a3a4e454eb;

  /// No description provided for @ui_auto_bulk_a3d534d9fe.
  ///
  /// In zh, this message translates to:
  /// **'较差'**
  String get ui_auto_bulk_a3d534d9fe;

  /// No description provided for @ui_auto_bulk_a3e3b88377.
  ///
  /// In zh, this message translates to:
  /// **'开始'**
  String get ui_auto_bulk_a3e3b88377;

  /// No description provided for @ui_auto_bulk_a4a695a764.
  ///
  /// In zh, this message translates to:
  /// **'💡 AI 健康趋势预测'**
  String get ui_auto_bulk_a4a695a764;

  /// No description provided for @ui_auto_bulk_a4b8077724.
  ///
  /// In zh, this message translates to:
  /// **'300ml'**
  String get ui_auto_bulk_a4b8077724;

  /// No description provided for @ui_auto_bulk_a761914f97.
  ///
  /// In zh, this message translates to:
  /// **'咖啡'**
  String get ui_auto_bulk_a761914f97;

  /// No description provided for @ui_auto_bulk_a8acbdbbe7.
  ///
  /// In zh, this message translates to:
  /// **'🥛 牛奶'**
  String get ui_auto_bulk_a8acbdbbe7;

  /// No description provided for @ui_auto_bulk_a8b52f17ee.
  ///
  /// In zh, this message translates to:
  /// **'分钟 / 周'**
  String get ui_auto_bulk_a8b52f17ee;

  /// No description provided for @ui_auto_bulk_a8ff0bc0cd.
  ///
  /// In zh, this message translates to:
  /// **'呼吸放松'**
  String get ui_auto_bulk_a8ff0bc0cd;

  /// No description provided for @ui_auto_bulk_aa99bb028c.
  ///
  /// In zh, this message translates to:
  /// **'放松紧张肌群，重建状态 · 约20分钟'**
  String get ui_auto_bulk_aa99bb028c;

  /// No description provided for @ui_auto_bulk_aac3529980.
  ///
  /// In zh, this message translates to:
  /// **'喝水提醒'**
  String get ui_auto_bulk_aac3529980;

  /// No description provided for @ui_auto_bulk_ab24ea3f34.
  ///
  /// In zh, this message translates to:
  /// **'近期摄入咖啡因'**
  String get ui_auto_bulk_ab24ea3f34;

  /// No description provided for @ui_auto_bulk_aca43234bd.
  ///
  /// In zh, this message translates to:
  /// **'实时更新'**
  String get ui_auto_bulk_aca43234bd;

  /// No description provided for @ui_auto_bulk_aceb86c6bc.
  ///
  /// In zh, this message translates to:
  /// **'矿泉水'**
  String get ui_auto_bulk_aceb86c6bc;

  /// No description provided for @ui_auto_bulk_ad74980084.
  ///
  /// In zh, this message translates to:
  /// **'当前级别'**
  String get ui_auto_bulk_ad74980084;

  /// No description provided for @ui_auto_bulk_ad96194e6d.
  ///
  /// In zh, this message translates to:
  /// **'得分'**
  String get ui_auto_bulk_ad96194e6d;

  /// No description provided for @ui_auto_bulk_af964b55d8.
  ///
  /// In zh, this message translates to:
  /// **'0 千卡'**
  String get ui_auto_bulk_af964b55d8;

  /// No description provided for @ui_auto_bulk_b04fcbe476.
  ///
  /// In zh, this message translates to:
  /// **'确定添加'**
  String get ui_auto_bulk_b04fcbe476;

  /// No description provided for @ui_auto_bulk_b09df93b93.
  ///
  /// In zh, this message translates to:
  /// **'保存这份计划'**
  String get ui_auto_bulk_b09df93b93;

  /// No description provided for @ui_auto_bulk_b0c0e6b638.
  ///
  /// In zh, this message translates to:
  /// **'平均心率'**
  String get ui_auto_bulk_b0c0e6b638;

  /// No description provided for @ui_auto_bulk_b0ce7c1c03.
  ///
  /// In zh, this message translates to:
  /// **'默认推荐'**
  String get ui_auto_bulk_b0ce7c1c03;

  /// No description provided for @ui_auto_bulk_b11890ee20.
  ///
  /// In zh, this message translates to:
  /// **'补齐运动名称、时长和强度，保存前可以补充备注。'**
  String get ui_auto_bulk_b11890ee20;

  /// No description provided for @ui_auto_bulk_b171d3f82b.
  ///
  /// In zh, this message translates to:
  /// **'腰围'**
  String get ui_auto_bulk_b171d3f82b;

  /// No description provided for @ui_auto_bulk_b193e19cfd.
  ///
  /// In zh, this message translates to:
  /// **'体重 (kg)'**
  String get ui_auto_bulk_b193e19cfd;

  /// No description provided for @ui_auto_bulk_b2b266574f.
  ///
  /// In zh, this message translates to:
  /// **'呼吸方式'**
  String get ui_auto_bulk_b2b266574f;

  /// No description provided for @ui_auto_bulk_b361c38d81.
  ///
  /// In zh, this message translates to:
  /// **'动感单车'**
  String get ui_auto_bulk_b361c38d81;

  /// No description provided for @ui_auto_bulk_b509484f28.
  ///
  /// In zh, this message translates to:
  /// **'恢复日'**
  String get ui_auto_bulk_b509484f28;

  /// No description provided for @ui_auto_bulk_b5d56ffd02.
  ///
  /// In zh, this message translates to:
  /// **'先看推荐，再决定是否保存为你的训练计划。'**
  String get ui_auto_bulk_b5d56ffd02;

  /// No description provided for @ui_auto_bulk_b63e327b72.
  ///
  /// In zh, this message translates to:
  /// **'减脂轻启动 · 第 2 周'**
  String get ui_auto_bulk_b63e327b72;

  /// No description provided for @ui_auto_bulk_b6878726fe.
  ///
  /// In zh, this message translates to:
  /// **'步数权限未开启，无法记录您的运动数据'**
  String get ui_auto_bulk_b6878726fe;

  /// No description provided for @ui_auto_bulk_bb440e5849.
  ///
  /// In zh, this message translates to:
  /// **'消耗热量'**
  String get ui_auto_bulk_bb440e5849;

  /// No description provided for @ui_auto_bulk_bb893f4b75.
  ///
  /// In zh, this message translates to:
  /// **'还没有你的专属计划'**
  String get ui_auto_bulk_bb893f4b75;

  /// No description provided for @ui_auto_bulk_bb8ad970aa.
  ///
  /// In zh, this message translates to:
  /// **'饮水量 (ml)'**
  String get ui_auto_bulk_bb8ad970aa;

  /// No description provided for @ui_auto_bulk_bbc7564540.
  ///
  /// In zh, this message translates to:
  /// **'🍽️ 饮食'**
  String get ui_auto_bulk_bbc7564540;

  /// No description provided for @ui_auto_bulk_bcaad88e13.
  ///
  /// In zh, this message translates to:
  /// **'快走 + 核心激活 · 25 分钟'**
  String get ui_auto_bulk_bcaad88e13;

  /// No description provided for @ui_auto_bulk_bd63d702c6.
  ///
  /// In zh, this message translates to:
  /// **'测算中...'**
  String get ui_auto_bulk_bd63d702c6;

  /// No description provided for @ui_auto_bulk_bdd8f81560.
  ///
  /// In zh, this message translates to:
  /// **'我的成就'**
  String get ui_auto_bulk_bdd8f81560;

  /// No description provided for @ui_auto_bulk_bf9c2940f7.
  ///
  /// In zh, this message translates to:
  /// **'按当前里程估算'**
  String get ui_auto_bulk_bf9c2940f7;

  /// No description provided for @ui_auto_bulk_c27d66f237.
  ///
  /// In zh, this message translates to:
  /// **'生理状态'**
  String get ui_auto_bulk_c27d66f237;

  /// No description provided for @ui_auto_bulk_c2ea797d8b.
  ///
  /// In zh, this message translates to:
  /// **'测量日期'**
  String get ui_auto_bulk_c2ea797d8b;

  /// No description provided for @ui_auto_bulk_c3a0f45e6a.
  ///
  /// In zh, this message translates to:
  /// **'我的训练计划'**
  String get ui_auto_bulk_c3a0f45e6a;

  /// No description provided for @ui_auto_bulk_c474eab369.
  ///
  /// In zh, this message translates to:
  /// **'管理活动'**
  String get ui_auto_bulk_c474eab369;

  /// No description provided for @ui_auto_bulk_c4d058c899.
  ///
  /// In zh, this message translates to:
  /// **'🍯 蜂蜜水'**
  String get ui_auto_bulk_c4d058c899;

  /// No description provided for @ui_auto_bulk_c53dbd00ec.
  ///
  /// In zh, this message translates to:
  /// **'组间休息'**
  String get ui_auto_bulk_c53dbd00ec;

  /// No description provided for @ui_auto_bulk_c5c01c8e21.
  ///
  /// In zh, this message translates to:
  /// **'良好'**
  String get ui_auto_bulk_c5c01c8e21;

  /// No description provided for @ui_auto_bulk_c62caaa297.
  ///
  /// In zh, this message translates to:
  /// **'开始这项练习'**
  String get ui_auto_bulk_c62caaa297;

  /// No description provided for @ui_auto_bulk_c69e181adf.
  ///
  /// In zh, this message translates to:
  /// **'增肌'**
  String get ui_auto_bulk_c69e181adf;

  /// No description provided for @ui_auto_bulk_c6bcf06d45.
  ///
  /// In zh, this message translates to:
  /// **'今日概览'**
  String get ui_auto_bulk_c6bcf06d45;

  /// No description provided for @ui_auto_bulk_c7390e077a.
  ///
  /// In zh, this message translates to:
  /// **'个性化计划'**
  String get ui_auto_bulk_c7390e077a;

  /// No description provided for @ui_auto_bulk_c743a1f2b3.
  ///
  /// In zh, this message translates to:
  /// **'按当前选择更新推荐计划'**
  String get ui_auto_bulk_c743a1f2b3;

  /// No description provided for @ui_auto_bulk_c76ca04b2c.
  ///
  /// In zh, this message translates to:
  /// **'保存记录'**
  String get ui_auto_bulk_c76ca04b2c;

  /// No description provided for @ui_auto_bulk_c7d668022a.
  ///
  /// In zh, this message translates to:
  /// **'记录当下状态，方便理解短期波动是否来自睡眠、压力或生理周期。'**
  String get ui_auto_bulk_c7d668022a;

  /// No description provided for @ui_auto_bulk_c7db6d4f1a.
  ///
  /// In zh, this message translates to:
  /// **'恢复'**
  String get ui_auto_bulk_c7db6d4f1a;

  /// No description provided for @ui_auto_bulk_c9cdd69719.
  ///
  /// In zh, this message translates to:
  /// **'填写补充说明（可选）'**
  String get ui_auto_bulk_c9cdd69719;

  /// No description provided for @ui_auto_bulk_c9f7f18159.
  ///
  /// In zh, this message translates to:
  /// **'🥤 可乐'**
  String get ui_auto_bulk_c9f7f18159;

  /// No description provided for @ui_auto_bulk_cb1de6e56e.
  ///
  /// In zh, this message translates to:
  /// **'海浪'**
  String get ui_auto_bulk_cb1de6e56e;

  /// No description provided for @ui_auto_bulk_cb68a5d25c.
  ///
  /// In zh, this message translates to:
  /// **'动作指南'**
  String get ui_auto_bulk_cb68a5d25c;

  /// No description provided for @ui_auto_bulk_cc6a89386d.
  ///
  /// In zh, this message translates to:
  /// **'3 组'**
  String get ui_auto_bulk_cc6a89386d;

  /// No description provided for @ui_auto_bulk_cd2fa34408.
  ///
  /// In zh, this message translates to:
  /// **'重新排计划'**
  String get ui_auto_bulk_cd2fa34408;

  /// No description provided for @ui_auto_bulk_ce4458d33a.
  ///
  /// In zh, this message translates to:
  /// **'🍊 果汁'**
  String get ui_auto_bulk_ce4458d33a;

  /// No description provided for @ui_auto_bulk_cf19377b19.
  ///
  /// In zh, this message translates to:
  /// **'开始今天训练'**
  String get ui_auto_bulk_cf19377b19;

  /// No description provided for @ui_auto_bulk_cf53436b01.
  ///
  /// In zh, this message translates to:
  /// **'超过60分钟未运动时提醒'**
  String get ui_auto_bulk_cf53436b01;

  /// No description provided for @ui_auto_bulk_cf6e9d30e2.
  ///
  /// In zh, this message translates to:
  /// **'步数同步'**
  String get ui_auto_bulk_cf6e9d30e2;

  /// No description provided for @ui_auto_bulk_cf72380ced.
  ///
  /// In zh, this message translates to:
  /// **'雨声'**
  String get ui_auto_bulk_cf72380ced;

  /// No description provided for @ui_auto_bulk_d05ae7c042.
  ///
  /// In zh, this message translates to:
  /// **'身体成分分析'**
  String get ui_auto_bulk_d05ae7c042;

  /// No description provided for @ui_auto_bulk_d0addf2ace.
  ///
  /// In zh, this message translates to:
  /// **'先给自己一份能直接开始的周安排。选好目标和级别后，我们会先推荐一版，再决定要不要保存。'**
  String get ui_auto_bulk_d0addf2ace;

  /// No description provided for @ui_auto_bulk_d2a48b9713.
  ///
  /// In zh, this message translates to:
  /// **'❤️ 恋爱'**
  String get ui_auto_bulk_d2a48b9713;

  /// No description provided for @ui_auto_bulk_d2a8caf29f.
  ///
  /// In zh, this message translates to:
  /// **'1. 第一步\\n2. 第二步'**
  String get ui_auto_bulk_d2a8caf29f;

  /// No description provided for @ui_auto_bulk_d31efa2696.
  ///
  /// In zh, this message translates to:
  /// **'身高（厘米）'**
  String get ui_auto_bulk_d31efa2696;

  /// No description provided for @ui_auto_bulk_d323ef3e7e.
  ///
  /// In zh, this message translates to:
  /// **'设置每日热量目标'**
  String get ui_auto_bulk_d323ef3e7e;

  /// No description provided for @ui_auto_bulk_d4e2682d2a.
  ///
  /// In zh, this message translates to:
  /// **'平均每日步数'**
  String get ui_auto_bulk_d4e2682d2a;

  /// No description provided for @ui_auto_bulk_d5145905be.
  ///
  /// In zh, this message translates to:
  /// **'酮体水平'**
  String get ui_auto_bulk_d5145905be;

  /// No description provided for @ui_auto_bulk_d5b3395d5b.
  ///
  /// In zh, this message translates to:
  /// **'约 126'**
  String get ui_auto_bulk_d5b3395d5b;

  /// No description provided for @ui_auto_bulk_d5f4f6cf31.
  ///
  /// In zh, this message translates to:
  /// **'例如 5.2'**
  String get ui_auto_bulk_d5f4f6cf31;

  /// No description provided for @ui_auto_bulk_d5fe43d170.
  ///
  /// In zh, this message translates to:
  /// **'运动提醒'**
  String get ui_auto_bulk_d5fe43d170;

  /// No description provided for @ui_auto_bulk_d62156b185.
  ///
  /// In zh, this message translates to:
  /// **'添加运动记录'**
  String get ui_auto_bulk_d62156b185;

  /// No description provided for @ui_auto_bulk_d69fc66f84.
  ///
  /// In zh, this message translates to:
  /// **'最近 7 天还没有练习这项动作。'**
  String get ui_auto_bulk_d69fc66f84;

  /// No description provided for @ui_auto_bulk_d773306636.
  ///
  /// In zh, this message translates to:
  /// **'训练要点'**
  String get ui_auto_bulk_d773306636;

  /// No description provided for @ui_auto_bulk_d79d498b40.
  ///
  /// In zh, this message translates to:
  /// **'小腿围'**
  String get ui_auto_bulk_d79d498b40;

  /// No description provided for @ui_auto_bulk_d9c9ff7475.
  ///
  /// In zh, this message translates to:
  /// **'臀围'**
  String get ui_auto_bulk_d9c9ff7475;

  /// No description provided for @ui_auto_bulk_dac7ac64df.
  ///
  /// In zh, this message translates to:
  /// **'版本信息'**
  String get ui_auto_bulk_dac7ac64df;

  /// No description provided for @ui_auto_bulk_dafaa9f2c9.
  ///
  /// In zh, this message translates to:
  /// **'健康与训练'**
  String get ui_auto_bulk_dafaa9f2c9;

  /// No description provided for @ui_auto_bulk_dbee8df721.
  ///
  /// In zh, this message translates to:
  /// **'先看推荐'**
  String get ui_auto_bulk_dbee8df721;

  /// No description provided for @ui_auto_bulk_dc3caaa8d6.
  ///
  /// In zh, this message translates to:
  /// **'0.0 km/h'**
  String get ui_auto_bulk_dc3caaa8d6;

  /// No description provided for @ui_auto_bulk_dd24b8a75c.
  ///
  /// In zh, this message translates to:
  /// **'邀请好友一起为健康加油'**
  String get ui_auto_bulk_dd24b8a75c;

  /// No description provided for @ui_auto_bulk_dfa3c0cd8c.
  ///
  /// In zh, this message translates to:
  /// **'增加 1 组循环即可，不建议直接把整周都改重。'**
  String get ui_auto_bulk_dfa3c0cd8c;

  /// No description provided for @ui_auto_bulk_dfa9881f55.
  ///
  /// In zh, this message translates to:
  /// **'轻体力劳动（工作学习、偶尔运动）'**
  String get ui_auto_bulk_dfa9881f55;

  /// No description provided for @ui_auto_bulk_dfac151de7.
  ///
  /// In zh, this message translates to:
  /// **'高级'**
  String get ui_auto_bulk_dfac151de7;

  /// No description provided for @ui_auto_bulk_e0f2044be3.
  ///
  /// In zh, this message translates to:
  /// **'可选，留空则自动估算'**
  String get ui_auto_bulk_e0f2044be3;

  /// No description provided for @ui_auto_bulk_e12bfc76a3.
  ///
  /// In zh, this message translates to:
  /// **'基础代谢 (千卡)'**
  String get ui_auto_bulk_e12bfc76a3;

  /// No description provided for @ui_auto_bulk_e1b4dc9631.
  ///
  /// In zh, this message translates to:
  /// **'训练分析'**
  String get ui_auto_bulk_e1b4dc9631;

  /// No description provided for @ui_auto_bulk_e20caada6c.
  ///
  /// In zh, this message translates to:
  /// **'血糖值'**
  String get ui_auto_bulk_e20caada6c;

  /// No description provided for @ui_auto_bulk_e2d4f79155.
  ///
  /// In zh, this message translates to:
  /// **'💼 工作'**
  String get ui_auto_bulk_e2d4f79155;

  /// No description provided for @ui_auto_bulk_e2e0b2ec85.
  ///
  /// In zh, this message translates to:
  /// **'身体状态摘要'**
  String get ui_auto_bulk_e2e0b2ec85;

  /// No description provided for @ui_auto_bulk_e39a1f352d.
  ///
  /// In zh, this message translates to:
  /// **'🫘 豆浆'**
  String get ui_auto_bulk_e39a1f352d;

  /// No description provided for @ui_auto_bulk_e464236ab6.
  ///
  /// In zh, this message translates to:
  /// **'动作名称'**
  String get ui_auto_bulk_e464236ab6;

  /// No description provided for @ui_auto_bulk_e4e36cd58f.
  ///
  /// In zh, this message translates to:
  /// **'🍋 柠檬水'**
  String get ui_auto_bulk_e4e36cd58f;

  /// No description provided for @ui_auto_bulk_e517b2fc6d.
  ///
  /// In zh, this message translates to:
  /// **'点击添加血压'**
  String get ui_auto_bulk_e517b2fc6d;

  /// No description provided for @ui_auto_bulk_e534f59ad9.
  ///
  /// In zh, this message translates to:
  /// **'高低强度交替，避免连续两天极限输出。'**
  String get ui_auto_bulk_e534f59ad9;

  /// No description provided for @ui_auto_bulk_e62bd90f05.
  ///
  /// In zh, this message translates to:
  /// **'白水'**
  String get ui_auto_bulk_e62bd90f05;

  /// No description provided for @ui_auto_bulk_e639f2b95d.
  ///
  /// In zh, this message translates to:
  /// **'记录时长（分钟）'**
  String get ui_auto_bulk_e639f2b95d;

  /// No description provided for @ui_auto_bulk_e663f2678c.
  ///
  /// In zh, this message translates to:
  /// **'训练贴士'**
  String get ui_auto_bulk_e663f2678c;

  /// No description provided for @ui_auto_bulk_e6805ed590.
  ///
  /// In zh, this message translates to:
  /// **'训练分类'**
  String get ui_auto_bulk_e6805ed590;

  /// No description provided for @ui_auto_bulk_e75ca0a5fa.
  ///
  /// In zh, this message translates to:
  /// **'放松呼吸 · 4 吸 / 6 呼'**
  String get ui_auto_bulk_e75ca0a5fa;

  /// No description provided for @ui_auto_bulk_e77453535a.
  ///
  /// In zh, this message translates to:
  /// **'蛋白质率 (%)'**
  String get ui_auto_bulk_e77453535a;

  /// No description provided for @ui_auto_bulk_e828380dfa.
  ///
  /// In zh, this message translates to:
  /// **'🏃 运动'**
  String get ui_auto_bulk_e828380dfa;

  /// No description provided for @ui_auto_bulk_e84b443b26.
  ///
  /// In zh, this message translates to:
  /// **'评分说明'**
  String get ui_auto_bulk_e84b443b26;

  /// No description provided for @ui_auto_bulk_e9087cc4da.
  ///
  /// In zh, this message translates to:
  /// **'8小时30分钟'**
  String get ui_auto_bulk_e9087cc4da;

  /// No description provided for @ui_auto_bulk_e9fa43d514.
  ///
  /// In zh, this message translates to:
  /// **'说些什么'**
  String get ui_auto_bulk_e9fa43d514;

  /// No description provided for @ui_auto_bulk_ec13baff37.
  ///
  /// In zh, this message translates to:
  /// **'5 分钟'**
  String get ui_auto_bulk_ec13baff37;

  /// No description provided for @ui_auto_bulk_ec2ce2d557.
  ///
  /// In zh, this message translates to:
  /// **'调整今天'**
  String get ui_auto_bulk_ec2ce2d557;

  /// No description provided for @ui_auto_bulk_ec41af834e.
  ///
  /// In zh, this message translates to:
  /// **'注销账号'**
  String get ui_auto_bulk_ec41af834e;

  /// No description provided for @ui_auto_bulk_ee3946d9c6.
  ///
  /// In zh, this message translates to:
  /// **'减脂 · 高级'**
  String get ui_auto_bulk_ee3946d9c6;

  /// No description provided for @ui_auto_bulk_ef90538429.
  ///
  /// In zh, this message translates to:
  /// **'🍲 汤'**
  String get ui_auto_bulk_ef90538429;

  /// No description provided for @ui_auto_bulk_efbfcadffc.
  ///
  /// In zh, this message translates to:
  /// **'餐食构成'**
  String get ui_auto_bulk_efbfcadffc;

  /// No description provided for @ui_auto_bulk_f10fec311a.
  ///
  /// In zh, this message translates to:
  /// **'第一天先用低门槛任务把训练开起来，给身体一个“本周要动”的信号。'**
  String get ui_auto_bulk_f10fec311a;

  /// No description provided for @ui_auto_bulk_f1313ecdba.
  ///
  /// In zh, this message translates to:
  /// **'减脂'**
  String get ui_auto_bulk_f1313ecdba;

  /// No description provided for @ui_auto_bulk_f1908f236d.
  ///
  /// In zh, this message translates to:
  /// **'💙'**
  String get ui_auto_bulk_f1908f236d;

  /// No description provided for @ui_auto_bulk_f3b7f56165.
  ///
  /// In zh, this message translates to:
  /// **'0 千卡'**
  String get ui_auto_bulk_f3b7f56165;

  /// No description provided for @ui_auto_bulk_f3ff4b8a2e.
  ///
  /// In zh, this message translates to:
  /// **'9000步'**
  String get ui_auto_bulk_f3ff4b8a2e;

  /// No description provided for @ui_auto_bulk_f4fc55c50d.
  ///
  /// In zh, this message translates to:
  /// **'篝火'**
  String get ui_auto_bulk_f4fc55c50d;

  /// No description provided for @ui_auto_bulk_f5a2d11402.
  ///
  /// In zh, this message translates to:
  /// **'水合状态'**
  String get ui_auto_bulk_f5a2d11402;

  /// No description provided for @ui_auto_bulk_f63ae244d3.
  ///
  /// In zh, this message translates to:
  /// **'压力水平（1-10）'**
  String get ui_auto_bulk_f63ae244d3;

  /// No description provided for @ui_auto_bulk_f6a9805632.
  ///
  /// In zh, this message translates to:
  /// **'主要循环'**
  String get ui_auto_bulk_f6a9805632;

  /// No description provided for @ui_auto_bulk_f778cca47f.
  ///
  /// In zh, this message translates to:
  /// **'🧋 奶茶'**
  String get ui_auto_bulk_f778cca47f;

  /// No description provided for @ui_auto_bulk_f77c938302.
  ///
  /// In zh, this message translates to:
  /// **'更多...'**
  String get ui_auto_bulk_f77c938302;

  /// No description provided for @ui_auto_bulk_fb6a4653ac.
  ///
  /// In zh, this message translates to:
  /// **'每2小时提醒补充水分'**
  String get ui_auto_bulk_fb6a4653ac;

  /// No description provided for @ui_auto_bulk_fdddc5f58f.
  ///
  /// In zh, this message translates to:
  /// **'跑步机快走'**
  String get ui_auto_bulk_fdddc5f58f;

  /// No description provided for @ui_auto_bulk_fe24f052d1.
  ///
  /// In zh, this message translates to:
  /// **'请完善身高体重信息以计算 BMI'**
  String get ui_auto_bulk_fe24f052d1;

  /// No description provided for @ui_auto_bulk_fe2d26a257.
  ///
  /// In zh, this message translates to:
  /// **'未设置'**
  String get ui_auto_bulk_fe2d26a257;

  /// No description provided for @ui_auto_bulk_ff0847911e.
  ///
  /// In zh, this message translates to:
  /// **'智能分析'**
  String get ui_auto_bulk_ff0847911e;

  /// No description provided for @ui_auto_bulk_ffd5f33df8.
  ///
  /// In zh, this message translates to:
  /// **'强度'**
  String get ui_auto_bulk_ffd5f33df8;

  /// No description provided for @ui_auto_dialog_118558717a.
  ///
  /// In zh, this message translates to:
  /// **'开启步数同步'**
  String get ui_auto_dialog_118558717a;

  /// No description provided for @ui_auto_dialog_194d3e4b51.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除这条运动记录吗？'**
  String get ui_auto_dialog_194d3e4b51;

  /// No description provided for @ui_auto_dialog_208460a7e6.
  ///
  /// In zh, this message translates to:
  /// **'退出训练'**
  String get ui_auto_dialog_208460a7e6;

  /// No description provided for @ui_auto_dialog_2af0da9c6f.
  ///
  /// In zh, this message translates to:
  /// **'选择提醒时间'**
  String get ui_auto_dialog_2af0da9c6f;

  /// No description provided for @ui_auto_dialog_2b6bc0f293.
  ///
  /// In zh, this message translates to:
  /// **'操作'**
  String get ui_auto_dialog_2b6bc0f293;

  /// No description provided for @ui_auto_dialog_519601ec51.
  ///
  /// In zh, this message translates to:
  /// **'参与排行榜需要开启步数同步与其余好友分享您的运动进度。是否立即开启？'**
  String get ui_auto_dialog_519601ec51;

  /// No description provided for @ui_auto_dialog_5586135905.
  ///
  /// In zh, this message translates to:
  /// **'数据导出与分享'**
  String get ui_auto_dialog_5586135905;

  /// No description provided for @ui_auto_dialog_631cd22018.
  ///
  /// In zh, this message translates to:
  /// **'确认删除'**
  String get ui_auto_dialog_631cd22018;

  /// No description provided for @ui_auto_dialog_81b5faddb0.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除这条饮食记录吗？'**
  String get ui_auto_dialog_81b5faddb0;

  /// No description provided for @ui_auto_dialog_8f8d34049e.
  ///
  /// In zh, this message translates to:
  /// **'设置手机号'**
  String get ui_auto_dialog_8f8d34049e;

  /// No description provided for @ui_auto_dialog_93247c8b36.
  ///
  /// In zh, this message translates to:
  /// **'设置每日目标'**
  String get ui_auto_dialog_93247c8b36;

  /// No description provided for @ui_auto_dialog_a790208caf.
  ///
  /// In zh, this message translates to:
  /// **'删除记录'**
  String get ui_auto_dialog_a790208caf;

  /// No description provided for @ui_auto_dialog_b71d903f00.
  ///
  /// In zh, this message translates to:
  /// **'还没有完成任何一组，确认现在退出吗？'**
  String get ui_auto_dialog_b71d903f00;

  /// No description provided for @ui_auto_dialog_b7bd22a900.
  ///
  /// In zh, this message translates to:
  /// **'选择月份'**
  String get ui_auto_dialog_b7bd22a900;

  /// No description provided for @ui_auto_dialog_bab8f14c91.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除这条体重记录吗？'**
  String get ui_auto_dialog_bab8f14c91;

  /// No description provided for @ui_auto_dialog_bdeb5d9bce.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除这条喝水记录吗？'**
  String get ui_auto_dialog_bdeb5d9bce;

  /// No description provided for @ui_auto_dialog_ec04cf29e9.
  ///
  /// In zh, this message translates to:
  /// **'设置昵称'**
  String get ui_auto_dialog_ec04cf29e9;

  /// No description provided for @ui_auto_dialog_f161d2d1f0.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除这条心情记录吗？'**
  String get ui_auto_dialog_f161d2d1f0;

  /// No description provided for @ui_auto_dialog_f31908db0b.
  ///
  /// In zh, this message translates to:
  /// **'正在登录中...'**
  String get ui_auto_dialog_f31908db0b;

  /// No description provided for @ui_auto_dialog_f637460777.
  ///
  /// In zh, this message translates to:
  /// **'提前结束训练'**
  String get ui_auto_dialog_f637460777;

  /// No description provided for @ui_auto_dialog_ff59d24ef1.
  ///
  /// In zh, this message translates to:
  /// **'健康评分说明'**
  String get ui_auto_dialog_ff59d24ef1;

  /// No description provided for @ui_auto_domain_0158398225.
  ///
  /// In zh, this message translates to:
  /// **'🏃 运动健身目标:\\n'**
  String get ui_auto_domain_0158398225;

  /// No description provided for @ui_auto_domain_0191d5284b.
  ///
  /// In zh, this message translates to:
  /// **'周四: 休息或拉伸'**
  String get ui_auto_domain_0191d5284b;

  /// No description provided for @ui_auto_domain_01a7bbce61.
  ///
  /// In zh, this message translates to:
  /// **'• 需要关注的风险因子:'**
  String get ui_auto_domain_01a7bbce61;

  /// No description provided for @ui_auto_domain_01b8eb9c0f.
  ///
  /// In zh, this message translates to:
  /// **'✅ 好消息！目前您的健康数据没有检测到明显的异常。\\n\\n'**
  String get ui_auto_domain_01b8eb9c0f;

  /// No description provided for @ui_auto_domain_022cb27aeb.
  ///
  /// In zh, this message translates to:
  /// **'❤️ 心率数据摘要:\\n'**
  String get ui_auto_domain_022cb27aeb;

  /// No description provided for @ui_auto_domain_068c9a13fc.
  ///
  /// In zh, this message translates to:
  /// **'🩺 血压数据摘要:\\n'**
  String get ui_auto_domain_068c9a13fc;

  /// No description provided for @ui_auto_domain_09565b5ad4.
  ///
  /// In zh, this message translates to:
  /// **'严格控制碳水化合物摄入'**
  String get ui_auto_domain_09565b5ad4;

  /// No description provided for @ui_auto_domain_0a2293ade5.
  ///
  /// In zh, this message translates to:
  /// **'• 每日记录体重和血压\\n'**
  String get ui_auto_domain_0a2293ade5;

  /// No description provided for @ui_auto_domain_0b3814ec49.
  ///
  /// In zh, this message translates to:
  /// **'瑜伽或普拉提'**
  String get ui_auto_domain_0b3814ec49;

  /// No description provided for @ui_auto_domain_0bfd71c39e.
  ///
  /// In zh, this message translates to:
  /// **'运动次数:'**
  String get ui_auto_domain_0bfd71c39e;

  /// No description provided for @ui_auto_domain_0cbdd1b300.
  ///
  /// In zh, this message translates to:
  /// **'周三: 康复性力量训练 30分钟'**
  String get ui_auto_domain_0cbdd1b300;

  /// No description provided for @ui_auto_domain_0f184c4639.
  ///
  /// In zh, this message translates to:
  /// **'肌肉围度测量'**
  String get ui_auto_domain_0f184c4639;

  /// No description provided for @ui_auto_domain_0f3d519777.
  ///
  /// In zh, this message translates to:
  /// **'睡眠不足可能影响血压'**
  String get ui_auto_domain_0f3d519777;

  /// No description provided for @ui_auto_domain_10c8d23166.
  ///
  /// In zh, this message translates to:
  /// **'继续正常训练'**
  String get ui_auto_domain_10c8d23166;

  /// No description provided for @ui_auto_domain_10e4d7d8fe.
  ///
  /// In zh, this message translates to:
  /// **'千卡\\n'**
  String get ui_auto_domain_10e4d7d8fe;

  /// No description provided for @ui_auto_domain_1166894c47.
  ///
  /// In zh, this message translates to:
  /// **'⚠️ 重要提醒: 检测到'**
  String get ui_auto_domain_1166894c47;

  /// No description provided for @ui_auto_domain_124be8cff5.
  ///
  /// In zh, this message translates to:
  /// **'• 逐步提高运动强度和时长\\n\\n'**
  String get ui_auto_domain_124be8cff5;

  /// No description provided for @ui_auto_domain_12662424e3.
  ///
  /// In zh, this message translates to:
  /// **'已出现低血糖症状，需立即处理'**
  String get ui_auto_domain_12662424e3;

  /// No description provided for @ui_auto_domain_12cf1d319d.
  ///
  /// In zh, this message translates to:
  /// **'增加水分摄入，监测血糖变化'**
  String get ui_auto_domain_12cf1d319d;

  /// No description provided for @ui_auto_domain_13aefd5658.
  ///
  /// In zh, this message translates to:
  /// **'最活跃:'**
  String get ui_auto_domain_13aefd5658;

  /// No description provided for @ui_auto_domain_15470bdee4.
  ///
  /// In zh, this message translates to:
  /// **'运动时长提升'**
  String get ui_auto_domain_15470bdee4;

  /// No description provided for @ui_auto_domain_172b5b1b1b.
  ///
  /// In zh, this message translates to:
  /// **'综合体能测试'**
  String get ui_auto_domain_172b5b1b1b;

  /// No description provided for @ui_auto_domain_17d3fda565.
  ///
  /// In zh, this message translates to:
  /// **'周六: 平衡和协调训练 25分钟'**
  String get ui_auto_domain_17d3fda565;

  /// No description provided for @ui_auto_domain_1880638f0f.
  ///
  /// In zh, this message translates to:
  /// **'周二: 间歇训练 40分钟'**
  String get ui_auto_domain_1880638f0f;

  /// No description provided for @ui_auto_domain_188d73b0fe.
  ///
  /// In zh, this message translates to:
  /// **'运动距离提升'**
  String get ui_auto_domain_188d73b0fe;

  /// No description provided for @ui_auto_domain_1b65bc788a.
  ///
  /// In zh, this message translates to:
  /// **'疼痛评分'**
  String get ui_auto_domain_1b65bc788a;

  /// No description provided for @ui_auto_domain_1bcbd8841d.
  ///
  /// In zh, this message translates to:
  /// **'• 每周进行150分钟中等强度有氧运动\\n'**
  String get ui_auto_domain_1bcbd8841d;

  /// No description provided for @ui_auto_domain_1bf50cd555.
  ///
  /// In zh, this message translates to:
  /// **'周六: 模拟比赛训练 90分钟'**
  String get ui_auto_domain_1bf50cd555;

  /// No description provided for @ui_auto_domain_1c740c608a.
  ///
  /// In zh, this message translates to:
  /// **'耐力训练需要更长时间，建议延长训练时长'**
  String get ui_auto_domain_1c740c608a;

  /// No description provided for @ui_auto_domain_20db52860d.
  ///
  /// In zh, this message translates to:
  /// **'• 整体风险等级:'**
  String get ui_auto_domain_20db52860d;

  /// No description provided for @ui_auto_domain_247faabfae.
  ///
  /// In zh, this message translates to:
  /// **'剧烈运动前血糖偏低，有低血糖风险'**
  String get ui_auto_domain_247faabfae;

  /// No description provided for @ui_auto_domain_24d0fe79ff.
  ///
  /// In zh, this message translates to:
  /// **'📊 体重数据摘要:\\n'**
  String get ui_auto_domain_24d0fe79ff;

  /// No description provided for @ui_auto_domain_250f28a47d.
  ///
  /// In zh, this message translates to:
  /// **'运动前适当补充碳水化合物'**
  String get ui_auto_domain_250f28a47d;

  /// No description provided for @ui_auto_domain_2533fb6fbe.
  ///
  /// In zh, this message translates to:
  /// **'可能存在过度训练，建议适当减少训练量并注重恢复'**
  String get ui_auto_domain_2533fb6fbe;

  /// No description provided for @ui_auto_domain_26ada521ff.
  ///
  /// In zh, this message translates to:
  /// **'立即补充15-20g快速碳水化合物（如葡萄糖片、果汁）'**
  String get ui_auto_domain_26ada521ff;

  /// No description provided for @ui_auto_domain_2876f4d469.
  ///
  /// In zh, this message translates to:
  /// **'您的健康状况良好，暂时没有特别的建议。请继续保持良好的生活习惯！'**
  String get ui_auto_domain_2876f4d469;

  /// No description provided for @ui_auto_domain_2d05e1b723.
  ///
  /// In zh, this message translates to:
  /// **'柔韧性训练后注意拉伸放松'**
  String get ui_auto_domain_2d05e1b723;

  /// No description provided for @ui_auto_domain_2d15cf3296.
  ///
  /// In zh, this message translates to:
  /// **'• 心率变异性:'**
  String get ui_auto_domain_2d15cf3296;

  /// No description provided for @ui_auto_domain_2d58d6b9a8.
  ///
  /// In zh, this message translates to:
  /// **'增加水分摄入，避免脱水'**
  String get ui_auto_domain_2d58d6b9a8;

  /// No description provided for @ui_auto_domain_2e4858cc12.
  ///
  /// In zh, this message translates to:
  /// **'主观疲劳度较高，明天安排轻松恢复训练'**
  String get ui_auto_domain_2e4858cc12;

  /// No description provided for @ui_auto_domain_2ef20f76fe.
  ///
  /// In zh, this message translates to:
  /// **'状态评价:'**
  String get ui_auto_domain_2ef20f76fe;

  /// No description provided for @ui_auto_domain_2fa9f414a9.
  ///
  /// In zh, this message translates to:
  /// **'有氧训练比例较高，建议增加力量训练'**
  String get ui_auto_domain_2fa9f414a9;

  /// No description provided for @ui_auto_domain_30378d3190.
  ///
  /// In zh, this message translates to:
  /// **'💡 个性化健康建议\\n\\n'**
  String get ui_auto_domain_30378d3190;

  /// No description provided for @ui_auto_domain_3109b36a2d.
  ///
  /// In zh, this message translates to:
  /// **'有氧运动比例较高，建议增加力量训练以提升肌肉力量'**
  String get ui_auto_domain_3109b36a2d;

  /// No description provided for @ui_auto_domain_3203b4fdfc.
  ///
  /// In zh, this message translates to:
  /// **'竞技状态评估'**
  String get ui_auto_domain_3203b4fdfc;

  /// No description provided for @ui_auto_domain_326a4df5da.
  ///
  /// In zh, this message translates to:
  /// **'建议增加柔韧性和平衡性训练，预防跌倒风险'**
  String get ui_auto_domain_326a4df5da;

  /// No description provided for @ui_auto_domain_32d2799db9.
  ///
  /// In zh, this message translates to:
  /// **'建议下次训练降低强度或安排恢复性运动'**
  String get ui_auto_domain_32d2799db9;

  /// No description provided for @ui_auto_domain_332be26365.
  ///
  /// In zh, this message translates to:
  /// **'请继续保持良好的健康习惯，定期记录健康数据以便及时发现变化。'**
  String get ui_auto_domain_332be26365;

  /// No description provided for @ui_auto_domain_3609de39c4.
  ///
  /// In zh, this message translates to:
  /// **'检测到以下异常情况：\\n\\n'**
  String get ui_auto_domain_3609de39c4;

  /// No description provided for @ui_auto_domain_362942410c.
  ///
  /// In zh, this message translates to:
  /// **'控制体重，减少腹部脂肪'**
  String get ui_auto_domain_362942410c;

  /// No description provided for @ui_auto_domain_3650e599b1.
  ///
  /// In zh, this message translates to:
  /// **'个)\\n'**
  String get ui_auto_domain_3650e599b1;

  /// No description provided for @ui_auto_domain_36853babb0.
  ///
  /// In zh, this message translates to:
  /// **'吸烟会导致血压短期升高'**
  String get ui_auto_domain_36853babb0;

  /// No description provided for @ui_auto_domain_398acfee79.
  ///
  /// In zh, this message translates to:
  /// **'低强度有氧运动'**
  String get ui_auto_domain_398acfee79;

  /// No description provided for @ui_auto_domain_3b1aad6756.
  ///
  /// In zh, this message translates to:
  /// **'最爱运动:'**
  String get ui_auto_domain_3b1aad6756;

  /// No description provided for @ui_auto_domain_3c1f3e6386.
  ///
  /// In zh, this message translates to:
  /// **'步\\n'**
  String get ui_auto_domain_3c1f3e6386;

  /// No description provided for @ui_auto_domain_3c5b58ce5d.
  ///
  /// In zh, this message translates to:
  /// **'周三: 力量训练 50分钟'**
  String get ui_auto_domain_3c5b58ce5d;

  /// No description provided for @ui_auto_domain_3d0f52ecb3.
  ///
  /// In zh, this message translates to:
  /// **'柔韧性训练不足，建议增加拉伸运动'**
  String get ui_auto_domain_3d0f52ecb3;

  /// No description provided for @ui_auto_domain_3e0442ebc9.
  ///
  /// In zh, this message translates to:
  /// **'请告诉我您最关心的健康方面，我会为您制定具体的目标和计划。'**
  String get ui_auto_domain_3e0442ebc9;

  /// No description provided for @ui_auto_domain_3fe9bfeed6.
  ///
  /// In zh, this message translates to:
  /// **'周二: 休息'**
  String get ui_auto_domain_3fe9bfeed6;

  /// No description provided for @ui_auto_domain_4068d15cd6.
  ///
  /// In zh, this message translates to:
  /// **'周一: 轻度拉伸和活动 30分钟'**
  String get ui_auto_domain_4068d15cd6;

  /// No description provided for @ui_auto_domain_4276db7384.
  ///
  /// In zh, this message translates to:
  /// **'力量训练比例不足，建议每周至少3次力量训练'**
  String get ui_auto_domain_4276db7384;

  /// No description provided for @ui_auto_domain_4315dce876.
  ///
  /// In zh, this message translates to:
  /// **'采用低GI饮食，控制餐后血糖'**
  String get ui_auto_domain_4315dce876;

  /// No description provided for @ui_auto_domain_4343913907.
  ///
  /// In zh, this message translates to:
  /// **'训练效果很好！继续保持当前的训练节奏'**
  String get ui_auto_domain_4343913907;

  /// No description provided for @ui_auto_domain_460b1cf933.
  ///
  /// In zh, this message translates to:
  /// **'年轻时是建立肌肉力量的最佳时期，建议增加力量训练'**
  String get ui_auto_domain_460b1cf933;

  /// No description provided for @ui_auto_domain_47fc4e9be0.
  ///
  /// In zh, this message translates to:
  /// **'⚠️ 风险评估:\\n'**
  String get ui_auto_domain_47fc4e9be0;

  /// No description provided for @ui_auto_domain_48779d97d5.
  ///
  /// In zh, this message translates to:
  /// **'静坐时间不足，可能影响测量准确性'**
  String get ui_auto_domain_48779d97d5;

  /// No description provided for @ui_auto_domain_49f7727737.
  ///
  /// In zh, this message translates to:
  /// **'总重量提升'**
  String get ui_auto_domain_49f7727737;

  /// No description provided for @ui_auto_domain_4a1d14a552.
  ///
  /// In zh, this message translates to:
  /// **'训练频率很高，注意安排休息日避免过度训练'**
  String get ui_auto_domain_4a1d14a552;

  /// No description provided for @ui_auto_domain_4a6ee85549.
  ///
  /// In zh, this message translates to:
  /// **'力量训练建议每个动作进行3组以上'**
  String get ui_auto_domain_4a6ee85549;

  /// No description provided for @ui_auto_domain_4bbe9419ae.
  ///
  /// In zh, this message translates to:
  /// **'考虑减少单餐碳水化合物摄入量'**
  String get ui_auto_domain_4bbe9419ae;

  /// No description provided for @ui_auto_domain_4c7c82564e.
  ///
  /// In zh, this message translates to:
  /// **'糖尿病前期：需要生活方式干预'**
  String get ui_auto_domain_4c7c82564e;

  /// No description provided for @ui_auto_domain_4d9d49cc4b.
  ///
  /// In zh, this message translates to:
  /// **'高强度训练过多，建议增加低中强度训练促进恢复'**
  String get ui_auto_domain_4d9d49cc4b;

  /// No description provided for @ui_auto_domain_50ca088d1d.
  ///
  /// In zh, this message translates to:
  /// **'周四: 瑜伽或拉伸 45分钟'**
  String get ui_auto_domain_50ca088d1d;

  /// No description provided for @ui_auto_domain_51c9d2bb4d.
  ///
  /// In zh, this message translates to:
  /// **'• 增强体能和肌肉力量\\n'**
  String get ui_auto_domain_51c9d2bb4d;

  /// No description provided for @ui_auto_domain_51d24bf0b4.
  ///
  /// In zh, this message translates to:
  /// **'出现高血糖症状时及时就医'**
  String get ui_auto_domain_51d24bf0b4;

  /// No description provided for @ui_auto_domain_520388fa5f.
  ///
  /// In zh, this message translates to:
  /// **'按摩放松'**
  String get ui_auto_domain_520388fa5f;

  /// No description provided for @ui_auto_domain_5451527d57.
  ///
  /// In zh, this message translates to:
  /// **'个高风险异常，建议尽快咨询医疗专业人士。'**
  String get ui_auto_domain_5451527d57;

  /// No description provided for @ui_auto_domain_56f7eae8d9.
  ///
  /// In zh, this message translates to:
  /// **'建议:'**
  String get ui_auto_domain_56f7eae8d9;

  /// No description provided for @ui_auto_domain_5884083e5d.
  ///
  /// In zh, this message translates to:
  /// **'📊 健康监测目标:\\n'**
  String get ui_auto_domain_5884083e5d;

  /// No description provided for @ui_auto_domain_58fa223577.
  ///
  /// In zh, this message translates to:
  /// **'• 每月减重1-2公斤\\n'**
  String get ui_auto_domain_58fa223577;

  /// No description provided for @ui_auto_domain_5ba37b6b8f.
  ///
  /// In zh, this message translates to:
  /// **'次\\n'**
  String get ui_auto_domain_5ba37b6b8f;

  /// No description provided for @ui_auto_domain_5bc0fa5655.
  ///
  /// In zh, this message translates to:
  /// **'周五: 水中运动 30分钟'**
  String get ui_auto_domain_5bc0fa5655;

  /// No description provided for @ui_auto_domain_5c8a4c101b.
  ///
  /// In zh, this message translates to:
  /// **'公里\\n'**
  String get ui_auto_domain_5c8a4c101b;

  /// No description provided for @ui_auto_domain_5da407f21e.
  ///
  /// In zh, this message translates to:
  /// **'周五: 中等强度有氧运动 50分钟'**
  String get ui_auto_domain_5da407f21e;

  /// No description provided for @ui_auto_domain_5e3816e33e.
  ///
  /// In zh, this message translates to:
  /// **'出现症状时避免驾车或操作机械'**
  String get ui_auto_domain_5e3816e33e;

  /// No description provided for @ui_auto_domain_60b69598ef.
  ///
  /// In zh, this message translates to:
  /// **'关节活动度'**
  String get ui_auto_domain_60b69598ef;

  /// No description provided for @ui_auto_domain_611563f881.
  ///
  /// In zh, this message translates to:
  /// **'学会识别低血糖早期症状'**
  String get ui_auto_domain_611563f881;

  /// No description provided for @ui_auto_domain_63deebf904.
  ///
  /// In zh, this message translates to:
  /// **'周六: 户外活动或运动'**
  String get ui_auto_domain_63deebf904;

  /// No description provided for @ui_auto_domain_65a298f89b.
  ///
  /// In zh, this message translates to:
  /// **'建议适当增加训练强度或时长'**
  String get ui_auto_domain_65a298f89b;

  /// No description provided for @ui_auto_domain_6807af1183.
  ///
  /// In zh, this message translates to:
  /// **'运动时长下降'**
  String get ui_auto_domain_6807af1183;

  /// No description provided for @ui_auto_domain_6b0acd5190.
  ///
  /// In zh, this message translates to:
  /// **'📈 基础指标分析:\\n'**
  String get ui_auto_domain_6b0acd5190;

  /// No description provided for @ui_auto_domain_6b1191b871.
  ///
  /// In zh, this message translates to:
  /// **'运动能力提升'**
  String get ui_auto_domain_6b1191b871;

  /// No description provided for @ui_auto_domain_6b483c9a34.
  ///
  /// In zh, this message translates to:
  /// **'最大摄氧量'**
  String get ui_auto_domain_6b483c9a34;

  /// No description provided for @ui_auto_domain_6dab0d4958.
  ///
  /// In zh, this message translates to:
  /// **'强度偏低，可以适当提高运动强度'**
  String get ui_auto_domain_6dab0d4958;

  /// No description provided for @ui_auto_domain_6df91827a4.
  ///
  /// In zh, this message translates to:
  /// **'• 改善睡眠质量\\n\\n'**
  String get ui_auto_domain_6df91827a4;

  /// No description provided for @ui_auto_domain_6fffd97155.
  ///
  /// In zh, this message translates to:
  /// **'连续运动:'**
  String get ui_auto_domain_6fffd97155;

  /// No description provided for @ui_auto_domain_702441c800.
  ///
  /// In zh, this message translates to:
  /// **'腰围测量'**
  String get ui_auto_domain_702441c800;

  /// No description provided for @ui_auto_domain_7223749f39.
  ///
  /// In zh, this message translates to:
  /// **'有氧耐力提升'**
  String get ui_auto_domain_7223749f39;

  /// No description provided for @ui_auto_domain_7387787323.
  ///
  /// In zh, this message translates to:
  /// **'🍯 血糖数据摘要:\\n'**
  String get ui_auto_domain_7387787323;

  /// No description provided for @ui_auto_domain_75f8d09fa9.
  ///
  /// In zh, this message translates to:
  /// **'建议每周至少进行3次运动，提高训练频率'**
  String get ui_auto_domain_75f8d09fa9;

  /// No description provided for @ui_auto_domain_76587923ac.
  ///
  /// In zh, this message translates to:
  /// **'训练负荷较高，注意休息和恢复'**
  String get ui_auto_domain_76587923ac;

  /// No description provided for @ui_auto_domain_7719812c3d.
  ///
  /// In zh, this message translates to:
  /// **'周三: 休息或瑜伽'**
  String get ui_auto_domain_7719812c3d;

  /// No description provided for @ui_auto_domain_77871dd476.
  ///
  /// In zh, this message translates to:
  /// **'周二: 高强度间歇训练 45分钟'**
  String get ui_auto_domain_77871dd476;

  /// No description provided for @ui_auto_domain_7a652e0b53.
  ///
  /// In zh, this message translates to:
  /// **'周日: 休息或恢复性训练'**
  String get ui_auto_domain_7a652e0b53;

  /// No description provided for @ui_auto_domain_7b7086ab27.
  ///
  /// In zh, this message translates to:
  /// **'• 改善心血管健康\\n'**
  String get ui_auto_domain_7b7086ab27;

  /// No description provided for @ui_auto_domain_7e9519f4ca.
  ///
  /// In zh, this message translates to:
  /// **'周三: 高强度间歇训练 30分钟'**
  String get ui_auto_domain_7e9519f4ca;

  /// No description provided for @ui_auto_domain_7f091b8169.
  ///
  /// In zh, this message translates to:
  /// **'力量训练比例较高，建议增加有氧运动改善心肺功能'**
  String get ui_auto_domain_7f091b8169;

  /// No description provided for @ui_auto_domain_812b5ecfed.
  ///
  /// In zh, this message translates to:
  /// **'增加有氧运动比例以提升耐力水平'**
  String get ui_auto_domain_812b5ecfed;

  /// No description provided for @ui_auto_domain_829103a35b.
  ///
  /// In zh, this message translates to:
  /// **'周三: 交叉训练 50分钟'**
  String get ui_auto_domain_829103a35b;

  /// No description provided for @ui_auto_domain_847624ceb1.
  ///
  /// In zh, this message translates to:
  /// **'高强度训练，注意充分休息和恢复'**
  String get ui_auto_domain_847624ceb1;

  /// No description provided for @ui_auto_domain_864565dfa9.
  ///
  /// In zh, this message translates to:
  /// **'酮体水平偏高，避免剧烈运动'**
  String get ui_auto_domain_864565dfa9;

  /// No description provided for @ui_auto_domain_876f719079.
  ///
  /// In zh, this message translates to:
  /// **'血糖过高时避免剧烈运动'**
  String get ui_auto_domain_876f719079;

  /// No description provided for @ui_auto_domain_88a5675d41.
  ///
  /// In zh, this message translates to:
  /// **'周五: 节奏训练 45分钟'**
  String get ui_auto_domain_88a5675d41;

  /// No description provided for @ui_auto_domain_893e81dc4c.
  ///
  /// In zh, this message translates to:
  /// **'🔍 健康数据异常分析\\n\\n'**
  String get ui_auto_domain_893e81dc4c;

  /// No description provided for @ui_auto_domain_8c94d17ae2.
  ///
  /// In zh, this message translates to:
  /// **'胰岛素注射后血糖偏低，需要密切监测'**
  String get ui_auto_domain_8c94d17ae2;

  /// No description provided for @ui_auto_domain_8d52ec2dbe.
  ///
  /// In zh, this message translates to:
  /// **'📉 体重管理目标:\\n'**
  String get ui_auto_domain_8d52ec2dbe;

  /// No description provided for @ui_auto_domain_8e34758437.
  ///
  /// In zh, this message translates to:
  /// **'有氧运动建议持续30分钟以上'**
  String get ui_auto_domain_8e34758437;

  /// No description provided for @ui_auto_domain_8f09d7dc1d.
  ///
  /// In zh, this message translates to:
  /// **'力量训练比例较高，建议增加有氧训练'**
  String get ui_auto_domain_8f09d7dc1d;

  /// No description provided for @ui_auto_domain_8f7e67d711.
  ///
  /// In zh, this message translates to:
  /// **'🏃 运动数据摘要:\\n'**
  String get ui_auto_domain_8f7e67d711;

  /// No description provided for @ui_auto_domain_8ffc2ad1db.
  ///
  /// In zh, this message translates to:
  /// **'消耗热量:'**
  String get ui_auto_domain_8ffc2ad1db;

  /// No description provided for @ui_auto_domain_90638d19d3.
  ///
  /// In zh, this message translates to:
  /// **'周五: 全身综合力量训练 60分钟'**
  String get ui_auto_domain_90638d19d3;

  /// No description provided for @ui_auto_domain_922601c6c0.
  ///
  /// In zh, this message translates to:
  /// **'总步数:'**
  String get ui_auto_domain_922601c6c0;

  /// No description provided for @ui_auto_domain_93075adb1d.
  ///
  /// In zh, this message translates to:
  /// **'天\\n'**
  String get ui_auto_domain_93075adb1d;

  /// No description provided for @ui_auto_domain_934234c338.
  ///
  /// In zh, this message translates to:
  /// **'选择低GI食物，如全谷物、蔬菜'**
  String get ui_auto_domain_934234c338;

  /// No description provided for @ui_auto_domain_980bead5fa.
  ///
  /// In zh, this message translates to:
  /// **'专项成绩提升'**
  String get ui_auto_domain_980bead5fa;

  /// No description provided for @ui_auto_domain_98ff58113c.
  ///
  /// In zh, this message translates to:
  /// **'周四: 专项战术训练 60分钟'**
  String get ui_auto_domain_98ff58113c;

  /// No description provided for @ui_auto_domain_99a901b764.
  ///
  /// In zh, this message translates to:
  /// **'周二: 全身力量训练 40分钟'**
  String get ui_auto_domain_99a901b764;

  /// No description provided for @ui_auto_domain_9a1b212858.
  ///
  /// In zh, this message translates to:
  /// **'周五: 速度和爆发力训练 40分钟'**
  String get ui_auto_domain_9a1b212858;

  /// No description provided for @ui_auto_domain_9b18d01bca.
  ///
  /// In zh, this message translates to:
  /// **'周六: 户外活动或运动 60分钟'**
  String get ui_auto_domain_9b18d01bca;

  /// No description provided for @ui_auto_domain_9d6bdc4273.
  ///
  /// In zh, this message translates to:
  /// **'有氧运动心率偏低，可以适当提高强度'**
  String get ui_auto_domain_9d6bdc4273;

  /// No description provided for @ui_auto_domain_9ddf000e46.
  ///
  /// In zh, this message translates to:
  /// **'已出现高血糖症状'**
  String get ui_auto_domain_9ddf000e46;

  /// No description provided for @ui_auto_domain_9ea648ee3e.
  ///
  /// In zh, this message translates to:
  /// **'保持良好睡眠'**
  String get ui_auto_domain_9ea648ee3e;

  /// No description provided for @ui_auto_domain_9fad791f80.
  ///
  /// In zh, this message translates to:
  /// **'• 目标BMI范围: 18.5-24.9\\n\\n'**
  String get ui_auto_domain_9fad791f80;

  /// No description provided for @ui_auto_domain_a23e9b1d98.
  ///
  /// In zh, this message translates to:
  /// **'🚨 检测到的异常:\\n'**
  String get ui_auto_domain_a23e9b1d98;

  /// No description provided for @ui_auto_domain_a4c32b8520.
  ///
  /// In zh, this message translates to:
  /// **'增加规律的有氧运动'**
  String get ui_auto_domain_a4c32b8520;

  /// No description provided for @ui_auto_domain_a636071546.
  ///
  /// In zh, this message translates to:
  /// **'增加血糖监测频率'**
  String get ui_auto_domain_a636071546;

  /// No description provided for @ui_auto_domain_a63b04c54b.
  ///
  /// In zh, this message translates to:
  /// **'存在高血压相关症状'**
  String get ui_auto_domain_a63b04c54b;

  /// No description provided for @ui_auto_domain_a902e1a349.
  ///
  /// In zh, this message translates to:
  /// **'健康数据异常检测报告\\n'**
  String get ui_auto_domain_a902e1a349;

  /// No description provided for @ui_auto_domain_aa11ab8d31.
  ///
  /// In zh, this message translates to:
  /// **'连续高强度训练较多，建议安排1-2天休息'**
  String get ui_auto_domain_aa11ab8d31;

  /// No description provided for @ui_auto_domain_aa47b8377d.
  ///
  /// In zh, this message translates to:
  /// **'周一: 轻松有氧运动 45分钟'**
  String get ui_auto_domain_aa47b8377d;

  /// No description provided for @ui_auto_domain_ab3719b077.
  ///
  /// In zh, this message translates to:
  /// **'• 血压状态:'**
  String get ui_auto_domain_ab3719b077;

  /// No description provided for @ui_auto_domain_aecb487ca6.
  ///
  /// In zh, this message translates to:
  /// **'总时长:'**
  String get ui_auto_domain_aecb487ca6;

  /// No description provided for @ui_auto_domain_afc7ed92bc.
  ///
  /// In zh, this message translates to:
  /// **'最近表现有所下降，可能需要调整训练计划或增加休息'**
  String get ui_auto_domain_afc7ed92bc;

  /// No description provided for @ui_auto_domain_b0b9ad684f.
  ///
  /// In zh, this message translates to:
  /// **'轻度拉伸'**
  String get ui_auto_domain_b0b9ad684f;

  /// No description provided for @ui_auto_domain_b4326bfab5.
  ///
  /// In zh, this message translates to:
  /// **'• 建立规律的运动习惯\\n'**
  String get ui_auto_domain_b4326bfab5;

  /// No description provided for @ui_auto_domain_bbe5c6206b.
  ///
  /// In zh, this message translates to:
  /// **'周三: 轻度有氧运动 30分钟'**
  String get ui_auto_domain_bbe5c6206b;

  /// No description provided for @ui_auto_domain_bd04fafd5d.
  ///
  /// In zh, this message translates to:
  /// **'进步速度放缓，考虑增加训练变化性或强度'**
  String get ui_auto_domain_bd04fafd5d;

  /// No description provided for @ui_auto_domain_c03d0fc681.
  ///
  /// In zh, this message translates to:
  /// **'📈 体重管理目标:\\n'**
  String get ui_auto_domain_c03d0fc681;

  /// No description provided for @ui_auto_domain_c0eb9b8a61.
  ///
  /// In zh, this message translates to:
  /// **'📊 本周运动报告\\n\\n'**
  String get ui_auto_domain_c0eb9b8a61;

  /// No description provided for @ui_auto_domain_c1a162c838.
  ///
  /// In zh, this message translates to:
  /// **'周四: 核心和功能性训练 45分钟'**
  String get ui_auto_domain_c1a162c838;

  /// No description provided for @ui_auto_domain_c48ee38c13.
  ///
  /// In zh, this message translates to:
  /// **'血糖过高时运动可能加重病情'**
  String get ui_auto_domain_c48ee38c13;

  /// No description provided for @ui_auto_domain_c560fc9ed3.
  ///
  /// In zh, this message translates to:
  /// **'开始记录你的第一次运动吧！'**
  String get ui_auto_domain_c560fc9ed3;

  /// No description provided for @ui_auto_domain_c5acf79cb2.
  ///
  /// In zh, this message translates to:
  /// **'每周体重变化'**
  String get ui_auto_domain_c5acf79cb2;

  /// No description provided for @ui_auto_domain_c92912a790.
  ///
  /// In zh, this message translates to:
  /// **'周五: 有氧运动 45分钟'**
  String get ui_auto_domain_c92912a790;

  /// No description provided for @ui_auto_domain_c933751de9.
  ///
  /// In zh, this message translates to:
  /// **'充足睡眠 (8+ 小时)'**
  String get ui_auto_domain_c933751de9;

  /// No description provided for @ui_auto_domain_c9f0f55b6f.
  ///
  /// In zh, this message translates to:
  /// **'酮体水平很高，需要紧急医疗处理'**
  String get ui_auto_domain_c9f0f55b6f;

  /// No description provided for @ui_auto_domain_ca46a276bd.
  ///
  /// In zh, this message translates to:
  /// **'周四: 功能性训练 40分钟'**
  String get ui_auto_domain_ca46a276bd;

  /// No description provided for @ui_auto_domain_cd161038d0.
  ///
  /// In zh, this message translates to:
  /// **'• 增加肌肉量，改善体成分\\n\\n'**
  String get ui_auto_domain_cd161038d0;

  /// No description provided for @ui_auto_domain_ce368c8ba1.
  ///
  /// In zh, this message translates to:
  /// **'周日: 积极恢复'**
  String get ui_auto_domain_ce368c8ba1;

  /// No description provided for @ui_auto_domain_cf34b1f168.
  ///
  /// In zh, this message translates to:
  /// **'酮体水平偏高，存在酮症酸中毒风险'**
  String get ui_auto_domain_cf34b1f168;

  /// No description provided for @ui_auto_domain_cfbc69b8a6.
  ///
  /// In zh, this message translates to:
  /// **'• 体重管理（减重/增重/维持）\\n'**
  String get ui_auto_domain_cfbc69b8a6;

  /// No description provided for @ui_auto_domain_d029846f9c.
  ///
  /// In zh, this message translates to:
  /// **'血压水平:'**
  String get ui_auto_domain_d029846f9c;

  /// No description provided for @ui_auto_domain_d2d63e717f.
  ///
  /// In zh, this message translates to:
  /// **'随着年龄增长，建议适当降低高强度训练比例'**
  String get ui_auto_domain_d2d63e717f;

  /// No description provided for @ui_auto_domain_d541478786.
  ///
  /// In zh, this message translates to:
  /// **'功能恢复程度'**
  String get ui_auto_domain_d541478786;

  /// No description provided for @ui_auto_domain_d58a0de5b4.
  ///
  /// In zh, this message translates to:
  /// **'💡 建议您选择2-3个最重要的目标开始，逐步建立健康习惯。'**
  String get ui_auto_domain_d58a0de5b4;

  /// No description provided for @ui_auto_domain_d65f283309.
  ///
  /// In zh, this message translates to:
  /// **'疾病状态可能影响血糖控制'**
  String get ui_auto_domain_d65f283309;

  /// No description provided for @ui_auto_domain_d6ce516e9b.
  ///
  /// In zh, this message translates to:
  /// **'周一: 有氧运动 40分钟'**
  String get ui_auto_domain_d6ce516e9b;

  /// No description provided for @ui_auto_domain_d80ee77d47.
  ///
  /// In zh, this message translates to:
  /// **'🔍 综合健康分析报告\\n\\n'**
  String get ui_auto_domain_d80ee77d47;

  /// No description provided for @ui_auto_domain_d84e920e36.
  ///
  /// In zh, this message translates to:
  /// **'周一: 上肢力量训练 60分钟'**
  String get ui_auto_domain_d84e920e36;

  /// No description provided for @ui_auto_domain_d92007593f.
  ///
  /// In zh, this message translates to:
  /// **'运动距离:'**
  String get ui_auto_domain_d92007593f;

  /// No description provided for @ui_auto_domain_d9ddffdff5.
  ///
  /// In zh, this message translates to:
  /// **'比赛表现'**
  String get ui_auto_domain_d9ddffdff5;

  /// No description provided for @ui_auto_domain_dc93a4ebab.
  ///
  /// In zh, this message translates to:
  /// **'🎯 健康目标设定指导\\n\\n'**
  String get ui_auto_domain_dc93a4ebab;

  /// No description provided for @ui_auto_domain_dd1800285d.
  ///
  /// In zh, this message translates to:
  /// **'心率过高，注意控制运动强度'**
  String get ui_auto_domain_dd1800285d;

  /// No description provided for @ui_auto_domain_dd4e675c26.
  ///
  /// In zh, this message translates to:
  /// **'深度拉伸'**
  String get ui_auto_domain_dd4e675c26;

  /// No description provided for @ui_auto_domain_de11f956a0.
  ///
  /// In zh, this message translates to:
  /// **'周六: 长距离训练 60-90分钟'**
  String get ui_auto_domain_de11f956a0;

  /// No description provided for @ui_auto_domain_de1ea7d80b.
  ///
  /// In zh, this message translates to:
  /// **'训练强度偏低，可以适当增加中高强度训练'**
  String get ui_auto_domain_de1ea7d80b;

  /// No description provided for @ui_auto_domain_de39304943.
  ///
  /// In zh, this message translates to:
  /// **'糖尿病风险：需要医疗干预'**
  String get ui_auto_domain_de39304943;

  /// No description provided for @ui_auto_domain_de7634a03b.
  ///
  /// In zh, this message translates to:
  /// **'有氧运动对减重最有效，建议增加有氧运动比例'**
  String get ui_auto_domain_de7634a03b;

  /// No description provided for @ui_auto_domain_dff5ad02a1.
  ///
  /// In zh, this message translates to:
  /// **'• 每周2-3次力量训练\\n'**
  String get ui_auto_domain_dff5ad02a1;

  /// No description provided for @ui_auto_domain_e02ece9ee0.
  ///
  /// In zh, this message translates to:
  /// **'周一: 专项技术训练 60分钟'**
  String get ui_auto_domain_e02ece9ee0;

  /// No description provided for @ui_auto_domain_e398bc97bb.
  ///
  /// In zh, this message translates to:
  /// **'平均速度提升'**
  String get ui_auto_domain_e398bc97bb;

  /// No description provided for @ui_auto_domain_e69828cdaa.
  ///
  /// In zh, this message translates to:
  /// **'📋 数据质量评分:'**
  String get ui_auto_domain_e69828cdaa;

  /// No description provided for @ui_auto_domain_e6a947b831.
  ///
  /// In zh, this message translates to:
  /// **'周二: 全身力量训练 45分钟'**
  String get ui_auto_domain_e6a947b831;

  /// No description provided for @ui_auto_domain_e8eba85c27.
  ///
  /// In zh, this message translates to:
  /// **'为了减重目标，建议增加训练时长或强度'**
  String get ui_auto_domain_e8eba85c27;

  /// No description provided for @ui_auto_domain_e9193a4bb3.
  ///
  /// In zh, this message translates to:
  /// **'动态拉伸'**
  String get ui_auto_domain_e9193a4bb3;

  /// No description provided for @ui_auto_domain_eae508a634.
  ///
  /// In zh, this message translates to:
  /// **'柔韧性训练不足，建议每周进行2-3次拉伸或瑜伽'**
  String get ui_auto_domain_eae508a634;

  /// No description provided for @ui_auto_domain_eb8ff3a824.
  ///
  /// In zh, this message translates to:
  /// **'周日: 休息或轻度活动'**
  String get ui_auto_domain_eb8ff3a824;

  /// No description provided for @ui_auto_domain_ebccd35712.
  ///
  /// In zh, this message translates to:
  /// **'近期摄入咖啡因，可能导致血压升高'**
  String get ui_auto_domain_ebccd35712;

  /// No description provided for @ui_auto_domain_ed150f8b8d.
  ///
  /// In zh, this message translates to:
  /// **'基于您当前的健康状况，我为您推荐以下目标：\\n\\n'**
  String get ui_auto_domain_ed150f8b8d;

  /// No description provided for @ui_auto_domain_efba07a761.
  ///
  /// In zh, this message translates to:
  /// **'📊 整体健康评分:'**
  String get ui_auto_domain_efba07a761;

  /// No description provided for @ui_auto_domain_eff8b119d7.
  ///
  /// In zh, this message translates to:
  /// **'心率恢复速度'**
  String get ui_auto_domain_eff8b119d7;

  /// No description provided for @ui_auto_domain_f03331b8c4.
  ///
  /// In zh, this message translates to:
  /// **'随身携带快速碳水化合物'**
  String get ui_auto_domain_f03331b8c4;

  /// No description provided for @ui_auto_domain_f09d4d847f.
  ///
  /// In zh, this message translates to:
  /// **'周日: 休息'**
  String get ui_auto_domain_f09d4d847f;

  /// No description provided for @ui_auto_domain_f0e217a5fe.
  ///
  /// In zh, this message translates to:
  /// **'运动后血压可能受到影响'**
  String get ui_auto_domain_f0e217a5fe;

  /// No description provided for @ui_auto_domain_f1a3e8bb6f.
  ///
  /// In zh, this message translates to:
  /// **'周一: 中等强度有氧运动 45分钟'**
  String get ui_auto_domain_f1a3e8bb6f;

  /// No description provided for @ui_auto_domain_f2ae442cbe.
  ///
  /// In zh, this message translates to:
  /// **'周四: 休息'**
  String get ui_auto_domain_f2ae442cbe;

  /// No description provided for @ui_auto_domain_f33ca242e5.
  ///
  /// In zh, this message translates to:
  /// **'继续保持规律运动，有助于血糖控制'**
  String get ui_auto_domain_f33ca242e5;

  /// No description provided for @ui_auto_domain_f3efc3e009.
  ///
  /// In zh, this message translates to:
  /// **'建议立即就医，可能需要药物治疗'**
  String get ui_auto_domain_f3efc3e009;

  /// No description provided for @ui_auto_domain_f52274565d.
  ///
  /// In zh, this message translates to:
  /// **'我可以帮您制定个性化的健康目标。常见的健康目标包括：\\n\\n'**
  String get ui_auto_domain_f52274565d;

  /// No description provided for @ui_auto_domain_f54a0f4992.
  ///
  /// In zh, this message translates to:
  /// **'• 月度健康状况评估\\n\\n'**
  String get ui_auto_domain_f54a0f4992;

  /// No description provided for @ui_auto_domain_f54d83df20.
  ///
  /// In zh, this message translates to:
  /// **'周六: 休息或拉伸'**
  String get ui_auto_domain_f54d83df20;

  /// No description provided for @ui_auto_domain_f5bc7582e6.
  ///
  /// In zh, this message translates to:
  /// **'为了增肌目标，需要增加训练负荷和重量'**
  String get ui_auto_domain_f5bc7582e6;

  /// No description provided for @ui_auto_domain_f63cd233d3.
  ///
  /// In zh, this message translates to:
  /// **'最大举重重量'**
  String get ui_auto_domain_f63cd233d3;

  /// No description provided for @ui_auto_domain_f71aaf94fe.
  ///
  /// In zh, this message translates to:
  /// **'周二: 下肢力量训练 60分钟'**
  String get ui_auto_domain_f71aaf94fe;

  /// No description provided for @ui_auto_domain_f973dc4758.
  ///
  /// In zh, this message translates to:
  /// **'充分水分补充'**
  String get ui_auto_domain_f973dc4758;

  /// No description provided for @ui_auto_domain_f98f6926f7.
  ///
  /// In zh, this message translates to:
  /// **'力量耐力提升'**
  String get ui_auto_domain_f98f6926f7;

  /// No description provided for @ui_auto_domain_f9984ecde0.
  ///
  /// In zh, this message translates to:
  /// **'尝试增加运动时长或增加间歇训练'**
  String get ui_auto_domain_f9984ecde0;

  /// No description provided for @ui_auto_domain_faa72f12f2.
  ///
  /// In zh, this message translates to:
  /// **'轻度有氧运动'**
  String get ui_auto_domain_faa72f12f2;

  /// No description provided for @ui_auto_domain_facfe17fb9.
  ///
  /// In zh, this message translates to:
  /// **'考虑调整训练方式或增加强度来突破平台期'**
  String get ui_auto_domain_facfe17fb9;

  /// No description provided for @ui_auto_domain_fb5c3547c7.
  ///
  /// In zh, this message translates to:
  /// **'• 健康增重，每月0.5-1公斤\\n'**
  String get ui_auto_domain_fb5c3547c7;

  /// No description provided for @ui_auto_domain_fcb5a56d73.
  ///
  /// In zh, this message translates to:
  /// **'• 每周记录运动数据\\n'**
  String get ui_auto_domain_fcb5a56d73;

  /// No description provided for @ui_auto_domain_fefb41c5b6.
  ///
  /// In zh, this message translates to:
  /// **'15分钟后重新测量血糖'**
  String get ui_auto_domain_fefb41c5b6;

  /// No description provided for @ui_auto_domain_fff2ba1947.
  ///
  /// In zh, this message translates to:
  /// **'低血糖风险：可能导致意识模糊、昏迷'**
  String get ui_auto_domain_fff2ba1947;

  /// No description provided for @ui_auto_format_00911c767b.
  ///
  /// In zh, this message translates to:
  /// **'• 最新血压: %1\$d/%2\$d mmHg\\n'**
  String get ui_auto_format_00911c767b;

  /// No description provided for @ui_auto_format_018fb387dd.
  ///
  /// In zh, this message translates to:
  /// **'近 7 天体脂 %+.1f%%，整体变化较平稳。'**
  String get ui_auto_format_018fb387dd;

  /// No description provided for @ui_auto_format_05c1654154.
  ///
  /// In zh, this message translates to:
  /// **'餐后血糖高: %1\$.1f %2\$s'**
  String get ui_auto_format_05c1654154;

  /// No description provided for @ui_auto_format_07c00ecc91.
  ///
  /// In zh, this message translates to:
  /// **'按当前趋势，预计在%d天后达到目标体重，继续保持！'**
  String get ui_auto_format_07c00ecc91;

  /// No description provided for @ui_auto_format_0ca0939c70.
  ///
  /// In zh, this message translates to:
  /// **'血压达到危症水平: %1\$d/%2\$d mmHg'**
  String get ui_auto_format_0ca0939c70;

  /// No description provided for @ui_auto_format_0ca2b75411.
  ///
  /// In zh, this message translates to:
  /// **'近 7 天体重 %1\$+.1f 公斤，波动区间 %2\$.1f 公斤。'**
  String get ui_auto_format_0ca2b75411;

  /// No description provided for @ui_auto_format_110e1fa9a5.
  ///
  /// In zh, this message translates to:
  /// **'体重在短期内剧烈变化%1\$.1fkg (%2\$.1f%%)，需要关注'**
  String get ui_auto_format_110e1fa9a5;

  /// No description provided for @ui_auto_format_1128d4212d.
  ///
  /// In zh, this message translates to:
  /// **'血压变异性过大: 收缩压SD=%1\$.1f, 舒张压SD=%2\$.1f'**
  String get ui_auto_format_1128d4212d;

  /// No description provided for @ui_auto_format_1137ccebb6.
  ///
  /// In zh, this message translates to:
  /// **'体重短期变化%1\$.1fkg (%2\$.1f%%)，超出正常范围'**
  String get ui_auto_format_1137ccebb6;

  /// No description provided for @ui_auto_format_1137e5af65.
  ///
  /// In zh, this message translates to:
  /// **'脉压差过小: %d mmHg'**
  String get ui_auto_format_1137e5af65;

  /// No description provided for @ui_auto_format_11a082b1fb.
  ///
  /// In zh, this message translates to:
  /// **'• 最新血糖: %1\$.1f %2\$s\\n'**
  String get ui_auto_format_11a082b1fb;

  /// No description provided for @ui_auto_format_2243af4253.
  ///
  /// In zh, this message translates to:
  /// **'心率过快: %d bpm'**
  String get ui_auto_format_2243af4253;

  /// No description provided for @ui_auto_format_24e07d01ef.
  ///
  /// In zh, this message translates to:
  /// **'您在%1\$s内进行了%2\$d次运动，平均每周%3\$d次，符合健康建议'**
  String get ui_auto_format_24e07d01ef;

  /// No description provided for @ui_auto_format_2c6250ff36.
  ///
  /// In zh, this message translates to:
  /// **'心率变异性持续下降: 趋势斜率%.2f'**
  String get ui_auto_format_2c6250ff36;

  /// No description provided for @ui_auto_format_2e022c1a7b.
  ///
  /// In zh, this message translates to:
  /// **'体重 %.1f 公斤'**
  String get ui_auto_format_2e022c1a7b;

  /// No description provided for @ui_auto_format_34e218de2c.
  ///
  /// In zh, this message translates to:
  /// **'低血糖: %1\$.1f %2\$s'**
  String get ui_auto_format_34e218de2c;

  /// No description provided for @ui_auto_format_373d2cc602.
  ///
  /// In zh, this message translates to:
  /// **'体重%1\$s趋势异常: 每周变化%2\$.1fkg'**
  String get ui_auto_format_373d2cc602;

  /// No description provided for @ui_auto_format_37d6964dc2.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s本周完成 %2\$d/%3\$d 天'**
  String get ui_auto_format_37d6964dc2;

  /// No description provided for @ui_auto_format_4800e5a37e.
  ///
  /// In zh, this message translates to:
  /// **'体脂 %1\$.1f%% · BMI %2\$.1f'**
  String get ui_auto_format_4800e5a37e;

  /// No description provided for @ui_auto_format_4a74d95d35.
  ///
  /// In zh, this message translates to:
  /// **'严重低血糖: %1\$.1f %2\$s'**
  String get ui_auto_format_4a74d95d35;

  /// No description provided for @ui_auto_format_4bff749c67.
  ///
  /// In zh, this message translates to:
  /// **'• 最新体重: %.1f kg\\n'**
  String get ui_auto_format_4bff749c67;

  /// No description provided for @ui_auto_format_4df896a891.
  ///
  /// In zh, this message translates to:
  /// **'本周运动%d次，建议增加到每周3次'**
  String get ui_auto_format_4df896a891;

  /// No description provided for @ui_auto_format_514479f9ed.
  ///
  /// In zh, this message translates to:
  /// **'静息心率过高: %d bpm'**
  String get ui_auto_format_514479f9ed;

  /// No description provided for @ui_auto_format_571f2094e0.
  ///
  /// In zh, this message translates to:
  /// **'• 平均血糖: %1\$.1f %2\$s\\n'**
  String get ui_auto_format_571f2094e0;

  /// No description provided for @ui_auto_format_5dd2a239a3.
  ///
  /// In zh, this message translates to:
  /// **'心率过慢: %d bpm'**
  String get ui_auto_format_5dd2a239a3;

  /// No description provided for @ui_auto_format_601463cc36.
  ///
  /// In zh, this message translates to:
  /// **'优先级: %1\$s | 证据等级: %2\$s\\n\\n'**
  String get ui_auto_format_601463cc36;

  /// No description provided for @ui_auto_format_610ed4cc33.
  ///
  /// In zh, this message translates to:
  /// **'本周运动%d次，运动频率优秀'**
  String get ui_auto_format_610ed4cc33;

  /// No description provided for @ui_auto_format_6abc726fed.
  ///
  /// In zh, this message translates to:
  /// **'• 运动次数: %d 次\\n'**
  String get ui_auto_format_6abc726fed;

  /// No description provided for @ui_auto_format_70bb46f4df.
  ///
  /// In zh, this message translates to:
  /// **'血糖变异性过大: CV=%.1f%%'**
  String get ui_auto_format_70bb46f4df;

  /// No description provided for @ui_auto_format_71eae9dc6f.
  ///
  /// In zh, this message translates to:
  /// **'• 变化: %+.1f kg\\n'**
  String get ui_auto_format_71eae9dc6f;

  /// No description provided for @ui_auto_format_739ff7016d.
  ///
  /// In zh, this message translates to:
  /// **'脉压差过大: %d mmHg'**
  String get ui_auto_format_739ff7016d;

  /// No description provided for @ui_auto_format_7e85fa1439.
  ///
  /// In zh, this message translates to:
  /// **'已设置每天 %1\$02d:%2\$02d 提醒'**
  String get ui_auto_format_7e85fa1439;

  /// No description provided for @ui_auto_format_8807c87491.
  ///
  /// In zh, this message translates to:
  /// **'计划完成 %1\$d/%2\$d 天'**
  String get ui_auto_format_8807c87491;

  /// No description provided for @ui_auto_format_8d111d9721.
  ///
  /// In zh, this message translates to:
  /// **'连续%d次血糖偏高'**
  String get ui_auto_format_8d111d9721;

  /// No description provided for @ui_auto_format_8d50543253.
  ///
  /// In zh, this message translates to:
  /// **'心率变异性极低: %.1f ms'**
  String get ui_auto_format_8d50543253;

  /// No description provided for @ui_auto_format_8e9d9a7e71.
  ///
  /// In zh, this message translates to:
  /// **'• 总运动时长: %d 分钟\\n'**
  String get ui_auto_format_8e9d9a7e71;

  /// No description provided for @ui_auto_format_902f933635.
  ///
  /// In zh, this message translates to:
  /// **'%1\$d\\\'%2\$02d\\&quot;/公里'**
  String get ui_auto_format_902f933635;

  /// No description provided for @ui_auto_format_9317acd6eb.
  ///
  /// In zh, this message translates to:
  /// **'血糖极高: %1\$.1f %2\$s'**
  String get ui_auto_format_9317acd6eb;

  /// No description provided for @ui_auto_format_958b9b0967.
  ///
  /// In zh, this message translates to:
  /// **'体重变化在%.1f公斤范围内，控制良好'**
  String get ui_auto_format_958b9b0967;

  /// No description provided for @ui_auto_format_a16a2356a7.
  ///
  /// In zh, this message translates to:
  /// **'血压严重偏高: %1\$d/%2\$d mmHg'**
  String get ui_auto_format_a16a2356a7;

  /// No description provided for @ui_auto_format_a5946fe7ec.
  ///
  /// In zh, this message translates to:
  /// **'空腹血糖高: %1\$.1f %2\$s'**
  String get ui_auto_format_a5946fe7ec;

  /// No description provided for @ui_auto_format_b26869ee5b.
  ///
  /// In zh, this message translates to:
  /// **'• 最新心率: %d bpm\\n'**
  String get ui_auto_format_b26869ee5b;

  /// No description provided for @ui_auto_format_b595803c8d.
  ///
  /// In zh, this message translates to:
  /// **'当前体水分 %.1f%%，建议结合最近状态一起观察。'**
  String get ui_auto_format_b595803c8d;

  /// No description provided for @ui_auto_format_bcd4386b44.
  ///
  /// In zh, this message translates to:
  /// **'静息心率过低: %d bpm'**
  String get ui_auto_format_bcd4386b44;

  /// No description provided for @ui_auto_format_bdef819d12.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s异常值: %2\$.2f (Z-Score: %3\$.2f)'**
  String get ui_auto_format_bdef819d12;

  /// No description provided for @ui_auto_format_c8124505fe.
  ///
  /// In zh, this message translates to:
  /// **'最大心率异常: %d bpm'**
  String get ui_auto_format_c8124505fe;

  /// No description provided for @ui_auto_format_c8de19ca20.
  ///
  /// In zh, this message translates to:
  /// **'血压偏低: %1\$d/%2\$d mmHg'**
  String get ui_auto_format_c8de19ca20;

  /// No description provided for @ui_auto_format_cdcb9bf7bc.
  ///
  /// In zh, this message translates to:
  /// **'• 血压趋势：收缩压%+d mmHg'**
  String get ui_auto_format_cdcb9bf7bc;

  /// No description provided for @ui_auto_format_d526a01c36.
  ///
  /// In zh, this message translates to:
  /// **'发现 %d 个潜在风险因子：\\n\\n'**
  String get ui_auto_format_d526a01c36;

  /// No description provided for @ui_auto_format_d883abb196.
  ///
  /// In zh, this message translates to:
  /// **'/ %,d步'**
  String get ui_auto_format_d883abb196;

  /// No description provided for @ui_auto_format_e123ec6667.
  ///
  /// In zh, this message translates to:
  /// **'最新血压%1\$d/%2\$d mmHg，处于理想范围'**
  String get ui_auto_format_e123ec6667;

  /// No description provided for @ui_auto_format_e6279b47a9.
  ///
  /// In zh, this message translates to:
  /// **'• 总消耗热量: %d 卡路里\\n'**
  String get ui_auto_format_e6279b47a9;

  /// No description provided for @ui_auto_format_eb61419bc7.
  ///
  /// In zh, this message translates to:
  /// **'• 体重变化：%+.1f 公斤'**
  String get ui_auto_format_eb61419bc7;

  /// No description provided for @ui_auto_format_efd46da980.
  ///
  /// In zh, this message translates to:
  /// **'心率变异性异常高: %.1f ms'**
  String get ui_auto_format_efd46da980;

  /// No description provided for @ui_auto_format_f363dd41bd.
  ///
  /// In zh, this message translates to:
  /// **'• 平均血压: %1\$.0f/%2\$.0f mmHg\\n'**
  String get ui_auto_format_f363dd41bd;

  /// No description provided for @ui_auto_format_f60d444a8d.
  ///
  /// In zh, this message translates to:
  /// **'训练时长 %1\$d 分钟 · 消耗 %2\$d 千卡'**
  String get ui_auto_format_f60d444a8d;

  /// No description provided for @ui_auto_format_fb5041c079.
  ///
  /// In zh, this message translates to:
  /// **'分析%d次运动记录的表现趋势'**
  String get ui_auto_format_fb5041c079;

  /// No description provided for @ui_auto_format_fe2b06f467.
  ///
  /// In zh, this message translates to:
  /// **'• 运动频率：每周约%d次'**
  String get ui_auto_format_fe2b06f467;

  /// No description provided for @ui_auto_full_004bf6c9a4.
  ///
  /// In zh, this message translates to:
  /// **'操作'**
  String get ui_auto_full_004bf6c9a4;

  /// No description provided for @ui_auto_full_009569d920.
  ///
  /// In zh, this message translates to:
  /// **'手动输入或在食材库中选择'**
  String get ui_auto_full_009569d920;

  /// No description provided for @ui_auto_full_01ceb3edde.
  ///
  /// In zh, this message translates to:
  /// **'无数据'**
  String get ui_auto_full_01ceb3edde;

  /// No description provided for @ui_auto_full_029c5cf68d.
  ///
  /// In zh, this message translates to:
  /// **'onboarding image'**
  String get ui_auto_full_029c5cf68d;

  /// No description provided for @ui_auto_full_02cc4f8f5a.
  ///
  /// In zh, this message translates to:
  /// **'请输入'**
  String get ui_auto_full_02cc4f8f5a;

  /// No description provided for @ui_auto_full_046f4e6039.
  ///
  /// In zh, this message translates to:
  /// **'0ml'**
  String get ui_auto_full_046f4e6039;

  /// No description provided for @ui_auto_full_0494499037.
  ///
  /// In zh, this message translates to:
  /// **'睡眠记录'**
  String get ui_auto_full_0494499037;

  /// No description provided for @ui_auto_full_04ab46142c.
  ///
  /// In zh, this message translates to:
  /// **'华为 / 荣耀 运动健康'**
  String get ui_auto_full_04ab46142c;

  /// No description provided for @ui_auto_full_052798d60b.
  ///
  /// In zh, this message translates to:
  /// **'+25米'**
  String get ui_auto_full_052798d60b;

  /// No description provided for @ui_auto_full_0713ccf219.
  ///
  /// In zh, this message translates to:
  /// **'经过一夜睡眠，身体处于缺水状态...'**
  String get ui_auto_full_0713ccf219;

  /// No description provided for @ui_auto_full_0724b8c5b1.
  ///
  /// In zh, this message translates to:
  /// **'⏯ 继续'**
  String get ui_auto_full_0724b8c5b1;

  /// No description provided for @ui_auto_full_072b030ba1.
  ///
  /// In zh, this message translates to:
  /// **'60'**
  String get ui_auto_full_072b030ba1;

  /// No description provided for @ui_auto_full_088ae13e05.
  ///
  /// In zh, this message translates to:
  /// **'走路步数'**
  String get ui_auto_full_088ae13e05;

  /// No description provided for @ui_auto_full_08f90c1a41.
  ///
  /// In zh, this message translates to:
  /// **'2000'**
  String get ui_auto_full_08f90c1a41;

  /// No description provided for @ui_auto_full_0a3b7f8c7f.
  ///
  /// In zh, this message translates to:
  /// **'2020年5月12日 4时6分'**
  String get ui_auto_full_0a3b7f8c7f;

  /// No description provided for @ui_auto_full_0bd46d3e70.
  ///
  /// In zh, this message translates to:
  /// **'当前金币：'**
  String get ui_auto_full_0bd46d3e70;

  /// No description provided for @ui_auto_full_0c1fec657f.
  ///
  /// In zh, this message translates to:
  /// **'秒'**
  String get ui_auto_full_0c1fec657f;

  /// No description provided for @ui_auto_full_0c4865b55f.
  ///
  /// In zh, this message translates to:
  /// **'0 Kal'**
  String get ui_auto_full_0c4865b55f;

  /// No description provided for @ui_auto_full_0d7bd91ed2.
  ///
  /// In zh, this message translates to:
  /// **'开心天数'**
  String get ui_auto_full_0d7bd91ed2;

  /// No description provided for @ui_auto_full_0e40fe69b8.
  ///
  /// In zh, this message translates to:
  /// **'收款账户:'**
  String get ui_auto_full_0e40fe69b8;

  /// No description provided for @ui_auto_full_1021d1e606.
  ///
  /// In zh, this message translates to:
  /// **'运动打卡动态圈'**
  String get ui_auto_full_1021d1e606;

  /// No description provided for @ui_auto_full_1063e38cb5.
  ///
  /// In zh, this message translates to:
  /// **'移除'**
  String get ui_auto_full_1063e38cb5;

  /// No description provided for @ui_auto_full_10ec59e73f.
  ///
  /// In zh, this message translates to:
  /// **'8小时'**
  String get ui_auto_full_10ec59e73f;

  /// No description provided for @ui_auto_full_11f81b5842.
  ///
  /// In zh, this message translates to:
  /// **'本周总步数'**
  String get ui_auto_full_11f81b5842;

  /// No description provided for @ui_auto_full_12d7939b3b.
  ///
  /// In zh, this message translates to:
  /// **'日均热量'**
  String get ui_auto_full_12d7939b3b;

  /// No description provided for @ui_auto_full_12f1d7ef38.
  ///
  /// In zh, this message translates to:
  /// **'结束'**
  String get ui_auto_full_12f1d7ef38;

  /// No description provided for @ui_auto_full_1301b323d3.
  ///
  /// In zh, this message translates to:
  /// **'450 千卡'**
  String get ui_auto_full_1301b323d3;

  /// No description provided for @ui_auto_full_135895622e.
  ///
  /// In zh, this message translates to:
  /// **'修改目标'**
  String get ui_auto_full_135895622e;

  /// No description provided for @ui_auto_full_13ac0e0299.
  ///
  /// In zh, this message translates to:
  /// **'喝水详情'**
  String get ui_auto_full_13ac0e0299;

  /// No description provided for @ui_auto_full_149e9677a5.
  ///
  /// In zh, this message translates to:
  /// **'170'**
  String get ui_auto_full_149e9677a5;

  /// No description provided for @ui_auto_full_14d18ae2bf.
  ///
  /// In zh, this message translates to:
  /// **'组数模式'**
  String get ui_auto_full_14d18ae2bf;

  /// No description provided for @ui_auto_full_14e6d83ff5.
  ///
  /// In zh, this message translates to:
  /// **'时间：'**
  String get ui_auto_full_14e6d83ff5;

  /// No description provided for @ui_auto_full_153fa67a7f.
  ///
  /// In zh, this message translates to:
  /// **'选择'**
  String get ui_auto_full_153fa67a7f;

  /// No description provided for @ui_auto_full_15806c39ad.
  ///
  /// In zh, this message translates to:
  /// **'连续签到0天'**
  String get ui_auto_full_15806c39ad;

  /// No description provided for @ui_auto_full_1724cf75f2.
  ///
  /// In zh, this message translates to:
  /// **'完成率'**
  String get ui_auto_full_1724cf75f2;

  /// No description provided for @ui_auto_full_173765b19a.
  ///
  /// In zh, this message translates to:
  /// **'🧘'**
  String get ui_auto_full_173765b19a;

  /// No description provided for @ui_auto_full_176848afab.
  ///
  /// In zh, this message translates to:
  /// **'·'**
  String get ui_auto_full_176848afab;

  /// No description provided for @ui_auto_full_1879879cb7.
  ///
  /// In zh, this message translates to:
  /// **'热量趋势'**
  String get ui_auto_full_1879879cb7;

  /// No description provided for @ui_auto_full_18940d53c5.
  ///
  /// In zh, this message translates to:
  /// **'12:00'**
  String get ui_auto_full_18940d53c5;

  /// No description provided for @ui_auto_full_18c50e88d7.
  ///
  /// In zh, this message translates to:
  /// **'目标距离'**
  String get ui_auto_full_18c50e88d7;

  /// No description provided for @ui_auto_full_19fcb9eb25.
  ///
  /// In zh, this message translates to:
  /// **'时间'**
  String get ui_auto_full_19fcb9eb25;

  /// No description provided for @ui_auto_full_1a69cc9440.
  ///
  /// In zh, this message translates to:
  /// **'立即开始'**
  String get ui_auto_full_1a69cc9440;

  /// No description provided for @ui_auto_full_1d5463d26b.
  ///
  /// In zh, this message translates to:
  /// **'共 86 种运动'**
  String get ui_auto_full_1d5463d26b;

  /// No description provided for @ui_auto_full_1dacb10f06.
  ///
  /// In zh, this message translates to:
  /// **'5800'**
  String get ui_auto_full_1dacb10f06;

  /// No description provided for @ui_auto_full_1deb846a2a.
  ///
  /// In zh, this message translates to:
  /// **'05-05'**
  String get ui_auto_full_1deb846a2a;

  /// No description provided for @ui_auto_full_1e0bbae5c4.
  ///
  /// In zh, this message translates to:
  /// **'坚持不懈'**
  String get ui_auto_full_1e0bbae5c4;

  /// No description provided for @ui_auto_full_1e8aef898a.
  ///
  /// In zh, this message translates to:
  /// **'累计签到0天'**
  String get ui_auto_full_1e8aef898a;

  /// No description provided for @ui_auto_full_1f0e3dad99.
  ///
  /// In zh, this message translates to:
  /// **'19'**
  String get ui_auto_full_1f0e3dad99;

  /// No description provided for @ui_auto_full_1fe85c057e.
  ///
  /// In zh, this message translates to:
  /// **'暂无记录，添加饮食试试'**
  String get ui_auto_full_1fe85c057e;

  /// No description provided for @ui_auto_full_1ff1de7740.
  ///
  /// In zh, this message translates to:
  /// **'24'**
  String get ui_auto_full_1ff1de7740;

  /// No description provided for @ui_auto_full_202f12ffba.
  ///
  /// In zh, this message translates to:
  /// **'倒计时'**
  String get ui_auto_full_202f12ffba;

  /// No description provided for @ui_auto_full_21fc612404.
  ///
  /// In zh, this message translates to:
  /// **'自动根据时长和距离计算'**
  String get ui_auto_full_21fc612404;

  /// No description provided for @ui_auto_full_220262ce51.
  ///
  /// In zh, this message translates to:
  /// **'太棒了，记录已保存'**
  String get ui_auto_full_220262ce51;

  /// No description provided for @ui_auto_full_2229fe1cf0.
  ///
  /// In zh, this message translates to:
  /// **'与运动、喝水、饮食、睡眠、心情记录联动解锁'**
  String get ui_auto_full_2229fe1cf0;

  /// No description provided for @ui_auto_full_2260674c11.
  ///
  /// In zh, this message translates to:
  /// **'勋章进度'**
  String get ui_auto_full_2260674c11;

  /// No description provided for @ui_auto_full_226b091218.
  ///
  /// In zh, this message translates to:
  /// **'类型'**
  String get ui_auto_full_226b091218;

  /// No description provided for @ui_auto_full_227e15e61a.
  ///
  /// In zh, this message translates to:
  /// **'长按拖动卡片调整卡片顺序'**
  String get ui_auto_full_227e15e61a;

  /// No description provided for @ui_auto_full_22b58c6798.
  ///
  /// In zh, this message translates to:
  /// **'可暂停后继续'**
  String get ui_auto_full_22b58c6798;

  /// No description provided for @ui_auto_full_22ce3c06d0.
  ///
  /// In zh, this message translates to:
  /// **'小米 / Zepp Life'**
  String get ui_auto_full_22ce3c06d0;

  /// No description provided for @ui_auto_full_2530cb0afb.
  ///
  /// In zh, this message translates to:
  /// **'20元'**
  String get ui_auto_full_2530cb0afb;

  /// No description provided for @ui_auto_full_2593af7293.
  ///
  /// In zh, this message translates to:
  /// **'📅 本月心情日历'**
  String get ui_auto_full_2593af7293;

  /// No description provided for @ui_auto_full_27749157cf.
  ///
  /// In zh, this message translates to:
  /// **'坚持天数'**
  String get ui_auto_full_27749157cf;

  /// No description provided for @ui_auto_full_29b5d75155.
  ///
  /// In zh, this message translates to:
  /// **'😴 睡眠趋势'**
  String get ui_auto_full_29b5d75155;

  /// No description provided for @ui_auto_full_2a813bc3eb.
  ///
  /// In zh, this message translates to:
  /// **'立即下载'**
  String get ui_auto_full_2a813bc3eb;

  /// No description provided for @ui_auto_full_2b24d49505.
  ///
  /// In zh, this message translates to:
  /// **'145'**
  String get ui_auto_full_2b24d49505;

  /// No description provided for @ui_auto_full_2b80deb8ec.
  ///
  /// In zh, this message translates to:
  /// **'历史最高步数'**
  String get ui_auto_full_2b80deb8ec;

  /// No description provided for @ui_auto_full_2be4237ee2.
  ///
  /// In zh, this message translates to:
  /// **'开始您的第一次运动吧'**
  String get ui_auto_full_2be4237ee2;

  /// No description provided for @ui_auto_full_2cc3f81d2f.
  ///
  /// In zh, this message translates to:
  /// **'未开启通知使用权'**
  String get ui_auto_full_2cc3f81d2f;

  /// No description provided for @ui_auto_full_2d60b7d559.
  ///
  /// In zh, this message translates to:
  /// **'暂无计划'**
  String get ui_auto_full_2d60b7d559;

  /// No description provided for @ui_auto_full_2e22cec81d.
  ///
  /// In zh, this message translates to:
  /// **'点击制定专属计划 ›'**
  String get ui_auto_full_2e22cec81d;

  /// No description provided for @ui_auto_full_2e85dea5d7.
  ///
  /// In zh, this message translates to:
  /// **'今天精神怎么样'**
  String get ui_auto_full_2e85dea5d7;

  /// No description provided for @ui_auto_full_2eff678853.
  ///
  /// In zh, this message translates to:
  /// **'累计重复次数'**
  String get ui_auto_full_2eff678853;

  /// No description provided for @ui_auto_full_2f81130a68.
  ///
  /// In zh, this message translates to:
  /// **'为什么早起要喝一杯水？'**
  String get ui_auto_full_2f81130a68;

  /// No description provided for @ui_auto_full_2faa266043.
  ///
  /// In zh, this message translates to:
  /// **'目标设置'**
  String get ui_auto_full_2faa266043;

  /// No description provided for @ui_auto_full_303492ea77.
  ///
  /// In zh, this message translates to:
  /// **'这是动态的内容文字...'**
  String get ui_auto_full_303492ea77;

  /// No description provided for @ui_auto_full_30565a8911.
  ///
  /// In zh, this message translates to:
  /// **'0.0'**
  String get ui_auto_full_30565a8911;

  /// No description provided for @ui_auto_full_31edf50b8d.
  ///
  /// In zh, this message translates to:
  /// **'秒表用于自由计时，倒计时适合间歇训练。'**
  String get ui_auto_full_31edf50b8d;

  /// No description provided for @ui_auto_full_32c65d8d74.
  ///
  /// In zh, this message translates to:
  /// **'标题'**
  String get ui_auto_full_32c65d8d74;

  /// No description provided for @ui_auto_full_33a34fb146.
  ///
  /// In zh, this message translates to:
  /// **'3 组 × 40 秒 · 组间休息 25 秒'**
  String get ui_auto_full_33a34fb146;

  /// No description provided for @ui_auto_full_33e75ff09d.
  ///
  /// In zh, this message translates to:
  /// **'28'**
  String get ui_auto_full_33e75ff09d;

  /// No description provided for @ui_auto_full_3424ee3e2c.
  ///
  /// In zh, this message translates to:
  /// **'总热量(千卡)'**
  String get ui_auto_full_3424ee3e2c;

  /// No description provided for @ui_auto_full_344f459e96.
  ///
  /// In zh, this message translates to:
  /// **'真实姓名:'**
  String get ui_auto_full_344f459e96;

  /// No description provided for @ui_auto_full_3600ace4b8.
  ///
  /// In zh, this message translates to:
  /// **'450千卡/天'**
  String get ui_auto_full_3600ace4b8;

  /// No description provided for @ui_auto_full_36285b8c01.
  ///
  /// In zh, this message translates to:
  /// **'描述文字'**
  String get ui_auto_full_36285b8c01;

  /// No description provided for @ui_auto_full_3644a684f9.
  ///
  /// In zh, this message translates to:
  /// **'200'**
  String get ui_auto_full_3644a684f9;

  /// No description provided for @ui_auto_full_36b9a14914.
  ///
  /// In zh, this message translates to:
  /// **'最近的摄入记录'**
  String get ui_auto_full_36b9a14914;

  /// No description provided for @ui_auto_full_3731393e39.
  ///
  /// In zh, this message translates to:
  /// **'为本次运动选择目标，达成后会自动提醒。'**
  String get ui_auto_full_3731393e39;

  /// No description provided for @ui_auto_full_3737bc69d9.
  ///
  /// In zh, this message translates to:
  /// **'冥想计时器'**
  String get ui_auto_full_3737bc69d9;

  /// No description provided for @ui_auto_full_375ec8858f.
  ///
  /// In zh, this message translates to:
  /// **'好的'**
  String get ui_auto_full_375ec8858f;

  /// No description provided for @ui_auto_full_3782d489af.
  ///
  /// In zh, this message translates to:
  /// **'+ 添加这一组'**
  String get ui_auto_full_3782d489af;

  /// No description provided for @ui_auto_full_37ad0425e7.
  ///
  /// In zh, this message translates to:
  /// **'12/28'**
  String get ui_auto_full_37ad0425e7;

  /// No description provided for @ui_auto_full_38ce27d846.
  ///
  /// In zh, this message translates to:
  /// **'下一步'**
  String get ui_auto_full_38ce27d846;

  /// No description provided for @ui_auto_full_39305aa280.
  ///
  /// In zh, this message translates to:
  /// **'80后的回忆！经典三国完美复刻，安卓用户的福利'**
  String get ui_auto_full_39305aa280;

  /// No description provided for @ui_auto_full_39d2b80d94.
  ///
  /// In zh, this message translates to:
  /// **'徒步'**
  String get ui_auto_full_39d2b80d94;

  /// No description provided for @ui_auto_full_3bf2085444.
  ///
  /// In zh, this message translates to:
  /// **'记饮食'**
  String get ui_auto_full_3bf2085444;

  /// No description provided for @ui_auto_full_3cc4b779df.
  ///
  /// In zh, this message translates to:
  /// **'午餐'**
  String get ui_auto_full_3cc4b779df;

  /// No description provided for @ui_auto_full_3ced03e62d.
  ///
  /// In zh, this message translates to:
  /// **'0千卡'**
  String get ui_auto_full_3ced03e62d;

  /// No description provided for @ui_auto_full_3cfb34717c.
  ///
  /// In zh, this message translates to:
  /// **'运动完成！'**
  String get ui_auto_full_3cfb34717c;

  /// No description provided for @ui_auto_full_3d322ae60a.
  ///
  /// In zh, this message translates to:
  /// **'暂停下载'**
  String get ui_auto_full_3d322ae60a;

  /// No description provided for @ui_auto_full_3dd997569b.
  ///
  /// In zh, this message translates to:
  /// **'助眠白噪音'**
  String get ui_auto_full_3dd997569b;

  /// No description provided for @ui_auto_full_3de6621409.
  ///
  /// In zh, this message translates to:
  /// **'7天万步挑战'**
  String get ui_auto_full_3de6621409;

  /// No description provided for @ui_auto_full_3dee6f61c7.
  ///
  /// In zh, this message translates to:
  /// **'50元'**
  String get ui_auto_full_3dee6f61c7;

  /// No description provided for @ui_auto_full_3df6930203.
  ///
  /// In zh, this message translates to:
  /// **'室内跑'**
  String get ui_auto_full_3df6930203;

  /// No description provided for @ui_auto_full_3e81e2c188.
  ///
  /// In zh, this message translates to:
  /// **'2000千卡'**
  String get ui_auto_full_3e81e2c188;

  /// No description provided for @ui_auto_full_3e9dc5c606.
  ///
  /// In zh, this message translates to:
  /// **'知晓过去，才能遇见未来'**
  String get ui_auto_full_3e9dc5c606;

  /// No description provided for @ui_auto_full_3fea7ca76c.
  ///
  /// In zh, this message translates to:
  /// **'状态'**
  String get ui_auto_full_3fea7ca76c;

  /// No description provided for @ui_auto_full_40fb1bf15b.
  ///
  /// In zh, this message translates to:
  /// **'输入水量'**
  String get ui_auto_full_40fb1bf15b;

  /// No description provided for @ui_auto_full_41c8ce3c58.
  ///
  /// In zh, this message translates to:
  /// **':567890'**
  String get ui_auto_full_41c8ce3c58;

  /// No description provided for @ui_auto_full_41eedf4071.
  ///
  /// In zh, this message translates to:
  /// **'12:11'**
  String get ui_auto_full_41eedf4071;

  /// No description provided for @ui_auto_full_42008e0811.
  ///
  /// In zh, this message translates to:
  /// **'.00'**
  String get ui_auto_full_42008e0811;

  /// No description provided for @ui_auto_full_4206e76abd.
  ///
  /// In zh, this message translates to:
  /// **'10元'**
  String get ui_auto_full_4206e76abd;

  /// No description provided for @ui_auto_full_420c331ac5.
  ///
  /// In zh, this message translates to:
  /// **'着陆无双'**
  String get ui_auto_full_420c331ac5;

  /// No description provided for @ui_auto_full_422708fe2a.
  ///
  /// In zh, this message translates to:
  /// **'谐振式呼吸 · 10 分钟 · 声音关'**
  String get ui_auto_full_422708fe2a;

  /// No description provided for @ui_auto_full_42a6b6726a.
  ///
  /// In zh, this message translates to:
  /// **'可选自由模式或固定公里数。'**
  String get ui_auto_full_42a6b6726a;

  /// No description provided for @ui_auto_full_4331f63c61.
  ///
  /// In zh, this message translates to:
  /// **'卡路里/千卡'**
  String get ui_auto_full_4331f63c61;

  /// No description provided for @ui_auto_full_434cb42d36.
  ///
  /// In zh, this message translates to:
  /// **'查看达人分享，发布你的打卡'**
  String get ui_auto_full_434cb42d36;

  /// No description provided for @ui_auto_full_4351cfebe4.
  ///
  /// In zh, this message translates to:
  /// **'查看'**
  String get ui_auto_full_4351cfebe4;

  /// No description provided for @ui_auto_full_43814c5454.
  ///
  /// In zh, this message translates to:
  /// **'正在进行深度识别分析...'**
  String get ui_auto_full_43814c5454;

  /// No description provided for @ui_auto_full_44762f8e10.
  ///
  /// In zh, this message translates to:
  /// **'174cm'**
  String get ui_auto_full_44762f8e10;

  /// No description provided for @ui_auto_full_44db993893.
  ///
  /// In zh, this message translates to:
  /// **'11月13日-11月19日'**
  String get ui_auto_full_44db993893;

  /// No description provided for @ui_auto_full_465260fe80.
  ///
  /// In zh, this message translates to:
  /// **'年'**
  String get ui_auto_full_465260fe80;

  /// No description provided for @ui_auto_full_466c416ff2.
  ///
  /// In zh, this message translates to:
  /// **'金币记录'**
  String get ui_auto_full_466c416ff2;

  /// No description provided for @ui_auto_full_4701d894b5.
  ///
  /// In zh, this message translates to:
  /// **'连续7天达到10,000步'**
  String get ui_auto_full_4701d894b5;

  /// No description provided for @ui_auto_full_4771af6d30.
  ///
  /// In zh, this message translates to:
  /// **'（新用户权益，仅一次）'**
  String get ui_auto_full_4771af6d30;

  /// No description provided for @ui_auto_full_47898c0658.
  ///
  /// In zh, this message translates to:
  /// **'完善个人信息'**
  String get ui_auto_full_47898c0658;

  /// No description provided for @ui_auto_full_4880c7d640.
  ///
  /// In zh, this message translates to:
  /// **'--/--'**
  String get ui_auto_full_4880c7d640;

  /// No description provided for @ui_auto_full_49f4f9e7be.
  ///
  /// In zh, this message translates to:
  /// **'坚持住，你可以的！'**
  String get ui_auto_full_49f4f9e7be;

  /// No description provided for @ui_auto_full_4a310d4298.
  ///
  /// In zh, this message translates to:
  /// **'2000 ml'**
  String get ui_auto_full_4a310d4298;

  /// No description provided for @ui_auto_full_4a7d1ed414.
  ///
  /// In zh, this message translates to:
  /// **'0000'**
  String get ui_auto_full_4a7d1ed414;

  /// No description provided for @ui_auto_full_4b1b4dc8cf.
  ///
  /// In zh, this message translates to:
  /// **'报告'**
  String get ui_auto_full_4b1b4dc8cf;

  /// No description provided for @ui_auto_full_4b518775c5.
  ///
  /// In zh, this message translates to:
  /// **'总时长'**
  String get ui_auto_full_4b518775c5;

  /// No description provided for @ui_auto_full_4b7c0b7de9.
  ///
  /// In zh, this message translates to:
  /// **'微小目标micro-target'**
  String get ui_auto_full_4b7c0b7de9;

  /// No description provided for @ui_auto_full_4b9c3271dc.
  ///
  /// In zh, this message translates to:
  /// **'重置'**
  String get ui_auto_full_4b9c3271dc;

  /// No description provided for @ui_auto_full_4b9ed1c6b3.
  ///
  /// In zh, this message translates to:
  /// **'22:30'**
  String get ui_auto_full_4b9ed1c6b3;

  /// No description provided for @ui_auto_full_4c2a8fe7ea.
  ///
  /// In zh, this message translates to:
  /// **'消息'**
  String get ui_auto_full_4c2a8fe7ea;

  /// No description provided for @ui_auto_full_4c4b4adfa7.
  ///
  /// In zh, this message translates to:
  /// **'1 分钟 7.5 次'**
  String get ui_auto_full_4c4b4adfa7;

  /// No description provided for @ui_auto_full_4de076364d.
  ///
  /// In zh, this message translates to:
  /// **'2024-01'**
  String get ui_auto_full_4de076364d;

  /// No description provided for @ui_auto_full_4f56d5bbad.
  ///
  /// In zh, this message translates to:
  /// **'休息秒数'**
  String get ui_auto_full_4f56d5bbad;

  /// No description provided for @ui_auto_full_4f7b91b1bf.
  ///
  /// In zh, this message translates to:
  /// **'共05分00秒'**
  String get ui_auto_full_4f7b91b1bf;

  /// No description provided for @ui_auto_full_4fd1ac252b.
  ///
  /// In zh, this message translates to:
  /// **'快来加入微步运动\\n与朋友一起健康打卡！'**
  String get ui_auto_full_4fd1ac252b;

  /// No description provided for @ui_auto_full_5039f8d760.
  ///
  /// In zh, this message translates to:
  /// **'正在练习'**
  String get ui_auto_full_5039f8d760;

  /// No description provided for @ui_auto_full_50671b9e76.
  ///
  /// In zh, this message translates to:
  /// **'室外跑'**
  String get ui_auto_full_50671b9e76;

  /// No description provided for @ui_auto_full_50a17fb398.
  ///
  /// In zh, this message translates to:
  /// **'开始呼吸'**
  String get ui_auto_full_50a17fb398;

  /// No description provided for @ui_auto_full_50fb8e0b7a.
  ///
  /// In zh, this message translates to:
  /// **'02月24日 12:23'**
  String get ui_auto_full_50fb8e0b7a;

  /// No description provided for @ui_auto_full_5141ba3b0e.
  ///
  /// In zh, this message translates to:
  /// **'116千卡/100g'**
  String get ui_auto_full_5141ba3b0e;

  /// No description provided for @ui_auto_full_516476e6a4.
  ///
  /// In zh, this message translates to:
  /// **'趋势分析'**
  String get ui_auto_full_516476e6a4;

  /// No description provided for @ui_auto_full_516e5ebd93.
  ///
  /// In zh, this message translates to:
  /// **'适合组间训练、冲刺和自由计时'**
  String get ui_auto_full_516e5ebd93;

  /// No description provided for @ui_auto_full_51753bb96b.
  ///
  /// In zh, this message translates to:
  /// **'开始后系统会自动按时长估算热量。暂停后可恢复，结束时会保存本次记录。'**
  String get ui_auto_full_51753bb96b;

  /// No description provided for @ui_auto_full_5188aa9e68.
  ///
  /// In zh, this message translates to:
  /// **'08:00'**
  String get ui_auto_full_5188aa9e68;

  /// No description provided for @ui_auto_full_51adb83f08.
  ///
  /// In zh, this message translates to:
  /// **'时间：00:00'**
  String get ui_auto_full_51adb83f08;

  /// No description provided for @ui_auto_full_52b94d7857.
  ///
  /// In zh, this message translates to:
  /// **'暂无体重记录'**
  String get ui_auto_full_52b94d7857;

  /// No description provided for @ui_auto_full_536719f5a0.
  ///
  /// In zh, this message translates to:
  /// **'设置每日饮水目标'**
  String get ui_auto_full_536719f5a0;

  /// No description provided for @ui_auto_full_53a11da256.
  ///
  /// In zh, this message translates to:
  /// **'喝水常识'**
  String get ui_auto_full_53a11da256;

  /// No description provided for @ui_auto_full_54b116f762.
  ///
  /// In zh, this message translates to:
  /// **'普通的view'**
  String get ui_auto_full_54b116f762;

  /// No description provided for @ui_auto_full_556cbd514e.
  ///
  /// In zh, this message translates to:
  /// **'趋势统计&gt;'**
  String get ui_auto_full_556cbd514e;

  /// No description provided for @ui_auto_full_55c7e16463.
  ///
  /// In zh, this message translates to:
  /// **'进度: 0 / 7 天'**
  String get ui_auto_full_55c7e16463;

  /// No description provided for @ui_auto_full_56164c5abe.
  ///
  /// In zh, this message translates to:
  /// **'吸气'**
  String get ui_auto_full_56164c5abe;

  /// No description provided for @ui_auto_full_5629f2d9d8.
  ///
  /// In zh, this message translates to:
  /// **'次数'**
  String get ui_auto_full_5629f2d9d8;

  /// No description provided for @ui_auto_full_5672a8eab2.
  ///
  /// In zh, this message translates to:
  /// **'公式：体重(kg) × 30~35ml'**
  String get ui_auto_full_5672a8eab2;

  /// No description provided for @ui_auto_full_569de58215.
  ///
  /// In zh, this message translates to:
  /// **'平均心情'**
  String get ui_auto_full_569de58215;

  /// No description provided for @ui_auto_full_56c4d686c5.
  ///
  /// In zh, this message translates to:
  /// **'－'**
  String get ui_auto_full_56c4d686c5;

  /// No description provided for @ui_auto_full_5830f10812.
  ///
  /// In zh, this message translates to:
  /// **'常吃食物'**
  String get ui_auto_full_5830f10812;

  /// No description provided for @ui_auto_full_58b9535df1.
  ///
  /// In zh, this message translates to:
  /// **'在运动的道路上，每一次迈步都是对自我的超越。累计完成10次运动即可获得此殊荣。'**
  String get ui_auto_full_58b9535df1;

  /// No description provided for @ui_auto_full_592a953516.
  ///
  /// In zh, this message translates to:
  /// **'适合 HIIT、组间休息和拉伸定时'**
  String get ui_auto_full_592a953516;

  /// No description provided for @ui_auto_full_59662644f5.
  ///
  /// In zh, this message translates to:
  /// **'持续运动时长'**
  String get ui_auto_full_59662644f5;

  /// No description provided for @ui_auto_full_5adf7e2af7.
  ///
  /// In zh, this message translates to:
  /// **'+晚餐'**
  String get ui_auto_full_5adf7e2af7;

  /// No description provided for @ui_auto_full_5b46020008.
  ///
  /// In zh, this message translates to:
  /// **'为您计算个性化的每日喝水目标'**
  String get ui_auto_full_5b46020008;

  /// No description provided for @ui_auto_full_5c106fb487.
  ///
  /// In zh, this message translates to:
  /// **'训练总时长'**
  String get ui_auto_full_5c106fb487;

  /// No description provided for @ui_auto_full_5d47dd2734.
  ///
  /// In zh, this message translates to:
  /// **'关联分析'**
  String get ui_auto_full_5d47dd2734;

  /// No description provided for @ui_auto_full_5db9d7da65.
  ///
  /// In zh, this message translates to:
  /// **'运动挑战赛'**
  String get ui_auto_full_5db9d7da65;

  /// No description provided for @ui_auto_full_5dfe2ea21b.
  ///
  /// In zh, this message translates to:
  /// **'150毫升'**
  String get ui_auto_full_5dfe2ea21b;

  /// No description provided for @ui_auto_full_5e56f330c5.
  ///
  /// In zh, this message translates to:
  /// **'(每100g 116千卡)'**
  String get ui_auto_full_5e56f330c5;

  /// No description provided for @ui_auto_full_5edcdff8de.
  ///
  /// In zh, this message translates to:
  /// **'1元'**
  String get ui_auto_full_5edcdff8de;

  /// No description provided for @ui_auto_full_601c427074.
  ///
  /// In zh, this message translates to:
  /// **'加餐'**
  String get ui_auto_full_601c427074;

  /// No description provided for @ui_auto_full_60584e35a4.
  ///
  /// In zh, this message translates to:
  /// **'运动排行'**
  String get ui_auto_full_60584e35a4;

  /// No description provided for @ui_auto_full_609b5f0a08.
  ///
  /// In zh, this message translates to:
  /// **'时'**
  String get ui_auto_full_609b5f0a08;

  /// No description provided for @ui_auto_full_611abd5bc1.
  ///
  /// In zh, this message translates to:
  /// **'🌅'**
  String get ui_auto_full_611abd5bc1;

  /// No description provided for @ui_auto_full_6359681fa9.
  ///
  /// In zh, this message translates to:
  /// **'历史获得000000金币'**
  String get ui_auto_full_6359681fa9;

  /// No description provided for @ui_auto_full_6415554be9.
  ///
  /// In zh, this message translates to:
  /// **'统计概览'**
  String get ui_auto_full_6415554be9;

  /// No description provided for @ui_auto_full_64eabf261d.
  ///
  /// In zh, this message translates to:
  /// **'添加训练组'**
  String get ui_auto_full_64eabf261d;

  /// No description provided for @ui_auto_full_6717251bc4.
  ///
  /// In zh, this message translates to:
  /// **'运动名称'**
  String get ui_auto_full_6717251bc4;

  /// No description provided for @ui_auto_full_675d78630c.
  ///
  /// In zh, this message translates to:
  /// **'0/15'**
  String get ui_auto_full_675d78630c;

  /// No description provided for @ui_auto_full_67bd93756b.
  ///
  /// In zh, this message translates to:
  /// **'正在处理...'**
  String get ui_auto_full_67bd93756b;

  /// No description provided for @ui_auto_full_67ff32d40f.
  ///
  /// In zh, this message translates to:
  /// **'8000'**
  String get ui_auto_full_67ff32d40f;

  /// No description provided for @ui_auto_full_685223c793.
  ///
  /// In zh, this message translates to:
  /// **'查看更多记录'**
  String get ui_auto_full_685223c793;

  /// No description provided for @ui_auto_full_68b53ac7cb.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！'**
  String get ui_auto_full_68b53ac7cb;

  /// No description provided for @ui_auto_full_69ae28690a.
  ///
  /// In zh, this message translates to:
  /// **'距离模式'**
  String get ui_auto_full_69ae28690a;

  /// No description provided for @ui_auto_full_69e4902b42.
  ///
  /// In zh, this message translates to:
  /// **'今天没有任何记录'**
  String get ui_auto_full_69e4902b42;

  /// No description provided for @ui_auto_full_6a0e726394.
  ///
  /// In zh, this message translates to:
  /// **'请将食物置于框内拍摄'**
  String get ui_auto_full_6a0e726394;

  /// No description provided for @ui_auto_full_6c96adb925.
  ///
  /// In zh, this message translates to:
  /// **'写详细记录'**
  String get ui_auto_full_6c96adb925;

  /// No description provided for @ui_auto_full_6cbf8d73ac.
  ///
  /// In zh, this message translates to:
  /// **'上次记录'**
  String get ui_auto_full_6cbf8d73ac;

  /// No description provided for @ui_auto_full_6cfd303529.
  ///
  /// In zh, this message translates to:
  /// **'每完成一组就记录次数和负重，统计会自动更新。'**
  String get ui_auto_full_6cfd303529;

  /// No description provided for @ui_auto_full_6d47e10b72.
  ///
  /// In zh, this message translates to:
  /// **'+加餐'**
  String get ui_auto_full_6d47e10b72;

  /// No description provided for @ui_auto_full_6db15cc014.
  ///
  /// In zh, this message translates to:
  /// **'智能推荐'**
  String get ui_auto_full_6db15cc014;

  /// No description provided for @ui_auto_full_6deabf9b13.
  ///
  /// In zh, this message translates to:
  /// **'平均入睡'**
  String get ui_auto_full_6deabf9b13;

  /// No description provided for @ui_auto_full_6ed3411932.
  ///
  /// In zh, this message translates to:
  /// **'走路距离'**
  String get ui_auto_full_6ed3411932;

  /// No description provided for @ui_auto_full_6f8d4e6ad1.
  ///
  /// In zh, this message translates to:
  /// **'1 次呼吸 8 秒，吸气 4 秒，吐气 4 秒'**
  String get ui_auto_full_6f8d4e6ad1;

  /// No description provided for @ui_auto_full_6f9173cf0b.
  ///
  /// In zh, this message translates to:
  /// **'累计运动'**
  String get ui_auto_full_6f9173cf0b;

  /// No description provided for @ui_auto_full_70ac95c0f5.
  ///
  /// In zh, this message translates to:
  /// **'2023.10.01 - 10.07'**
  String get ui_auto_full_70ac95c0f5;

  /// No description provided for @ui_auto_full_7124f37663.
  ///
  /// In zh, this message translates to:
  /// **'2000毫升'**
  String get ui_auto_full_7124f37663;

  /// No description provided for @ui_auto_full_7141503c9a.
  ///
  /// In zh, this message translates to:
  /// **'📊 心情分布'**
  String get ui_auto_full_7141503c9a;

  /// No description provided for @ui_auto_full_7229ecc631.
  ///
  /// In zh, this message translates to:
  /// **'次'**
  String get ui_auto_full_7229ecc631;

  /// No description provided for @ui_auto_full_751a79afde.
  ///
  /// In zh, this message translates to:
  /// **'30分钟'**
  String get ui_auto_full_751a79afde;

  /// No description provided for @ui_auto_full_75907b0a7d.
  ///
  /// In zh, this message translates to:
  /// **'历史最低'**
  String get ui_auto_full_75907b0a7d;

  /// No description provided for @ui_auto_full_75945ff792.
  ///
  /// In zh, this message translates to:
  /// **'今日已摄入 (千卡)'**
  String get ui_auto_full_75945ff792;

  /// No description provided for @ui_auto_full_762871af71.
  ///
  /// In zh, this message translates to:
  /// **'05:00'**
  String get ui_auto_full_762871af71;

  /// No description provided for @ui_auto_full_76cc0b5f96.
  ///
  /// In zh, this message translates to:
  /// **'配速'**
  String get ui_auto_full_76cc0b5f96;

  /// No description provided for @ui_auto_full_780b32ce6d.
  ///
  /// In zh, this message translates to:
  /// **'如何获得：累计完成10次运动'**
  String get ui_auto_full_780b32ce6d;

  /// No description provided for @ui_auto_full_7867c816a4.
  ///
  /// In zh, this message translates to:
  /// **'2026-04-08'**
  String get ui_auto_full_7867c816a4;

  /// No description provided for @ui_auto_full_7a0c7660e8.
  ///
  /// In zh, this message translates to:
  /// **'已完成训练组数'**
  String get ui_auto_full_7a0c7660e8;

  /// No description provided for @ui_auto_full_7a7fd63831.
  ///
  /// In zh, this message translates to:
  /// **'劳力士服务中心，清洗保养，更换配件，9秒费用查询'**
  String get ui_auto_full_7a7fd63831;

  /// No description provided for @ui_auto_full_7a9f8d95e9.
  ///
  /// In zh, this message translates to:
  /// **'暂无运动记录'**
  String get ui_auto_full_7a9f8d95e9;

  /// No description provided for @ui_auto_full_7b544696c4.
  ///
  /// In zh, this message translates to:
  /// **'+999'**
  String get ui_auto_full_7b544696c4;

  /// No description provided for @ui_auto_full_7bf7e846e3.
  ///
  /// In zh, this message translates to:
  /// **'00:00'**
  String get ui_auto_full_7bf7e846e3;

  /// No description provided for @ui_auto_full_7cf597282a.
  ///
  /// In zh, this message translates to:
  /// **'300千卡'**
  String get ui_auto_full_7cf597282a;

  /// No description provided for @ui_auto_full_7d0e9960f9.
  ///
  /// In zh, this message translates to:
  /// **'勋章收集进度'**
  String get ui_auto_full_7d0e9960f9;

  /// No description provided for @ui_auto_full_7db888defd.
  ///
  /// In zh, this message translates to:
  /// **'1天'**
  String get ui_auto_full_7db888defd;

  /// No description provided for @ui_auto_full_7e21757fc9.
  ///
  /// In zh, this message translates to:
  /// **'我的运动成就'**
  String get ui_auto_full_7e21757fc9;

  /// No description provided for @ui_auto_full_7e43977d37.
  ///
  /// In zh, this message translates to:
  /// **'分段记录'**
  String get ui_auto_full_7e43977d37;

  /// No description provided for @ui_auto_full_7e5e1b55f7.
  ///
  /// In zh, this message translates to:
  /// **'排行榜等活动请在对应页面查看'**
  String get ui_auto_full_7e5e1b55f7;

  /// No description provided for @ui_auto_full_7e70bf9755.
  ///
  /// In zh, this message translates to:
  /// **'+100米'**
  String get ui_auto_full_7e70bf9755;

  /// No description provided for @ui_auto_full_7ef605fc8d.
  ///
  /// In zh, this message translates to:
  /// **'150'**
  String get ui_auto_full_7ef605fc8d;

  /// No description provided for @ui_auto_full_8022b7772c.
  ///
  /// In zh, this message translates to:
  /// **'连续运动'**
  String get ui_auto_full_8022b7772c;

  /// No description provided for @ui_auto_full_819767ada1.
  ///
  /// In zh, this message translates to:
  /// **'用户名'**
  String get ui_auto_full_819767ada1;

  /// No description provided for @ui_auto_full_81b8db0e94.
  ///
  /// In zh, this message translates to:
  /// **'开始 / 暂停'**
  String get ui_auto_full_81b8db0e94;

  /// No description provided for @ui_auto_full_8227e17a67.
  ///
  /// In zh, this message translates to:
  /// **'米'**
  String get ui_auto_full_8227e17a67;

  /// No description provided for @ui_auto_full_8245f63bdb.
  ///
  /// In zh, this message translates to:
  /// **'💧 喝水'**
  String get ui_auto_full_8245f63bdb;

  /// No description provided for @ui_auto_full_828ff9eeb5.
  ///
  /// In zh, this message translates to:
  /// **'里程：0km'**
  String get ui_auto_full_828ff9eeb5;

  /// No description provided for @ui_auto_full_82918f84bb.
  ///
  /// In zh, this message translates to:
  /// **'+早餐'**
  String get ui_auto_full_82918f84bb;

  /// No description provided for @ui_auto_full_83494985ed.
  ///
  /// In zh, this message translates to:
  /// **'2026-03-05'**
  String get ui_auto_full_83494985ed;

  /// No description provided for @ui_auto_full_83a7472b49.
  ///
  /// In zh, this message translates to:
  /// **'心情记录'**
  String get ui_auto_full_83a7472b49;

  /// No description provided for @ui_auto_full_843574dcfb.
  ///
  /// In zh, this message translates to:
  /// **'登山'**
  String get ui_auto_full_843574dcfb;

  /// No description provided for @ui_auto_full_84448e65ad.
  ///
  /// In zh, this message translates to:
  /// **'饮食日记'**
  String get ui_auto_full_84448e65ad;

  /// No description provided for @ui_auto_full_8461474614.
  ///
  /// In zh, this message translates to:
  /// **'搜索运动类型...'**
  String get ui_auto_full_8461474614;

  /// No description provided for @ui_auto_full_853ae90f03.
  ///
  /// In zh, this message translates to:
  /// **':'**
  String get ui_auto_full_853ae90f03;

  /// No description provided for @ui_auto_full_86c7dee2fb.
  ///
  /// In zh, this message translates to:
  /// **'推荐每日喝水目标'**
  String get ui_auto_full_86c7dee2fb;

  /// No description provided for @ui_auto_full_872300b2a7.
  ///
  /// In zh, this message translates to:
  /// **'餐类分析'**
  String get ui_auto_full_872300b2a7;

  /// No description provided for @ui_auto_full_87e4d9efe3.
  ///
  /// In zh, this message translates to:
  /// **'稍后再说'**
  String get ui_auto_full_87e4d9efe3;

  /// No description provided for @ui_auto_full_896303044a.
  ///
  /// In zh, this message translates to:
  /// **'步数'**
  String get ui_auto_full_896303044a;

  /// No description provided for @ui_auto_full_8a53255def.
  ///
  /// In zh, this message translates to:
  /// **'📜 历史记录'**
  String get ui_auto_full_8a53255def;

  /// No description provided for @ui_auto_full_8c489d0946.
  ///
  /// In zh, this message translates to:
  /// **'体重'**
  String get ui_auto_full_8c489d0946;

  /// No description provided for @ui_auto_full_8ca8f0eec9.
  ///
  /// In zh, this message translates to:
  /// **'日均步数'**
  String get ui_auto_full_8ca8f0eec9;

  /// No description provided for @ui_auto_full_8cb7b3cf89.
  ///
  /// In zh, this message translates to:
  /// **'时间训练'**
  String get ui_auto_full_8cb7b3cf89;

  /// No description provided for @ui_auto_full_8d80b1c191.
  ///
  /// In zh, this message translates to:
  /// **'🎯'**
  String get ui_auto_full_8d80b1c191;

  /// No description provided for @ui_auto_full_8da5a4dc82.
  ///
  /// In zh, this message translates to:
  /// **'详细报告'**
  String get ui_auto_full_8da5a4dc82;

  /// No description provided for @ui_auto_full_8e296a067a.
  ///
  /// In zh, this message translates to:
  /// **'25'**
  String get ui_auto_full_8e296a067a;

  /// No description provided for @ui_auto_full_8e50bef39e.
  ///
  /// In zh, this message translates to:
  /// **'5元'**
  String get ui_auto_full_8e50bef39e;

  /// No description provided for @ui_auto_full_8fe4d8dcbf.
  ///
  /// In zh, this message translates to:
  /// **'结束并保存'**
  String get ui_auto_full_8fe4d8dcbf;

  /// No description provided for @ui_auto_full_90b5ef82f4.
  ///
  /// In zh, this message translates to:
  /// **'45.5/公斤'**
  String get ui_auto_full_90b5ef82f4;

  /// No description provided for @ui_auto_full_92636e8c8f.
  ///
  /// In zh, this message translates to:
  /// **'跳过'**
  String get ui_auto_full_92636e8c8f;

  /// No description provided for @ui_auto_full_930c87f11a.
  ///
  /// In zh, this message translates to:
  /// **'我的勋章'**
  String get ui_auto_full_930c87f11a;

  /// No description provided for @ui_auto_full_930f3b0722.
  ///
  /// In zh, this message translates to:
  /// **'2000ml'**
  String get ui_auto_full_930f3b0722;

  /// No description provided for @ui_auto_full_94b99c784e.
  ///
  /// In zh, this message translates to:
  /// **'25分钟/天'**
  String get ui_auto_full_94b99c784e;

  /// No description provided for @ui_auto_full_9564eb1724.
  ///
  /// In zh, this message translates to:
  /// **'微步运动 - 个人周报'**
  String get ui_auto_full_9564eb1724;

  /// No description provided for @ui_auto_full_958b9c3aff.
  ///
  /// In zh, this message translates to:
  /// **'选择运动类型'**
  String get ui_auto_full_958b9c3aff;

  /// No description provided for @ui_auto_full_96a6ae1411.
  ///
  /// In zh, this message translates to:
  /// **'晚餐'**
  String get ui_auto_full_96a6ae1411;

  /// No description provided for @ui_auto_full_975b94b333.
  ///
  /// In zh, this message translates to:
  /// **'日历模式'**
  String get ui_auto_full_975b94b333;

  /// No description provided for @ui_auto_full_975bebf84b.
  ///
  /// In zh, this message translates to:
  /// **'健走'**
  String get ui_auto_full_975bebf84b;

  /// No description provided for @ui_auto_full_97e56f883f.
  ///
  /// In zh, this message translates to:
  /// **'用户001'**
  String get ui_auto_full_97e56f883f;

  /// No description provided for @ui_auto_full_9819dcfb2e.
  ///
  /// In zh, this message translates to:
  /// **'计策略，才真三国！'**
  String get ui_auto_full_9819dcfb2e;

  /// No description provided for @ui_auto_full_98f1370821.
  ///
  /// In zh, this message translates to:
  /// **'20'**
  String get ui_auto_full_98f1370821;

  /// No description provided for @ui_auto_full_99530cd613.
  ///
  /// In zh, this message translates to:
  /// **'记录距离'**
  String get ui_auto_full_99530cd613;

  /// No description provided for @ui_auto_full_99946dae32.
  ///
  /// In zh, this message translates to:
  /// **'399千卡'**
  String get ui_auto_full_99946dae32;

  /// No description provided for @ui_auto_full_99c5f4bf7d.
  ///
  /// In zh, this message translates to:
  /// **'现有余额'**
  String get ui_auto_full_99c5f4bf7d;

  /// No description provided for @ui_auto_full_99d0cb8cd7.
  ///
  /// In zh, this message translates to:
  /// **'最多摄入'**
  String get ui_auto_full_99d0cb8cd7;

  /// No description provided for @ui_auto_full_9ae362bda2.
  ///
  /// In zh, this message translates to:
  /// **'挑战赛'**
  String get ui_auto_full_9ae362bda2;

  /// No description provided for @ui_auto_full_9b6ad6b8d1.
  ///
  /// In zh, this message translates to:
  /// **'不知道为什么，心情很差'**
  String get ui_auto_full_9b6ad6b8d1;

  /// No description provided for @ui_auto_full_9bd10d1e34.
  ///
  /// In zh, this message translates to:
  /// **'总次数'**
  String get ui_auto_full_9bd10d1e34;

  /// No description provided for @ui_auto_full_9bf4d3b0d2.
  ///
  /// In zh, this message translates to:
  /// **'确认并设置目标'**
  String get ui_auto_full_9bf4d3b0d2;

  /// No description provided for @ui_auto_full_9d4b3439f7.
  ///
  /// In zh, this message translates to:
  /// **'已适配的健康 App (请确保已开启其通知权限)'**
  String get ui_auto_full_9d4b3439f7;

  /// No description provided for @ui_auto_full_9d93c0f0f4.
  ///
  /// In zh, this message translates to:
  /// **'0小时'**
  String get ui_auto_full_9d93c0f0f4;

  /// No description provided for @ui_auto_full_9f1ef07877.
  ///
  /// In zh, this message translates to:
  /// **'0%'**
  String get ui_auto_full_9f1ef07877;

  /// No description provided for @ui_auto_full_a017e24739.
  ///
  /// In zh, this message translates to:
  /// **'📦'**
  String get ui_auto_full_a017e24739;

  /// No description provided for @ui_auto_full_a09c311859.
  ///
  /// In zh, this message translates to:
  /// **'👩'**
  String get ui_auto_full_a09c311859;

  /// No description provided for @ui_auto_full_a0d675a18d.
  ///
  /// In zh, this message translates to:
  /// **'10 千卡/分钟'**
  String get ui_auto_full_a0d675a18d;

  /// No description provided for @ui_auto_full_a111462d34.
  ///
  /// In zh, this message translates to:
  /// **'毫升'**
  String get ui_auto_full_a111462d34;

  /// No description provided for @ui_auto_full_a142cf6091.
  ///
  /// In zh, this message translates to:
  /// **'当前未播放'**
  String get ui_auto_full_a142cf6091;

  /// No description provided for @ui_auto_full_a17b2353e6.
  ///
  /// In zh, this message translates to:
  /// **'历史最高'**
  String get ui_auto_full_a17b2353e6;

  /// No description provided for @ui_auto_full_a1fa277792.
  ///
  /// In zh, this message translates to:
  /// **'类型'**
  String get ui_auto_full_a1fa277792;

  /// No description provided for @ui_auto_full_a329425bc3.
  ///
  /// In zh, this message translates to:
  /// **'添加饮食记录'**
  String get ui_auto_full_a329425bc3;

  /// No description provided for @ui_auto_full_a330de9254.
  ///
  /// In zh, this message translates to:
  /// **'本次运动提示'**
  String get ui_auto_full_a330de9254;

  /// No description provided for @ui_auto_full_a3b1555fb4.
  ///
  /// In zh, this message translates to:
  /// **'🏆'**
  String get ui_auto_full_a3b1555fb4;

  /// No description provided for @ui_auto_full_a3ed39e1f4.
  ///
  /// In zh, this message translates to:
  /// **'0次'**
  String get ui_auto_full_a3ed39e1f4;

  /// No description provided for @ui_auto_full_a5a2defa4c.
  ///
  /// In zh, this message translates to:
  /// **'平均起床'**
  String get ui_auto_full_a5a2defa4c;

  /// No description provided for @ui_auto_full_a65ac88694.
  ///
  /// In zh, this message translates to:
  /// **'有目标才有前行的动力'**
  String get ui_auto_full_a65ac88694;

  /// No description provided for @ui_auto_full_a680280bbf.
  ///
  /// In zh, this message translates to:
  /// **'12次/天'**
  String get ui_auto_full_a680280bbf;

  /// No description provided for @ui_auto_full_a719a5355c.
  ///
  /// In zh, this message translates to:
  /// **'谐振式呼吸'**
  String get ui_auto_full_a719a5355c;

  /// No description provided for @ui_auto_full_a79aa8b2c6.
  ///
  /// In zh, this message translates to:
  /// **'+午餐'**
  String get ui_auto_full_a79aa8b2c6;

  /// No description provided for @ui_auto_full_a81ff74cf2.
  ///
  /// In zh, this message translates to:
  /// **'秒表计时'**
  String get ui_auto_full_a81ff74cf2;

  /// No description provided for @ui_auto_full_a957a56cbf.
  ///
  /// In zh, this message translates to:
  /// **'8,000步'**
  String get ui_auto_full_a957a56cbf;

  /// No description provided for @ui_auto_full_aa00c4c0f4.
  ///
  /// In zh, this message translates to:
  /// **'0/0'**
  String get ui_auto_full_aa00c4c0f4;

  /// No description provided for @ui_auto_full_aa94c6c829.
  ///
  /// In zh, this message translates to:
  /// **'步数模式'**
  String get ui_auto_full_aa94c6c829;

  /// No description provided for @ui_auto_full_ab1d3e8c0c.
  ///
  /// In zh, this message translates to:
  /// **'建议每日行走3000~6000步'**
  String get ui_auto_full_ab1d3e8c0c;

  /// No description provided for @ui_auto_full_ab20cc42f3.
  ///
  /// In zh, this message translates to:
  /// **'和'**
  String get ui_auto_full_ab20cc42f3;

  /// No description provided for @ui_auto_full_ab40c65017.
  ///
  /// In zh, this message translates to:
  /// **'米饭 300克'**
  String get ui_auto_full_ab40c65017;

  /// No description provided for @ui_auto_full_aba77ea6be.
  ///
  /// In zh, this message translates to:
  /// **'👨'**
  String get ui_auto_full_aba77ea6be;

  /// No description provided for @ui_auto_full_aba7927f37.
  ///
  /// In zh, this message translates to:
  /// **'◠◡◠'**
  String get ui_auto_full_aba7927f37;

  /// No description provided for @ui_auto_full_abac49610b.
  ///
  /// In zh, this message translates to:
  /// **'显示在健康页'**
  String get ui_auto_full_abac49610b;

  /// No description provided for @ui_auto_full_abe0326e06.
  ///
  /// In zh, this message translates to:
  /// **'报名挑战'**
  String get ui_auto_full_abe0326e06;

  /// No description provided for @ui_auto_full_ac29e4af16.
  ///
  /// In zh, this message translates to:
  /// **'5:00'**
  String get ui_auto_full_ac29e4af16;

  /// No description provided for @ui_auto_full_acaf45716b.
  ///
  /// In zh, this message translates to:
  /// **'设定目标'**
  String get ui_auto_full_acaf45716b;

  /// No description provided for @ui_auto_full_acd84bcb5a.
  ///
  /// In zh, this message translates to:
  /// **'修改热量预算'**
  String get ui_auto_full_acd84bcb5a;

  /// No description provided for @ui_auto_full_ad24a0659b.
  ///
  /// In zh, this message translates to:
  /// **'🌧️'**
  String get ui_auto_full_ad24a0659b;

  /// No description provided for @ui_auto_full_ad6bd0aa90.
  ///
  /// In zh, this message translates to:
  /// **'健康成就之旅'**
  String get ui_auto_full_ad6bd0aa90;

  /// No description provided for @ui_auto_full_af6c0066f0.
  ///
  /// In zh, this message translates to:
  /// **'当前日期暂无记录'**
  String get ui_auto_full_af6c0066f0;

  /// No description provided for @ui_auto_full_b01465d386.
  ///
  /// In zh, this message translates to:
  /// **'根据您的体重，推荐每日喝水 1800-2100 ml'**
  String get ui_auto_full_b01465d386;

  /// No description provided for @ui_auto_full_b14b8efad6.
  ///
  /// In zh, this message translates to:
  /// **'距离/公里'**
  String get ui_auto_full_b14b8efad6;

  /// No description provided for @ui_auto_full_b1575b8f21.
  ///
  /// In zh, this message translates to:
  /// **'Set 1'**
  String get ui_auto_full_b1575b8f21;

  /// No description provided for @ui_auto_full_b15d91274e.
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get ui_auto_full_b15d91274e;

  /// No description provided for @ui_auto_full_b1d400b800.
  ///
  /// In zh, this message translates to:
  /// **'输入活动名称'**
  String get ui_auto_full_b1d400b800;

  /// No description provided for @ui_auto_full_b205e4e707.
  ///
  /// In zh, this message translates to:
  /// **'户外跑步'**
  String get ui_auto_full_b205e4e707;

  /// No description provided for @ui_auto_full_b2652ac926.
  ///
  /// In zh, this message translates to:
  /// **'今日已摄入'**
  String get ui_auto_full_b2652ac926;

  /// No description provided for @ui_auto_full_b2e34c9407.
  ///
  /// In zh, this message translates to:
  /// **'0 步'**
  String get ui_auto_full_b2e34c9407;

  /// No description provided for @ui_auto_full_b31b286d1c.
  ///
  /// In zh, this message translates to:
  /// **'开启后，应用将能自动同步来自华为健康、小米、微信运动等 App 在通知栏显示的最新步数。'**
  String get ui_auto_full_b31b286d1c;

  /// No description provided for @ui_auto_full_b31e80a43d.
  ///
  /// In zh, this message translates to:
  /// **'160 CM'**
  String get ui_auto_full_b31e80a43d;

  /// No description provided for @ui_auto_full_b3bb3c7225.
  ///
  /// In zh, this message translates to:
  /// **'+2500'**
  String get ui_auto_full_b3bb3c7225;

  /// No description provided for @ui_auto_full_b3c19432d2.
  ///
  /// In zh, this message translates to:
  /// **'记录喝水'**
  String get ui_auto_full_b3c19432d2;

  /// No description provided for @ui_auto_full_b4a7887b5f.
  ///
  /// In zh, this message translates to:
  /// **'《用户协议》'**
  String get ui_auto_full_b4a7887b5f;

  /// No description provided for @ui_auto_full_b4c9eb14cf.
  ///
  /// In zh, this message translates to:
  /// **'喝水趋势'**
  String get ui_auto_full_b4c9eb14cf;

  /// No description provided for @ui_auto_full_b5a7adde1a.
  ///
  /// In zh, this message translates to:
  /// **'描述'**
  String get ui_auto_full_b5a7adde1a;

  /// No description provided for @ui_auto_full_b5b4018257.
  ///
  /// In zh, this message translates to:
  /// **'每日饮食'**
  String get ui_auto_full_b5b4018257;

  /// No description provided for @ui_auto_full_b637b2e5b1.
  ///
  /// In zh, this message translates to:
  /// **'1500ml'**
  String get ui_auto_full_b637b2e5b1;

  /// No description provided for @ui_auto_full_b68c994969.
  ///
  /// In zh, this message translates to:
  /// **'识别包名: com.xiaomi.hm.health'**
  String get ui_auto_full_b68c994969;

  /// No description provided for @ui_auto_full_b6a80b5685.
  ///
  /// In zh, this message translates to:
  /// **'持续运动时间'**
  String get ui_auto_full_b6a80b5685;

  /// No description provided for @ui_auto_full_b6bf780f0f.
  ///
  /// In zh, this message translates to:
  /// **'开启自动同步'**
  String get ui_auto_full_b6bf780f0f;

  /// No description provided for @ui_auto_full_b6d767d2f8.
  ///
  /// In zh, this message translates to:
  /// **'22'**
  String get ui_auto_full_b6d767d2f8;

  /// No description provided for @ui_auto_full_b6f3af2122.
  ///
  /// In zh, this message translates to:
  /// **'任务标题'**
  String get ui_auto_full_b6f3af2122;

  /// No description provided for @ui_auto_full_b707a15e19.
  ///
  /// In zh, this message translates to:
  /// **'12:23'**
  String get ui_auto_full_b707a15e19;

  /// No description provided for @ui_auto_full_b78a322350.
  ///
  /// In zh, this message translates to:
  /// **'标题'**
  String get ui_auto_full_b78a322350;

  /// No description provided for @ui_auto_full_b7b8f3a8b3.
  ///
  /// In zh, this message translates to:
  /// **'立刻录入'**
  String get ui_auto_full_b7b8f3a8b3;

  /// No description provided for @ui_auto_full_ba10fcc9a4.
  ///
  /// In zh, this message translates to:
  /// **'💧'**
  String get ui_auto_full_ba10fcc9a4;

  /// No description provided for @ui_auto_full_ba9dc6d2d4.
  ///
  /// In zh, this message translates to:
  /// **'历史记录'**
  String get ui_auto_full_ba9dc6d2d4;

  /// No description provided for @ui_auto_full_baad5e8013.
  ///
  /// In zh, this message translates to:
  /// **'消耗热量 (千卡)'**
  String get ui_auto_full_baad5e8013;

  /// No description provided for @ui_auto_full_bae9ba337e.
  ///
  /// In zh, this message translates to:
  /// **'搜索运动类型'**
  String get ui_auto_full_bae9ba337e;

  /// No description provided for @ui_auto_full_baec6461b0.
  ///
  /// In zh, this message translates to:
  /// **'icon'**
  String get ui_auto_full_baec6461b0;

  /// No description provided for @ui_auto_full_bb5cc40cd7.
  ///
  /// In zh, this message translates to:
  /// **'立即签到'**
  String get ui_auto_full_bb5cc40cd7;

  /// No description provided for @ui_auto_full_bc86f166cd.
  ///
  /// In zh, this message translates to:
  /// **'喝水记录'**
  String get ui_auto_full_bc86f166cd;

  /// No description provided for @ui_auto_full_bce7575206.
  ///
  /// In zh, this message translates to:
  /// **'5000米/天'**
  String get ui_auto_full_bce7575206;

  /// No description provided for @ui_auto_full_bd547d7793.
  ///
  /// In zh, this message translates to:
  /// **'记录体重'**
  String get ui_auto_full_bd547d7793;

  /// No description provided for @ui_auto_full_bd8be5579e.
  ///
  /// In zh, this message translates to:
  /// **'初试身手'**
  String get ui_auto_full_bd8be5579e;

  /// No description provided for @ui_auto_full_be0f745778.
  ///
  /// In zh, this message translates to:
  /// **'今天'**
  String get ui_auto_full_be0f745778;

  /// No description provided for @ui_auto_full_c20ad4d76f.
  ///
  /// In zh, this message translates to:
  /// **'12'**
  String get ui_auto_full_c20ad4d76f;

  /// No description provided for @ui_auto_full_c31f48f84e.
  ///
  /// In zh, this message translates to:
  /// **'分享'**
  String get ui_auto_full_c31f48f84e;

  /// No description provided for @ui_auto_full_c380a317b5.
  ///
  /// In zh, this message translates to:
  /// **'🏅'**
  String get ui_auto_full_c380a317b5;

  /// No description provided for @ui_auto_full_c3992269b4.
  ///
  /// In zh, this message translates to:
  /// **'退出'**
  String get ui_auto_full_c3992269b4;

  /// No description provided for @ui_auto_full_c39a1ae0d7.
  ///
  /// In zh, this message translates to:
  /// **'奖励'**
  String get ui_auto_full_c39a1ae0d7;

  /// No description provided for @ui_auto_full_c3ebe27993.
  ///
  /// In zh, this message translates to:
  /// **'日均摄入'**
  String get ui_auto_full_c3ebe27993;

  /// No description provided for @ui_auto_full_c4442f1f0d.
  ///
  /// In zh, this message translates to:
  /// **'8500 步'**
  String get ui_auto_full_c4442f1f0d;

  /// No description provided for @ui_auto_full_c47c9e3026.
  ///
  /// In zh, this message translates to:
  /// **'静谧雨夜'**
  String get ui_auto_full_c47c9e3026;

  /// No description provided for @ui_auto_full_c4ca4238a0.
  ///
  /// In zh, this message translates to:
  /// **'1'**
  String get ui_auto_full_c4ca4238a0;

  /// No description provided for @ui_auto_full_c6036a69be.
  ///
  /// In zh, this message translates to:
  /// **'1120'**
  String get ui_auto_full_c6036a69be;

  /// No description provided for @ui_auto_full_c60b1d7393.
  ///
  /// In zh, this message translates to:
  /// **'累计完成10次运动训练'**
  String get ui_auto_full_c60b1d7393;

  /// No description provided for @ui_auto_full_c623f7cba4.
  ///
  /// In zh, this message translates to:
  /// **'第 1 组 / 共 3 组'**
  String get ui_auto_full_c623f7cba4;

  /// No description provided for @ui_auto_full_c7a5d893fe.
  ///
  /// In zh, this message translates to:
  /// **'当前日期暂无心情'**
  String get ui_auto_full_c7a5d893fe;

  /// No description provided for @ui_auto_full_c7a9759564.
  ///
  /// In zh, this message translates to:
  /// **'主食杂粮'**
  String get ui_auto_full_c7a9759564;

  /// No description provided for @ui_auto_full_c81e728d9d.
  ///
  /// In zh, this message translates to:
  /// **'2'**
  String get ui_auto_full_c81e728d9d;

  /// No description provided for @ui_auto_full_c883ad8285.
  ///
  /// In zh, this message translates to:
  /// **'今日暂无记录'**
  String get ui_auto_full_c883ad8285;

  /// No description provided for @ui_auto_full_c990336583.
  ///
  /// In zh, this message translates to:
  /// **'📈 心情趋势'**
  String get ui_auto_full_c990336583;

  /// No description provided for @ui_auto_full_c9e3981784.
  ///
  /// In zh, this message translates to:
  /// **'份量：'**
  String get ui_auto_full_c9e3981784;

  /// No description provided for @ui_auto_full_cab7976bc6.
  ///
  /// In zh, this message translates to:
  /// **'去领金币'**
  String get ui_auto_full_cab7976bc6;

  /// No description provided for @ui_auto_full_cbe1a97e3c.
  ///
  /// In zh, this message translates to:
  /// **'删除下载'**
  String get ui_auto_full_cbe1a97e3c;

  /// No description provided for @ui_auto_full_cedf8da054.
  ///
  /// In zh, this message translates to:
  /// **'&gt;'**
  String get ui_auto_full_cedf8da054;

  /// No description provided for @ui_auto_full_cef3aac8a8.
  ///
  /// In zh, this message translates to:
  /// **'5公里'**
  String get ui_auto_full_cef3aac8a8;

  /// No description provided for @ui_auto_full_cfa5301358.
  ///
  /// In zh, this message translates to:
  /// **'1500'**
  String get ui_auto_full_cfa5301358;

  /// No description provided for @ui_auto_full_cfab1ba8c6.
  ///
  /// In zh, this message translates to:
  /// **'--'**
  String get ui_auto_full_cfab1ba8c6;

  /// No description provided for @ui_auto_full_cfcd208495.
  ///
  /// In zh, this message translates to:
  /// **'0'**
  String get ui_auto_full_cfcd208495;

  /// No description provided for @ui_auto_full_d0a11d0791.
  ///
  /// In zh, this message translates to:
  /// **'风险评估'**
  String get ui_auto_full_d0a11d0791;

  /// No description provided for @ui_auto_full_d158af3104.
  ///
  /// In zh, this message translates to:
  /// **'手动设置'**
  String get ui_auto_full_d158af3104;

  /// No description provided for @ui_auto_full_d1f56abd6f.
  ///
  /// In zh, this message translates to:
  /// **'微信登录'**
  String get ui_auto_full_d1f56abd6f;

  /// No description provided for @ui_auto_full_d2c10763a0.
  ///
  /// In zh, this message translates to:
  /// **'成就勋章'**
  String get ui_auto_full_d2c10763a0;

  /// No description provided for @ui_auto_full_d3d9446802.
  ///
  /// In zh, this message translates to:
  /// **'10'**
  String get ui_auto_full_d3d9446802;

  /// No description provided for @ui_auto_full_d4d5353022.
  ///
  /// In zh, this message translates to:
  /// **'工作、休息'**
  String get ui_auto_full_d4d5353022;

  /// No description provided for @ui_auto_full_d5d3db1765.
  ///
  /// In zh, this message translates to:
  /// **'title'**
  String get ui_auto_full_d5d3db1765;

  /// No description provided for @ui_auto_full_d7735b3644.
  ///
  /// In zh, this message translates to:
  /// **'金币奖励'**
  String get ui_auto_full_d7735b3644;

  /// No description provided for @ui_auto_full_d7cfe6658c.
  ///
  /// In zh, this message translates to:
  /// **'3月05号'**
  String get ui_auto_full_d7cfe6658c;

  /// No description provided for @ui_auto_full_d7da265427.
  ///
  /// In zh, this message translates to:
  /// **'运动打卡圈'**
  String get ui_auto_full_d7da265427;

  /// No description provided for @ui_auto_full_d7f1e92e98.
  ///
  /// In zh, this message translates to:
  /// **'今日记录'**
  String get ui_auto_full_d7f1e92e98;

  /// No description provided for @ui_auto_full_daf783c8cd.
  ///
  /// In zh, this message translates to:
  /// **'分'**
  String get ui_auto_full_daf783c8cd;

  /// No description provided for @ui_auto_full_db01fbb538.
  ///
  /// In zh, this message translates to:
  /// **'倒计时关闭: --:--'**
  String get ui_auto_full_db01fbb538;

  /// No description provided for @ui_auto_full_dc3ebd082a.
  ///
  /// In zh, this message translates to:
  /// **'✕ 退出'**
  String get ui_auto_full_dc3ebd082a;

  /// No description provided for @ui_auto_full_dc5a9a0d09.
  ///
  /// In zh, this message translates to:
  /// **'04:57'**
  String get ui_auto_full_dc5a9a0d09;

  /// No description provided for @ui_auto_full_dc69f249a8.
  ///
  /// In zh, this message translates to:
  /// **'记圈'**
  String get ui_auto_full_dc69f249a8;

  /// No description provided for @ui_auto_full_dd5925ba52.
  ///
  /// In zh, this message translates to:
  /// **'00:00:00'**
  String get ui_auto_full_dd5925ba52;

  /// No description provided for @ui_auto_full_dec2ce394c.
  ///
  /// In zh, this message translates to:
  /// **'000金币≈0.0元'**
  String get ui_auto_full_dec2ce394c;

  /// No description provided for @ui_auto_full_df58350aa3.
  ///
  /// In zh, this message translates to:
  /// **'2023-5'**
  String get ui_auto_full_df58350aa3;

  /// No description provided for @ui_auto_full_dfb8d511c7.
  ///
  /// In zh, this message translates to:
  /// **'用户名称'**
  String get ui_auto_full_dfb8d511c7;

  /// No description provided for @ui_auto_full_dff521d468.
  ///
  /// In zh, this message translates to:
  /// **'▶'**
  String get ui_auto_full_dff521d468;

  /// No description provided for @ui_auto_full_e092736459.
  ///
  /// In zh, this message translates to:
  /// **'0/39'**
  String get ui_auto_full_e092736459;

  /// No description provided for @ui_auto_full_e0ea1fa1cc.
  ///
  /// In zh, this message translates to:
  /// **'CONGRATULATIONS!'**
  String get ui_auto_full_e0ea1fa1cc;

  /// No description provided for @ui_auto_full_e1089d4dfa.
  ///
  /// In zh, this message translates to:
  /// **'--:--'**
  String get ui_auto_full_e1089d4dfa;

  /// No description provided for @ui_auto_full_e126ecd515.
  ///
  /// In zh, this message translates to:
  /// **'公里'**
  String get ui_auto_full_e126ecd515;

  /// No description provided for @ui_auto_full_e2e8da69d0.
  ///
  /// In zh, this message translates to:
  /// **'2003年12月22日  22:23'**
  String get ui_auto_full_e2e8da69d0;

  /// No description provided for @ui_auto_full_e4da3b7fbb.
  ///
  /// In zh, this message translates to:
  /// **'5'**
  String get ui_auto_full_e4da3b7fbb;

  /// No description provided for @ui_auto_full_e5446f0f1b.
  ///
  /// In zh, this message translates to:
  /// **'分享荣誉'**
  String get ui_auto_full_e5446f0f1b;

  /// No description provided for @ui_auto_full_e56c452eae.
  ///
  /// In zh, this message translates to:
  /// **'(因部分系统机制问题，可能出现需多次同步才能获取到步数的情况。 )'**
  String get ui_auto_full_e56c452eae;

  /// No description provided for @ui_auto_full_e5bf251ab3.
  ///
  /// In zh, this message translates to:
  /// **'系统同步权限'**
  String get ui_auto_full_e5bf251ab3;

  /// No description provided for @ui_auto_full_e61f2cc4c3.
  ///
  /// In zh, this message translates to:
  /// **'同意'**
  String get ui_auto_full_e61f2cc4c3;

  /// No description provided for @ui_auto_full_e6f60d6bb2.
  ///
  /// In zh, this message translates to:
  /// **'+50米'**
  String get ui_auto_full_e6f60d6bb2;

  /// No description provided for @ui_auto_full_e704927421.
  ///
  /// In zh, this message translates to:
  /// **'累计消耗'**
  String get ui_auto_full_e704927421;

  /// No description provided for @ui_auto_full_e71b341b0b.
  ///
  /// In zh, this message translates to:
  /// **'深呼吸，放松心情'**
  String get ui_auto_full_e71b341b0b;

  /// No description provided for @ui_auto_full_e83a256e4f.
  ///
  /// In zh, this message translates to:
  /// **'确认'**
  String get ui_auto_full_e83a256e4f;

  /// No description provided for @ui_auto_full_e90ecdaa8d.
  ///
  /// In zh, this message translates to:
  /// **'10分钟前'**
  String get ui_auto_full_e90ecdaa8d;

  /// No description provided for @ui_auto_full_e91496ea7f.
  ///
  /// In zh, this message translates to:
  /// **'总热量'**
  String get ui_auto_full_e91496ea7f;

  /// No description provided for @ui_auto_full_e93028bdc1.
  ///
  /// In zh, this message translates to:
  /// **'3000'**
  String get ui_auto_full_e93028bdc1;

  /// No description provided for @ui_auto_full_e957ecc6c1.
  ///
  /// In zh, this message translates to:
  /// **'饮食统计'**
  String get ui_auto_full_e957ecc6c1;

  /// No description provided for @ui_auto_full_ea4aada68b.
  ///
  /// In zh, this message translates to:
  /// **'📊 质量分布'**
  String get ui_auto_full_ea4aada68b;

  /// No description provided for @ui_auto_full_eabc9b5baa.
  ///
  /// In zh, this message translates to:
  /// **'未解锁'**
  String get ui_auto_full_eabc9b5baa;

  /// No description provided for @ui_auto_full_eb02697caa.
  ///
  /// In zh, this message translates to:
  /// **'平均质量'**
  String get ui_auto_full_eb02697caa;

  /// No description provided for @ui_auto_full_eb1a35c316.
  ///
  /// In zh, this message translates to:
  /// **'已完成 3 组，累计 6 分钟。'**
  String get ui_auto_full_eb1a35c316;

  /// No description provided for @ui_auto_full_eb4d632f51.
  ///
  /// In zh, this message translates to:
  /// **'回到今天'**
  String get ui_auto_full_eb4d632f51;

  /// No description provided for @ui_auto_full_eccbc87e4b.
  ///
  /// In zh, this message translates to:
  /// **'3'**
  String get ui_auto_full_eccbc87e4b;

  /// No description provided for @ui_auto_full_ed83f53ede.
  ///
  /// In zh, this message translates to:
  /// **'01-04'**
  String get ui_auto_full_ed83f53ede;

  /// No description provided for @ui_auto_full_ee057f9e6d.
  ///
  /// In zh, this message translates to:
  /// **'记录天数'**
  String get ui_auto_full_ee057f9e6d;

  /// No description provided for @ui_auto_full_ee1b82d5f0.
  ///
  /// In zh, this message translates to:
  /// **'平均时长'**
  String get ui_auto_full_ee1b82d5f0;

  /// No description provided for @ui_auto_full_eeaa9837de.
  ///
  /// In zh, this message translates to:
  /// **'荣誉达成'**
  String get ui_auto_full_eeaa9837de;

  /// No description provided for @ui_auto_full_ef5f002f0f.
  ///
  /// In zh, this message translates to:
  /// **'19.3公里'**
  String get ui_auto_full_ef5f002f0f;

  /// No description provided for @ui_auto_full_efdce06448.
  ///
  /// In zh, this message translates to:
  /// **'使用推荐值'**
  String get ui_auto_full_efdce06448;

  /// No description provided for @ui_auto_full_f00df1a375.
  ///
  /// In zh, this message translates to:
  /// **'总组数'**
  String get ui_auto_full_f00df1a375;

  /// No description provided for @ui_auto_full_f104d150a1.
  ///
  /// In zh, this message translates to:
  /// **'2026-03-21 达成'**
  String get ui_auto_full_f104d150a1;

  /// No description provided for @ui_auto_full_f18c57a7f2.
  ///
  /// In zh, this message translates to:
  /// **'克'**
  String get ui_auto_full_f18c57a7f2;

  /// No description provided for @ui_auto_full_f39ae9ff3a.
  ///
  /// In zh, this message translates to:
  /// **'1800'**
  String get ui_auto_full_f39ae9ff3a;

  /// No description provided for @ui_auto_full_f3b184dc98.
  ///
  /// In zh, this message translates to:
  /// **'搜索食物'**
  String get ui_auto_full_f3b184dc98;

  /// No description provided for @ui_auto_full_f4f46b7feb.
  ///
  /// In zh, this message translates to:
  /// **'00:0'**
  String get ui_auto_full_f4f46b7feb;

  /// No description provided for @ui_auto_full_f511e9e0d4.
  ///
  /// In zh, this message translates to:
  /// **'15分钟'**
  String get ui_auto_full_f511e9e0d4;

  /// No description provided for @ui_auto_full_f70f5c6b53.
  ///
  /// In zh, this message translates to:
  /// **'户外跑'**
  String get ui_auto_full_f70f5c6b53;

  /// No description provided for @ui_auto_full_f7211d3ffc.
  ///
  /// In zh, this message translates to:
  /// **'⏰ 作息规律'**
  String get ui_auto_full_f7211d3ffc;

  /// No description provided for @ui_auto_full_f7696a9b36.
  ///
  /// In zh, this message translates to:
  /// **'2500'**
  String get ui_auto_full_f7696a9b36;

  /// No description provided for @ui_auto_full_f7ddd489ab.
  ///
  /// In zh, this message translates to:
  /// **'0.00'**
  String get ui_auto_full_f7ddd489ab;

  /// No description provided for @ui_auto_full_f818259b1d.
  ///
  /// In zh, this message translates to:
  /// **'2023-01-01'**
  String get ui_auto_full_f818259b1d;

  /// No description provided for @ui_auto_full_f819de8124.
  ///
  /// In zh, this message translates to:
  /// **'75%'**
  String get ui_auto_full_f819de8124;

  /// No description provided for @ui_auto_full_f899139df5.
  ///
  /// In zh, this message translates to:
  /// **'100'**
  String get ui_auto_full_f899139df5;

  /// No description provided for @ui_auto_full_f8c3feb48c.
  ///
  /// In zh, this message translates to:
  /// **'日历'**
  String get ui_auto_full_f8c3feb48c;

  /// No description provided for @ui_auto_full_f965fea308.
  ///
  /// In zh, this message translates to:
  /// **'次数'**
  String get ui_auto_full_f965fea308;

  /// No description provided for @ui_auto_full_f9992b2c2e.
  ///
  /// In zh, this message translates to:
  /// **'5000/天'**
  String get ui_auto_full_f9992b2c2e;

  /// No description provided for @ui_auto_full_fb2ea5cbb4.
  ///
  /// In zh, this message translates to:
  /// **'手动输入或使用快捷按钮累加本次运动距离。'**
  String get ui_auto_full_fb2ea5cbb4;

  /// No description provided for @ui_auto_full_fb852fc6cc.
  ///
  /// In zh, this message translates to:
  /// **'进行中'**
  String get ui_auto_full_fb852fc6cc;

  /// No description provided for @ui_auto_full_fb9951660e.
  ///
  /// In zh, this message translates to:
  /// **'所有类型'**
  String get ui_auto_full_fb9951660e;

  /// No description provided for @ui_auto_full_fcd9436296.
  ///
  /// In zh, this message translates to:
  /// **'重量'**
  String get ui_auto_full_fcd9436296;

  /// No description provided for @ui_auto_full_fd375dee48.
  ///
  /// In zh, this message translates to:
  /// **'07:00'**
  String get ui_auto_full_fd375dee48;

  /// No description provided for @ui_auto_full_fd6e4095e0.
  ///
  /// In zh, this message translates to:
  /// **'识别包名: com.huawei.health / com.hihonor.health'**
  String get ui_auto_full_fd6e4095e0;

  /// No description provided for @ui_auto_full_fdc9d587b5.
  ///
  /// In zh, this message translates to:
  /// **'我的本周跑量'**
  String get ui_auto_full_fdc9d587b5;

  /// No description provided for @ui_auto_full_feac70e2cf.
  ///
  /// In zh, this message translates to:
  /// **'今天 12:00'**
  String get ui_auto_full_feac70e2cf;

  /// No description provided for @ui_auto_full_ff0ee55e51.
  ///
  /// In zh, this message translates to:
  /// **'时间模式'**
  String get ui_auto_full_ff0ee55e51;

  /// No description provided for @ui_auto_full_ff6ba24d41.
  ///
  /// In zh, this message translates to:
  /// **'🚶 步数'**
  String get ui_auto_full_ff6ba24d41;

  /// No description provided for @ui_auto_full_ff8bed43ac.
  ///
  /// In zh, this message translates to:
  /// **'1/4'**
  String get ui_auto_full_ff8bed43ac;

  /// No description provided for @ui_auto_method_010c9f12d9.
  ///
  /// In zh, this message translates to:
  /// **'你的运动目标已达成'**
  String get ui_auto_method_010c9f12d9;

  /// No description provided for @ui_auto_method_014c2b8adc.
  ///
  /// In zh, this message translates to:
  /// **'请完善日期和时间信息'**
  String get ui_auto_method_014c2b8adc;

  /// No description provided for @ui_auto_method_028cdfbeb0.
  ///
  /// In zh, this message translates to:
  /// **'删除提示'**
  String get ui_auto_method_028cdfbeb0;

  /// No description provided for @ui_auto_method_08b5033ee3.
  ///
  /// In zh, this message translates to:
  /// **'请输入有效的运动时长'**
  String get ui_auto_method_08b5033ee3;

  /// No description provided for @ui_auto_method_09c89dc8b9.
  ///
  /// In zh, this message translates to:
  /// **'继续训练'**
  String get ui_auto_method_09c89dc8b9;

  /// No description provided for @ui_auto_method_0a20fd57a1.
  ///
  /// In zh, this message translates to:
  /// **'运动分布'**
  String get ui_auto_method_0a20fd57a1;

  /// No description provided for @ui_auto_method_11d7819fac.
  ///
  /// In zh, this message translates to:
  /// **'每天定时提醒您开始训练计划'**
  String get ui_auto_method_11d7819fac;

  /// No description provided for @ui_auto_method_1303e638b5.
  ///
  /// In zh, this message translates to:
  /// **'修改时间'**
  String get ui_auto_method_1303e638b5;

  /// No description provided for @ui_auto_method_182cece58d.
  ///
  /// In zh, this message translates to:
  /// **'💡 微步 AI 健康建议'**
  String get ui_auto_method_182cece58d;

  /// No description provided for @ui_auto_method_1a4ccdb444.
  ///
  /// In zh, this message translates to:
  /// **'取消退出'**
  String get ui_auto_method_1a4ccdb444;

  /// No description provided for @ui_auto_method_1d37e75bf3.
  ///
  /// In zh, this message translates to:
  /// **'请输入舒张压'**
  String get ui_auto_method_1d37e75bf3;

  /// No description provided for @ui_auto_method_20910c5de0.
  ///
  /// In zh, this message translates to:
  /// **'0公里/小时'**
  String get ui_auto_method_20910c5de0;

  /// No description provided for @ui_auto_method_241f2e6b75.
  ///
  /// In zh, this message translates to:
  /// **'你还没有记录过腰围'**
  String get ui_auto_method_241f2e6b75;

  /// No description provided for @ui_auto_method_246aa46373.
  ///
  /// In zh, this message translates to:
  /// **'你还没有记录过小腿围'**
  String get ui_auto_method_246aa46373;

  /// No description provided for @ui_auto_method_319a541426.
  ///
  /// In zh, this message translates to:
  /// **'请输入血糖值'**
  String get ui_auto_method_319a541426;

  /// No description provided for @ui_auto_method_322e528433.
  ///
  /// In zh, this message translates to:
  /// **'注销账号'**
  String get ui_auto_method_322e528433;

  /// No description provided for @ui_auto_method_334306b663.
  ///
  /// In zh, this message translates to:
  /// **'请输入运动时长'**
  String get ui_auto_method_334306b663;

  /// No description provided for @ui_auto_method_3daa166c8d.
  ///
  /// In zh, this message translates to:
  /// **'心率范围应在30-250之间'**
  String get ui_auto_method_3daa166c8d;

  /// No description provided for @ui_auto_method_4565fd5463.
  ///
  /// In zh, this message translates to:
  /// **'今天还没有运动哦，现在开始吧！'**
  String get ui_auto_method_4565fd5463;

  /// No description provided for @ui_auto_method_56c9087a99.
  ///
  /// In zh, this message translates to:
  /// **'已删除记录'**
  String get ui_auto_method_56c9087a99;

  /// No description provided for @ui_auto_method_5c94123fcf.
  ///
  /// In zh, this message translates to:
  /// **'请输入有效的血糖值'**
  String get ui_auto_method_5c94123fcf;

  /// No description provided for @ui_auto_method_6954f9a3a2.
  ///
  /// In zh, this message translates to:
  /// **'申请记步权限'**
  String get ui_auto_method_6954f9a3a2;

  /// No description provided for @ui_auto_method_6d1c35286a.
  ///
  /// In zh, this message translates to:
  /// **'每日运动提醒通知'**
  String get ui_auto_method_6d1c35286a;

  /// No description provided for @ui_auto_method_760fb8dcbe.
  ///
  /// In zh, this message translates to:
  /// **'修改体重记录'**
  String get ui_auto_method_760fb8dcbe;

  /// No description provided for @ui_auto_method_7a3af6b4f1.
  ///
  /// In zh, this message translates to:
  /// **'使用轨迹记录提示'**
  String get ui_auto_method_7a3af6b4f1;

  /// No description provided for @ui_auto_method_8347a927c0.
  ///
  /// In zh, this message translates to:
  /// **'修改'**
  String get ui_auto_method_8347a927c0;

  /// No description provided for @ui_auto_method_85db755989.
  ///
  /// In zh, this message translates to:
  /// **'当您久坐不动时提醒您起来活动'**
  String get ui_auto_method_85db755989;

  /// No description provided for @ui_auto_method_86fbb83305.
  ///
  /// In zh, this message translates to:
  /// **'请输入平均心率'**
  String get ui_auto_method_86fbb83305;

  /// No description provided for @ui_auto_method_914c87d06e.
  ///
  /// In zh, this message translates to:
  /// **'动作库训练 ·'**
  String get ui_auto_method_914c87d06e;

  /// No description provided for @ui_auto_method_91e0484906.
  ///
  /// In zh, this message translates to:
  /// **'🏃 运动时间到！'**
  String get ui_auto_method_91e0484906;

  /// No description provided for @ui_auto_method_9c1f8b7c2f.
  ///
  /// In zh, this message translates to:
  /// **'你还没有记录过身高'**
  String get ui_auto_method_9c1f8b7c2f;

  /// No description provided for @ui_auto_method_a190b617aa.
  ///
  /// In zh, this message translates to:
  /// **'收缩压应大于舒张压'**
  String get ui_auto_method_a190b617aa;

  /// No description provided for @ui_auto_method_a717bbf10f.
  ///
  /// In zh, this message translates to:
  /// **'定时提醒您补充水分'**
  String get ui_auto_method_a717bbf10f;

  /// No description provided for @ui_auto_method_aa2fb1b6cf.
  ///
  /// In zh, this message translates to:
  /// **'请选择日期'**
  String get ui_auto_method_aa2fb1b6cf;

  /// No description provided for @ui_auto_method_ab69dba354.
  ///
  /// In zh, this message translates to:
  /// **'你还没有记录过臀围'**
  String get ui_auto_method_ab69dba354;

  /// No description provided for @ui_auto_method_ae6b76a9e5.
  ///
  /// In zh, this message translates to:
  /// **'你还没有记录过体重'**
  String get ui_auto_method_ae6b76a9e5;

  /// No description provided for @ui_auto_method_c21a0dc9ca.
  ///
  /// In zh, this message translates to:
  /// **'你还没有记录过上臂围'**
  String get ui_auto_method_c21a0dc9ca;

  /// No description provided for @ui_auto_method_c34d201966.
  ///
  /// In zh, this message translates to:
  /// **'你还没有记录过胸围'**
  String get ui_auto_method_c34d201966;

  /// No description provided for @ui_auto_method_c48ae72c9a.
  ///
  /// In zh, this message translates to:
  /// **'训练结束，共完成'**
  String get ui_auto_method_c48ae72c9a;

  /// No description provided for @ui_auto_method_c6cdba261a.
  ///
  /// In zh, this message translates to:
  /// **'运动时长应在1-600分钟之间'**
  String get ui_auto_method_c6cdba261a;

  /// No description provided for @ui_auto_method_c93ca01a8c.
  ///
  /// In zh, this message translates to:
  /// **'你还没有记录过大腿围'**
  String get ui_auto_method_c93ca01a8c;

  /// No description provided for @ui_auto_method_cb8c7f5d68.
  ///
  /// In zh, this message translates to:
  /// **'公斤'**
  String get ui_auto_method_cb8c7f5d68;

  /// No description provided for @ui_auto_method_cb91f5ebd6.
  ///
  /// In zh, this message translates to:
  /// **'收缩压范围应在60-300之间'**
  String get ui_auto_method_cb91f5ebd6;

  /// No description provided for @ui_auto_method_d2bf878baf.
  ///
  /// In zh, this message translates to:
  /// **'有未保存的训练记录，是否退出？'**
  String get ui_auto_method_d2bf878baf;

  /// No description provided for @ui_auto_method_d9f14636aa.
  ///
  /// In zh, this message translates to:
  /// **'舒张压范围应在40-200之间'**
  String get ui_auto_method_d9f14636aa;

  /// No description provided for @ui_auto_method_de0ff792fc.
  ///
  /// In zh, this message translates to:
  /// **'运动目标达成'**
  String get ui_auto_method_de0ff792fc;

  /// No description provided for @ui_auto_method_e50478fc58.
  ///
  /// In zh, this message translates to:
  /// **'请输入收缩压'**
  String get ui_auto_method_e50478fc58;

  /// No description provided for @ui_auto_method_e74553d2a4.
  ///
  /// In zh, this message translates to:
  /// **'请输入有效的心率值'**
  String get ui_auto_method_e74553d2a4;

  /// No description provided for @ui_auto_method_eb45a8e060.
  ///
  /// In zh, this message translates to:
  /// **'开启并进入'**
  String get ui_auto_method_eb45a8e060;

  /// No description provided for @ui_auto_method_efa54b12a2.
  ///
  /// In zh, this message translates to:
  /// **'血糖值超出正常范围'**
  String get ui_auto_method_efa54b12a2;

  /// No description provided for @ui_auto_method_f2a63912dc.
  ///
  /// In zh, this message translates to:
  /// **'请输入有效的体重值'**
  String get ui_auto_method_f2a63912dc;

  /// No description provided for @ui_auto_method_fb015878f6.
  ///
  /// In zh, this message translates to:
  /// **'引导式训练：'**
  String get ui_auto_method_fb015878f6;

  /// No description provided for @ui_auto_method_fbd05a89ca.
  ///
  /// In zh, this message translates to:
  /// **'请选择时间'**
  String get ui_auto_method_fbd05a89ca;

  /// No description provided for @ui_auto_method_fecefe9ee6.
  ///
  /// In zh, this message translates to:
  /// **'取消提醒'**
  String get ui_auto_method_fecefe9ee6;

  /// No description provided for @ui_auto_return_007032bfb3.
  ///
  /// In zh, this message translates to:
  /// **'综合力量'**
  String get ui_auto_return_007032bfb3;

  /// No description provided for @ui_auto_return_0218cbc880.
  ///
  /// In zh, this message translates to:
  /// **'开心'**
  String get ui_auto_return_0218cbc880;

  /// No description provided for @ui_auto_return_02c7b1a320.
  ///
  /// In zh, this message translates to:
  /// **'拉力器'**
  String get ui_auto_return_02c7b1a320;

  /// No description provided for @ui_auto_return_047b1b29b7.
  ///
  /// In zh, this message translates to:
  /// **'进阶安排'**
  String get ui_auto_return_047b1b29b7;

  /// No description provided for @ui_auto_return_04a99be8ff.
  ///
  /// In zh, this message translates to:
  /// **'让一周里有稳定活动量，同时留出恢复空间，适合长期维持。'**
  String get ui_auto_return_04a99be8ff;

  /// No description provided for @ui_auto_return_07198d2f5b.
  ///
  /// In zh, this message translates to:
  /// **'未检测到明显的健康数据异常。'**
  String get ui_auto_return_07198d2f5b;

  /// No description provided for @ui_auto_return_0775b64987.
  ///
  /// In zh, this message translates to:
  /// **'血压波动中等'**
  String get ui_auto_return_0775b64987;

  /// No description provided for @ui_auto_return_09e647347b.
  ///
  /// In zh, this message translates to:
  /// **'睡前'**
  String get ui_auto_return_09e647347b;

  /// No description provided for @ui_auto_return_0ba0974488.
  ///
  /// In zh, this message translates to:
  /// **'上肢推力'**
  String get ui_auto_return_0ba0974488;

  /// No description provided for @ui_auto_return_0c457a3656.
  ///
  /// In zh, this message translates to:
  /// **'其他类'**
  String get ui_auto_return_0c457a3656;

  /// No description provided for @ui_auto_return_0d98c74797.
  ///
  /// In zh, this message translates to:
  /// **'其他'**
  String get ui_auto_return_0d98c74797;

  /// No description provided for @ui_auto_return_0ee2ef1657.
  ///
  /// In zh, this message translates to:
  /// **'背部拉力'**
  String get ui_auto_return_0ee2ef1657;

  /// No description provided for @ui_auto_return_12df6bb699.
  ///
  /// In zh, this message translates to:
  /// **'轻体力劳动'**
  String get ui_auto_return_12df6bb699;

  /// No description provided for @ui_auto_return_17d32c917e.
  ///
  /// In zh, this message translates to:
  /// **'近三个月'**
  String get ui_auto_return_17d32c917e;

  /// No description provided for @ui_auto_return_199710422d.
  ///
  /// In zh, this message translates to:
  /// **'健康状况良好'**
  String get ui_auto_return_199710422d;

  /// No description provided for @ui_auto_return_19ac677ac0.
  ///
  /// In zh, this message translates to:
  /// **'低'**
  String get ui_auto_return_19ac677ac0;

  /// No description provided for @ui_auto_return_1fa42afe88.
  ///
  /// In zh, this message translates to:
  /// **'入门'**
  String get ui_auto_return_1fa42afe88;

  /// No description provided for @ui_auto_return_1ff7d056fc.
  ///
  /// In zh, this message translates to:
  /// **'这份计划会优先帮你建立稳定训练节奏，再通过有氧和力量配合提高效率。'**
  String get ui_auto_return_1ff7d056fc;

  /// No description provided for @ui_auto_return_2166bdec84.
  ///
  /// In zh, this message translates to:
  /// **'更新单个任务'**
  String get ui_auto_return_2166bdec84;

  /// No description provided for @ui_auto_return_259309fccf.
  ///
  /// In zh, this message translates to:
  /// **'获取用户信息'**
  String get ui_auto_return_259309fccf;

  /// No description provided for @ui_auto_return_27fd53ef6a.
  ///
  /// In zh, this message translates to:
  /// **'心率上升'**
  String get ui_auto_return_27fd53ef6a;

  /// No description provided for @ui_auto_return_28022da8a2.
  ///
  /// In zh, this message translates to:
  /// **'未测量'**
  String get ui_auto_return_28022da8a2;

  /// No description provided for @ui_auto_return_290ba906ee.
  ///
  /// In zh, this message translates to:
  /// **'分数模式'**
  String get ui_auto_return_290ba906ee;

  /// No description provided for @ui_auto_return_2aa7946e8c.
  ///
  /// In zh, this message translates to:
  /// **'过高'**
  String get ui_auto_return_2aa7946e8c;

  /// No description provided for @ui_auto_return_32127a5552.
  ///
  /// In zh, this message translates to:
  /// **'分享列表'**
  String get ui_auto_return_32127a5552;

  /// No description provided for @ui_auto_return_33823e9215.
  ///
  /// In zh, this message translates to:
  /// **'数据不足'**
  String get ui_auto_return_33823e9215;

  /// No description provided for @ui_auto_return_33a4541c27.
  ///
  /// In zh, this message translates to:
  /// **'高度异常'**
  String get ui_auto_return_33a4541c27;

  /// No description provided for @ui_auto_return_344ac0470d.
  ///
  /// In zh, this message translates to:
  /// **'减脂燃卡'**
  String get ui_auto_return_344ac0470d;

  /// No description provided for @ui_auto_return_352238403e.
  ///
  /// In zh, this message translates to:
  /// **'重体力劳动'**
  String get ui_auto_return_352238403e;

  /// No description provided for @ui_auto_return_363b17ecdd.
  ///
  /// In zh, this message translates to:
  /// **'签到列表'**
  String get ui_auto_return_363b17ecdd;

  /// No description provided for @ui_auto_return_38adeae14a.
  ///
  /// In zh, this message translates to:
  /// **'良好的开始！继续加油！'**
  String get ui_auto_return_38adeae14a;

  /// No description provided for @ui_auto_return_3bde446e92.
  ///
  /// In zh, this message translates to:
  /// **'随机'**
  String get ui_auto_return_3bde446e92;

  /// No description provided for @ui_auto_return_3ff7d41b80.
  ///
  /// In zh, this message translates to:
  /// **'增肌塑形'**
  String get ui_auto_return_3ff7d41b80;

  /// No description provided for @ui_auto_return_4051392566.
  ///
  /// In zh, this message translates to:
  /// **'杠铃'**
  String get ui_auto_return_4051392566;

  /// No description provided for @ui_auto_return_4073db4b41.
  ///
  /// In zh, this message translates to:
  /// **'血糖稳定'**
  String get ui_auto_return_4073db4b41;

  /// No description provided for @ui_auto_return_40ac13bfa5.
  ///
  /// In zh, this message translates to:
  /// **'最近一段时间数据变化不大，整体状态比较稳定。'**
  String get ui_auto_return_40ac13bfa5;

  /// No description provided for @ui_auto_return_4296d7d293.
  ///
  /// In zh, this message translates to:
  /// **'高'**
  String get ui_auto_return_4296d7d293;

  /// No description provided for @ui_auto_return_4433e710a6.
  ///
  /// In zh, this message translates to:
  /// **'高风险'**
  String get ui_auto_return_4433e710a6;

  /// No description provided for @ui_auto_return_44d865f037.
  ///
  /// In zh, this message translates to:
  /// **'加油！你离目标只有一步之遥！'**
  String get ui_auto_return_44d865f037;

  /// No description provided for @ui_auto_return_45a7cc1444.
  ///
  /// In zh, this message translates to:
  /// **'器械'**
  String get ui_auto_return_45a7cc1444;

  /// No description provided for @ui_auto_return_46b568edc8.
  ///
  /// In zh, this message translates to:
  /// **'健康状况优秀'**
  String get ui_auto_return_46b568edc8;

  /// No description provided for @ui_auto_return_4984cd115b.
  ///
  /// In zh, this message translates to:
  /// **'轻度异常'**
  String get ui_auto_return_4984cd115b;

  /// No description provided for @ui_auto_return_4a1ef083cd.
  ///
  /// In zh, this message translates to:
  /// **'健康状况一般'**
  String get ui_auto_return_4a1ef083cd;

  /// No description provided for @ui_auto_return_4ce7899995.
  ///
  /// In zh, this message translates to:
  /// **'中度异常'**
  String get ui_auto_return_4ce7899995;

  /// No description provided for @ui_auto_return_4e49f70ac9.
  ///
  /// In zh, this message translates to:
  /// **'下降趋势'**
  String get ui_auto_return_4e49f70ac9;

  /// No description provided for @ui_auto_return_5177ba3f70.
  ///
  /// In zh, this message translates to:
  /// **'先从第一天开练，优先建立本周训练节奏。'**
  String get ui_auto_return_5177ba3f70;

  /// No description provided for @ui_auto_return_523cc0df7c.
  ///
  /// In zh, this message translates to:
  /// **'工作学习、偶尔运动'**
  String get ui_auto_return_523cc0df7c;

  /// No description provided for @ui_auto_return_52c9b5254f.
  ///
  /// In zh, this message translates to:
  /// **'空腹'**
  String get ui_auto_return_52c9b5254f;

  /// No description provided for @ui_auto_return_544fac400d.
  ///
  /// In zh, this message translates to:
  /// **'标准'**
  String get ui_auto_return_544fac400d;

  /// No description provided for @ui_auto_return_54d5511acc.
  ///
  /// In zh, this message translates to:
  /// **'近一个月'**
  String get ui_auto_return_54d5511acc;

  /// No description provided for @ui_auto_return_57406d700f.
  ///
  /// In zh, this message translates to:
  /// **'哑铃'**
  String get ui_auto_return_57406d700f;

  /// No description provided for @ui_auto_return_5a1c279867.
  ///
  /// In zh, this message translates to:
  /// **'肥胖'**
  String get ui_auto_return_5a1c279867;

  /// No description provided for @ui_auto_return_5a3ca79b00.
  ///
  /// In zh, this message translates to:
  /// **'心率下降'**
  String get ui_auto_return_5a3ca79b00;

  /// No description provided for @ui_auto_return_5d17462485.
  ///
  /// In zh, this message translates to:
  /// **'建议固定在晨起或同一时段测量，这样趋势会更有参考价值。'**
  String get ui_auto_return_5d17462485;

  /// No description provided for @ui_auto_return_5f2dc77d2a.
  ///
  /// In zh, this message translates to:
  /// **'保持健康'**
  String get ui_auto_return_5f2dc77d2a;

  /// No description provided for @ui_auto_return_5f31d5ff13.
  ///
  /// In zh, this message translates to:
  /// **'推荐升级'**
  String get ui_auto_return_5f31d5ff13;

  /// No description provided for @ui_auto_return_5f5d2a2ac5.
  ///
  /// In zh, this message translates to:
  /// **'需要改善'**
  String get ui_auto_return_5f5d2a2ac5;

  /// No description provided for @ui_auto_return_6019c34509.
  ///
  /// In zh, this message translates to:
  /// **'高血压危症'**
  String get ui_auto_return_6019c34509;

  /// No description provided for @ui_auto_return_60c36f2a55.
  ///
  /// In zh, this message translates to:
  /// **'全身燃脂'**
  String get ui_auto_return_60c36f2a55;

  /// No description provided for @ui_auto_return_62103751df.
  ///
  /// In zh, this message translates to:
  /// **'还没有训练记录'**
  String get ui_auto_return_62103751df;

  /// No description provided for @ui_auto_return_629504fbfb.
  ///
  /// In zh, this message translates to:
  /// **'中体力劳动'**
  String get ui_auto_return_629504fbfb;

  /// No description provided for @ui_auto_return_62e9a33db6.
  ///
  /// In zh, this message translates to:
  /// **'设备传感器'**
  String get ui_auto_return_62e9a33db6;

  /// No description provided for @ui_auto_return_6574c5bb8e.
  ///
  /// In zh, this message translates to:
  /// **'中等风险'**
  String get ui_auto_return_6574c5bb8e;

  /// No description provided for @ui_auto_return_65b945e53a.
  ///
  /// In zh, this message translates to:
  /// **'未知等级'**
  String get ui_auto_return_65b945e53a;

  /// No description provided for @ui_auto_return_6684c12045.
  ///
  /// In zh, this message translates to:
  /// **'步数列表'**
  String get ui_auto_return_6684c12045;

  /// No description provided for @ui_auto_return_66e769b1a5.
  ///
  /// In zh, this message translates to:
  /// **'高血压1期'**
  String get ui_auto_return_66e769b1a5;

  /// No description provided for @ui_auto_return_67c8e36b05.
  ///
  /// In zh, this message translates to:
  /// **'血压相对稳定'**
  String get ui_auto_return_67c8e36b05;

  /// No description provided for @ui_auto_return_687e3242dd.
  ///
  /// In zh, this message translates to:
  /// **'壶铃'**
  String get ui_auto_return_687e3242dd;

  /// No description provided for @ui_auto_return_69bb0e0ef0.
  ///
  /// In zh, this message translates to:
  /// **'偏低'**
  String get ui_auto_return_69bb0e0ef0;

  /// No description provided for @ui_auto_return_6b828e4da7.
  ///
  /// In zh, this message translates to:
  /// **'以有氧和基础力量穿插推进，先把每周训练频率稳定下来，再逐步提高量。'**
  String get ui_auto_return_6b828e4da7;

  /// No description provided for @ui_auto_return_6e52fb57ac.
  ///
  /// In zh, this message translates to:
  /// **'棒极了'**
  String get ui_auto_return_6e52fb57ac;

  /// No description provided for @ui_auto_return_6f47172756.
  ///
  /// In zh, this message translates to:
  /// **'每天运动、每周6-7天'**
  String get ui_auto_return_6f47172756;

  /// No description provided for @ui_auto_return_6fa87eee37.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！你已经完成了今天的目标！'**
  String get ui_auto_return_6fa87eee37;

  /// No description provided for @ui_auto_return_74a97af209.
  ///
  /// In zh, this message translates to:
  /// **'✅ 目标已达成！'**
  String get ui_auto_return_74a97af209;

  /// No description provided for @ui_auto_return_77002ac334.
  ///
  /// In zh, this message translates to:
  /// **'常常运动、每周3-5天'**
  String get ui_auto_return_77002ac334;

  /// No description provided for @ui_auto_return_7d4be39879.
  ///
  /// In zh, this message translates to:
  /// **'这份计划会优先把肌群训练顺序排清楚，避免今天练太多、明天又接不上。'**
  String get ui_auto_return_7d4be39879;

  /// No description provided for @ui_auto_return_7e7a98ea11.
  ///
  /// In zh, this message translates to:
  /// **'同步任务结果'**
  String get ui_auto_return_7e7a98ea11;

  /// No description provided for @ui_auto_return_8034682695.
  ///
  /// In zh, this message translates to:
  /// **'开始运动吧，让我们一起达成目标！'**
  String get ui_auto_return_8034682695;

  /// No description provided for @ui_auto_return_82190805cf.
  ///
  /// In zh, this message translates to:
  /// **'未评价'**
  String get ui_auto_return_82190805cf;

  /// No description provided for @ui_auto_return_840e932a8f.
  ///
  /// In zh, this message translates to:
  /// **'极高'**
  String get ui_auto_return_840e932a8f;

  /// No description provided for @ui_auto_return_882e940129.
  ///
  /// In zh, this message translates to:
  /// **'心率稳定'**
  String get ui_auto_return_882e940129;

  /// No description provided for @ui_auto_return_897b3c231f.
  ///
  /// In zh, this message translates to:
  /// **'任务奖励'**
  String get ui_auto_return_897b3c231f;

  /// No description provided for @ui_auto_return_8b3f0fc495.
  ///
  /// In zh, this message translates to:
  /// **'无体力劳动'**
  String get ui_auto_return_8b3f0fc495;

  /// No description provided for @ui_auto_return_8fa28f95c0.
  ///
  /// In zh, this message translates to:
  /// **'伤心'**
  String get ui_auto_return_8fa28f95c0;

  /// No description provided for @ui_auto_return_8fd16a40aa.
  ///
  /// In zh, this message translates to:
  /// **'近一年'**
  String get ui_auto_return_8fd16a40aa;

  /// No description provided for @ui_auto_return_90150b8f84.
  ///
  /// In zh, this message translates to:
  /// **'继续保持！你已经完成了一半！'**
  String get ui_auto_return_90150b8f84;

  /// No description provided for @ui_auto_return_90624d92ff.
  ///
  /// In zh, this message translates to:
  /// **'强体力劳动'**
  String get ui_auto_return_90624d92ff;

  /// No description provided for @ui_auto_return_945efd24eb.
  ///
  /// In zh, this message translates to:
  /// **'几乎不运动'**
  String get ui_auto_return_945efd24eb;

  /// No description provided for @ui_auto_return_9636aa6c88.
  ///
  /// In zh, this message translates to:
  /// **'训练推进'**
  String get ui_auto_return_9636aa6c88;

  /// No description provided for @ui_auto_return_9709fc1814.
  ///
  /// In zh, this message translates to:
  /// **'血糖下降'**
  String get ui_auto_return_9709fc1814;

  /// No description provided for @ui_auto_return_9c50f7da20.
  ///
  /// In zh, this message translates to:
  /// **'高度关注'**
  String get ui_auto_return_9c50f7da20;

  /// No description provided for @ui_auto_return_9cca4adc21.
  ///
  /// In zh, this message translates to:
  /// **'继续恢复，下一组马上开始'**
  String get ui_auto_return_9cca4adc21;

  /// No description provided for @ui_auto_return_9d675a3344.
  ///
  /// In zh, this message translates to:
  /// **'糟糕'**
  String get ui_auto_return_9d675a3344;

  /// No description provided for @ui_auto_return_9e2fcbe01e.
  ///
  /// In zh, this message translates to:
  /// **'这份计划更看重连续性和恢复，不会一开始就把配速和时长拉得太满。'**
  String get ui_auto_return_9e2fcbe01e;

  /// No description provided for @ui_auto_return_9f39c66407.
  ///
  /// In zh, this message translates to:
  /// **'餐前'**
  String get ui_auto_return_9f39c66407;

  /// No description provided for @ui_auto_return_a27dc5ee7f.
  ///
  /// In zh, this message translates to:
  /// **'长椅辅助'**
  String get ui_auto_return_a27dc5ee7f;

  /// No description provided for @ui_auto_return_a3f9afcc4a.
  ///
  /// In zh, this message translates to:
  /// **'弹力带'**
  String get ui_auto_return_a3f9afcc4a;

  /// No description provided for @ui_auto_return_a5dd7463a7.
  ///
  /// In zh, this message translates to:
  /// **'上臀围'**
  String get ui_auto_return_a5dd7463a7;

  /// No description provided for @ui_auto_return_a786e00c2e.
  ///
  /// In zh, this message translates to:
  /// **'先按推、拉、腿的节奏把力量训练排开，既能感受到训练感，也更容易坚持。'**
  String get ui_auto_return_a786e00c2e;

  /// No description provided for @ui_auto_return_abd4f121c8.
  ///
  /// In zh, this message translates to:
  /// **'提升耐力'**
  String get ui_auto_return_abd4f121c8;

  /// No description provided for @ui_auto_return_adc2f3b438.
  ///
  /// In zh, this message translates to:
  /// **'稳步提升'**
  String get ui_auto_return_adc2f3b438;

  /// No description provided for @ui_auto_return_b0876f1470.
  ///
  /// In zh, this message translates to:
  /// **'以心肺和连续运动时长为主，不急着拉太高强度，先把续航做出来。'**
  String get ui_auto_return_b0876f1470;

  /// No description provided for @ui_auto_return_b16c321e24.
  ///
  /// In zh, this message translates to:
  /// **'需改善'**
  String get ui_auto_return_b16c321e24;

  /// No description provided for @ui_auto_return_b3bd3d4322.
  ///
  /// In zh, this message translates to:
  /// **'轻微'**
  String get ui_auto_return_b3bd3d4322;

  /// No description provided for @ui_auto_return_b56976385d.
  ///
  /// In zh, this message translates to:
  /// **'低风险'**
  String get ui_auto_return_b56976385d;

  /// No description provided for @ui_auto_return_b6080f70ae.
  ///
  /// In zh, this message translates to:
  /// **'上升趋势'**
  String get ui_auto_return_b6080f70ae;

  /// No description provided for @ui_auto_return_b7eb5030e4.
  ///
  /// In zh, this message translates to:
  /// **'今天练过'**
  String get ui_auto_return_b7eb5030e4;

  /// No description provided for @ui_auto_return_bc413e4d48.
  ///
  /// In zh, this message translates to:
  /// **'餐后'**
  String get ui_auto_return_bc413e4d48;

  /// No description provided for @ui_auto_return_c08ed90d8c.
  ///
  /// In zh, this message translates to:
  /// **'优秀'**
  String get ui_auto_return_c08ed90d8c;

  /// No description provided for @ui_auto_return_c195df6308.
  ///
  /// In zh, this message translates to:
  /// **'异常'**
  String get ui_auto_return_c195df6308;

  /// No description provided for @ui_auto_return_c2d670ba1d.
  ///
  /// In zh, this message translates to:
  /// **'中度关注'**
  String get ui_auto_return_c2d670ba1d;

  /// No description provided for @ui_auto_return_c385f61608.
  ///
  /// In zh, this message translates to:
  /// **'已暂停 · 准备阶段'**
  String get ui_auto_return_c385f61608;

  /// No description provided for @ui_auto_return_c691c57a22.
  ///
  /// In zh, this message translates to:
  /// **'分享上传'**
  String get ui_auto_return_c691c57a22;

  /// No description provided for @ui_auto_return_ca27b7bc75.
  ///
  /// In zh, this message translates to:
  /// **'任务列表'**
  String get ui_auto_return_ca27b7bc75;

  /// No description provided for @ui_auto_return_cb0ed5ef5f.
  ///
  /// In zh, this message translates to:
  /// **'紧急'**
  String get ui_auto_return_cb0ed5ef5f;

  /// No description provided for @ui_auto_return_cb28af4f7d.
  ///
  /// In zh, this message translates to:
  /// **'所选时间段'**
  String get ui_auto_return_cb28af4f7d;

  /// No description provided for @ui_auto_return_ce9820e8fc.
  ///
  /// In zh, this message translates to:
  /// **'重新进入准备状态'**
  String get ui_auto_return_ce9820e8fc;

  /// No description provided for @ui_auto_return_d108d00445.
  ///
  /// In zh, this message translates to:
  /// **'血压升高'**
  String get ui_auto_return_d108d00445;

  /// No description provided for @ui_auto_return_d622b6431c.
  ///
  /// In zh, this message translates to:
  /// **'修改用户信息'**
  String get ui_auto_return_d622b6431c;

  /// No description provided for @ui_auto_return_d910698a4c.
  ///
  /// In zh, this message translates to:
  /// **'邀请好友列表'**
  String get ui_auto_return_d910698a4c;

  /// No description provided for @ui_auto_return_de8ba4bf6e.
  ///
  /// In zh, this message translates to:
  /// **'臀腿下肢'**
  String get ui_auto_return_de8ba4bf6e;

  /// No description provided for @ui_auto_return_def2f47326.
  ///
  /// In zh, this message translates to:
  /// **'随机金币列表'**
  String get ui_auto_return_def2f47326;

  /// No description provided for @ui_auto_return_e1c2b56da0.
  ///
  /// In zh, this message translates to:
  /// **'这份计划重点是长期可持续，让运动成为日常的一部分，而不是临时冲刺。'**
  String get ui_auto_return_e1c2b56da0;

  /// No description provided for @ui_auto_return_e51dd8297b.
  ///
  /// In zh, this message translates to:
  /// **'相对稳定'**
  String get ui_auto_return_e51dd8297b;

  /// No description provided for @ui_auto_return_e82a8ff5d3.
  ///
  /// In zh, this message translates to:
  /// **'同步步数'**
  String get ui_auto_return_e82a8ff5d3;

  /// No description provided for @ui_auto_return_e903d4db06.
  ///
  /// In zh, this message translates to:
  /// **'已暂停 · 组间休息中'**
  String get ui_auto_return_e903d4db06;

  /// No description provided for @ui_auto_return_e969467d2a.
  ///
  /// In zh, this message translates to:
  /// **'糖尿病范围'**
  String get ui_auto_return_e969467d2a;

  /// No description provided for @ui_auto_return_eadd05ba6a.
  ///
  /// In zh, this message translates to:
  /// **'中等'**
  String get ui_auto_return_eadd05ba6a;

  /// No description provided for @ui_auto_return_eb3dc8827d.
  ///
  /// In zh, this message translates to:
  /// **'厘米'**
  String get ui_auto_return_eb3dc8827d;

  /// No description provided for @ui_auto_return_ee5c3b1c3b.
  ///
  /// In zh, this message translates to:
  /// **'紧急异常'**
  String get ui_auto_return_ee5c3b1c3b;

  /// No description provided for @ui_auto_return_f0c7ca8e1e.
  ///
  /// In zh, this message translates to:
  /// **'近一周'**
  String get ui_auto_return_f0c7ca8e1e;

  /// No description provided for @ui_auto_return_f14e998bfa.
  ///
  /// In zh, this message translates to:
  /// **'需要重点关注'**
  String get ui_auto_return_f14e998bfa;

  /// No description provided for @ui_auto_return_f1d4ff50f3.
  ///
  /// In zh, this message translates to:
  /// **'自定义'**
  String get ui_auto_return_f1d4ff50f3;

  /// No description provided for @ui_auto_return_f5550b13ef.
  ///
  /// In zh, this message translates to:
  /// **'轻度提醒'**
  String get ui_auto_return_f5550b13ef;

  /// No description provided for @ui_auto_return_f5551e8b0a.
  ///
  /// In zh, this message translates to:
  /// **'昨天练过'**
  String get ui_auto_return_f5551e8b0a;

  /// No description provided for @ui_auto_return_f7b4e955b1.
  ///
  /// In zh, this message translates to:
  /// **'高血压2期'**
  String get ui_auto_return_f7b4e955b1;

  /// No description provided for @ui_auto_return_fa0203f425.
  ///
  /// In zh, this message translates to:
  /// **'综合评分（满分100）\\n当前状态良好，继续保持'**
  String get ui_auto_return_fa0203f425;

  /// No description provided for @ui_auto_return_fa11f8c07c.
  ///
  /// In zh, this message translates to:
  /// **'进阶'**
  String get ui_auto_return_fa11f8c07c;

  /// No description provided for @ui_auto_return_fad5015c5c.
  ///
  /// In zh, this message translates to:
  /// **'需要关注'**
  String get ui_auto_return_fad5015c5c;

  /// No description provided for @ui_auto_return_fae056648d.
  ///
  /// In zh, this message translates to:
  /// **'血糖上升'**
  String get ui_auto_return_fae056648d;

  /// No description provided for @ui_auto_return_fb0f345856.
  ///
  /// In zh, this message translates to:
  /// **'身体概况'**
  String get ui_auto_return_fb0f345856;

  /// No description provided for @ui_auto_return_fb139d778f.
  ///
  /// In zh, this message translates to:
  /// **'强度运动、长时间运动或体力劳动'**
  String get ui_auto_return_fb139d778f;

  /// No description provided for @ui_auto_return_fe0e8bf768.
  ///
  /// In zh, this message translates to:
  /// **'注册'**
  String get ui_auto_return_fe0e8bf768;

  /// No description provided for @ui_auto_return_fe14e21a5d.
  ///
  /// In zh, this message translates to:
  /// **'灵活恢复'**
  String get ui_auto_return_fe14e21a5d;

  /// No description provided for @ui_auto_return_ffb0da9e7c.
  ///
  /// In zh, this message translates to:
  /// **'血压波动较大'**
  String get ui_auto_return_ffb0da9e7c;

  /// No description provided for @ui_auto_settext_0050bd5b5f.
  ///
  /// In zh, this message translates to:
  /// **'趋势统计 &gt;'**
  String get ui_auto_settext_0050bd5b5f;

  /// No description provided for @ui_auto_settext_01e13bc33f.
  ///
  /// In zh, this message translates to:
  /// **'屏息'**
  String get ui_auto_settext_01e13bc33f;

  /// No description provided for @ui_auto_settext_026c7d7f64.
  ///
  /// In zh, this message translates to:
  /// **'步数目标'**
  String get ui_auto_settext_026c7d7f64;

  /// No description provided for @ui_auto_settext_042fd7f260.
  ///
  /// In zh, this message translates to:
  /// **'开启权限'**
  String get ui_auto_settext_042fd7f260;

  /// No description provided for @ui_auto_settext_083a6661e0.
  ///
  /// In zh, this message translates to:
  /// **'更多运动'**
  String get ui_auto_settext_083a6661e0;

  /// No description provided for @ui_auto_settext_08806ea315.
  ///
  /// In zh, this message translates to:
  /// **'总览'**
  String get ui_auto_settext_08806ea315;

  /// No description provided for @ui_auto_settext_095e938e2a.
  ///
  /// In zh, this message translates to:
  /// **'停止'**
  String get ui_auto_settext_095e938e2a;

  /// No description provided for @ui_auto_settext_0a9ccf7dc0.
  ///
  /// In zh, this message translates to:
  /// **'今日已完成'**
  String get ui_auto_settext_0a9ccf7dc0;

  /// No description provided for @ui_auto_settext_0bffc62bb3.
  ///
  /// In zh, this message translates to:
  /// **'网络错误'**
  String get ui_auto_settext_0bffc62bb3;

  /// No description provided for @ui_auto_settext_121f4b0dae.
  ///
  /// In zh, this message translates to:
  /// **'身体数据概览'**
  String get ui_auto_settext_121f4b0dae;

  /// No description provided for @ui_auto_settext_1622dc9b6b.
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get ui_auto_settext_1622dc9b6b;

  /// No description provided for @ui_auto_settext_175e141184.
  ///
  /// In zh, this message translates to:
  /// **'选择食物'**
  String get ui_auto_settext_175e141184;

  /// No description provided for @ui_auto_settext_1761529cd9.
  ///
  /// In zh, this message translates to:
  /// **'心情统计'**
  String get ui_auto_settext_1761529cd9;

  /// No description provided for @ui_auto_settext_1951a4400c.
  ///
  /// In zh, this message translates to:
  /// **'📉 下降趋势'**
  String get ui_auto_settext_1951a4400c;

  /// No description provided for @ui_auto_settext_1b6b943d3e.
  ///
  /// In zh, this message translates to:
  /// **'HRV一般'**
  String get ui_auto_settext_1b6b943d3e;

  /// No description provided for @ui_auto_settext_1c56d8c5aa.
  ///
  /// In zh, this message translates to:
  /// **'注册失败'**
  String get ui_auto_settext_1c56d8c5aa;

  /// No description provided for @ui_auto_settext_1ce65a4d22.
  ///
  /// In zh, this message translates to:
  /// **'账号覆盖提示'**
  String get ui_auto_settext_1ce65a4d22;

  /// No description provided for @ui_auto_settext_1ede6f42ae.
  ///
  /// In zh, this message translates to:
  /// **'编辑运动记录'**
  String get ui_auto_settext_1ede6f42ae;

  /// No description provided for @ui_auto_settext_1fd1d7f524.
  ///
  /// In zh, this message translates to:
  /// **'健身动作库'**
  String get ui_auto_settext_1fd1d7f524;

  /// No description provided for @ui_auto_settext_23c9bc4d87.
  ///
  /// In zh, this message translates to:
  /// **'昨日'**
  String get ui_auto_settext_23c9bc4d87;

  /// No description provided for @ui_auto_settext_27ca568be2.
  ///
  /// In zh, this message translates to:
  /// **'继续'**
  String get ui_auto_settext_27ca568be2;

  /// No description provided for @ui_auto_settext_296304f1e5.
  ///
  /// In zh, this message translates to:
  /// **'今日'**
  String get ui_auto_settext_296304f1e5;

  /// No description provided for @ui_auto_settext_2d82e6718d.
  ///
  /// In zh, this message translates to:
  /// **'已完成本轮练习'**
  String get ui_auto_settext_2d82e6718d;

  /// No description provided for @ui_auto_settext_2de6425f4d.
  ///
  /// In zh, this message translates to:
  /// **'尚未运动'**
  String get ui_auto_settext_2de6425f4d;

  /// No description provided for @ui_auto_settext_307dd9d6df.
  ///
  /// In zh, this message translates to:
  /// **'尚未达成'**
  String get ui_auto_settext_307dd9d6df;

  /// No description provided for @ui_auto_settext_3098a5ce4f.
  ///
  /// In zh, this message translates to:
  /// **'本次热量'**
  String get ui_auto_settext_3098a5ce4f;

  /// No description provided for @ui_auto_settext_32e720d9ab.
  ///
  /// In zh, this message translates to:
  /// **'未设置训练计划'**
  String get ui_auto_settext_32e720d9ab;

  /// No description provided for @ui_auto_settext_3382654a2d.
  ///
  /// In zh, this message translates to:
  /// **'室外跑步'**
  String get ui_auto_settext_3382654a2d;

  /// No description provided for @ui_auto_settext_34a72046cc.
  ///
  /// In zh, this message translates to:
  /// **'喝水日记'**
  String get ui_auto_settext_34a72046cc;

  /// No description provided for @ui_auto_settext_351e35c899.
  ///
  /// In zh, this message translates to:
  /// **'总消耗'**
  String get ui_auto_settext_351e35c899;

  /// No description provided for @ui_auto_settext_381300584f.
  ///
  /// In zh, this message translates to:
  /// **'运动排行榜'**
  String get ui_auto_settext_381300584f;

  /// No description provided for @ui_auto_settext_3b23be1873.
  ///
  /// In zh, this message translates to:
  /// **'1局'**
  String get ui_auto_settext_3b23be1873;

  /// No description provided for @ui_auto_settext_3eaac754ec.
  ///
  /// In zh, this message translates to:
  /// **'时速(km/h)'**
  String get ui_auto_settext_3eaac754ec;

  /// No description provided for @ui_auto_settext_3ff901bb94.
  ///
  /// In zh, this message translates to:
  /// **'最近一周没有一天步数达标哦！'**
  String get ui_auto_settext_3ff901bb94;

  /// No description provided for @ui_auto_settext_40d2b84573.
  ///
  /// In zh, this message translates to:
  /// **'混音盘为空，请点击上方图标添加声音'**
  String get ui_auto_settext_40d2b84573;

  /// No description provided for @ui_auto_settext_45600acbf1.
  ///
  /// In zh, this message translates to:
  /// **'个人记录!'**
  String get ui_auto_settext_45600acbf1;

  /// No description provided for @ui_auto_settext_48ac479789.
  ///
  /// In zh, this message translates to:
  /// **'当前'**
  String get ui_auto_settext_48ac479789;

  /// No description provided for @ui_auto_settext_4b1931d4e4.
  ///
  /// In zh, this message translates to:
  /// **'1 组'**
  String get ui_auto_settext_4b1931d4e4;

  /// No description provided for @ui_auto_settext_4eb19ee1b0.
  ///
  /// In zh, this message translates to:
  /// **'立即体验'**
  String get ui_auto_settext_4eb19ee1b0;

  /// No description provided for @ui_auto_settext_5130cd5086.
  ///
  /// In zh, this message translates to:
  /// **'最近一周没有一天步数达标，继续加油哦！'**
  String get ui_auto_settext_5130cd5086;

  /// No description provided for @ui_auto_settext_51af880f25.
  ///
  /// In zh, this message translates to:
  /// **'你有正在下载安装的任务没有完成，是否继续？'**
  String get ui_auto_settext_51af880f25;

  /// No description provided for @ui_auto_settext_5467a21410.
  ///
  /// In zh, this message translates to:
  /// **'服务运行正常：正在后台监听步数中'**
  String get ui_auto_settext_5467a21410;

  /// No description provided for @ui_auto_settext_5a6f8404a6.
  ///
  /// In zh, this message translates to:
  /// **'本次得分'**
  String get ui_auto_settext_5a6f8404a6;

  /// No description provided for @ui_auto_settext_5f8dc0ce07.
  ///
  /// In zh, this message translates to:
  /// **'稍后重新尝试'**
  String get ui_auto_settext_5f8dc0ce07;

  /// No description provided for @ui_auto_settext_611f266873.
  ///
  /// In zh, this message translates to:
  /// **'步/天'**
  String get ui_auto_settext_611f266873;

  /// No description provided for @ui_auto_settext_61ad98ddbe.
  ///
  /// In zh, this message translates to:
  /// **'分钟/天'**
  String get ui_auto_settext_61ad98ddbe;

  /// No description provided for @ui_auto_settext_637e171533.
  ///
  /// In zh, this message translates to:
  /// **'体重日历'**
  String get ui_auto_settext_637e171533;

  /// No description provided for @ui_auto_settext_65a8d79f83.
  ///
  /// In zh, this message translates to:
  /// **'本次时长'**
  String get ui_auto_settext_65a8d79f83;

  /// No description provided for @ui_auto_settext_6bae563936.
  ///
  /// In zh, this message translates to:
  /// **'编辑饮食记录'**
  String get ui_auto_settext_6bae563936;

  /// No description provided for @ui_auto_settext_72fa7c88b7.
  ///
  /// In zh, this message translates to:
  /// **'分析'**
  String get ui_auto_settext_72fa7c88b7;

  /// No description provided for @ui_auto_settext_750f2dc7b2.
  ///
  /// In zh, this message translates to:
  /// **'今天建议做低强度放松，给后续训练腾出恢复空间。'**
  String get ui_auto_settext_750f2dc7b2;

  /// No description provided for @ui_auto_settext_7605539297.
  ///
  /// In zh, this message translates to:
  /// **'体重记录'**
  String get ui_auto_settext_7605539297;

  /// No description provided for @ui_auto_settext_7f7c7dcf89.
  ///
  /// In zh, this message translates to:
  /// **'再来一次'**
  String get ui_auto_settext_7f7c7dcf89;

  /// No description provided for @ui_auto_settext_80e55391ce.
  ///
  /// In zh, this message translates to:
  /// **'约 60'**
  String get ui_auto_settext_80e55391ce;

  /// No description provided for @ui_auto_settext_83427e16b5.
  ///
  /// In zh, this message translates to:
  /// **'返回动作库'**
  String get ui_auto_settext_83427e16b5;

  /// No description provided for @ui_auto_settext_8a070ffdb2.
  ///
  /// In zh, this message translates to:
  /// **'暂无饮食记录'**
  String get ui_auto_settext_8a070ffdb2;

  /// No description provided for @ui_auto_settext_8a8df3bb6f.
  ///
  /// In zh, this message translates to:
  /// **'血糖变化趋势'**
  String get ui_auto_settext_8a8df3bb6f;

  /// No description provided for @ui_auto_settext_8dc3844129.
  ///
  /// In zh, this message translates to:
  /// **'千卡/天'**
  String get ui_auto_settext_8dc3844129;

  /// No description provided for @ui_auto_settext_92da267ec4.
  ///
  /// In zh, this message translates to:
  /// **'当天步数目标已达成，请继续加油哦！'**
  String get ui_auto_settext_92da267ec4;

  /// No description provided for @ui_auto_settext_93162c388a.
  ///
  /// In zh, this message translates to:
  /// **'平均每日消耗'**
  String get ui_auto_settext_93162c388a;

  /// No description provided for @ui_auto_settext_9377bdb218.
  ///
  /// In zh, this message translates to:
  /// **'已解锁'**
  String get ui_auto_settext_9377bdb218;

  /// No description provided for @ui_auto_settext_96c9c629a1.
  ///
  /// In zh, this message translates to:
  /// **'睡眠统计'**
  String get ui_auto_settext_96c9c629a1;

  /// No description provided for @ui_auto_settext_9b1259da82.
  ///
  /// In zh, this message translates to:
  /// **'公里'**
  String get ui_auto_settext_9b1259da82;

  /// No description provided for @ui_auto_settext_9cb4f069f5.
  ///
  /// In zh, this message translates to:
  /// **'添加一条身体成分数据'**
  String get ui_auto_settext_9cb4f069f5;

  /// No description provided for @ui_auto_settext_9cc2ec222a.
  ///
  /// In zh, this message translates to:
  /// **'暂无趋势图，添加心率后自动生成'**
  String get ui_auto_settext_9cc2ec222a;

  /// No description provided for @ui_auto_settext_9d007233b0.
  ///
  /// In zh, this message translates to:
  /// **'情绪状态'**
  String get ui_auto_settext_9d007233b0;

  /// No description provided for @ui_auto_settext_9d44a3879f.
  ///
  /// In zh, this message translates to:
  /// **'本次训练量'**
  String get ui_auto_settext_9d44a3879f;

  /// No description provided for @ui_auto_settext_9de0d246a9.
  ///
  /// In zh, this message translates to:
  /// **'米'**
  String get ui_auto_settext_9de0d246a9;

  /// No description provided for @ui_auto_settext_9e5ffa068e.
  ///
  /// In zh, this message translates to:
  /// **'基本信息'**
  String get ui_auto_settext_9e5ffa068e;

  /// No description provided for @ui_auto_settext_a103c5d353.
  ///
  /// In zh, this message translates to:
  /// **'120金币'**
  String get ui_auto_settext_a103c5d353;

  /// No description provided for @ui_auto_settext_a4955af0c9.
  ///
  /// In zh, this message translates to:
  /// **'体重稳定'**
  String get ui_auto_settext_a4955af0c9;

  /// No description provided for @ui_auto_settext_a6c7d9b36f.
  ///
  /// In zh, this message translates to:
  /// **'趋势模式'**
  String get ui_auto_settext_a6c7d9b36f;

  /// No description provided for @ui_auto_settext_a7c26800a8.
  ///
  /// In zh, this message translates to:
  /// **'管理系统权限'**
  String get ui_auto_settext_a7c26800a8;

  /// No description provided for @ui_auto_settext_a8b0c20416.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get ui_auto_settext_a8b0c20416;

  /// No description provided for @ui_auto_settext_aa9e192981.
  ///
  /// In zh, this message translates to:
  /// **'运动目标设置'**
  String get ui_auto_settext_aa9e192981;

  /// No description provided for @ui_auto_settext_ac50dadaeb.
  ///
  /// In zh, this message translates to:
  /// **'微信已绑定其他账号，登录将清空并覆盖本地数据，是否继续？'**
  String get ui_auto_settext_ac50dadaeb;

  /// No description provided for @ui_auto_settext_adc32002ac.
  ///
  /// In zh, this message translates to:
  /// **'力量训练'**
  String get ui_auto_settext_adc32002ac;

  /// No description provided for @ui_auto_settext_b2217d8bcd.
  ///
  /// In zh, this message translates to:
  /// **'米/天'**
  String get ui_auto_settext_b2217d8bcd;

  /// No description provided for @ui_auto_settext_b3d6debc0e.
  ///
  /// In zh, this message translates to:
  /// **'暂无趋势图，添加血压后自动生成'**
  String get ui_auto_settext_b3d6debc0e;

  /// No description provided for @ui_auto_settext_b450d1dbea.
  ///
  /// In zh, this message translates to:
  /// **'运动能力分析'**
  String get ui_auto_settext_b450d1dbea;

  /// No description provided for @ui_auto_settext_b7ef28cc5e.
  ///
  /// In zh, this message translates to:
  /// **'体重变化趋势'**
  String get ui_auto_settext_b7ef28cc5e;

  /// No description provided for @ui_auto_settext_b9db8476ee.
  ///
  /// In zh, this message translates to:
  /// **'暂无记录'**
  String get ui_auto_settext_b9db8476ee;

  /// No description provided for @ui_auto_settext_ba4b5ed1ab.
  ///
  /// In zh, this message translates to:
  /// **'今'**
  String get ui_auto_settext_ba4b5ed1ab;

  /// No description provided for @ui_auto_settext_bdf040d84d.
  ///
  /// In zh, this message translates to:
  /// **'室内跑步'**
  String get ui_auto_settext_bdf040d84d;

  /// No description provided for @ui_auto_settext_c0397ade9e.
  ///
  /// In zh, this message translates to:
  /// **'选择归属地'**
  String get ui_auto_settext_c0397ade9e;

  /// No description provided for @ui_auto_settext_c72b05b689.
  ///
  /// In zh, this message translates to:
  /// **'暂无趋势图，添加血糖后自动生成'**
  String get ui_auto_settext_c72b05b689;

  /// No description provided for @ui_auto_settext_c78b865070.
  ///
  /// In zh, this message translates to:
  /// **'退出提示'**
  String get ui_auto_settext_c78b865070;

  /// No description provided for @ui_auto_settext_c827d8dbb7.
  ///
  /// In zh, this message translates to:
  /// **'历史'**
  String get ui_auto_settext_c827d8dbb7;

  /// No description provided for @ui_auto_settext_c877db470b.
  ///
  /// In zh, this message translates to:
  /// **'网络不畅，请检查当前网络是否正常连接，重新连接。'**
  String get ui_auto_settext_c877db470b;

  /// No description provided for @ui_auto_settext_c931fd73fa.
  ///
  /// In zh, this message translates to:
  /// **'历史轨迹'**
  String get ui_auto_settext_c931fd73fa;

  /// No description provided for @ui_auto_settext_c99d9de34c.
  ///
  /// In zh, this message translates to:
  /// **'动作详情'**
  String get ui_auto_settext_c99d9de34c;

  /// No description provided for @ui_auto_settext_cab5c3401c.
  ///
  /// In zh, this message translates to:
  /// **'无HRV数据'**
  String get ui_auto_settext_cab5c3401c;

  /// No description provided for @ui_auto_settext_cb58e8f54c.
  ///
  /// In zh, this message translates to:
  /// **'停留'**
  String get ui_auto_settext_cb58e8f54c;

  /// No description provided for @ui_auto_settext_cb940a4be6.
  ///
  /// In zh, this message translates to:
  /// **'0天'**
  String get ui_auto_settext_cb940a4be6;

  /// No description provided for @ui_auto_settext_cc5b9ae9e9.
  ///
  /// In zh, this message translates to:
  /// **'配速(/100m)'**
  String get ui_auto_settext_cc5b9ae9e9;

  /// No description provided for @ui_auto_settext_cc79f33387.
  ///
  /// In zh, this message translates to:
  /// **'体重目标'**
  String get ui_auto_settext_cc79f33387;

  /// No description provided for @ui_auto_settext_ce26955a3c.
  ///
  /// In zh, this message translates to:
  /// **'知道了'**
  String get ui_auto_settext_ce26955a3c;

  /// No description provided for @ui_auto_settext_d09504750e.
  ///
  /// In zh, this message translates to:
  /// **'图表'**
  String get ui_auto_settext_d09504750e;

  /// No description provided for @ui_auto_settext_d272fce633.
  ///
  /// In zh, this message translates to:
  /// **'HRV偏低'**
  String get ui_auto_settext_d272fce633;

  /// No description provided for @ui_auto_settext_d54dbb4070.
  ///
  /// In zh, this message translates to:
  /// **'血压监测趋势'**
  String get ui_auto_settext_d54dbb4070;

  /// No description provided for @ui_auto_settext_d6425bd4e9.
  ///
  /// In zh, this message translates to:
  /// **'饮食记录'**
  String get ui_auto_settext_d6425bd4e9;

  /// No description provided for @ui_auto_settext_d7656a6524.
  ///
  /// In zh, this message translates to:
  /// **'统计'**
  String get ui_auto_settext_d7656a6524;

  /// No description provided for @ui_auto_settext_dbad0af540.
  ///
  /// In zh, this message translates to:
  /// **'昨晚'**
  String get ui_auto_settext_dbad0af540;

  /// No description provided for @ui_auto_settext_ded8fd2493.
  ///
  /// In zh, this message translates to:
  /// **'📈 上升趋势'**
  String get ui_auto_settext_ded8fd2493;

  /// No description provided for @ui_auto_settext_e0dc0736fb.
  ///
  /// In zh, this message translates to:
  /// **'围度'**
  String get ui_auto_settext_e0dc0736fb;

  /// No description provided for @ui_auto_settext_e25a8523aa.
  ///
  /// In zh, this message translates to:
  /// **'HRV良好'**
  String get ui_auto_settext_e25a8523aa;

  /// No description provided for @ui_auto_settext_e487278310.
  ///
  /// In zh, this message translates to:
  /// **'心率变异性分析'**
  String get ui_auto_settext_e487278310;

  /// No description provided for @ui_auto_settext_e68c51c236.
  ///
  /// In zh, this message translates to:
  /// **'次/天'**
  String get ui_auto_settext_e68c51c236;

  /// No description provided for @ui_auto_settext_e8834b2790.
  ///
  /// In zh, this message translates to:
  /// **'恢复日 · 主动放松'**
  String get ui_auto_settext_e8834b2790;

  /// No description provided for @ui_auto_settext_e8a01dca93.
  ///
  /// In zh, this message translates to:
  /// **'上次'**
  String get ui_auto_settext_e8a01dca93;

  /// No description provided for @ui_auto_settext_ea3f7e1252.
  ///
  /// In zh, this message translates to:
  /// **'训练计时'**
  String get ui_auto_settext_ea3f7e1252;

  /// No description provided for @ui_auto_settext_ebd585c58e.
  ///
  /// In zh, this message translates to:
  /// **'⚖️ 平稳趋势'**
  String get ui_auto_settext_ebd585c58e;

  /// No description provided for @ui_auto_settext_ee6d45cd80.
  ///
  /// In zh, this message translates to:
  /// **'喝水小知识'**
  String get ui_auto_settext_ee6d45cd80;

  /// No description provided for @ui_auto_settext_expr_026de1d259.
  ///
  /// In zh, this message translates to:
  /// **'放松修复'**
  String get ui_auto_settext_expr_026de1d259;

  /// No description provided for @ui_auto_settext_expr_03d4b1e4de.
  ///
  /// In zh, this message translates to:
  /// **'共'**
  String get ui_auto_settext_expr_03d4b1e4de;

  /// No description provided for @ui_auto_settext_expr_075c6cbbc4.
  ///
  /// In zh, this message translates to:
  /// **'千卡)'**
  String get ui_auto_settext_expr_075c6cbbc4;

  /// No description provided for @ui_auto_settext_expr_098872f0ca.
  ///
  /// In zh, this message translates to:
  /// **'千卡/100g'**
  String get ui_auto_settext_expr_098872f0ca;

  /// No description provided for @ui_auto_settext_expr_0d29a4f3cb.
  ///
  /// In zh, this message translates to:
  /// **'预计'**
  String get ui_auto_settext_expr_0d29a4f3cb;

  /// No description provided for @ui_auto_settext_expr_0d34237ed5.
  ///
  /// In zh, this message translates to:
  /// **'最近 7 天练了'**
  String get ui_auto_settext_expr_0d34237ed5;

  /// No description provided for @ui_auto_settext_expr_10a9cdab77.
  ///
  /// In zh, this message translates to:
  /// **'开始，先把动作标准度练出来。'**
  String get ui_auto_settext_expr_10a9cdab77;

  /// No description provided for @ui_auto_settext_expr_12c3c7deec.
  ///
  /// In zh, this message translates to:
  /// **'训练贴士：'**
  String get ui_auto_settext_expr_12c3c7deec;

  /// No description provided for @ui_auto_settext_expr_1445f8419c.
  ///
  /// In zh, this message translates to:
  /// **'连续签到'**
  String get ui_auto_settext_expr_1445f8419c;

  /// No description provided for @ui_auto_settext_expr_190f2fba12.
  ///
  /// In zh, this message translates to:
  /// **'种运动'**
  String get ui_auto_settext_expr_190f2fba12;

  /// No description provided for @ui_auto_settext_expr_2280628083.
  ///
  /// In zh, this message translates to:
  /// **'分钟'**
  String get ui_auto_settext_expr_2280628083;

  /// No description provided for @ui_auto_settext_expr_23e8bba360.
  ///
  /// In zh, this message translates to:
  /// **'千卡'**
  String get ui_auto_settext_expr_23e8bba360;

  /// No description provided for @ui_auto_settext_expr_270c0afaed.
  ///
  /// In zh, this message translates to:
  /// **'MM月dd日 HH时mm分'**
  String get ui_auto_settext_expr_270c0afaed;

  /// No description provided for @ui_auto_settext_expr_2a33020e5b.
  ///
  /// In zh, this message translates to:
  /// **'保存中...'**
  String get ui_auto_settext_expr_2a33020e5b;

  /// No description provided for @ui_auto_settext_expr_2c09632037.
  ///
  /// In zh, this message translates to:
  /// **'比赛局数'**
  String get ui_auto_settext_expr_2c09632037;

  /// No description provided for @ui_auto_settext_expr_2de0d491d0.
  ///
  /// In zh, this message translates to:
  /// **'小时'**
  String get ui_auto_settext_expr_2de0d491d0;

  /// No description provided for @ui_auto_settext_expr_2fbe048dc9.
  ///
  /// In zh, this message translates to:
  /// **'今日步数：'**
  String get ui_auto_settext_expr_2fbe048dc9;

  /// No description provided for @ui_auto_settext_expr_32bd5b7791.
  ///
  /// In zh, this message translates to:
  /// **'平均: %.0f 次/分'**
  String get ui_auto_settext_expr_32bd5b7791;

  /// No description provided for @ui_auto_settext_expr_34b8e01d10.
  ///
  /// In zh, this message translates to:
  /// **'达成'**
  String get ui_auto_settext_expr_34b8e01d10;

  /// No description provided for @ui_auto_settext_expr_375768d0e2.
  ///
  /// In zh, this message translates to:
  /// **'正在混响:'**
  String get ui_auto_settext_expr_375768d0e2;

  /// No description provided for @ui_auto_settext_expr_375a9bb93d.
  ///
  /// In zh, this message translates to:
  /// **'dd日HH时'**
  String get ui_auto_settext_expr_375a9bb93d;

  /// No description provided for @ui_auto_settext_expr_3a4bf2ca04.
  ///
  /// In zh, this message translates to:
  /// **'%d分'**
  String get ui_auto_settext_expr_3a4bf2ca04;

  /// No description provided for @ui_auto_settext_expr_3c5d185406.
  ///
  /// In zh, this message translates to:
  /// **'个声音)'**
  String get ui_auto_settext_expr_3c5d185406;

  /// No description provided for @ui_auto_settext_expr_3e97f641af.
  ///
  /// In zh, this message translates to:
  /// **'已保存当前进度，下次可以继续补齐'**
  String get ui_auto_settext_expr_3e97f641af;

  /// No description provided for @ui_auto_settext_expr_3ee4f8346a.
  ///
  /// In zh, this message translates to:
  /// **'里程：'**
  String get ui_auto_settext_expr_3ee4f8346a;

  /// No description provided for @ui_auto_settext_expr_3fc066bda0.
  ///
  /// In zh, this message translates to:
  /// **'组准备开始'**
  String get ui_auto_settext_expr_3fc066bda0;

  /// No description provided for @ui_auto_settext_expr_40966af2b9.
  ///
  /// In zh, this message translates to:
  /// **'今日步数:'**
  String get ui_auto_settext_expr_40966af2b9;

  /// No description provided for @ui_auto_settext_expr_41c51524f2.
  ///
  /// In zh, this message translates to:
  /// **'次 /'**
  String get ui_auto_settext_expr_41c51524f2;

  /// No description provided for @ui_auto_settext_expr_4221ac0354.
  ///
  /// In zh, this message translates to:
  /// **'组，休息后进入下一组'**
  String get ui_auto_settext_expr_4221ac0354;

  /// No description provided for @ui_auto_settext_expr_4273806e68.
  ///
  /// In zh, this message translates to:
  /// **'前天'**
  String get ui_auto_settext_expr_4273806e68;

  /// No description provided for @ui_auto_settext_expr_442c6ae209.
  ///
  /// In zh, this message translates to:
  /// **'组'**
  String get ui_auto_settext_expr_442c6ae209;

  /// No description provided for @ui_auto_settext_expr_4449109b18.
  ///
  /// In zh, this message translates to:
  /// **'分钟 / 周 ·'**
  String get ui_auto_settext_expr_4449109b18;

  /// No description provided for @ui_auto_settext_expr_468586c644.
  ///
  /// In zh, this message translates to:
  /// **'平均: %1\$.0f/%2\$.0f'**
  String get ui_auto_settext_expr_468586c644;

  /// No description provided for @ui_auto_settext_expr_4c72faeb40.
  ///
  /// In zh, this message translates to:
  /// **'平均: %1\$.1f %2\$s'**
  String get ui_auto_settext_expr_4c72faeb40;

  /// No description provided for @ui_auto_settext_expr_4d1c5c8107.
  ///
  /// In zh, this message translates to:
  /// **'第'**
  String get ui_auto_settext_expr_4d1c5c8107;

  /// No description provided for @ui_auto_settext_expr_4e690898eb.
  ///
  /// In zh, this message translates to:
  /// **'轨迹'**
  String get ui_auto_settext_expr_4e690898eb;

  /// No description provided for @ui_auto_settext_expr_4eb3ef7e26.
  ///
  /// In zh, this message translates to:
  /// **'%d 千卡'**
  String get ui_auto_settext_expr_4eb3ef7e26;

  /// No description provided for @ui_auto_settext_expr_4f8a02fa50.
  ///
  /// In zh, this message translates to:
  /// **'已解锁'**
  String get ui_auto_settext_expr_4f8a02fa50;

  /// No description provided for @ui_auto_settext_expr_51823a5487.
  ///
  /// In zh, this message translates to:
  /// **'秒'**
  String get ui_auto_settext_expr_51823a5487;

  /// No description provided for @ui_auto_settext_expr_52ddefadd9.
  ///
  /// In zh, this message translates to:
  /// **'步达到目标'**
  String get ui_auto_settext_expr_52ddefadd9;

  /// No description provided for @ui_auto_settext_expr_5ad932355e.
  ///
  /// In zh, this message translates to:
  /// **'昨天'**
  String get ui_auto_settext_expr_5ad932355e;

  /// No description provided for @ui_auto_settext_expr_5ed3652e0c.
  ///
  /// In zh, this message translates to:
  /// **'%d 分钟'**
  String get ui_auto_settext_expr_5ed3652e0c;

  /// No description provided for @ui_auto_settext_expr_620bf82011.
  ///
  /// In zh, this message translates to:
  /// **'记录'**
  String get ui_auto_settext_expr_620bf82011;

  /// No description provided for @ui_auto_settext_expr_6525af5994.
  ///
  /// In zh, this message translates to:
  /// **'yyyy年MM月dd日 HH时mm分'**
  String get ui_auto_settext_expr_6525af5994;

  /// No description provided for @ui_auto_settext_expr_66fc0f5d20.
  ///
  /// In zh, this message translates to:
  /// **'训练组数'**
  String get ui_auto_settext_expr_66fc0f5d20;

  /// No description provided for @ui_auto_settext_expr_6af7053c51.
  ///
  /// In zh, this message translates to:
  /// **'已完成'**
  String get ui_auto_settext_expr_6af7053c51;

  /// No description provided for @ui_auto_settext_expr_6da7f307c1.
  ///
  /// In zh, this message translates to:
  /// **'总运动时长'**
  String get ui_auto_settext_expr_6da7f307c1;

  /// No description provided for @ui_auto_settext_expr_6db932e3e0.
  ///
  /// In zh, this message translates to:
  /// **'计划进度\\n'**
  String get ui_auto_settext_expr_6db932e3e0;

  /// No description provided for @ui_auto_settext_expr_6dc392c8b6.
  ///
  /// In zh, this message translates to:
  /// **'步'**
  String get ui_auto_settext_expr_6dc392c8b6;

  /// No description provided for @ui_auto_settext_expr_6e1bba8ef0.
  ///
  /// In zh, this message translates to:
  /// **'%d 次/分'**
  String get ui_auto_settext_expr_6e1bba8ef0;

  /// No description provided for @ui_auto_settext_expr_70a5a6da4d.
  ///
  /// In zh, this message translates to:
  /// **'· 第'**
  String get ui_auto_settext_expr_70a5a6da4d;

  /// No description provided for @ui_auto_settext_expr_731edaa0a3.
  ///
  /// In zh, this message translates to:
  /// **'内脏脂肪评估:'**
  String get ui_auto_settext_expr_731edaa0a3;

  /// No description provided for @ui_auto_settext_expr_732cb78055.
  ///
  /// In zh, this message translates to:
  /// **'本周步数达标天数'**
  String get ui_auto_settext_expr_732cb78055;

  /// No description provided for @ui_auto_settext_expr_734c8e4512.
  ///
  /// In zh, this message translates to:
  /// **'体重下降'**
  String get ui_auto_settext_expr_734c8e4512;

  /// No description provided for @ui_auto_settext_expr_73fbb26b83.
  ///
  /// In zh, this message translates to:
  /// **'混音已暂停 ('**
  String get ui_auto_settext_expr_73fbb26b83;

  /// No description provided for @ui_auto_settext_expr_74fc6f0fdd.
  ///
  /// In zh, this message translates to:
  /// **'倒计时关闭: %1\$02d:%2\$02d'**
  String get ui_auto_settext_expr_74fc6f0fdd;

  /// No description provided for @ui_auto_settext_expr_768d3586c7.
  ///
  /// In zh, this message translates to:
  /// **'约'**
  String get ui_auto_settext_expr_768d3586c7;

  /// No description provided for @ui_auto_settext_expr_791bc60789.
  ///
  /// In zh, this message translates to:
  /// **'千卡/分钟'**
  String get ui_auto_settext_expr_791bc60789;

  /// No description provided for @ui_auto_settext_expr_7b67add891.
  ///
  /// In zh, this message translates to:
  /// **'%+.1f 公斤'**
  String get ui_auto_settext_expr_7b67add891;

  /// No description provided for @ui_auto_settext_expr_7c782c174b.
  ///
  /// In zh, this message translates to:
  /// **'组'**
  String get ui_auto_settext_expr_7c782c174b;

  /// No description provided for @ui_auto_settext_expr_82d497414c.
  ///
  /// In zh, this message translates to:
  /// **'跟着节奏呼吸，不用着急'**
  String get ui_auto_settext_expr_82d497414c;

  /// No description provided for @ui_auto_settext_expr_84c40939a8.
  ///
  /// In zh, this message translates to:
  /// **'%.1f 公里'**
  String get ui_auto_settext_expr_84c40939a8;

  /// No description provided for @ui_auto_settext_expr_89751b7149.
  ///
  /// In zh, this message translates to:
  /// **'%d 公里'**
  String get ui_auto_settext_expr_89751b7149;

  /// No description provided for @ui_auto_settext_expr_8a579efc2c.
  ///
  /// In zh, this message translates to:
  /// **'主动恢复'**
  String get ui_auto_settext_expr_8a579efc2c;

  /// No description provided for @ui_auto_settext_expr_8caed06f5a.
  ///
  /// In zh, this message translates to:
  /// **'组'**
  String get ui_auto_settext_expr_8caed06f5a;

  /// No description provided for @ui_auto_settext_expr_8d3fbcb21e.
  ///
  /// In zh, this message translates to:
  /// **'，继续完成这项动作能更容易形成稳定训练节奏。'**
  String get ui_auto_settext_expr_8d3fbcb21e;

  /// No description provided for @ui_auto_settext_expr_91be773496.
  ///
  /// In zh, this message translates to:
  /// **'体脂率评估:'**
  String get ui_auto_settext_expr_91be773496;

  /// No description provided for @ui_auto_settext_expr_91d9c7e284.
  ///
  /// In zh, this message translates to:
  /// **'已暂停，准备好后继续'**
  String get ui_auto_settext_expr_91d9c7e284;

  /// No description provided for @ui_auto_settext_expr_93c18999d1.
  ///
  /// In zh, this message translates to:
  /// **'(每100g'**
  String get ui_auto_settext_expr_93c18999d1;

  /// No description provided for @ui_auto_settext_expr_944f943623.
  ///
  /// In zh, this message translates to:
  /// **'1 次呼吸'**
  String get ui_auto_settext_expr_944f943623;

  /// No description provided for @ui_auto_settext_expr_9765f20daf.
  ///
  /// In zh, this message translates to:
  /// **'保持动作标准，完成第'**
  String get ui_auto_settext_expr_9765f20daf;

  /// No description provided for @ui_auto_settext_expr_980ebecc3b.
  ///
  /// In zh, this message translates to:
  /// **'计划会根据你当天状态做小幅调整。'**
  String get ui_auto_settext_expr_980ebecc3b;

  /// No description provided for @ui_auto_settext_expr_9c9917c9a5.
  ///
  /// In zh, this message translates to:
  /// **'体重上升'**
  String get ui_auto_settext_expr_9c9917c9a5;

  /// No description provided for @ui_auto_settext_expr_9cfcd41db8.
  ///
  /// In zh, this message translates to:
  /// **'比赛时长'**
  String get ui_auto_settext_expr_9cfcd41db8;

  /// No description provided for @ui_auto_settext_expr_9f23dd00db.
  ///
  /// In zh, this message translates to:
  /// **'训练完成，但保存记录时出了点问题'**
  String get ui_auto_settext_expr_9f23dd00db;

  /// No description provided for @ui_auto_settext_expr_9f4a723f24.
  ///
  /// In zh, this message translates to:
  /// **'%.1f分'**
  String get ui_auto_settext_expr_9f4a723f24;

  /// No description provided for @ui_auto_settext_expr_a1b490203a.
  ///
  /// In zh, this message translates to:
  /// **'还差'**
  String get ui_auto_settext_expr_a1b490203a;

  /// No description provided for @ui_auto_settext_expr_a75d9a51b3.
  ///
  /// In zh, this message translates to:
  /// **'今天'**
  String get ui_auto_settext_expr_a75d9a51b3;

  /// No description provided for @ui_auto_settext_expr_a80b6b7ff5.
  ///
  /// In zh, this message translates to:
  /// **'基础代谢评估:'**
  String get ui_auto_settext_expr_a80b6b7ff5;

  /// No description provided for @ui_auto_settext_expr_aaa94b14f0.
  ///
  /// In zh, this message translates to:
  /// **'组训练'**
  String get ui_auto_settext_expr_aaa94b14f0;

  /// No description provided for @ui_auto_settext_expr_b06fd0134f.
  ///
  /// In zh, this message translates to:
  /// **'已结束训练，但保存记录时出了点问题'**
  String get ui_auto_settext_expr_b06fd0134f;

  /// No description provided for @ui_auto_settext_expr_b3617d12c7.
  ///
  /// In zh, this message translates to:
  /// **'开始'**
  String get ui_auto_settext_expr_b3617d12c7;

  /// No description provided for @ui_auto_settext_expr_b544c6a4da.
  ///
  /// In zh, this message translates to:
  /// **'个环境音'**
  String get ui_auto_settext_expr_b544c6a4da;

  /// No description provided for @ui_auto_settext_expr_b98da0392e.
  ///
  /// In zh, this message translates to:
  /// **'训练完成，已经为你保存到记录中'**
  String get ui_auto_settext_expr_b98da0392e;

  /// No description provided for @ui_auto_settext_expr_bb503dfbd7.
  ///
  /// In zh, this message translates to:
  /// **'评分说明 ·'**
  String get ui_auto_settext_expr_bb503dfbd7;

  /// No description provided for @ui_auto_settext_expr_bc0bf70bb7.
  ///
  /// In zh, this message translates to:
  /// **'累计签到'**
  String get ui_auto_settext_expr_bc0bf70bb7;

  /// No description provided for @ui_auto_settext_expr_bd8dff4270.
  ///
  /// In zh, this message translates to:
  /// **'历史获得'**
  String get ui_auto_settext_expr_bd8dff4270;

  /// No description provided for @ui_auto_settext_expr_c4c4af0a75.
  ///
  /// In zh, this message translates to:
  /// **'项'**
  String get ui_auto_settext_expr_c4c4af0a75;

  /// No description provided for @ui_auto_settext_expr_d2075bc5a1.
  ///
  /// In zh, this message translates to:
  /// **'%.1f 公斤'**
  String get ui_auto_settext_expr_d2075bc5a1;

  /// No description provided for @ui_auto_settext_expr_d39ad9b33e.
  ///
  /// In zh, this message translates to:
  /// **'分钟 · 放松一下'**
  String get ui_auto_settext_expr_d39ad9b33e;

  /// No description provided for @ui_auto_settext_expr_dc5b716f86.
  ///
  /// In zh, this message translates to:
  /// **'累计'**
  String get ui_auto_settext_expr_dc5b716f86;

  /// No description provided for @ui_auto_settext_expr_ddb046bc7a.
  ///
  /// In zh, this message translates to:
  /// **'编辑心情记录'**
  String get ui_auto_settext_expr_ddb046bc7a;

  /// No description provided for @ui_auto_settext_expr_df80137c14.
  ///
  /// In zh, this message translates to:
  /// **'%d 次'**
  String get ui_auto_settext_expr_df80137c14;

  /// No description provided for @ui_auto_settext_expr_e40cc5cdf5.
  ///
  /// In zh, this message translates to:
  /// **'金币≈'**
  String get ui_auto_settext_expr_e40cc5cdf5;

  /// No description provided for @ui_auto_settext_expr_e5cddafc72.
  ///
  /// In zh, this message translates to:
  /// **'如何获得：'**
  String get ui_auto_settext_expr_e5cddafc72;

  /// No description provided for @ui_auto_settext_expr_ed2ac55a00.
  ///
  /// In zh, this message translates to:
  /// **'天'**
  String get ui_auto_settext_expr_ed2ac55a00;

  /// No description provided for @ui_auto_settext_expr_ee4f4ab9a6.
  ///
  /// In zh, this message translates to:
  /// **'组 / 共'**
  String get ui_auto_settext_expr_ee4f4ab9a6;

  /// No description provided for @ui_auto_settext_expr_f24b607086.
  ///
  /// In zh, this message translates to:
  /// **'运动记录 %d 次'**
  String get ui_auto_settext_expr_f24b607086;

  /// No description provided for @ui_auto_settext_expr_f36c95d450.
  ///
  /// In zh, this message translates to:
  /// **'周'**
  String get ui_auto_settext_expr_f36c95d450;

  /// No description provided for @ui_auto_settext_expr_f87fb0ab9b.
  ///
  /// In zh, this message translates to:
  /// **'训练时长'**
  String get ui_auto_settext_expr_f87fb0ab9b;

  /// No description provided for @ui_auto_settext_expr_f938fee1fe.
  ///
  /// In zh, this message translates to:
  /// **'已完成第'**
  String get ui_auto_settext_expr_f938fee1fe;

  /// No description provided for @ui_auto_settext_expr_fb0984d3bd.
  ///
  /// In zh, this message translates to:
  /// **'进度:'**
  String get ui_auto_settext_expr_fb0984d3bd;

  /// No description provided for @ui_auto_settext_expr_fbd2b1fb73.
  ///
  /// In zh, this message translates to:
  /// **'共'**
  String get ui_auto_settext_expr_fbd2b1fb73;

  /// No description provided for @ui_auto_settext_expr_fd7da79562.
  ///
  /// In zh, this message translates to:
  /// **'建议按'**
  String get ui_auto_settext_expr_fd7da79562;

  /// No description provided for @ui_auto_settext_expr_fe7dc19c93.
  ///
  /// In zh, this message translates to:
  /// **'次，累计'**
  String get ui_auto_settext_expr_fe7dc19c93;

  /// No description provided for @ui_auto_settext_f0b2194fca.
  ///
  /// In zh, this message translates to:
  /// **'未开启权限：无法获取第三方手环数据'**
  String get ui_auto_settext_f0b2194fca;

  /// No description provided for @ui_auto_settext_f1438dba95.
  ///
  /// In zh, this message translates to:
  /// **'本次距离'**
  String get ui_auto_settext_f1438dba95;

  /// No description provided for @ui_auto_settext_f1f989e8cb.
  ///
  /// In zh, this message translates to:
  /// **'未完成任务提示'**
  String get ui_auto_settext_f1f989e8cb;

  /// No description provided for @ui_auto_settext_f411d0f1f9.
  ///
  /// In zh, this message translates to:
  /// **'说明'**
  String get ui_auto_settext_f411d0f1f9;

  /// No description provided for @ui_auto_settext_f449961589.
  ///
  /// In zh, this message translates to:
  /// **'呼气'**
  String get ui_auto_settext_f449961589;

  /// No description provided for @ui_auto_settext_f74578e8ed.
  ///
  /// In zh, this message translates to:
  /// **'这一轮已经完成，慢慢回到日常节奏'**
  String get ui_auto_settext_f74578e8ed;

  /// No description provided for @ui_auto_settext_f79d949400.
  ///
  /// In zh, this message translates to:
  /// **'还没有这项动作的训练记录，今天完成一次就会开始累计你的节奏。'**
  String get ui_auto_settext_f79d949400;

  /// No description provided for @ui_auto_settext_f899b800f8.
  ///
  /// In zh, this message translates to:
  /// **'轨迹追踪'**
  String get ui_auto_settext_f899b800f8;

  /// No description provided for @ui_auto_settext_f920ed4b43.
  ///
  /// In zh, this message translates to:
  /// **'编辑喝水记录'**
  String get ui_auto_settext_f920ed4b43;

  /// No description provided for @ui_auto_settext_f96eeb093c.
  ///
  /// In zh, this message translates to:
  /// **'距离目标'**
  String get ui_auto_settext_f96eeb093c;

  /// No description provided for @ui_auto_settext_fad5222ca0.
  ///
  /// In zh, this message translates to:
  /// **'已完成'**
  String get ui_auto_settext_fad5222ca0;

  /// No description provided for @ui_auto_settext_fafd698b3f.
  ///
  /// In zh, this message translates to:
  /// **'000金币'**
  String get ui_auto_settext_fafd698b3f;

  /// No description provided for @ui_auto_settext_fb0833fd64.
  ///
  /// In zh, this message translates to:
  /// **'热量目标'**
  String get ui_auto_settext_fb0833fd64;

  /// No description provided for @ui_auto_settext_fbf93809e9.
  ///
  /// In zh, this message translates to:
  /// **'今天不安排高强度'**
  String get ui_auto_settext_fbf93809e9;

  /// No description provided for @ui_auto_settext_fc94ff94f0.
  ///
  /// In zh, this message translates to:
  /// **'已保存到我的训练计划'**
  String get ui_auto_settext_fc94ff94f0;

  /// No description provided for @ui_auto_settext_fe95c9b74b.
  ///
  /// In zh, this message translates to:
  /// **'首次记录'**
  String get ui_auto_settext_fe95c9b74b;

  /// No description provided for @ui_auto_settext_ff21681af5.
  ///
  /// In zh, this message translates to:
  /// **'周报总结'**
  String get ui_auto_settext_ff21681af5;

  /// No description provided for @ui_auto_text_1fcc29d0.
  ///
  /// In zh, this message translates to:
  /// **'五'**
  String get ui_auto_text_1fcc29d0;

  /// No description provided for @ui_auto_text_21716cf3.
  ///
  /// In zh, this message translates to:
  /// **'四'**
  String get ui_auto_text_21716cf3;

  /// No description provided for @ui_auto_text_249aba76.
  ///
  /// In zh, this message translates to:
  /// **'天'**
  String get ui_auto_text_249aba76;

  /// No description provided for @ui_auto_text_2d8be272.
  ///
  /// In zh, this message translates to:
  /// **'二'**
  String get ui_auto_text_2d8be272;

  /// No description provided for @ui_auto_text_3adbdb3a.
  ///
  /// In zh, this message translates to:
  /// **'分类'**
  String get ui_auto_text_3adbdb3a;

  /// No description provided for @ui_auto_text_4ff1e74e.
  ///
  /// In zh, this message translates to:
  /// **'日期'**
  String get ui_auto_text_4ff1e74e;

  /// No description provided for @ui_auto_text_61b45352.
  ///
  /// In zh, this message translates to:
  /// **'六'**
  String get ui_auto_text_61b45352;

  /// No description provided for @ui_auto_text_7941da94.
  ///
  /// In zh, this message translates to:
  /// **'一'**
  String get ui_auto_text_7941da94;

  /// No description provided for @ui_auto_text_8d63ef38.
  ///
  /// In zh, this message translates to:
  /// **'暂停'**
  String get ui_auto_text_8d63ef38;

  /// No description provided for @ui_auto_text_9830e1f8.
  ///
  /// In zh, this message translates to:
  /// **'ml'**
  String get ui_auto_text_9830e1f8;

  /// No description provided for @ui_auto_text_99c8f454.
  ///
  /// In zh, this message translates to:
  /// **'中级'**
  String get ui_auto_text_99c8f454;

  /// No description provided for @ui_auto_text_9f27d5a6.
  ///
  /// In zh, this message translates to:
  /// **'😐'**
  String get ui_auto_text_9f27d5a6;

  /// No description provided for @ui_auto_text_e662ff59.
  ///
  /// In zh, this message translates to:
  /// **'三'**
  String get ui_auto_text_e662ff59;

  /// No description provided for @ui_auto_text_eab619fb.
  ///
  /// In zh, this message translates to:
  /// **'水'**
  String get ui_auto_text_eab619fb;

  /// No description provided for @ui_auto_text_ebe86682.
  ///
  /// In zh, this message translates to:
  /// **'kg'**
  String get ui_auto_text_ebe86682;

  /// No description provided for @ui_auto_text_edb33656.
  ///
  /// In zh, this message translates to:
  /// **'早餐'**
  String get ui_auto_text_edb33656;

  /// No description provided for @ui_auto_text_edfec00f.
  ///
  /// In zh, this message translates to:
  /// **'米饭'**
  String get ui_auto_text_edfec00f;

  /// No description provided for @ui_auto_text_f8384fff.
  ///
  /// In zh, this message translates to:
  /// **'达标天数'**
  String get ui_auto_text_f8384fff;

  /// No description provided for @ui_auto_toast_0007d170de.
  ///
  /// In zh, this message translates to:
  /// **'删除成功'**
  String get ui_auto_toast_0007d170de;

  /// No description provided for @ui_auto_toast_0998b48251.
  ///
  /// In zh, this message translates to:
  /// **'已取消运动提醒'**
  String get ui_auto_toast_0998b48251;

  /// No description provided for @ui_auto_toast_09a4d0ac21.
  ///
  /// In zh, this message translates to:
  /// **'计划已删除'**
  String get ui_auto_toast_09a4d0ac21;

  /// No description provided for @ui_auto_toast_0ae3dd7e89.
  ///
  /// In zh, this message translates to:
  /// **'请先打开GPS选项。'**
  String get ui_auto_toast_0ae3dd7e89;

  /// No description provided for @ui_auto_toast_0ebf5ee0dd.
  ///
  /// In zh, this message translates to:
  /// **'请输入次数'**
  String get ui_auto_toast_0ebf5ee0dd;

  /// No description provided for @ui_auto_toast_0f6d81c7ab.
  ///
  /// In zh, this message translates to:
  /// **'请输入食物名称'**
  String get ui_auto_toast_0f6d81c7ab;

  /// No description provided for @ui_auto_toast_0ff01a967a.
  ///
  /// In zh, this message translates to:
  /// **'保存失败，请重试'**
  String get ui_auto_toast_0ff01a967a;

  /// No description provided for @ui_auto_toast_1334bdfb0f.
  ///
  /// In zh, this message translates to:
  /// **'无法写入文件'**
  String get ui_auto_toast_1334bdfb0f;

  /// No description provided for @ui_auto_toast_17527addf8.
  ///
  /// In zh, this message translates to:
  /// **'目标水量必须大于0'**
  String get ui_auto_toast_17527addf8;

  /// No description provided for @ui_auto_toast_1974fe5349.
  ///
  /// In zh, this message translates to:
  /// **'绑定成功'**
  String get ui_auto_toast_1974fe5349;

  /// No description provided for @ui_auto_toast_1b92092d63.
  ///
  /// In zh, this message translates to:
  /// **'已更新'**
  String get ui_auto_toast_1b92092d63;

  /// No description provided for @ui_auto_toast_24738562b3.
  ///
  /// In zh, this message translates to:
  /// **'已授予权限。'**
  String get ui_auto_toast_24738562b3;

  /// No description provided for @ui_auto_toast_2be1cd9fe1.
  ///
  /// In zh, this message translates to:
  /// **'请输入有效数字'**
  String get ui_auto_toast_2be1cd9fe1;

  /// No description provided for @ui_auto_toast_2ca23a0f63.
  ///
  /// In zh, this message translates to:
  /// **'呼吸练习已完成，已为您记录下这份平静'**
  String get ui_auto_toast_2ca23a0f63;

  /// No description provided for @ui_auto_toast_2de1fc7b0d.
  ///
  /// In zh, this message translates to:
  /// **'运动记录保存成功'**
  String get ui_auto_toast_2de1fc7b0d;

  /// No description provided for @ui_auto_toast_34285b7262.
  ///
  /// In zh, this message translates to:
  /// **'微信步数未更新（小于或等于当前步数）'**
  String get ui_auto_toast_34285b7262;

  /// No description provided for @ui_auto_toast_375ef8f9cd.
  ///
  /// In zh, this message translates to:
  /// **'定时结束，声音已关闭'**
  String get ui_auto_toast_375ef8f9cd;

  /// No description provided for @ui_auto_toast_38cff18bdc.
  ///
  /// In zh, this message translates to:
  /// **'请先选择要混合的声音'**
  String get ui_auto_toast_38cff18bdc;

  /// No description provided for @ui_auto_toast_3b108349b9.
  ///
  /// In zh, this message translates to:
  /// **'保存成功'**
  String get ui_auto_toast_3b108349b9;

  /// No description provided for @ui_auto_toast_3bbd3d903a.
  ///
  /// In zh, this message translates to:
  /// **'久坐提醒已开启（每60分钟检测）'**
  String get ui_auto_toast_3bbd3d903a;

  /// No description provided for @ui_auto_toast_3eed9eab68.
  ///
  /// In zh, this message translates to:
  /// **'喝水提醒已开启（每2小时提醒）'**
  String get ui_auto_toast_3eed9eab68;

  /// No description provided for @ui_auto_toast_453196e0b4.
  ///
  /// In zh, this message translates to:
  /// **'请先同意隐私政策！'**
  String get ui_auto_toast_453196e0b4;

  /// No description provided for @ui_auto_toast_4687fdfd5d.
  ///
  /// In zh, this message translates to:
  /// **'喝水量必须大于0'**
  String get ui_auto_toast_4687fdfd5d;

  /// No description provided for @ui_auto_toast_4d23ef069b.
  ///
  /// In zh, this message translates to:
  /// **'运动数据保存成功'**
  String get ui_auto_toast_4d23ef069b;

  /// No description provided for @ui_auto_toast_4e20534e06.
  ///
  /// In zh, this message translates to:
  /// **'微信配置错误，无法启动小程序'**
  String get ui_auto_toast_4e20534e06;

  /// No description provided for @ui_auto_toast_4ee17ce951.
  ///
  /// In zh, this message translates to:
  /// **'报名成功！'**
  String get ui_auto_toast_4ee17ce951;

  /// No description provided for @ui_auto_toast_4fcb6ba144.
  ///
  /// In zh, this message translates to:
  /// **'请先登录后再签到'**
  String get ui_auto_toast_4fcb6ba144;

  /// No description provided for @ui_auto_toast_522393e5aa.
  ///
  /// In zh, this message translates to:
  /// **'暂停追踪'**
  String get ui_auto_toast_522393e5aa;

  /// No description provided for @ui_auto_toast_53d92fed86.
  ///
  /// In zh, this message translates to:
  /// **'请至少添加一组训练'**
  String get ui_auto_toast_53d92fed86;

  /// No description provided for @ui_auto_toast_55aa6366c0.
  ///
  /// In zh, this message translates to:
  /// **'更新成功'**
  String get ui_auto_toast_55aa6366c0;

  /// No description provided for @ui_auto_toast_5b3d9e0404.
  ///
  /// In zh, this message translates to:
  /// **'继续追踪'**
  String get ui_auto_toast_5b3d9e0404;

  /// No description provided for @ui_auto_toast_5cc232620c.
  ///
  /// In zh, this message translates to:
  /// **'已删除'**
  String get ui_auto_toast_5cc232620c;

  /// No description provided for @ui_auto_toast_5d91eb10a2.
  ///
  /// In zh, this message translates to:
  /// **'尚未安装微信，请安装后登录!'**
  String get ui_auto_toast_5d91eb10a2;

  /// No description provided for @ui_auto_toast_63fc80c44e.
  ///
  /// In zh, this message translates to:
  /// **'训练完成！已保存记录'**
  String get ui_auto_toast_63fc80c44e;

  /// No description provided for @ui_auto_toast_655b6683f5.
  ///
  /// In zh, this message translates to:
  /// **'已关闭步数同步，您将从排行榜隐身'**
  String get ui_auto_toast_655b6683f5;

  /// No description provided for @ui_auto_toast_66228e25dd.
  ///
  /// In zh, this message translates to:
  /// **'运动追踪完成，请检查数据'**
  String get ui_auto_toast_66228e25dd;

  /// No description provided for @ui_auto_toast_695068095c.
  ///
  /// In zh, this message translates to:
  /// **'热量必须大于0'**
  String get ui_auto_toast_695068095c;

  /// No description provided for @ui_auto_toast_6de920b4e4.
  ///
  /// In zh, this message translates to:
  /// **'保存失败'**
  String get ui_auto_toast_6de920b4e4;

  /// No description provided for @ui_auto_toast_6e76b9e5db.
  ///
  /// In zh, this message translates to:
  /// **'保存运动记录时出错'**
  String get ui_auto_toast_6e76b9e5db;

  /// No description provided for @ui_auto_toast_6ff591fd18.
  ///
  /// In zh, this message translates to:
  /// **'未到提现额度'**
  String get ui_auto_toast_6ff591fd18;

  /// No description provided for @ui_auto_toast_71fa3bd0e5.
  ///
  /// In zh, this message translates to:
  /// **'登录成功'**
  String get ui_auto_toast_71fa3bd0e5;

  /// No description provided for @ui_auto_toast_7311a0e31c.
  ///
  /// In zh, this message translates to:
  /// **'账户或姓名错误'**
  String get ui_auto_toast_7311a0e31c;

  /// No description provided for @ui_auto_toast_747dcb5a82.
  ///
  /// In zh, this message translates to:
  /// **'同步成功，步数已更新'**
  String get ui_auto_toast_747dcb5a82;

  /// No description provided for @ui_auto_toast_7772c07df8.
  ///
  /// In zh, this message translates to:
  /// **'微信步数未更新（可能是获取失败）'**
  String get ui_auto_toast_7772c07df8;

  /// No description provided for @ui_auto_toast_778f16b62d.
  ///
  /// In zh, this message translates to:
  /// **'已关闭 AI 健康建议主动推送'**
  String get ui_auto_toast_778f16b62d;

  /// No description provided for @ui_auto_toast_7adb3a5ebb.
  ///
  /// In zh, this message translates to:
  /// **'该成就尚未解锁，暂不可分享'**
  String get ui_auto_toast_7adb3a5ebb;

  /// No description provided for @ui_auto_toast_7f274dd9f8.
  ///
  /// In zh, this message translates to:
  /// **'记录失败'**
  String get ui_auto_toast_7f274dd9f8;

  /// No description provided for @ui_auto_toast_815d30bfe7.
  ///
  /// In zh, this message translates to:
  /// **'目标步数不能大于100000步'**
  String get ui_auto_toast_815d30bfe7;

  /// No description provided for @ui_auto_toast_82f746cfbb.
  ///
  /// In zh, this message translates to:
  /// **'目标热量必须大于0'**
  String get ui_auto_toast_82f746cfbb;

  /// No description provided for @ui_auto_toast_87929ada35.
  ///
  /// In zh, this message translates to:
  /// **'请先登录，再邀请好友'**
  String get ui_auto_toast_87929ada35;

  /// No description provided for @ui_auto_toast_8a3e40040e.
  ///
  /// In zh, this message translates to:
  /// **'已开启 AI 健康建议主动推送'**
  String get ui_auto_toast_8a3e40040e;

  /// No description provided for @ui_auto_toast_8ba8075267.
  ///
  /// In zh, this message translates to:
  /// **'请先确认推荐计划'**
  String get ui_auto_toast_8ba8075267;

  /// No description provided for @ui_auto_toast_8d3711b0a2.
  ///
  /// In zh, this message translates to:
  /// **'时间不可以小于两秒'**
  String get ui_auto_toast_8d3711b0a2;

  /// No description provided for @ui_auto_toast_8ec90cf246.
  ///
  /// In zh, this message translates to:
  /// **'数据库不可用，无法导出'**
  String get ui_auto_toast_8ec90cf246;

  /// No description provided for @ui_auto_toast_934aa75b00.
  ///
  /// In zh, this message translates to:
  /// **'开始追踪运动'**
  String get ui_auto_toast_934aa75b00;

  /// No description provided for @ui_auto_toast_99903297d0.
  ///
  /// In zh, this message translates to:
  /// **'请填写完整的身高、年龄信息'**
  String get ui_auto_toast_99903297d0;

  /// No description provided for @ui_auto_toast_9a32f3bcdc.
  ///
  /// In zh, this message translates to:
  /// **'训练计划已保存'**
  String get ui_auto_toast_9a32f3bcdc;

  /// No description provided for @ui_auto_toast_9bca3eea66.
  ///
  /// In zh, this message translates to:
  /// **'停止追踪运动'**
  String get ui_auto_toast_9bca3eea66;

  /// No description provided for @ui_auto_toast_9e4a21b207.
  ///
  /// In zh, this message translates to:
  /// **'未获取到步数数据，请在小程序中点击\\&quot;获取\\&quot;按钮'**
  String get ui_auto_toast_9e4a21b207;

  /// No description provided for @ui_auto_toast_a158b1d76d.
  ///
  /// In zh, this message translates to:
  /// **'已按当前目标更新推荐计划'**
  String get ui_auto_toast_a158b1d76d;

  /// No description provided for @ui_auto_toast_a1a16bd5c2.
  ///
  /// In zh, this message translates to:
  /// **'请输入体重'**
  String get ui_auto_toast_a1a16bd5c2;

  /// No description provided for @ui_auto_toast_a344697b7e.
  ///
  /// In zh, this message translates to:
  /// **'下载安装中'**
  String get ui_auto_toast_a344697b7e;

  /// No description provided for @ui_auto_toast_a5e1c3af2e.
  ///
  /// In zh, this message translates to:
  /// **'记录不存在'**
  String get ui_auto_toast_a5e1c3af2e;

  /// No description provided for @ui_auto_toast_acf0664a54.
  ///
  /// In zh, this message translates to:
  /// **'删除失败'**
  String get ui_auto_toast_acf0664a54;

  /// No description provided for @ui_auto_toast_baeb696683.
  ///
  /// In zh, this message translates to:
  /// **'请选择运动类型'**
  String get ui_auto_toast_baeb696683;

  /// No description provided for @ui_auto_toast_bfede875b8.
  ///
  /// In zh, this message translates to:
  /// **'同步步数成功'**
  String get ui_auto_toast_bfede875b8;

  /// No description provided for @ui_auto_toast_c071e6ba94.
  ///
  /// In zh, this message translates to:
  /// **'任务同步错误，获取积分失败'**
  String get ui_auto_toast_c071e6ba94;

  /// No description provided for @ui_auto_toast_c17cd2589c.
  ///
  /// In zh, this message translates to:
  /// **'已开启步数同步，将在排行榜展示您的成绩'**
  String get ui_auto_toast_c17cd2589c;

  /// No description provided for @ui_auto_toast_c2b4cb90a1.
  ///
  /// In zh, this message translates to:
  /// **'计算失败，请检查输入'**
  String get ui_auto_toast_c2b4cb90a1;

  /// No description provided for @ui_auto_toast_c415b99ff6.
  ///
  /// In zh, this message translates to:
  /// **'生成周报失败'**
  String get ui_auto_toast_c415b99ff6;

  /// No description provided for @ui_auto_toast_c57e280893.
  ///
  /// In zh, this message translates to:
  /// **'请先开始播放'**
  String get ui_auto_toast_c57e280893;

  /// No description provided for @ui_auto_toast_c777696c97.
  ///
  /// In zh, this message translates to:
  /// **'目标热量不能超过10000千卡'**
  String get ui_auto_toast_c777696c97;

  /// No description provided for @ui_auto_toast_cb6b1ae4bf.
  ///
  /// In zh, this message translates to:
  /// **'久坐提醒已关闭'**
  String get ui_auto_toast_cb6b1ae4bf;

  /// No description provided for @ui_auto_toast_d70bd48b0e.
  ///
  /// In zh, this message translates to:
  /// **'请先加载广告'**
  String get ui_auto_toast_d70bd48b0e;

  /// No description provided for @ui_auto_toast_d87a089379.
  ///
  /// In zh, this message translates to:
  /// **'请先安装微信客户端'**
  String get ui_auto_toast_d87a089379;

  /// No description provided for @ui_auto_toast_da9d9fcbd5.
  ///
  /// In zh, this message translates to:
  /// **'缺少读写权限，无法计步，请前往设置设置权限！'**
  String get ui_auto_toast_da9d9fcbd5;

  /// No description provided for @ui_auto_toast_db8309e5b0.
  ///
  /// In zh, this message translates to:
  /// **'请先登录，再填写邀请码'**
  String get ui_auto_toast_db8309e5b0;

  /// No description provided for @ui_auto_toast_dc220d76e2.
  ///
  /// In zh, this message translates to:
  /// **'启动微信小程序失败，请稍后重试'**
  String get ui_auto_toast_dc220d76e2;

  /// No description provided for @ui_auto_toast_dd10c24f36.
  ///
  /// In zh, this message translates to:
  /// **'喝水提醒已关闭'**
  String get ui_auto_toast_dd10c24f36;

  /// No description provided for @ui_auto_toast_dde8f0daab.
  ///
  /// In zh, this message translates to:
  /// **'需要相机权限才能识别食物'**
  String get ui_auto_toast_dde8f0daab;

  /// No description provided for @ui_auto_toast_de5049a584.
  ///
  /// In zh, this message translates to:
  /// **'没有获取到任务，请稍后再试！'**
  String get ui_auto_toast_de5049a584;

  /// No description provided for @ui_auto_toast_df2bdb20b7.
  ///
  /// In zh, this message translates to:
  /// **'登录或注册异常！'**
  String get ui_auto_toast_df2bdb20b7;

  /// No description provided for @ui_auto_toast_e024d09f21.
  ///
  /// In zh, this message translates to:
  /// **'已记录'**
  String get ui_auto_toast_e024d09f21;

  /// No description provided for @ui_auto_toast_e5d289bb5f.
  ///
  /// In zh, this message translates to:
  /// **'保存分享图片失败'**
  String get ui_auto_toast_e5d289bb5f;

  /// No description provided for @ui_auto_toast_f09e8a93ad.
  ///
  /// In zh, this message translates to:
  /// **'请输入有效的血压值'**
  String get ui_auto_toast_f09e8a93ad;

  /// No description provided for @ui_auto_toast_f285c5c4d7.
  ///
  /// In zh, this message translates to:
  /// **'提现失败'**
  String get ui_auto_toast_f285c5c4d7;

  /// No description provided for @ui_auto_toast_f81afc66d2.
  ///
  /// In zh, this message translates to:
  /// **'请输入目标水量'**
  String get ui_auto_toast_f81afc66d2;

  /// No description provided for @ui_auto_toast_f8229cd83f.
  ///
  /// In zh, this message translates to:
  /// **'三方分享功能暂未开启'**
  String get ui_auto_toast_f8229cd83f;

  /// No description provided for @ui_auto_toast_f8dfedcd8a.
  ///
  /// In zh, this message translates to:
  /// **'已保存'**
  String get ui_auto_toast_f8dfedcd8a;

  /// No description provided for @ui_auto_toast_f978b57fc6.
  ///
  /// In zh, this message translates to:
  /// **'手机没有安装浏览器'**
  String get ui_auto_toast_f978b57fc6;

  /// No description provided for @ui_auto_toast_fa3e596cc9.
  ///
  /// In zh, this message translates to:
  /// **'生成分享图片失败'**
  String get ui_auto_toast_fa3e596cc9;

  /// No description provided for @ui_auto_toast_fbd78423e5.
  ///
  /// In zh, this message translates to:
  /// **'微信步数获取失败，请重试'**
  String get ui_auto_toast_fbd78423e5;

  /// No description provided for @ui_auto_toast_fc4d1c55d0.
  ///
  /// In zh, this message translates to:
  /// **'保存数据解析失败'**
  String get ui_auto_toast_fc4d1c55d0;

  /// No description provided for @ui_auto_toast_fde53cbf7c.
  ///
  /// In zh, this message translates to:
  /// **'请输入有效的数字'**
  String get ui_auto_toast_fde53cbf7c;

  /// No description provided for @ui_auto_toast_fec0f829f0.
  ///
  /// In zh, this message translates to:
  /// **'目标水量不能超过10000ml'**
  String get ui_auto_toast_fec0f829f0;

  /// No description provided for @ui_auto_toast_fecd719238.
  ///
  /// In zh, this message translates to:
  /// **'请输入目标热量'**
  String get ui_auto_toast_fecd719238;

  /// No description provided for @ui_auto_uiadd_0160674ec4.
  ///
  /// In zh, this message translates to:
  /// **'营养建议：\\n'**
  String get ui_auto_uiadd_0160674ec4;

  /// No description provided for @ui_auto_uiadd_019536ee70.
  ///
  /// In zh, this message translates to:
  /// **'心率变异性一般，建议适量运动\\n'**
  String get ui_auto_uiadd_019536ee70;

  /// No description provided for @ui_auto_uiadd_052b389815.
  ///
  /// In zh, this message translates to:
  /// **'次徒手训练'**
  String get ui_auto_uiadd_052b389815;

  /// No description provided for @ui_auto_uiadd_069280a207.
  ///
  /// In zh, this message translates to:
  /// **'• 控制热量摄入，增加蔬菜水果比例\\n'**
  String get ui_auto_uiadd_069280a207;

  /// No description provided for @ui_auto_uiadd_10d14ffdfd.
  ///
  /// In zh, this message translates to:
  /// **'心率变异性偏低，注意休息和恢复\\n'**
  String get ui_auto_uiadd_10d14ffdfd;

  /// No description provided for @ui_auto_uiadd_14dfc9fed0.
  ///
  /// In zh, this message translates to:
  /// **'优先保持节奏连续，必要时可降低速度但不要突然停下。'**
  String get ui_auto_uiadd_14dfc9fed0;

  /// No description provided for @ui_auto_uiadd_1633a674e8.
  ///
  /// In zh, this message translates to:
  /// **'控制盐分并规律测压'**
  String get ui_auto_uiadd_1633a674e8;

  /// No description provided for @ui_auto_uiadd_1a6855d748.
  ///
  /// In zh, this message translates to:
  /// **'\\n今天已完成'**
  String get ui_auto_uiadd_1a6855d748;

  /// No description provided for @ui_auto_uiadd_1fee02c204.
  ///
  /// In zh, this message translates to:
  /// **'运动建议：\\n'**
  String get ui_auto_uiadd_1fee02c204;

  /// No description provided for @ui_auto_uiadd_2022007ce8.
  ///
  /// In zh, this message translates to:
  /// **'\\n\\n每项满分25分。缺少数据的项不参与分母计算。'**
  String get ui_auto_uiadd_2022007ce8;

  /// No description provided for @ui_auto_uiadd_284bb48815.
  ///
  /// In zh, this message translates to:
  /// **'· 体脂'**
  String get ui_auto_uiadd_284bb48815;

  /// No description provided for @ui_auto_uiadd_28e72b8294.
  ///
  /// In zh, this message translates to:
  /// **'总分采用满分100分：\\n'**
  String get ui_auto_uiadd_28e72b8294;

  /// No description provided for @ui_auto_uiadd_2adfd2a4b7.
  ///
  /// In zh, this message translates to:
  /// **'体重偏轻，建议增加营养摄入'**
  String get ui_auto_uiadd_2adfd2a4b7;

  /// No description provided for @ui_auto_uiadd_34c469767b.
  ///
  /// In zh, this message translates to:
  /// **'当前数据完整度：'**
  String get ui_auto_uiadd_34c469767b;

  /// No description provided for @ui_auto_uiadd_35c1440c01.
  ///
  /// In zh, this message translates to:
  /// **'• 运动与血压：规律运动有助于血压稳定\\n'**
  String get ui_auto_uiadd_35c1440c01;

  /// No description provided for @ui_auto_uiadd_389a2bb87e.
  ///
  /// In zh, this message translates to:
  /// **'血糖水平偏高，建议定期监测'**
  String get ui_auto_uiadd_389a2bb87e;

  /// No description provided for @ui_auto_uiadd_3a00251d1c.
  ///
  /// In zh, this message translates to:
  /// **'总分 = (各项得分之和) ÷ (已采集项数 × 25) × 100\\n\\n'**
  String get ui_auto_uiadd_3a00251d1c;

  /// No description provided for @ui_auto_uiadd_4613933c9c.
  ///
  /// In zh, this message translates to:
  /// **'• 运动前后关注心率变化\\n'**
  String get ui_auto_uiadd_4613933c9c;

  /// No description provided for @ui_auto_uiadd_48e6d4b908.
  ///
  /// In zh, this message translates to:
  /// **'体重超标，建议控制饮食和增加运动'**
  String get ui_auto_uiadd_48e6d4b908;

  /// No description provided for @ui_auto_uiadd_4e1df344a4.
  ///
  /// In zh, this message translates to:
  /// **'健康趋势分析：\\n\\n'**
  String get ui_auto_uiadd_4e1df344a4;

  /// No description provided for @ui_auto_uiadd_4f6991b407.
  ///
  /// In zh, this message translates to:
  /// **'• 减少高热量零食和饮料\\n\\n'**
  String get ui_auto_uiadd_4f6991b407;

  /// No description provided for @ui_auto_uiadd_543161e315.
  ///
  /// In zh, this message translates to:
  /// **'血压偏高，建议医疗咨询'**
  String get ui_auto_uiadd_543161e315;

  /// No description provided for @ui_auto_uiadd_56db689db7.
  ///
  /// In zh, this message translates to:
  /// **'建议继续保持良好的生活习惯'**
  String get ui_auto_uiadd_56db689db7;

  /// No description provided for @ui_auto_uiadd_58498b4434.
  ///
  /// In zh, this message translates to:
  /// **'(建议增加)\\n'**
  String get ui_auto_uiadd_58498b4434;

  /// No description provided for @ui_auto_uiadd_5d51a9b5cc.
  ///
  /// In zh, this message translates to:
  /// **'(相对稳定)\\n'**
  String get ui_auto_uiadd_5d51a9b5cc;

  /// No description provided for @ui_auto_uiadd_654c77e339.
  ///
  /// In zh, this message translates to:
  /// **'监测建议：\\n'**
  String get ui_auto_uiadd_654c77e339;

  /// No description provided for @ui_auto_uiadd_655cebd5e1.
  ///
  /// In zh, this message translates to:
  /// **'\\n预计消耗：'**
  String get ui_auto_uiadd_655cebd5e1;

  /// No description provided for @ui_auto_uiadd_66a96f9beb.
  ///
  /// In zh, this message translates to:
  /// **'训练量：'**
  String get ui_auto_uiadd_66a96f9beb;

  /// No description provided for @ui_auto_uiadd_67680b020f.
  ///
  /// In zh, this message translates to:
  /// **'在舒适范围内拉伸，感受到牵拉即可，不要强压。'**
  String get ui_auto_uiadd_67680b020f;

  /// No description provided for @ui_auto_uiadd_6879545ad9.
  ///
  /// In zh, this message translates to:
  /// **'核心收紧，注意动作轨迹，不要为了速度牺牲姿势。'**
  String get ui_auto_uiadd_6879545ad9;

  /// No description provided for @ui_auto_uiadd_6edf9cc763.
  ///
  /// In zh, this message translates to:
  /// **'心率变异性良好，身体恢复能力强\\n'**
  String get ui_auto_uiadd_6edf9cc763;

  /// No description provided for @ui_auto_uiadd_8124c54765.
  ///
  /// In zh, this message translates to:
  /// **'/4 项\\n\\n'**
  String get ui_auto_uiadd_8124c54765;

  /// No description provided for @ui_auto_uiadd_8481345a33.
  ///
  /// In zh, this message translates to:
  /// **'(稳定)\\n'**
  String get ui_auto_uiadd_8481345a33;

  /// No description provided for @ui_auto_uiadd_902c692662.
  ///
  /// In zh, this message translates to:
  /// **'个性化健康建议：\\n\\n'**
  String get ui_auto_uiadd_902c692662;

  /// No description provided for @ui_auto_uiadd_9262bbf90c.
  ///
  /// In zh, this message translates to:
  /// **'• 坚持定期记录体重和体成分\\n'**
  String get ui_auto_uiadd_9262bbf90c;

  /// No description provided for @ui_auto_uiadd_992f0766c2.
  ///
  /// In zh, this message translates to:
  /// **'• 心率变异性：'**
  String get ui_auto_uiadd_992f0766c2;

  /// No description provided for @ui_auto_uiadd_9da79d5d36.
  ///
  /// In zh, this message translates to:
  /// **'秒，吸气'**
  String get ui_auto_uiadd_9da79d5d36;

  /// No description provided for @ui_auto_uiadd_a254b51d7b.
  ///
  /// In zh, this message translates to:
  /// **'\\n解锁：这是你这项动作的个人最佳完成时长'**
  String get ui_auto_uiadd_a254b51d7b;

  /// No description provided for @ui_auto_uiadd_a9e3037b01.
  ///
  /// In zh, this message translates to:
  /// **'运动增加有助于体重控制\\n'**
  String get ui_auto_uiadd_a9e3037b01;

  /// No description provided for @ui_auto_uiadd_afef8e5738.
  ///
  /// In zh, this message translates to:
  /// **'组，约'**
  String get ui_auto_uiadd_afef8e5738;

  /// No description provided for @ui_auto_uiadd_b03a71a556.
  ///
  /// In zh, this message translates to:
  /// **'• 血压偏高时增加监测频率\\n'**
  String get ui_auto_uiadd_b03a71a556;

  /// No description provided for @ui_auto_uiadd_b32a847036.
  ///
  /// In zh, this message translates to:
  /// **'先用 20 秒熟悉动作节奏，保持呼吸稳定。'**
  String get ui_auto_uiadd_b32a847036;

  /// No description provided for @ui_auto_uiadd_c2ae26e1ba.
  ///
  /// In zh, this message translates to:
  /// **'，停留'**
  String get ui_auto_uiadd_c2ae26e1ba;

  /// No description provided for @ui_auto_uiadd_c7f6d655bb.
  ///
  /// In zh, this message translates to:
  /// **'优先保证睡眠和恢复'**
  String get ui_auto_uiadd_c7f6d655bb;

  /// No description provided for @ui_auto_uiadd_c88b6f2891.
  ///
  /// In zh, this message translates to:
  /// **'每组结束后短暂放松，再开始下一组'**
  String get ui_auto_uiadd_c88b6f2891;

  /// No description provided for @ui_auto_uiadd_d0a41d0152.
  ///
  /// In zh, this message translates to:
  /// **'✓ 当前健康状况良好，无明显风险因子\\n'**
  String get ui_auto_uiadd_d0a41d0152;

  /// No description provided for @ui_auto_uiadd_d540e7989f.
  ///
  /// In zh, this message translates to:
  /// **'，吐气'**
  String get ui_auto_uiadd_d540e7989f;

  /// No description provided for @ui_auto_uiadd_da810b9534.
  ///
  /// In zh, this message translates to:
  /// **'减少高糖饮食并复测'**
  String get ui_auto_uiadd_da810b9534;

  /// No description provided for @ui_auto_uiadd_dcd21040a9.
  ///
  /// In zh, this message translates to:
  /// **'(符合健康建议)\\n'**
  String get ui_auto_uiadd_dcd21040a9;

  /// No description provided for @ui_auto_uiadd_dd3b3cede4.
  ///
  /// In zh, this message translates to:
  /// **'健康风险评估：\\n\\n'**
  String get ui_auto_uiadd_dd3b3cede4;

  /// No description provided for @ui_auto_uiadd_e052f572be.
  ///
  /// In zh, this message translates to:
  /// **'• 运动频率与体重变化：'**
  String get ui_auto_uiadd_e052f572be;

  /// No description provided for @ui_auto_uiadd_e2e59afa07.
  ///
  /// In zh, this message translates to:
  /// **'需要更长时间的数据来分析趋势\\n'**
  String get ui_auto_uiadd_e2e59afa07;

  /// No description provided for @ui_auto_uiadd_e330351f60.
  ///
  /// In zh, this message translates to:
  /// **'每周至少运动3次'**
  String get ui_auto_uiadd_e330351f60;

  /// No description provided for @ui_auto_uiadd_edca5c94c2.
  ///
  /// In zh, this message translates to:
  /// **'运动不足，增加慢性病风险'**
  String get ui_auto_uiadd_edca5c94c2;

  /// No description provided for @ui_auto_uiadd_f20744e5e3.
  ///
  /// In zh, this message translates to:
  /// **'健康数据相关性分析：\\n\\n'**
  String get ui_auto_uiadd_f20744e5e3;

  /// No description provided for @ui_auto_uiadd_fe92bb19d7.
  ///
  /// In zh, this message translates to:
  /// **'\\n最近 7 天练习'**
  String get ui_auto_uiadd_fe92bb19d7;

  /// No description provided for @ui_calorie.
  ///
  /// In zh, this message translates to:
  /// **'热量'**
  String get ui_calorie;

  /// No description provided for @ui_calorie_burn.
  ///
  /// In zh, this message translates to:
  /// **'热量消耗'**
  String get ui_calorie_burn;

  /// No description provided for @ui_common_add.
  ///
  /// In zh, this message translates to:
  /// **'添加'**
  String get ui_common_add;

  /// No description provided for @ui_common_cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get ui_common_cancel;

  /// No description provided for @ui_common_completed.
  ///
  /// In zh, this message translates to:
  /// **'完成'**
  String get ui_common_completed;

  /// No description provided for @ui_common_confirm.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get ui_common_confirm;

  /// No description provided for @ui_common_day.
  ///
  /// In zh, this message translates to:
  /// **'日'**
  String get ui_common_day;

  /// No description provided for @ui_common_delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get ui_common_delete;

  /// No description provided for @ui_common_month.
  ///
  /// In zh, this message translates to:
  /// **'月'**
  String get ui_common_month;

  /// No description provided for @ui_common_none.
  ///
  /// In zh, this message translates to:
  /// **'暂无'**
  String get ui_common_none;

  /// No description provided for @ui_common_save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get ui_common_save;

  /// No description provided for @ui_common_suggestion.
  ///
  /// In zh, this message translates to:
  /// **'建议'**
  String get ui_common_suggestion;

  /// No description provided for @ui_common_today.
  ///
  /// In zh, this message translates to:
  /// **'今天'**
  String get ui_common_today;

  /// No description provided for @ui_common_unrecorded.
  ///
  /// In zh, this message translates to:
  /// **'未记录'**
  String get ui_common_unrecorded;

  /// No description provided for @ui_common_week.
  ///
  /// In zh, this message translates to:
  /// **'周'**
  String get ui_common_week;

  /// No description provided for @ui_common_yesterday.
  ///
  /// In zh, this message translates to:
  /// **'昨天'**
  String get ui_common_yesterday;

  /// No description provided for @ui_duration.
  ///
  /// In zh, this message translates to:
  /// **'时长'**
  String get ui_duration;

  /// No description provided for @ui_sport_timer.
  ///
  /// In zh, this message translates to:
  /// **'运动计时'**
  String get ui_sport_timer;

  /// No description provided for @ui_training_plan.
  ///
  /// In zh, this message translates to:
  /// **'训练计划'**
  String get ui_training_plan;

  /// No description provided for @ui_unit_kcal.
  ///
  /// In zh, this message translates to:
  /// **'千卡'**
  String get ui_unit_kcal;

  /// No description provided for @ui_weekday_fri.
  ///
  /// In zh, this message translates to:
  /// **'周五'**
  String get ui_weekday_fri;

  /// No description provided for @ui_weekday_mon.
  ///
  /// In zh, this message translates to:
  /// **'周一'**
  String get ui_weekday_mon;

  /// No description provided for @ui_weekday_sat.
  ///
  /// In zh, this message translates to:
  /// **'周六'**
  String get ui_weekday_sat;

  /// No description provided for @ui_weekday_sun.
  ///
  /// In zh, this message translates to:
  /// **'周日'**
  String get ui_weekday_sun;

  /// No description provided for @ui_weekday_thu.
  ///
  /// In zh, this message translates to:
  /// **'周四'**
  String get ui_weekday_thu;

  /// No description provided for @ui_weekday_tue.
  ///
  /// In zh, this message translates to:
  /// **'周二'**
  String get ui_weekday_tue;

  /// No description provided for @ui_weekday_wed.
  ///
  /// In zh, this message translates to:
  /// **'周三'**
  String get ui_weekday_wed;

  /// No description provided for @unit_money.
  ///
  /// In zh, this message translates to:
  /// **'元'**
  String get unit_money;

  /// No description provided for @unknown_sport.
  ///
  /// In zh, this message translates to:
  /// **'未知运动'**
  String get unknown_sport;

  /// No description provided for @unregister_user.
  ///
  /// In zh, this message translates to:
  /// **'未登录用户'**
  String get unregister_user;

  /// No description provided for @user_page_contact_wechat.
  ///
  /// In zh, this message translates to:
  /// **'公众号: 微小目标'**
  String get user_page_contact_wechat;

  /// No description provided for @user_page_step_sync_subtitle.
  ///
  /// In zh, this message translates to:
  /// **'从健康应用通知同步步数'**
  String get user_page_step_sync_subtitle;

  /// No description provided for @user_xy.
  ///
  /// In zh, this message translates to:
  /// **'用户协议'**
  String get user_xy;

  /// No description provided for @user_ys.
  ///
  /// In zh, this message translates to:
  /// **'隐私政策'**
  String get user_ys;

  /// No description provided for @userinfo_gx.
  ///
  /// In zh, this message translates to:
  /// **'个人信息共享清单'**
  String get userinfo_gx;

  /// No description provided for @userinfo_sj.
  ///
  /// In zh, this message translates to:
  /// **'个人信息收集清单'**
  String get userinfo_sj;

  /// No description provided for @ver_name.
  ///
  /// In zh, this message translates to:
  /// **'版本号'**
  String get ver_name;

  /// No description provided for @video_double_coin.
  ///
  /// In zh, this message translates to:
  /// **'看完视频奖励翻倍'**
  String get video_double_coin;

  /// No description provided for @view_all_data.
  ///
  /// In zh, this message translates to:
  /// **'全部记录'**
  String get view_all_data;

  /// No description provided for @voice_coach_distance_10km.
  ///
  /// In zh, this message translates to:
  /// **'十公里！你是跑步达人！'**
  String get voice_coach_distance_10km;

  /// No description provided for @voice_coach_distance_5km.
  ///
  /// In zh, this message translates to:
  /// **'五公里达成！'**
  String get voice_coach_distance_5km;

  /// No description provided for @voice_coach_distance_update_format.
  ///
  /// In zh, this message translates to:
  /// **'已完成%1\$d公里'**
  String get voice_coach_distance_update_format;

  /// No description provided for @voice_coach_encourage_10.
  ///
  /// In zh, this message translates to:
  /// **'不错的开始，继续保持！'**
  String get voice_coach_encourage_10;

  /// No description provided for @voice_coach_encourage_30.
  ///
  /// In zh, this message translates to:
  /// **'半小时了，你真棒！'**
  String get voice_coach_encourage_30;

  /// No description provided for @voice_coach_encourage_60.
  ///
  /// In zh, this message translates to:
  /// **'一小时运动，太厉害了！'**
  String get voice_coach_encourage_60;

  /// No description provided for @voice_coach_encouragement_1.
  ///
  /// In zh, this message translates to:
  /// **'加油，你是最棒的！'**
  String get voice_coach_encouragement_1;

  /// No description provided for @voice_coach_encouragement_2.
  ///
  /// In zh, this message translates to:
  /// **'保持这个节奏！'**
  String get voice_coach_encouragement_2;

  /// No description provided for @voice_coach_encouragement_3.
  ///
  /// In zh, this message translates to:
  /// **'坚持就是胜利！'**
  String get voice_coach_encouragement_3;

  /// No description provided for @voice_coach_encouragement_4.
  ///
  /// In zh, this message translates to:
  /// **'你做得很好！'**
  String get voice_coach_encouragement_4;

  /// No description provided for @voice_coach_encouragement_5.
  ///
  /// In zh, this message translates to:
  /// **'再坚持一下！'**
  String get voice_coach_encouragement_5;

  /// No description provided for @voice_coach_encouragement_6.
  ///
  /// In zh, this message translates to:
  /// **'突破自我，超越极限！'**
  String get voice_coach_encouragement_6;

  /// No description provided for @voice_coach_encouragement_7.
  ///
  /// In zh, this message translates to:
  /// **'每一步都是进步！'**
  String get voice_coach_encouragement_7;

  /// No description provided for @voice_coach_encouragement_8.
  ///
  /// In zh, this message translates to:
  /// **'汗水不会辜负你！'**
  String get voice_coach_encouragement_8;

  /// No description provided for @voice_coach_finish_calories_format.
  ///
  /// In zh, this message translates to:
  /// **'消耗%1\$d千卡。'**
  String get voice_coach_finish_calories_format;

  /// No description provided for @voice_coach_finish_duration_format.
  ///
  /// In zh, this message translates to:
  /// **'本次运动%1\$d分钟，'**
  String get voice_coach_finish_duration_format;

  /// No description provided for @voice_coach_finish_intro.
  ///
  /// In zh, this message translates to:
  /// **'运动结束！'**
  String get voice_coach_finish_intro;

  /// No description provided for @voice_coach_finish_outro.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！'**
  String get voice_coach_finish_outro;

  /// No description provided for @voice_coach_hr_zone_1.
  ///
  /// In zh, this message translates to:
  /// **'热身区，可以加快速度'**
  String get voice_coach_hr_zone_1;

  /// No description provided for @voice_coach_hr_zone_2.
  ///
  /// In zh, this message translates to:
  /// **'燃脂区，保持这个强度'**
  String get voice_coach_hr_zone_2;

  /// No description provided for @voice_coach_hr_zone_3.
  ///
  /// In zh, this message translates to:
  /// **'有氧区，很好的训练强度'**
  String get voice_coach_hr_zone_3;

  /// No description provided for @voice_coach_hr_zone_4.
  ///
  /// In zh, this message translates to:
  /// **'无氧区，注意不要过度'**
  String get voice_coach_hr_zone_4;

  /// No description provided for @voice_coach_hr_zone_5.
  ///
  /// In zh, this message translates to:
  /// **'极限区，请适当放慢'**
  String get voice_coach_hr_zone_5;

  /// No description provided for @voice_coach_milestone_format.
  ///
  /// In zh, this message translates to:
  /// **'恭喜！%1\$s'**
  String get voice_coach_milestone_format;

  /// No description provided for @voice_coach_pace_format.
  ///
  /// In zh, this message translates to:
  /// **'当前配速%1\$d分%2\$d秒每公里'**
  String get voice_coach_pace_format;

  /// No description provided for @voice_coach_pause.
  ///
  /// In zh, this message translates to:
  /// **'运动暂停'**
  String get voice_coach_pause;

  /// No description provided for @voice_coach_resume.
  ///
  /// In zh, this message translates to:
  /// **'继续运动，保持节奏'**
  String get voice_coach_resume;

  /// No description provided for @voice_coach_start_format.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s开始，加油！'**
  String get voice_coach_start_format;

  /// No description provided for @voice_coach_time_update_format.
  ///
  /// In zh, this message translates to:
  /// **'已运动%1\$d分钟'**
  String get voice_coach_time_update_format;

  /// No description provided for @watch_all_ad_get_coin.
  ///
  /// In zh, this message translates to:
  /// **'看完视频领取金币'**
  String get watch_all_ad_get_coin;

  /// No description provided for @water_record_added_format.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s 已记录 %2\$dml'**
  String get water_record_added_format;

  /// No description provided for @water_record_added_net_format.
  ///
  /// In zh, this message translates to:
  /// **'%1\$s 已记录 %2\$dml（净补水 %3\$dml）'**
  String get water_record_added_net_format;

  /// No description provided for @water_target_set_by_profile_format.
  ///
  /// In zh, this message translates to:
  /// **'已根据您的信息设置目标为 %1\$dml'**
  String get water_target_set_by_profile_format;

  /// No description provided for @water_target_set_format.
  ///
  /// In zh, this message translates to:
  /// **'目标已设置为 %1\$dml'**
  String get water_target_set_format;

  /// No description provided for @wed.
  ///
  /// In zh, this message translates to:
  /// **'周三'**
  String get wed;

  /// No description provided for @weight.
  ///
  /// In zh, this message translates to:
  /// **'体重'**
  String get weight;

  /// No description provided for @weight_management.
  ///
  /// In zh, this message translates to:
  /// **'体重管理'**
  String get weight_management;

  /// No description provided for @welcome_hello.
  ///
  /// In zh, this message translates to:
  /// **'你好，'**
  String get welcome_hello;

  /// No description provided for @white_noise_name_1.
  ///
  /// In zh, this message translates to:
  /// **'窗外细雨'**
  String get white_noise_name_1;

  /// No description provided for @white_noise_name_10.
  ///
  /// In zh, this message translates to:
  /// **'壁炉柴火'**
  String get white_noise_name_10;

  /// No description provided for @white_noise_name_11.
  ///
  /// In zh, this message translates to:
  /// **'山顶狂风'**
  String get white_noise_name_11;

  /// No description provided for @white_noise_name_12.
  ///
  /// In zh, this message translates to:
  /// **'竹林微风'**
  String get white_noise_name_12;

  /// No description provided for @white_noise_name_13.
  ///
  /// In zh, this message translates to:
  /// **'宇宙白噪'**
  String get white_noise_name_13;

  /// No description provided for @white_noise_name_14.
  ///
  /// In zh, this message translates to:
  /// **'粉红记忆'**
  String get white_noise_name_14;

  /// No description provided for @white_noise_name_15.
  ///
  /// In zh, this message translates to:
  /// **'褐色沉思'**
  String get white_noise_name_15;

  /// No description provided for @white_noise_name_2.
  ///
  /// In zh, this message translates to:
  /// **'雷雨交加'**
  String get white_noise_name_2;

  /// No description provided for @white_noise_name_3.
  ///
  /// In zh, this message translates to:
  /// **'屋檐雨声'**
  String get white_noise_name_3;

  /// No description provided for @white_noise_name_4.
  ///
  /// In zh, this message translates to:
  /// **'森林小雨'**
  String get white_noise_name_4;

  /// No description provided for @white_noise_name_5.
  ///
  /// In zh, this message translates to:
  /// **'夏日海浪'**
  String get white_noise_name_5;

  /// No description provided for @white_noise_name_6.
  ///
  /// In zh, this message translates to:
  /// **'深海呼吸'**
  String get white_noise_name_6;

  /// No description provided for @white_noise_name_7.
  ///
  /// In zh, this message translates to:
  /// **'山间溪流'**
  String get white_noise_name_7;

  /// No description provided for @white_noise_name_8.
  ///
  /// In zh, this message translates to:
  /// **'静谧湖泊'**
  String get white_noise_name_8;

  /// No description provided for @white_noise_name_9.
  ///
  /// In zh, this message translates to:
  /// **'深夜篝火'**
  String get white_noise_name_9;

  /// No description provided for @white_noise_timer_set_format.
  ///
  /// In zh, this message translates to:
  /// **'已设置 %1\$d 分钟后自动关闭'**
  String get white_noise_timer_set_format;

  /// No description provided for @widget_description.
  ///
  /// In zh, this message translates to:
  /// **'微步运动 — 步数/喝水/热量 桌面小组件'**
  String get widget_description;

  /// No description provided for @workout_meta_finish_format.
  ///
  /// In zh, this message translates to:
  /// **'已完成 %1\$d/%2\$d 组 | 共计 %3\$d 分钟 | 预计消耗 %4\$d 千卡'**
  String get workout_meta_finish_format;

  /// No description provided for @workout_paused_round_format.
  ///
  /// In zh, this message translates to:
  /// **'暂停中 | 第%1\$d组进行中'**
  String get workout_paused_round_format;

  /// No description provided for @workout_resume_round_format.
  ///
  /// In zh, this message translates to:
  /// **'继续第%1\$d组训练'**
  String get workout_resume_round_format;

  /// No description provided for @workout_stop_save_msg_format.
  ///
  /// In zh, this message translates to:
  /// **'已完成%1\$d/%2\$d组。保存当前进度吗？'**
  String get workout_stop_save_msg_format;

  /// No description provided for @workout_summary_completed.
  ///
  /// In zh, this message translates to:
  /// **'计划圆满完成'**
  String get workout_summary_completed;

  /// No description provided for @workout_summary_saved.
  ///
  /// In zh, this message translates to:
  /// **'当前进度已保存'**
  String get workout_summary_saved;

  /// No description provided for @workout_toast_completed.
  ///
  /// In zh, this message translates to:
  /// **'训练已完成'**
  String get workout_toast_completed;

  /// No description provided for @workout_toast_ended.
  ///
  /// In zh, this message translates to:
  /// **'训练已结束'**
  String get workout_toast_ended;

  /// No description provided for @workout_toast_saved.
  ///
  /// In zh, this message translates to:
  /// **'进度已保存'**
  String get workout_toast_saved;

  /// No description provided for @workout_unit_km.
  ///
  /// In zh, this message translates to:
  /// **'公里'**
  String get workout_unit_km;

  /// No description provided for @write_invite_code.
  ///
  /// In zh, this message translates to:
  /// **'填写邀请码'**
  String get write_invite_code;

  /// No description provided for @write_invite_code_hint.
  ///
  /// In zh, this message translates to:
  /// **'下载应用后的24小时内输入有效'**
  String get write_invite_code_hint;

  /// No description provided for @wx_entry_error_code_format.
  ///
  /// In zh, this message translates to:
  /// **'错误码%1\$d'**
  String get wx_entry_error_code_format;

  /// No description provided for @wx_entry_launch_failed_format.
  ///
  /// In zh, this message translates to:
  /// **'跳转失败：%1\$s'**
  String get wx_entry_launch_failed_format;

  /// No description provided for @wx_entry_step_format_error.
  ///
  /// In zh, this message translates to:
  /// **'步数数据格式错误：%1\$s'**
  String get wx_entry_step_format_error;

  /// No description provided for @wx_entry_step_process_error.
  ///
  /// In zh, this message translates to:
  /// **'处理步数数据时出错：%1\$s'**
  String get wx_entry_step_process_error;

  /// No description provided for @wx_hint_content.
  ///
  /// In zh, this message translates to:
  /// **'允许App读取微信运动步数'**
  String get wx_hint_content;

  /// No description provided for @wx_hint_title.
  ///
  /// In zh, this message translates to:
  /// **'读取微信运动步数'**
  String get wx_hint_title;

  /// No description provided for @wx_steps.
  ///
  /// In zh, this message translates to:
  /// **'同步微信步数成功：'**
  String get wx_steps;

  /// No description provided for @wx_steps_hint.
  ///
  /// In zh, this message translates to:
  /// **'请用小程序同步微信步数，获取实时步数'**
  String get wx_steps_hint;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'zh':
      return AppL10nZh();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
