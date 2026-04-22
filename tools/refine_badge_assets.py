from __future__ import annotations

import json
import re
from pathlib import Path

from PIL import Image, ImageEnhance, ImageOps


ROOT = Path(__file__).resolve().parents[1]
SOURCE_DIR = ROOT / "创意参考图" / "badge_reference"
APP_BADGE_DIR = ROOT / "testapp" / "assets" / "images" / "badges"
DESIGN_BADGE_DIR = ROOT / "Design_Resource" / "UI_design_resource" / "badges"

CANVAS_SIZE = 1024
CONTENT_SIZE = 936


BADGES = [
    {
        "source_index": 1,
        "id": "learning_onboarding_start",
        "title_zh": "学习启程",
        "category": "learning",
        "style": "round",
        "rarity": "common",
        "animal": "bunny",
        "trigger": "完成首开引导的学习承诺卡",
    },
    {
        "source_index": 2,
        "id": "habit_daily_checkin",
        "title_zh": "今日打卡",
        "category": "habit",
        "style": "round",
        "rarity": "common",
        "animal": "bear",
        "trigger": "完成当天第一项学习任务",
    },
    {
        "source_index": 3,
        "id": "streak_3_day_combo",
        "title_zh": "三日连击",
        "category": "streak",
        "style": "round",
        "rarity": "rare",
        "animal": "penguin",
        "trigger": "连续学习 3 天",
    },
    {
        "source_index": 4,
        "id": "streak_7_day_persist",
        "title_zh": "七日坚持",
        "category": "streak",
        "style": "round",
        "rarity": "epic",
        "animal": "shiba",
        "trigger": "连续学习 7 天",
    },
    {
        "source_index": 5,
        "id": "focus_30_min_session",
        "title_zh": "专注 30 分",
        "category": "focus",
        "style": "round",
        "rarity": "rare",
        "animal": "cat",
        "trigger": "单次专注学习达到 30 分钟",
    },
    {
        "source_index": 6,
        "id": "learning_reading_master",
        "title_zh": "阅读达人",
        "category": "learning",
        "style": "round",
        "rarity": "epic",
        "animal": "owl",
        "trigger": "完成指定章节的深度阅读",
    },
    {
        "source_index": 7,
        "id": "practice_drill_master",
        "title_zh": "练习高手",
        "category": "practice",
        "style": "round",
        "rarity": "rare",
        "animal": "hamster",
        "trigger": "完成一组练习清单",
    },
    {
        "source_index": 8,
        "id": "review_recap_master",
        "title_zh": "复习能手",
        "category": "review",
        "style": "round",
        "rarity": "rare",
        "animal": "panda",
        "trigger": "完成错题或知识点复盘",
    },
    {
        "source_index": 9,
        "id": "progress_halfway",
        "title_zh": "进度过半",
        "category": "progress",
        "style": "round",
        "rarity": "epic",
        "animal": "turtle",
        "trigger": "学习路径总进度达到 50%",
    },
    {
        "source_index": 10,
        "id": "level_scholar_max",
        "title_zh": "满级学霸",
        "category": "level",
        "style": "round",
        "rarity": "legendary",
        "animal": "lion",
        "trigger": "达到 V1 学习等级上限",
    },
    {
        "source_index": 11,
        "id": "learning_onboarding_start",
        "title_zh": "学习启程",
        "category": "learning",
        "style": "card",
        "rarity": "common",
        "animal": "bunny",
        "trigger": "完成首开引导的学习承诺卡",
    },
    {
        "source_index": 12,
        "id": "habit_daily_checkin",
        "title_zh": "今日打卡",
        "category": "habit",
        "style": "card",
        "rarity": "common",
        "animal": "bear",
        "trigger": "完成当天第一项学习任务",
    },
    {
        "source_index": 13,
        "id": "streak_3_day_combo",
        "title_zh": "三日连击",
        "category": "streak",
        "style": "card",
        "rarity": "rare",
        "animal": "penguin",
        "trigger": "连续学习 3 天",
    },
    {
        "source_index": 14,
        "id": "streak_7_day_persist",
        "title_zh": "七日坚持",
        "category": "streak",
        "style": "card",
        "rarity": "epic",
        "animal": "shiba",
        "trigger": "连续学习 7 天",
    },
    {
        "source_index": 15,
        "id": "focus_30_min_session",
        "title_zh": "专注 30 分",
        "category": "focus",
        "style": "card",
        "rarity": "rare",
        "animal": "cat",
        "trigger": "单次专注学习达到 30 分钟",
    },
    {
        "source_index": 16,
        "id": "learning_reading_master",
        "title_zh": "阅读达人",
        "category": "learning",
        "style": "card",
        "rarity": "epic",
        "animal": "owl",
        "trigger": "完成指定章节的深度阅读",
    },
    {
        "source_index": 17,
        "id": "practice_drill_master",
        "title_zh": "练习高手",
        "category": "practice",
        "style": "card",
        "rarity": "rare",
        "animal": "hamster",
        "trigger": "完成一组练习清单",
    },
    {
        "source_index": 18,
        "id": "review_recap_master",
        "title_zh": "复习能手",
        "category": "review",
        "style": "card",
        "rarity": "rare",
        "animal": "panda",
        "trigger": "完成错题或知识点复盘",
    },
    {
        "source_index": 19,
        "id": "progress_halfway",
        "title_zh": "进度过半",
        "category": "progress",
        "style": "card",
        "rarity": "epic",
        "animal": "turtle",
        "trigger": "学习路径总进度达到 50%",
    },
    {
        "source_index": 20,
        "id": "level_scholar_max",
        "title_zh": "满级学霸",
        "category": "level",
        "style": "card",
        "rarity": "legendary",
        "animal": "lion",
        "trigger": "达到 V1 学习等级上限",
    },
]


def _source_files_by_index() -> dict[int, Path]:
    files = sorted(SOURCE_DIR.glob("*.png"), key=lambda path: path.stat().st_mtime)
    indexed: dict[int, Path] = {}
    for path in files:
        match = re.search(r"\((\d+)\)\.png$", path.name)
        if not match:
            continue
        number = int(match.group(1))
        hour_bucket = "02_36" in path.name
        index = number if hour_bucket else number + 10
        indexed[index] = path
    return indexed


def _make_edge_background_transparent(image: Image.Image) -> Image.Image:
    image = image.convert("RGBA")
    pixels = image.load()
    width, height = image.size
    stack = []
    seen = set()

    def is_background(x: int, y: int) -> bool:
        r, g, b, a = pixels[x, y]
        return a > 0 and min(r, g, b) >= 246 and max(r, g, b) - min(r, g, b) <= 12

    for x in range(width):
        stack.append((x, 0))
        stack.append((x, height - 1))
    for y in range(height):
        stack.append((0, y))
        stack.append((width - 1, y))

    while stack:
        x, y = stack.pop()
        if (x, y) in seen or not (0 <= x < width and 0 <= y < height):
            continue
        seen.add((x, y))
        if not is_background(x, y):
            continue
        pixels[x, y] = (255, 255, 255, 0)
        stack.extend(((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)))

    return image


def _refine(image: Image.Image) -> Image.Image:
    image = _make_edge_background_transparent(image)
    bbox = image.getbbox()
    if bbox is not None:
        image = image.crop(bbox)

    image = ImageEnhance.Color(image).enhance(1.06)
    image = ImageEnhance.Contrast(image).enhance(1.03)
    image = ImageEnhance.Sharpness(image).enhance(1.08)

    image.thumbnail((CONTENT_SIZE, CONTENT_SIZE), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (CANVAS_SIZE, CANVAS_SIZE), (255, 255, 255, 0))
    x = (CANVAS_SIZE - image.width) // 2
    y = (CANVAS_SIZE - image.height) // 2
    canvas.alpha_composite(image, (x, y))
    return canvas


def _make_contact_sheet(paths: list[Path], output_path: Path) -> None:
    thumb_size = 180
    label_height = 32
    columns = 5
    rows = (len(paths) + columns - 1) // columns
    sheet = Image.new(
        "RGBA",
        (columns * thumb_size, rows * (thumb_size + label_height)),
        (255, 250, 246, 255),
    )

    for index, path in enumerate(paths):
        img = Image.open(path).convert("RGBA")
        img = ImageOps.contain(img, (thumb_size - 16, thumb_size - 16))
        x = (index % columns) * thumb_size + (thumb_size - img.width) // 2
        y = (index // columns) * (thumb_size + label_height) + 8
        sheet.alpha_composite(img, (x, y))

    sheet.convert("RGB").save(output_path, quality=95)


def main() -> None:
    APP_BADGE_DIR.mkdir(parents=True, exist_ok=True)
    DESIGN_BADGE_DIR.mkdir(parents=True, exist_ok=True)

    for directory in (APP_BADGE_DIR, DESIGN_BADGE_DIR):
        for old_output in directory.glob("achievement_*.png"):
            old_output.unlink()

    sources = _source_files_by_index()
    manifest = []
    output_paths = []

    for badge in BADGES:
        source = sources[badge["source_index"]]
        purpose = badge["id"]
        category_prefix = f"{badge['category']}_"
        if purpose.startswith(category_prefix):
            purpose = purpose[len(category_prefix) :]
        filename = f"achievement_{badge['category']}_{purpose}_{badge['style']}_{badge['animal']}.png"
        app_path = APP_BADGE_DIR / filename
        design_path = DESIGN_BADGE_DIR / filename

        refined = _refine(Image.open(source))
        refined.save(app_path)
        refined.save(design_path)
        output_paths.append(design_path)

        manifest.append(
            {
                "id": badge["id"],
                "titleZh": badge["title_zh"],
                "category": badge["category"],
                "style": badge["style"],
                "rarity": badge["rarity"],
                "animal": badge["animal"],
                "trigger": badge["trigger"],
                "assetPath": f"assets/images/badges/{filename}",
                "designResourcePath": f"Design_Resource/UI_design_resource/badges/{filename}",
                "sourceFile": f"创意参考图/badge_reference/{source.name}",
            }
        )

    manifest_path = DESIGN_BADGE_DIR / "badge_manifest.json"
    manifest_path.write_text(
        json.dumps(
            {
                "version": 1,
                "canvasSize": CANVAS_SIZE,
                "notes": "Refined from badge_reference images: trimmed, transparent edge background, normalized 1024px canvas, subtle color/contrast/sharpness lift.",
                "badges": manifest,
            },
            ensure_ascii=False,
            indent=2,
        ),
        encoding="utf-8",
    )
    _make_contact_sheet(output_paths, DESIGN_BADGE_DIR / "badge_contact_sheet.png")


if __name__ == "__main__":
    main()
