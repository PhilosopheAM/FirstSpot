/// Last Updated: 2026-04-10
/// 最后更新: 2026-04-10
///
/// Module: Onboarding models - enumerations and states for the onboarding flow
/// 模块: 首开引导模型 - 引导流程的枚举与状态
///
/// Dependencies: None
/// 依赖: 无
///
/// Author: Harry Chen
/// Email: 11911421@mail.sustech.edu.cn

/// 每月可攒金额范围
enum SavingsRange {
  lessThan500('<500', '很多人也是从小额开始的，关键是坚持。'),
  between500And2000('500-2000', '聚沙成塔，这是一个很好的起点。'),
  between2000And5000('2000-5000', '非常棒的储蓄习惯，你的资产会稳步增长。'),
  moreThan5000('>5000', '充足的现金流能让你在投资时更从容。');

  const SavingsRange(this.label, this.feedback);
  final String label;
  final String feedback;
}

/// 用户身份
enum UserIdentityType {
  student('在校学生', '学生时代接触理财，是对未来最好的投资。'),
  newWorker('刚工作(1-3年)', '职场新人正是建立第一桶金的关键期。'),
  experiencedWorker('工作3年以上', '有一定积蓄后，是时候让钱为你工作了。'),
  other('其它', '无论什么身份，理财都是人生的必修课。');

  const UserIdentityType(this.label, this.feedback);
  final String label;
  final String feedback;
}

/// 面对波动的情绪
enum VolatilityFeeling {
  scared('一点点亏就睡不着', '😰', '怕亏钱是正常的，我们会从最基础的安全感开始讲。'),
  acceptSmall('小起伏还能接受', '🙂', '保持平常心，这是做长线投资的好心态。'),
  acceptLarge('能接受上下波动，不想爆仓', '😎', '你很有风险意识，我们会教你如何做资产配置。');

  const VolatilityFeeling(this.label, this.emoji, this.feedback);
  final String label;
  final String emoji;
  final String feedback;
}

/// 用户问卷答案收集
class OnboardingProfileAnswers {
  OnboardingProfileAnswers({
    this.identity,
    this.savings,
    this.volatility,
  });

  UserIdentityType? identity;
  SavingsRange? savings;
  VolatilityFeeling? volatility;

  bool get isComplete => identity != null && savings != null && volatility != null;
}
