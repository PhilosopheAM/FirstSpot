# frontend/feature-stock-insight — 个股信息页

## 模块职责

展示单只股票的聚合信息：标的信息（中英文名 + 代码） / 日线价格走势 / 公司多维信息滑窗 / AI 术语解释。走**中间层模式**：UI 依赖抽象 `StockInsightBackendApi`，实现可切换（真实后端 / Mock）。

## 关键文件

```text
testapp/lib/features/stock_insight/
├── pages/
│   └── stock_insight_template_page.dart   # 顶级页面，装配 UI + 数据服务
├── widgets/
│   └── price_fluctuation_chart.dart       # 日线走势图组件
├── domain/
│   └── stock_insight_models.dart          # SecurityProfile / PricePoint / CompanyInfoCategory / GlossaryItem / StockInsightViewData
└── data/
    └── stock_insight_data_service.dart    # StockInsightBackendApi 契约 + StockInsightDataService 中间层
```

## 对外接口

### 领域模型（`stock_insight_models.dart`）

| 类型 | 字段 | 用途 |
|---|---|---|
| `SecurityProfile` | `securityNameCn / securityNameEn / ticker` | 图表头部信息 |
| `PricePoint` | `x, y` | 单个日线价格点 |
| `CompanyInfoCategory` | `title, content` | 公司信息滑窗的一项 |
| `GlossaryItem` | `term, explanation, whyItMatters` | AI 术语解释项 |
| `StockInsightViewData` | 以上组合 | 中间层聚合响应 |

### 数据层（`stock_insight_data_service.dart`）

| 符号 | 类型 | 作用 |
|---|---|---|
| `StockInsightBackendApi`（abstract） | 契约 | 后端中间层的客户端协议；方法 `fetchStockInsight({required ticker}) → StockInsightViewData` |
| `StockInsightDataService` | 类 | 页面消费的服务；构造参数 `backendApi`；`loadPageData(ticker)` 转发到 `backendApi.fetchStockInsight` |

> 当前 `StockInsightBackendApi` 可能有一个 Mock 实现（同文件后段），替换为真实实现时**保持契约不变**。

### 页面

- `StockInsightTemplatePage`：接收 `ticker`，内部装配数据服务，加载 `StockInsightViewData` 并渲染。

### 组件

- `PriceFluctuationChart`：接收 `List<PricePoint>`，绘制价格曲线。

## 依赖关系

- 本 feature **最终**依赖后端 `datafetcher` 的 `/api/v1/stocks/{symbol}/daily`（通过 `StockInsightBackendApi` 的某个真实实现）
- 依赖 `dart:math`（Mock 数据生成）
- 未来可能依赖图表库（确认见 `pubspec.yaml`）

## 与后端的契约映射

| 后端返回字段（`DailyResponse`） | 前端消费位置 |
|---|---|
| `data[].date / close` | `dayLineSeries: List<PricePoint>` 的 `x, y` |
| `symbol` | `SecurityProfile.ticker`（可能需要二次补全中英文名） |

> 后端当前只返回日线 OHLC，**中英文名、公司信息、术语解释还没有真实后端**，现在由前端 Mock 提供。接入真实后端时：
> 1. 在 `datafetcher` 新增对应端点
> 2. 实现 `StockInsightBackendApi` 的真实版
> 3. 更新本文档「与后端的契约映射」表

## 扩展注意

- **新增一个展示板块**：domain 加模型 → `StockInsightViewData` 加字段 → 数据服务契约返回包含 → 页面渲染对应组件 → 本文档更新
- **切换后端实现**：只换 `StockInsightTemplatePage` 中 `backendApi` 注入的实现类，UI / widgets / domain 都不动

## 变更日志

- 2026-04-20: 初始化文档；当前 5 个领域模型、1 个契约抽象、1 个中间层服务、1 个页面、1 个图表组件。
