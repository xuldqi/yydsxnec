// 完整路由表 - 所有页面已业务实现

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/start_logo/start_logo_screen.dart';

import '../../features/permissions/permission_guide_screen.dart';
import '../../features/agreement/agreement_screen.dart';
import '../../features/agreement/common_problem_screen.dart';
import '../../features/agreement/explain_screen.dart';
import '../../features/health/health_screen.dart';
import '../../features/steps/steps_screen.dart';
import '../../features/sport/sport_screen.dart';
import '../../features/sleep/sleep_screen.dart';
import '../../features/sleep/sleep_record_screen.dart';
import '../../features/water/pages/home_page.dart' as water_home;
import '../../features/poop/pages/poop_screen.dart' as poop;
import '../../features/weight_fitness/screens/home_screen.dart' as weight_fitness;
import '../../features/profile/profile_screen.dart';
import '../../features/records/records_screen.dart';
import '../../features/goal/goal_screen.dart';
import "../../features/setting/data_export_screen.dart";
import "../../features/reports/achievement_poster_screen.dart";
import '../../features/count_time/count_time_screen.dart';
import '../../features/meditation/meditation_screen.dart';
import '../../features/white_noise/white_noise_screen.dart';
import '../../features/diet/diet_screen.dart';
import '../../features/setting/setting_screen.dart';
import '../../features/user_info/user_info_screen.dart';
import '../../features/achievements/achievements_screen.dart';

import '../../features/health_viz/health_viz_screen.dart';
import '../../features/vital_signs/vital_signs_screen.dart';
import '../../features/training/training_plan_screen.dart';
import '../../features/movement/movement_library_screen.dart';
import '../../features/movement/movement_library_screen.dart' show Movement;
import '../../features/reports/week_report_screen.dart';
import '../../features/reports/reports_host_screen.dart';
import '../../features/ai_scan/ai_scan_screen.dart';
import '../../features/step_target/count_step_screen.dart';

import '../../features/sport_extra/sport_extra_screens.dart';
import '../../features/misc/misc_screens.dart';
import '../../features/fasting/fasting_entry.dart' as fasting_entry;
import '../../features/mood/mood_home_screen.dart';
import '../../features/mood/mood_stats_screen.dart';
import '../../features/mood/mood_record_screen.dart';
import '../../features/mood/mood_tag_screen.dart';
import '../../features/period/period_home_screen.dart';
import '../../features/period/period_screens.dart';
import '../../features/body_record/body_record_screens.dart';
import '../../features/sport_detail/sport_detail_screens.dart';
import '../../core/database/app_database.dart';
import '../../features/sport_detail/sport_session_detail_screen.dart';
import '../../features/sport_detail/trace_history_screen.dart';
import '../../features/vital_signs/vital_detail_screen.dart';
import '../../features/water/water_history_screen.dart';
import '../../features/misc/misc_sub_screens.dart';
import '../../features/misc/misc_tail_screens.dart';
import '../../features/diet/calorie_screens.dart';
import '../../core/theme/app_colors.dart';
import '../shell/main_shell.dart';

import '../../main.dart' show initialRoute;

final router = GoRouter(
  initialLocation: initialRoute,
  routes: [
    GoRoute(path: '/start-logo', builder: (c, s) => const StartLogoScreen()),
    GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreen()),

    GoRoute(path: '/permission', builder: (c, s) => const PermissionGuideScreen()),
    GoRoute(path: '/agreement', builder: (c, s) => const AgreementScreen(isPrivacy: false)),
    GoRoute(path: '/privacy', builder: (c, s) => const AgreementScreen(isPrivacy: true)),
    GoRoute(path: '/common-problem', builder: (c, s) => const CommonProblemScreen()),
    GoRoute(path: '/explain', builder: (c, s) => const ExplainScreen(titleKey: 'dataCollectDesc', contentKey: 'deviceSyncDesc')),

    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (c, s) => const StepsScreen()),
        GoRoute(path: '/daily', builder: (c, s) => const ReportsHostScreen()),
        GoRoute(path: '/goal', builder: (c, s) => const GoalScreen()),
        GoRoute(path: '/relax', builder: (c, s) => const MeditationScreen()),
        GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
      ],
    ),

    // 健康/步数/运动/睡眠/水/体重 - 完整
    GoRoute(path: '/steps', builder: (c, s) => const StepsScreen()),
    GoRoute(path: '/sleep', builder: (c, s) => const SleepScreen()),
    GoRoute(path: '/water', builder: (c, s) => const water_home.HomePage()),
    GoRoute(path: '/poop', builder: (c, s) => const poop.PoopScreen()),
    GoRoute(path: '/weight', builder: (c, s) => const weight_fitness.HomeScreen()),
    GoRoute(path: '/count-time', builder: (c, s) => CountTimeScreen(
          type: s.uri.queryParameters['type'],
          goal: s.uri.queryParameters['goal'],
        )),
    GoRoute(path: '/meditation', builder: (c, s) => const MeditationScreen()),
    GoRoute(path: '/white-noise', builder: (c, s) => const WhiteNoiseScreen()),
    GoRoute(path: '/diet', builder: (c, s) => const DietScreen()),

    GoRoute(path: '/vital-signs', builder: (c, s) => const VitalSignsScreen()),


    // 成就
    GoRoute(path: '/achievements', builder: (c, s) => const AchievementsScreen()),

    // 训练/动作
    GoRoute(path: '/training-plan', builder: (c, s) => const TrainingPlanScreen()),
    GoRoute(path: '/my-training-plan', builder: (c, s) => const MyTrainingPlanScreen()),
    GoRoute(path: '/movement-library', builder: (c, s) => const MovementLibraryScreen()),
    GoRoute(path: '/movement-detail', builder: (c, s) => const MovementDetailScreen(movement: _placeholderMovement)),
    GoRoute(path: '/movement-timer', builder: (c, s) => const MovementTimerScreen(movement: _placeholderMovement)),
    GoRoute(path: '/guided-workout', builder: (c, s) => const GuidedWorkoutScreen()),
    GoRoute(path: '/exercise-tracking', builder: (c, s) => const ExerciseTrackingScreen()),

    // 周报
    GoRoute(path: '/week-sport-report', builder: (c, s) => const ReportsHostScreen(initialIndex: 1)),

    // 步数目标
    GoRoute(path: '/count-step', builder: (c, s) => const CountStepScreen()),
    GoRoute(path: '/count-step-new', builder: (c, s) => const CountStepNewScreen()),
    GoRoute(path: '/set-target', builder: (c, s) => const SetTargetScreen()),
    GoRoute(path: '/set-sport-target', builder: (c, s) => const SetSportTargetScreen()),
    GoRoute(path: '/target', builder: (c, s) => const TargetActivityScreen()),
    GoRoute(path: '/custom-target', builder: (c, s) => const CustomTargetScreen()),
    GoRoute(path: '/step-target-list', builder: (c, s) => const StepTargetListScreen()),

    // 体重/睡眠/冥想/水/食 扩展
    GoRoute(path: '/weight-calendar', builder: (c, s) => const WeightCalendarScreen()),
    GoRoute(path: '/professional-weight', builder: (c, s) => const ProfessionalWeightScreen()),
    GoRoute(path: '/body-record', builder: (c, s) => const BodyRecordScreen()),
    GoRoute(path: '/body-record-info', builder: (c, s) => const BodyRecordInfoScreen()),
    GoRoute(path: '/sleep-record', builder: (c, s) => const SleepRecordScreen()),
    GoRoute(path: '/food-recognition', builder: (c, s) => const FoodRecognitionScreen()),
    GoRoute(path: '/mood', builder: (c, s) => const MoodHomeScreen()),
    GoRoute(path: '/mood/stats', builder: (c, s) => const MoodStatsScreen()),
    GoRoute(path: '/mood/record', builder: (c, s) => const MoodRecordScreen()),
    GoRoute(path: '/mood/tags', builder: (c, s) => const MoodTagScreen()),

    // 运动扩展
    GoRoute(path: '/distance-sport', builder: (c, s) => const DistanceSportScreen()),
    GoRoute(path: '/time-sport', builder: (c, s) => const TimeSportScreen()),
    GoRoute(path: '/sport-type', builder: (c, s) => const SportTypeSelectorScreen()),
    GoRoute(path: '/add-sport-record', builder: (c, s) => const AddSportRecordScreen()),
    GoRoute(path: '/sport-detail', builder: (c, s) => const SportDetailScreen()),



    // 轨迹已移除



    // AI
    GoRoute(path: '/ai-scan', builder: (c, s) => const AiHealthScanScreen()),

    // 编辑主页卡片已移除


    // 设置 + 资料
    GoRoute(path: '/setting', builder: (c, s) => const SettingScreen()),
    GoRoute(path: '/data-export', builder: (c, s) => const DataExportScreen()),
    GoRoute(path: '/achievement-poster', builder: (c, s) => const AchievementPosterScreen()),
    GoRoute(path: '/user-info', builder: (c, s) => const UserInfoScreen()),

    // 节食 (Fasting)
    GoRoute(path: '/fasting', builder: (c, s) => const fasting_entry.AppInitializer()),

    // Period 经期
    GoRoute(path: '/period', builder: (c, s) => const PeriodHomeScreen()),
    GoRoute(path: '/period/record', builder: (c, s) => const PeriodRecordScreen()),
    GoRoute(path: '/period/calendar', builder: (c, s) => const PeriodCalendarScreen()),
    GoRoute(path: '/period/history', builder: (c, s) => const PeriodHistoryScreen()),
    GoRoute(path: '/period/trends', builder: (c, s) => const PeriodTrendsScreen()),
    GoRoute(path: '/period/prediction', builder: (c, s) => const PeriodPredictionScreen()),
    GoRoute(path: '/period/reminder', builder: (c, s) => const PeriodReminderScreen()),

    // Body Record
    GoRoute(path: '/body-record', builder: (c, s) => const BodyRecordManageScreen()),
    GoRoute(path: '/body-record/info', builder: (c, s) => const BodyRecordInfoScreen()),

    // 训练详情
    GoRoute(path: '/workout/start', builder: (c, s) => const StartWorkoutScreen(name: '训练', totalMin: 20)),
    GoRoute(path: '/workout/detail', builder: (c, s) => const WorkoutDetailScreen(name: '标准训练')),
    GoRoute(path: '/workout/history', builder: (c, s) => const WorkoutHistoryScreen()),

    // 扫描结果+建议
    GoRoute(path: '/ai-scan-result', builder: (c, s) => const AIHealthScanResultScreen()),
    GoRoute(path: '/smart-advice', builder: (c, s) => const SmartAdviceScreen()),

    // 运动子页
    GoRoute(path: '/sport/walk-distance', builder: (c, s) => const WalkDistanceScreen()),
    GoRoute(path: '/sport/walk-history', builder: (c, s) => const WalkDistanceHistoryScreen()),
    GoRoute(path: '/sport/distance', builder: (c, s) => const DistanceSportScreen()),
    GoRoute(path: '/sport/time', builder: (c, s) => const TimeSportScreen()),
    GoRoute(path: '/sport/exercise-tracking', builder: (c, s) => const ExerciseTrackingScreen()),
    GoRoute(path: '/sport/goal', builder: (c, s) => const SportGoalSettingScreen()),
    GoRoute(path: '/sport/guided', builder: (c, s) => const GuidedWorkoutScreen()),
    GoRoute(path: '/trace-history', builder: (c, s) => const TraceHistoryScreen()),
    GoRoute(path: '/sport-session-detail', builder: (c, s) => SportSessionDetailScreen(record: s.extra as ExerciseRecord)),

    // 健康仪表板

    GoRoute(path: '/health-full-report', builder: (c, s) => const HealthFullReportScreen()),
    GoRoute(
      path: '/vital-detail', 
      builder: (c, s) => VitalDetailScreen(
        title: s.uri.queryParameters['title'] ?? '',
        type: s.uri.queryParameters['type'] ?? '',
      ),
    ),
    // 卡路里
    GoRoute(path: '/calorie', builder: (c, s) => const CalorieHomeScreen()),
    GoRoute(path: '/calorie/goal', builder: (c, s) => const CalorieGoalSettingScreen()),
    GoRoute(path: '/calorie/history', builder: (c, s) => const CalorieHistoryScreen()),

    // 饮水历史
    GoRoute(path: '/water-history', builder: (c, s) => const WaterHistoryScreen()),

    GoRoute(path: '/calorie/day', builder: (c, s) => const CalorieDayDetailScreen()),
    GoRoute(path: '/calender', builder: (c, s) => const CalenderScreen()),
    GoRoute(path: '/scan-history', builder: (c, s) => const HealthScanHistoryScreen()),
    GoRoute(path: '/new-ver', builder: (c, s) => const NewVerScreen()),
  ],
);

const _placeholderMovement = Movement(
  id: 'm1', name: '标准俯卧撑', bodyPart: '胸/三头', difficulty: '入门', equipment: '无',
  durationSec: 60, calories: 8, color: AppColors.sportOther, icon: Icons.accessibility_rounded,
  steps: ['双手撑地，与肩同宽', '身体保持一条直线', '下降至胸部接近地面', '推起至起始位置', '重复 10-15 次'],
);
