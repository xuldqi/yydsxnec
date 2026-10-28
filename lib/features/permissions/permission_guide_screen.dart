// 权限引导页 (对应 Android permission_pager_hint_* + permission 体系)

import 'package:flutter/material.dart';
import '../../l10n/app_l10n_ext.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../l10n/app_localizations.dart';

class PermissionGuideScreen extends StatefulWidget {
  const PermissionGuideScreen({super.key});

  @override
  State<PermissionGuideScreen> createState() => _PermissionGuideScreenState();
}

class _PermissionGuideScreenState extends State<PermissionGuideScreen> {
  int _index = 0;
  final _pages = <_PermItem>[
    _PermItem(
      icon: Icons.directions_walk_rounded,
      titleKey: 'perm_activity_title',
      descKey: 'perm_activity_desc',
      color: AppColors.primary,
      permission: Permission.activityRecognition,
    ),
    _PermItem(
      icon: Icons.location_on_rounded,
      titleKey: 'perm_location_title',
      descKey: 'perm_location_desc',
      color: AppColors.sportWalk,
      permission: Permission.location,
    ),
    _PermItem(
      icon: Icons.notifications_active_rounded,
      titleKey: 'perm_notification_title',
      descKey: 'perm_notification_desc',
      color: AppColors.sportRun,
      permission: Permission.notification,
    ),
  ];

  String _lookup(String key) {
    final l = AppL10n.of(context);
    switch (key) {
      case 'perm_activity_title': return l.s.permActivityTitle;
      case 'perm_activity_desc': return l.s.permActivityDesc;
      case 'perm_location_title': return l.s.permLocationTitle;
      case 'perm_location_desc': return l.s.permLocationDesc;
      case 'perm_notification_title': return l.s.permNotificationTitle;
      case 'perm_notification_desc': return l.s.permNotificationDesc;
    }
    return key;
  }

  Future<void> _grant() async {
    final p = _pages[_index].permission;
    final status = await p.request();
    if (!mounted) return;
    if (status.isGranted || status.isLimited) {
      _next();
    } else if (status.isPermanentlyDenied) {
      _showSettingsDialog();
    } else {
      _next();
    }
  }

  void _next() {
    if (_index < _pages.length - 1) {
      setState(() => _index++);
    } else {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/onboarding');
      }
    }
  }

  void _showSettingsDialog() {
    final l = AppL10n.of(context).s;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.permOpenSettings),
        content: Text(l.permOpenSettingsDesc),
        actions: [
          TextButton(
            onPressed: () { Navigator.of(context).pop(); _next(); },
            child: Text(l.cancel),
          ),
          ElevatedButton(
            onPressed: () { openAppSettings(); Navigator.of(context).pop(); },
            child: Text(l.goSettings),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final p = _pages[_index];
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spacingLg),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  color: p.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(p.icon, size: 100, color: p.color),
              ),
              const SizedBox(height: AppDimens.spacingXxl),
              Text(_lookup(p.titleKey),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22, fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimens.spacingSm),
              Text(_lookup(p.descKey),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 15, height: 1.5,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  final active = i == _index;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 24 : 8, height: 8,
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppDimens.spacingXl),
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: _grant,
                  child: Text(_index == _pages.length - 1 ? l.s.permEnter : l.s.permGrant,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: AppDimens.spacingSm),
              TextButton(
                onPressed: _next,
                child: Text(l.s.skip,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              ),
              const SizedBox(height: AppDimens.spacingSm),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermItem {
  final IconData icon;
  final String titleKey;
  final String descKey;
  final Color color;
  final Permission permission;
  const _PermItem({required this.icon, required this.titleKey, required this.descKey, required this.color, required this.permission});
}
