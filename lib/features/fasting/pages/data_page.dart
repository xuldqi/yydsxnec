import 'package:flutter/material.dart';

import 'package:steps_webu_flutter/core/theme/app_colors.dart';
import 'record_page.dart';
import 'statistics_page.dart';

class DataPage extends StatelessWidget {
  const DataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: const LinearGradient(colors: [AppColors.background, AppColors.surface])),
        child: const SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '数据',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '记录、趋势和分析放在一起看，先看今天，再看变化。',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.35,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 18),
                RecordView(),
                SizedBox(height: 28),
                StatisticsView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
