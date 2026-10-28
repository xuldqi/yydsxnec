import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:intl/date_symbol_data_local.dart';

import 'core/constants/app_constants.dart' as constants;
import 'models/fasting_plan.dart';
import 'models/fasting_session.dart';
import 'models/water_record.dart';
import 'models/weight_record.dart';
import 'models/suggestion.dart';
import 'models/exercise_record.dart';
import 'models/food_record.dart';
import 'models/week_plan.dart';
import 'models/achievement.dart';
import 'pages/main_screen.dart';
import 'pages/onboarding_page.dart';
import 'pages/splash_privacy_page.dart';
import 'providers/fasting_provider.dart';
import 'providers/user_settings_provider.dart';
import 'theme/app_theme.dart';
import 'utils/platform_utils.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化本地化日期格式（用于 zh_CN 等本地化格式化）
  try {
    await initializeDateFormatting('zh_CN', null);
  } catch (e) {
    // 如果初始化失败，不要阻塞应用启动，仅在需要的地方回退到非本地化格式
    if (kDebugMode) {
      debugPrint('日期本地化初始化失败: $e');
    }
  }

  try {
    await initializeHive();
  } catch (e) {
    debugPrint('Hive 初始化失败: $e');
    // 继续执行，让应用至少能启动
  }

  // 初始化通知服务（Web 上可能不支持，不要阻塞）
  try {
    await NotificationService().initialize();
  } catch (e) {
    debugPrint('通知服务初始化失败（Web 可能不支持）: $e');
    // Web 上通知服务可能不支持，不要阻塞启动
  }

  runApp(const ProviderScope(child: LightFastingApp()));
}

Future<void> initializeHive({String? testPath}) async {
  // 初始化Hive。测试环境传入路径，避免依赖平台插件提供存储目录。
  if (testPath == null) {
    await Hive.initFlutter();
  } else {
    Hive.init(testPath);
  }

  // 为避免 Hive 将适配器注册为 dynamic（导致所有写入都走同一个适配器，从而出现
  // 'FastingSessionImpl is not a subtype of FastingPlan' 这类错误），
  // 这里显式为每个类型使用泛型版本的 registerAdapter。
  void registerAdapterIfNeeded<T>(int typeId, TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter<T>(adapter);
    }
  }

  // 注册适配器（避免热重载/热重启导致重复注册）
  registerAdapterIfNeeded<FastingPlan>(0, FastingPlanAdapter());
  registerAdapterIfNeeded<FastingSession>(2, FastingSessionAdapter());
  registerAdapterIfNeeded<WaterRecord>(4, WaterRecordAdapter());
  registerAdapterIfNeeded<WeightRecord>(6, WeightRecordAdapter());
  registerAdapterIfNeeded<Suggestion>(7, SuggestionAdapter());
  registerAdapterIfNeeded<ExerciseRecord>(16, ExerciseRecordAdapter());
  registerAdapterIfNeeded<FoodRecord>(11, FoodRecordAdapter());
  registerAdapterIfNeeded<WeekPlan>(12, WeekPlanAdapter());
  registerAdapterIfNeeded<Achievement>(13, AchievementAdapter());

  // 注册枚举适配器
  registerAdapterIfNeeded<constants.FastingDifficulty>(
    1,
    constants.FastingDifficultyAdapter(),
  );
  registerAdapterIfNeeded<constants.FastingStatus>(
    10,
    constants.FastingStatusAdapter(),
  );
  registerAdapterIfNeeded<constants.SuggestionType>(
    8,
    constants.SuggestionTypeAdapter(),
  );
  registerAdapterIfNeeded<constants.SuggestionPriority>(
    9,
    constants.SuggestionPriorityAdapter(),
  );
  registerAdapterIfNeeded<WaterTypeAdapter>(5, WaterTypeAdapterAdapter());
  registerAdapterIfNeeded<constants.ExerciseType>(
    17,
    constants.ExerciseTypeAdapter(),
  );
  registerAdapterIfNeeded<AchievementType>(14, AchievementTypeAdapter());
  registerAdapterIfNeeded<AchievementRarity>(15, AchievementRarityAdapter());
}

class LightFastingApp extends ConsumerWidget {
  const LightFastingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: '小鹿轻断食',
      theme: ThemeData.light().copyWith(
        // 根据平台调整字体
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: PlatformUtils.getFontFamily(),
        ),
      ),
      darkTheme: ThemeData.light().copyWith(
        // 根据平台调整字体
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: PlatformUtils.getFontFamily(),
        ),
      ),
      themeMode: themeMode,
      scrollBehavior: PlatformUtils.getScrollBehavior(),
      home: const AppInitializer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppInitializer extends ConsumerStatefulWidget {
  const AppInitializer({super.key});

  @override
  ConsumerState<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends ConsumerState<AppInitializer> {
  bool _hasTimedOut = false;

  @override
  void initState() {
    super.initState();
    // 3秒超时保护
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final currentState = ref.read(fastingPlansProvider);
        if (currentState.isLoading) {
          setState(() {
            _hasTimedOut = true;
          });
          // 强制使用预设方案
          ref.read(fastingPlansProvider.notifier).usePresetPlans();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(fastingPlansProvider);
    final onboardingAsync = ref.watch(hasCompletedOnboardingProvider);
    final privacyAsync = ref.watch(hasAgreedPrivacyProvider);

    // 等待状态加载完成
    if (plansAsync.isLoading ||
        onboardingAsync.isLoading ||
        privacyAsync.isLoading) {
      if (!_hasTimedOut) {
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('正在初始化应用...'),
                SizedBox(height: 8),
                Text(
                  '如果长时间无响应，将自动进入',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }
    }

    if (plansAsync.hasError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(fastingPlansProvider.notifier).usePresetPlans();
      });
    }

    final hasAgreed = privacyAsync.valueOrNull ?? false;
    if (!hasAgreed) {
      return const SplashPrivacyPage();
    }

    final hasOnboarded = onboardingAsync.valueOrNull ?? false;
    return hasOnboarded ? const MainScreen() : const OnboardingPage();
  }
}
