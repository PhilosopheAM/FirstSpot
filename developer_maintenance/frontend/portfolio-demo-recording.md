# FirstSpot 录屏演示数据说明

## 用途

Android Studio / 真机录屏时，需要可见的**持仓**、**金库卡牌**与**徽章**。以下数据在首次空状态时自动注入（各模块独立种子标记，互不影响）。

---

## 一、金库（卡牌 + 徽章）

### 默认解锁

| 类型 | 内容 |
|------|------|
| 概念卡 | 第 1–5 章（CH01–CH05）共 5 张 |
| 徽章 | 学习启程、小测通关、复习回顾（共 3 枚） |

对应章节卡名称示例：市场门口的第一步、交易所地图……（见 `guidance_lessons.dart`）。

### 关键实现

| 文件 | 作用 |
|------|------|
| `guidance_demo_seed.dart` | `vaultDemoCompletedLessonIds`、`vaultDemoBadgeIds` |
| `guidance_user_progress.dart` | `load()` 时 `_maybeSeedVaultDemo`；标记键 `learning_guidance.vault_demo_seeded_v1` |

进入首页底部 **金库** → 切换「卡片 / 徽章」即可左右滑动演示。

---

## 二、持仓

Android Studio / 真机录屏时，持仓总览与详情「走势示意」需要可见数据。本包在**首次无本地持仓**时自动注入 6 条演示持仓，并从 `assets/mock_data/*_daily.json` 绘制迷你折线图。

## 演示持仓（6 条）

| 类型 | 代码 | 名称 | 买入日 | 备注 |
|------|------|------|--------|------|
| 股票 | 600519.SH | 贵州茅台 | 2025-09-12 | 富途牛牛 |
| 股票 | 000858.SZ | 五粮液 | 2025-10-08 | 招商证券 |
| 股票 | 601318.SH | 中国平安 | 2025-11-21 | 富途牛牛 |
| ETF | 510300.SH | 沪深300ETF | 2025-12-15 | 招商证券 |
| ETF | 159915.SZ | 创业板ETF | 2026-02-03 | 富途牛牛 |
| ETF | 512880.SH | 证券ETF | 2026-04-07 | 招商证券 |

`lastPrice` / `dayChangePercent` 与对应 mock 日线末日收盘价对齐（截至 2026-05-20）。

## 关键实现

| 文件 | 作用 |
|------|------|
| `portfolio_demo_seed.dart` | `buildPortfolioDemoHoldings()`、`portfolioDemoSeededPrefKey` |
| `portfolio_repository.dart` | 空列表首次加载时注入并写 `portfolio.demo_seeded_v1` |
| `portfolio_market_data_service.dart` | 读取 `assets/mock_data/{code}_daily.json` |
| `portfolio_sparkline_chart.dart` | 详情弹层走势折线（fl_chart） |

## 录屏前若页面仍为空

可能已写入「已种子」标记但数据被删空。任选其一重置：

1. **卸载并重装 App**（清空 SharedPreferences，推荐）
2. 清除应用数据（系统设置 / adb）
3. 调试分别调用：
   - 持仓：`PortfolioRepository().clearAll()`
   - 金库：`guidanceUserProgress.clearAllProgress()`
4. 冷启动后重新进入对应页面（金库会在 `VaultPage` / `load()` 时注入）

## 重新生成 mock 日线

本地 AKTools 未启动时，可用项目根目录脚本逻辑生成（2025-09-01～2026-05-20 交易日随机游走）：

```powershell
Set-Location f:\Do_Some_Great_Things\FirstSpot
python -c "# 见 feature-portfolio.md 变更日志或联系维护者索取生成片段"
```

产出目录：`testapp/assets/mock_data/{600519,000858,601318,510300,159915,512880}_daily.json`。

接入真实行情后，可将 `PortfolioMarketDataService` 改为请求 `datafetcher` 日线接口，保留同一 JSON 字段结构。

## 变更日志

- 2026-05-21: 金库录屏演示：默认 CH01–CH05 卡牌 + 3 徽章；文档扩展为录屏总览。
- 2026-05-21: 持仓录屏演示种子、6 份 mock 日线、详情走势折线图。
