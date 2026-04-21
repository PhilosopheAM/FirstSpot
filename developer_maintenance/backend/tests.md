# backend/tests — 测试

## 模块职责

pytest 测试集合。当前主要覆盖 `services/daily_service.py` 的降级逻辑与 `providers/canghai_client.py` 的协议兼容性。

## 关键文件

| 路径 | 作用 |
|---|---|
| `datafetcher/tests/__init__.py` | 空包声明 |
| `datafetcher/tests/test_daily_service.py` | `DailyService.get_latest_daily` 主流程测试 |
| `datafetcher/tests/test_daily_service_canghai_only.py` | 降级到沧海这一层的专项测试 |
| `datafetcher/tests/test_canghai_client.py` | Canghai provider 单元测试 |

## 运行方式

```bash
cd datafetcher
pytest -q
```

## 约定

- Provider 层测试用 **monkeypatch / mock** 替换 `urlopen`，不打真实网络
- Service 层测试用**内存假 client**（实现 `fetch_*` 接口），断言降级路径、字段映射、截断逻辑
- 新增功能必须**同步加测试**；测试命名：`test_<模块>_<场景>.py`

## 依赖关系

依赖：`pytest`、`app.*` 全部模块

被依赖：CI / 本地回归

## 变更日志

- 2026-04-20: 初始化文档；当前 3 个测试文件，覆盖 Service 主流程 + Canghai 降级专项 + Canghai client。
