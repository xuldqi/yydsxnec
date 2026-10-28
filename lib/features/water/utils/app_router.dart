import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/home_page.dart';
import '../pages/record_page.dart';
import '../pages/photo_ocr_page.dart';
import '../pages/splash_page.dart';
import '../pages/settings_page.dart';
import '../pages/brands_page.dart';
import '../pages/brand_detail_page.dart';
import '../pages/achievements_page.dart';
import '../pages/record_detail_page.dart';

import '../widgets/privacy_consent_gate.dart';
import 'package:provider/provider.dart';
import '../services/personalization_service.dart';
import '../services/session_service.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return PrivacyConsentGate(
            onConsentReady: () async {
              await context.read<PersonalizationProvider>().loadPreferences();
              await SessionService.ensureLocalUser();
            },
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/splash',
            name: 'splash',
            builder: (context, state) => const SplashPage(),
          ),
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(initialTab: 0),
          ),
          GoRoute(
            path: '/record',
            name: 'record',
            builder: (context, state) {
              final prefill = state.extra as Map<String, dynamic>?;
              return RecordPage(prefill: prefill);
            },
          ),
          GoRoute(
            path: '/photo-ocr',
            name: 'photo_ocr',
            builder: (context, state) {
              final prefill = state.extra as Map<String, dynamic>?;
              return PhotoOcrPage(initialPrefill: prefill);
            },
          ),
          GoRoute(
            path: '/records',
            name: 'records',
            builder: (context, state) => const HomePage(initialTab: 1),
          ),
          GoRoute(
            path: '/records/:id',
            name: 'record_detail',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return RecordDetailPage(recordId: id);
            },
          ),
          GoRoute(
            path: '/statistics',
            name: 'statistics',
            builder: (context, state) => const HomePage(initialTab: 2),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const HomePage(initialTab: 3),
          ),
          GoRoute(
            path: '/brands',
            name: 'brands',
            builder: (context, state) {
              final fromRecord = state.uri.queryParameters['from'] == 'record';
              final recordDraft = state.extra is Map<String, dynamic>
                  ? state.extra as Map<String, dynamic>
                  : null;
              return BrandsPage(fromRecord: fromRecord, recordDraft: recordDraft);
            },
          ),
          GoRoute(
            path: '/brands/:id',
            name: 'brand_detail',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              final fromRecord = state.uri.queryParameters['from'] == 'record';
              final recordDraft = state.extra is Map<String, dynamic>
                  ? state.extra as Map<String, dynamic>
                  : null;
              return BrandDetailPage(
                brandId: id,
                fromRecord: fromRecord,
                recordDraft: recordDraft,
              );
            },
          ),
          GoRoute(
            path: '/achievements',
            name: 'achievements',
            builder: (context, state) => const AchievementsPage(),
          ),
        ],
      ),
    ],
  );
}
