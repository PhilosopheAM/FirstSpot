# MiniMax MCP 接入说明

## 当前接入方案

由于当前机器已经具备 `node` / `npx`，但 `uvx` 尚未安装成功，因此本项目优先采用 MiniMax 官方 **JavaScript MCP** 方案接入。

官方文档：

- [MiniMax MCP 文档](https://platform.minimaxi.com/docs/guides/mcp-guide)
- [音乐生成 API / 能力说明](https://platform.minimaxi.com/docs/api-reference/music-intro)

## 已完成内容

已经写入的 Cursor MCP 配置文件：

- `C:\Users\harry\.cursor\mcp.json`

当前配置要点：

- `command`: `npx`
- `args`: `["-y", "minimax-mcp-js"]`
- `transport`: `studio`
- `MINIMAX_API_HOST`: `https://api.minimaxi.com`
- `MINIMAX_MCP_BASE_PATH`: `F:\Do_Some_Great_Things\FirstSpot\Design_Resource\Sound_design_resource\generated_by_minimax`
- `MINIMAX_RESOURCE_MODE`: `local`

## 还需要你手动完成的一步

把 `C:\Users\harry\.cursor\mcp.json` 里的：

`REPLACE_WITH_YOUR_MINIMAX_API_KEY`

替换成你自己的 MiniMax API Key。

官方文档说明，API Key 需要在 MiniMax 开放平台创建。

## 接入后怎么生效

1. 填写 API Key
2. 重启 Cursor，或者在 MCP 设置里重新加载
3. 确认 `MiniMax` MCP Server 已经出现在工具列表中

## 输出目录

MiniMax 生成的本地文件会输出到：

`F:\Do_Some_Great_Things\FirstSpot\Design_Resource\Sound_design_resource\generated_by_minimax`

## 音频格式约定

当前项目允许 `.mp3` 与 `.wav` 混用。

- 短音效可以使用 `.wav` 或 `.mp3`
- BGM 和较长音频使用 `.mp3` 也完全可以
- 关键是保持文件基名稳定，例如 `correct_ding`、`option_select_pop`
- 后续在 App 中接入时，以实际文件扩展名为准，不要求为了文档统一而强制转码

换句话说，文档中的音效名可以视为“目标资源名”，扩展名不再强制绑定为 `.wav`。

## 项目内 Skill

为了后续统一走技能流，本项目新增了本地 skill：

- `F:\Do_Some_Great_Things\FirstSpot\.cursor\skills\minimax-audio-gen\SKILL.md`

后续当你提到这些需求时，应该触发这个 skill：

- 生成音效
- 生成 BGM
- 生成 loop
- 生成角色语音
- 把产品交互描述转成 MiniMax 音频 prompt

## 关于官方文档中的一个小差异

MiniMax 官方 MCP 页面里，Cursor 部分展示的 JS 版配置示例有一处看起来沿用了 Python 版片段；但同一页的 JS 版 Claude Desktop 配置明确给出了：

- `command = npx`
- `args = ["-y", "minimax-mcp-js"]`

结合本机环境已经验证 `npx -y minimax-mcp-js --help` 可运行，因此当前接入采用这一官方 JS 包名与启动方式。
