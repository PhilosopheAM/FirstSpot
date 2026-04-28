# frontend/feature-learning-guidance

## 模块职责

`learning_guidance` 承载 FirstSpot 投资者教育 12 章学习路径。模块负责章节列表、严格顺序解锁、章节详情、Myo 对话式讲解、每章“先教育、再小测”的学习闭环、统一章末通行证小测组件、48 道题库、金融术语首次出现高亮解释、目录页词汇表复习入口与概念卡主视觉展示。

## 关键文件


| 文件                                                                         | 作用                                                       |
| -------------------------------------------------------------------------- | -------------------------------------------------------- |
| `testapp/lib/features/learning_guidance/domain/guidance_models.dart`       | 章节、题目、选项与题型模型                                            |
| `testapp/lib/features/learning_guidance/data/guidance_concept_dialogues.dart` | 12 章“概念”环节 Myo 引导式问答脚本；每章 7 个概念路径节点、每节点 3 个用户提问式选项 |
| `testapp/lib/features/learning_guidance/data/guidance_lessons.dart`        | 12 章课程数据、关键点、Myo 引导语与 48 道练习题                            |
| `testapp/lib/features/learning_guidance/data/guidance_glossary.dart`       | 金融 / 市场 / 投资术语表，维护新手白话解释、别名匹配和词汇表展示内容                    |
| `testapp/lib/features/learning_guidance/pages/guidance_learning_page.dart` | 课程列表与章节详情页；目录页负责逐章解锁和词汇表入口；详情页先展示可点亮的概念、案例、互动学习卡，再解锁章末小测 |
| `testapp/lib/features/learning_guidance/widgets/finance_term_text.dart`    | 可复用术语高亮文本组件；仅渲染页面传入的可高亮术语；点击术语弹出 Myo 解释框，支持右上角关闭和背景关闭    |
| `testapp/lib/features/learning_guidance/widgets/myo_practice_block.dart`   | 可复用章末通行证小测组件，包含即时反馈、卡片解锁、XP 与下一章通行证文案                    |
| `testapp/test/learning_guidance_test.dart`                                 | 课程页基础渲染与章节详情练习入口测试                                       |
| `testapp/assets/audio/guidance_*.wav`                                      | 投资者教育学习闭环音效，用于学习卡点亮、小测解锁和终章奖励反馈                          |
| `testapp/assets/images/characters/myo/*.png`                               | 学习流程中复用的 Myo 表情素材                                        |
| `testapp/assets/images/guidance_cards/*.png`                               | 12 张线条风格章节主视觉                                            |
| `testapp/assets/images/learning_guidance/*.png`                            | 章末通行证小测背景图、通过结果插画与重练鼓励插画；同步自设计资源归档目录 |
| `Design_Resource/UI_design_resource/guidance_cards/README.md`              | 素材风格规范、提示词摘要与同步说明                                        |
| `Design_Resource/UI_design_resource/learning_guidance/README.md`           | 章末练习缺失美术素材的归档清单、用途说明与前端同步规则 |
| `UX-Product-Design/guidance/14_先教育再小测学习闭环与素材补全记录.md`                       | V1.2 学习闭环、资料检索汇总、缺失美术提示词与音频提示词                           |
| `Design_Resource/Sound_design_resource/guidance_learning_audio_prompts.md` | 投资者教育学习闭环音频素材提示词与实装映射                                    |


## 对外接口 / 调用方式

首页通过 `GuidanceLearningPage` 进入课程：

```dart
Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (_) => const GuidanceLearningPage(),
  ),
);
```

`GuidanceLearningPage` 当前无构造参数，内部直接读取 `guidanceLessons` 静态数据。

- 第 1 章默认解锁；第 N 章必须等第 N-1 章学习阶段三张卡片全部点亮后才能进入。
- 词汇表入口位于课程目录页，只展示已完成学习章节中首次引入的术语；未解锁术语不会出现在复习列表中。
- 术语高亮采用“全 12 章首次出现”策略：同一个 canonical term 只在从 CH01 到 CH12 顺序扫描到的第一个文本位置以浅蓝词卡样式高亮并可交互，后续重复出现保持普通文本。

### 2026-04-28 概念路径图重构补充

- CH01-CH12 的“概念”学习步点击后均进入 Myo 聊天框；聊天框由上方飞入，左上角返回章节页。
- 聊天选择进度保存在 `GuidanceLearningPage` 页面状态中，再次进入会接续上次节点。
- 12 章脚本统一维护在 `guidance_concept_dialogues.dart`，采用“概念路径图”方法：每章 7 个必经节点、每节点 3 个用户提问式选项，选项表达不同但收束到同一教学目标，避免关键概念因分支路径而漏触发。
- 概念对话的术语首次出现扫描覆盖全部 12 章，不再只扫描 CH01。

## 依赖关系

- 依赖 Flutter `material.dart`。
- 依赖 `audioplayers` 播放 learning guidance 音效；播放失败时只忽略音频层，不阻断学习流程。
- 被 `features/onboarding/pages/home_dashboard_page.dart` 作为首页任务入口调用。
- 图片资源由 `pubspec.yaml` 的 `assets/images/guidance_cards/`、`assets/images/characters/myo/` 与 `assets/images/learning_guidance/` 暴露；音频资源由 `assets/audio/guidance_*.wav` 暴露。
- `MyoPracticeBlock` 按题型使用单选/匹配背景，按章节奇偶切换通过/重练插画版本，保证 12 章章末小测复用同一套素材规则。
- 课程内容与设计文档对应 `UX-Product-Design/guidance/13_12章练习交互细化与素材清单.md` 与 `UX-Product-Design/guidance/14_先教育再小测学习闭环与素材补全记录.md`。
- 12 章概念聊天方法论与路径图对应 `UX-Product-Design/guidance/15_12章概念聊天对话与首章实装.md`。

## 变更日志

- 2026-04-25: 新增 `learning_guidance` feature，接入 12 章课程、48 道练习、Myo 即时反馈组件和线条风格章节主视觉。
- 2026-04-25: 新增 `learning_guidance_test.dart`，覆盖课程列表渲染和章节详情练习入口。
- 2026-04-25: 将章节详情调整为“概念教育 + 案例说明 + 轻量互动 + 章末通行证小测”，并补充学习闭环与音频素材提示词维护文档。
- 2026-04-25: 新增金融术语高亮解释组件与术语表，章节学习卡改为点亮后解锁章末小测，并接入 Myo 表情素材贯穿学习流程。
- 2026-04-25: 导入 6 个 `guidance_*.wav` 学习闭环音效，接入学习卡点亮、章末小测解锁、通行证通过和 CH12 终章奖励。
- 2026-04-25: 调整术语高亮为浅蓝词卡样式且去掉下划线；新增目录页词汇表复习入口；章节入口改为严格顺序解锁，并补充对应 widget 测试。
- 2026-04-25: 导入并接入 8 张章末练习图片素材，新增 `assets/images/learning_guidance/` 声明；小测题卡使用题型背景图，结果区使用通过/重练插画。
- 2026-04-25: 新增 12 章“概念”聊天脚本数据与 CH01 概念聊天框实装；第 1 章概念卡改为 Myo 对话入口，支持上方飞入动画、左上角返回、进度保存、术语词卡解释和完成后自动点亮概念学习步。
- 2026-04-28: 将 12 章概念聊天脚本重构为“概念路径图”驱动的 7 节点必经路径，并将概念聊天入口与术语首次出现扫描扩展到 CH01-CH12。
