"""Make the Google Play store graphics in export/play/ (gitignored). See docs/PLAY_STORE.md.

- feature_graphic.png  1024 x 500, 24-bit PNG (no alpha): a game screenshot, darkened, with the icon and the title.
- icon_512.png         512 x 512, 32-bit PNG (with alpha): game/icon.png as RGBA.
- screenshot_<n>.png   each screenshot scaled up 2x with no smoothing (pixel art stays sharp), 24-bit PNG.

The screenshots come from export/itch/ (made by export/itch/capture_shots.gd). The marketing text says
"pirateaba's Innworld", never a book title (docs/DESIGN.md section 7).
Run: python tools/build_store_art.py [screenshot dir] [out dir]
"""
import sys
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
ICON = ROOT / "game" / "icon.png"
FONT = ROOT / "game" / "assets" / "fonts" / "PixelOperator-Bold.ttf"
FEATURE = (1024, 500)
TITLE = "Innworld RPG"
TAGLINE = "A free fan-made RPG in pirateaba's Innworld"
# Play limits for a screenshot: each side 320 - 3840 px, the long side at most 2x the short side.
SHOT_MIN, SHOT_MAX = 320, 3840


def load(path):
    with Image.open(path) as im:  # close the file at once (Windows locks open files)
        im.load()
        return im


def shot_ok(size):
    w, h = size
    return SHOT_MIN <= min(w, h) and max(w, h) <= SHOT_MAX and max(w, h) <= 2 * min(w, h)


def scale_shot(img):
    img = img.convert("RGB")
    big = img.resize((img.width * 2, img.height * 2), Image.NEAREST)
    return big if shot_ok(big.size) else img


def icon_rgba():
    return load(ICON).convert("RGBA")


def feature_graphic(background):
    w, h = FEATURE
    bg = background.convert("RGB")
    scale = max(w / bg.width, h / bg.height)
    bg = bg.resize((round(bg.width * scale), round(bg.height * scale)), Image.NEAREST)
    left, top = (bg.width - w) // 2, (bg.height - h) // 2
    img = bg.crop((left, top, left + w, top + h))
    img = Image.blend(img, Image.new("RGB", FEATURE, (12, 14, 30)), 0.7)

    # the icon is 64 x 64 pixel art drawn 8x: back to 64, then 5x for a sharp 320 px square
    icon = load(ICON).convert("RGB").resize((64, 64), Image.NEAREST).resize((320, 320), Image.NEAREST)
    img.paste(icon, (60, (h - 320) // 2))

    # text is centred in the space right of the icon
    d = ImageDraw.Draw(img)
    left, right = 400, w - 24
    title = ImageFont.truetype(str(FONT), 96)
    tag = ImageFont.truetype(str(FONT), 32)
    while d.textlength(TAGLINE, font=tag) > right - left and tag.size > 12:
        tag = ImageFont.truetype(str(FONT), tag.size - 2)
    tx = left + (right - left - d.textlength(TITLE, font=title)) // 2
    gx = left + (right - left - d.textlength(TAGLINE, font=tag)) // 2
    d.text((tx + 4, 174), TITLE, font=title, fill=(0, 0, 0))  # drop shadow
    d.text((tx, 170), TITLE, font=title, fill=(246, 222, 150))
    d.text((gx, 290), TAGLINE, font=tag, fill=(232, 232, 232))
    return img


def build(shot_dir, out_dir):
    out_dir.mkdir(parents=True, exist_ok=True)
    shots = sorted(shot_dir.glob("screenshot_*.png"))
    if not shots:
        raise SystemExit(f"No screenshot_*.png in {shot_dir}")
    made = []
    for n, path in enumerate(shots, 1):
        img = scale_shot(load(path))
        if not shot_ok(img.size):
            raise SystemExit(f"{path.name} {img.size} is outside the Play screenshot limits")
        dest = out_dir / f"screenshot_{n}.png"
        img.save(dest)
        made.append(dest)
    feature_graphic(load(shots[0])).save(out_dir / "feature_graphic.png")
    icon_rgba().save(out_dir / "icon_512.png")
    return made


if __name__ == "__main__":
    src = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "export" / "itch"
    dst = Path(sys.argv[2]) if len(sys.argv) > 2 else ROOT / "export" / "play"
    for p in build(src, dst):
        print("made", p)
    print("made", dst / "feature_graphic.png")
    print("made", dst / "icon_512.png")
