# DataFetcher (Independent Module)

`DataFetcher` 是一个独立 Python 服务，用于把 Flutter 请求转为上游 AKTools 请求，并完成：

- 数据源降级：`stock_zh_a_hist`(东财) -> `stock_zh_a_daily`(新浪) -> `local akshare`(本地直连) -> `canghai`(沧海)
- 输入解析：`symbol` 同时支持股票代码（如 `600519`）和股票名称（如 `贵州茅台`）
- 字段标准化：统一成 `date/open/high/low/close/volume/amount`
- 固定返回最近 N 条日线（默认 120）

> 当前按你的要求：**不做本地缓存**，只做请求、拉取、处理、交付。

---

## 1) 目录结构

```text
datafetcher/
  requirements.txt
  README.md
  app/
    __init__.py
    main.py
    config.py
    models.py
    providers/
      __init__.py
      aktools_client.py
    services/
      __init__.py
      daily_service.py
```

---

## 2) 安装与启动

在你的 `firstspot-ak` 虚拟环境里执行：

```bash
cd F:\Do_Some_Great_Things\FirstSpot\datafetcher
pip install -r requirements.txt
```

先确认 AKTools 已启动：

```bash
python -m aktools --host 127.0.0.1 --port 8080
```

再启动 DataFetcher：

```bash
uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
```

---

## 3) Flutter 请求格式（当前假定）

```http
GET /api/v1/stocks/{symbol}/daily?limit=120
```

示例：

```http
GET http://127.0.0.1:8000/api/v1/stocks/600000/daily?limit=120

# 也支持按名称输入（URL 需编码）
GET http://127.0.0.1:8000/api/v1/stocks/%E8%B4%B5%E5%B7%9E%E8%8C%85%E5%8F%B0/daily?limit=6000
```

返回示例（节选）：

```json
{
  "symbol": "600000",
  "stock_name": "浦发银行",
  "requested_limit": 120,
  "actual_count": 120,
  "insufficient_history": false,
  "source_used": "eastmoney:stock_zh_a_hist",
  "data": [
    {
      "date": "2025-09-01",
      "open": 10.1,
      "high": 10.5,
      "low": 9.9,
      "close": 10.2,
      "volume": 1234567.0,
      "amount": 123456789.0
    }
  ]
}
```

---

## 4) 日线不足 120 条（新股等）处理方式

当实际历史交易数据 `< 120` 时，常见有 3 种处理策略：

1. **Return Available（当前已实现，推荐测试阶段）**  
   - 返回所有可用数据；
   - `insufficient_history=true`，`actual_count<120`。
   - 优点：真实、简单，前端最容易处理。

2. **Pad Null（可后续扩展）**  
   - 返回固定 120 条，不足部分补 `null`（或空对象）；
   - 优点：前端序列长度恒定；
   - 缺点：图表渲染逻辑复杂，容易误读。

3. **Hard Error（可后续扩展）**  
   - 若不足 120，直接返回 4xx 错误；
   - 优点：数据质量门槛严格；
   - 缺点：用户体验较差，新股几乎总报错。

---

## 5) 可维护性设计说明

- `providers/`：只负责调用 AKTools
- `services/`：只负责业务逻辑（降级、标准化、截断）
- `models.py`：统一对外响应结构
- `config.py`：统一环境配置（端口、上游地址、limit）

后续要接入新的第三方源时，只需：

1. 在 `providers/` 新增客户端；
2. 在 `services/daily_service.py` 增加 fallback 顺序；
3. 保持 `models.py` 不变即可让 Flutter 无感升级。

