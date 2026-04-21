/// Last Updated: 2026-04-10
/// 最后更新: 2026-04-10
///
/// Module: Onboarding preferences service - handles first launch detection and local storage
/// 模块: 首开引导配置服务 - 处理首次启动检测与本地存储
///
/// Dependencies: shared_preferences
/// 依赖: shared_preferences
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn

import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPreferencesService {
  static const String _keyCompletedOnboarding = 'hasCompletedOnboarding';
  static const String _keySkippedOnboarding = 'hasSkippedOnboarding';

  /// 判断是否需要展示首开引导
  Future<bool> shouldShowOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool completed = prefs.getBool(_keyCompletedOnboarding) ?? false;
    final bool skipped = prefs.getBool(_keySkippedOnboarding) ?? false;
    
    // 如果既没有完成也没有跳过，就需要展示
    return !completed && !skipped;
  }

  /// 标记已完成首开引导
  Future<void> markOnboardingCompleted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCompletedOnboarding, true);
  }

  /// 标记已跳过首开引导
  Future<void> markOnboardingSkipped() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySkippedOnboarding, true);
  }
}
