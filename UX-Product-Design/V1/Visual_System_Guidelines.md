# FirstSpot · V1 视觉系统规范 (Visual System Guidelines)

> 基于多邻国式游戏化风格设计的 FirstSpot 移动端投资教育 App 视觉系统规范。
> 关联文件：`UX-Product-Design/V1/Gamified_Onboarding_Design.md`

## 1. 设计原则 (Design Principles)

- **陪伴感与安全感**：用多彩但稳健的色彩，消除金融带来的严肃与恐惧。
- **强反馈交互**：采用类似游戏的新手村设计，通过圆润的卡片和带下沉阴影的按钮给用户即时的视觉满足。
- **清晰的信息层级**：重点信息醒目，避免大段文字，用卡片、图标进行拆分。

## 2. 色彩系统 (Color System)

| 用途 | 色名 | HEX |
|---|---|---|
| 品牌主色 | 嫩芽绿 | `#4CC38A` |
| 品牌辅色 | 日出橙 | `#FFB547` |
| 强调色 | Streak 火焰 | `#FF5C39` |
| 成功 | 柠檬黄 | `#FDE047` |
| 风险红 | 珊瑚粉 | `#FF6B8B` |
| 稳健蓝 | 薄荷蓝 | `#5EA8D9` |
| 中性 深 | 墨黑 | `#1F2328` |
| 中性 浅 | 奶油白 | `#FFF9F0` |
| 分割线 | 烟灰 | `#E6E8EC` |

## 3. 字体系统 (Typography)

- **中文**：思源黑体 Variable (Heavy / Medium / Regular)
- **英文 / 数字**：Inter (Heavy / Medium / Regular)
- **特定数字 (如 XP/Streak)**：Inter Extra Bold + Italic

## 4. 组件规范 (Component Guidelines)

### 4.1 按钮 (Buttons)
- **圆角**：28px 胶囊形
- **阴影**：软投影 + 底部 4px 的深色底座（例如：主色按钮带有深绿色的 4px 下沉阴影，形成按钮被按下时的立体触感反馈）。
- **文字**：居中，字号 16px - 18px，Medium 或 Heavy。

### 4.2 卡片 (Cards)
- **圆角**：16px
- **背景**：白底或极浅的中性浅色
- **阴影**：轻微的扩散阴影，增加页面层级感。

### 4.3 图标与插画 (Icons & Illustrations)
- **图标**：多彩、圆润或带有一定厚度的设计。
- **插画**：厚涂 + 圆润线条。

## 5. 动效指引 (Motion Guidelines)
- **弹性动画为主**：spring (stiffness 180, damping 14)
- **按钮轻按**：100-200ms
- **页面切换**：300-400ms