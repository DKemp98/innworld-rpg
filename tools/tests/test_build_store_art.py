"""Tests for tools/build_store_art.py (Google Play graphics, docs/PLAY_STORE.md).

Run: python -m unittest discover -s tools/tests
"""

import sys
import tempfile
import unittest
from pathlib import Path

from PIL import Image

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
import build_store_art as bsa  # noqa: E402


def load(path):
    with Image.open(path) as im:  # close the file: Windows can not delete an open temp file
        im.load()
        return im


class BuildStoreArtTest(unittest.TestCase):
    def test_play_sizes_and_formats(self):
        with tempfile.TemporaryDirectory() as tmp:
            src, out = Path(tmp) / "src", Path(tmp) / "out"
            src.mkdir()
            Image.new("RGB", (1152, 648), (40, 60, 80)).save(src / "screenshot_1_inn.png")
            Image.new("RGBA", (2000, 1125), (40, 60, 80, 255)).save(src / "screenshot_2_big.png")
            shots = bsa.build(src, out)

            feature = load(out / "feature_graphic.png")
            self.assertEqual(feature.size, (1024, 500))
            self.assertEqual(feature.mode, "RGB")  # Play: no alpha
            icon = load(out / "icon_512.png")
            self.assertEqual(icon.size, (512, 512))
            self.assertEqual(icon.mode, "RGBA")  # Play: 32-bit PNG
            self.assertEqual(load(shots[0]).size, (2304, 1296))  # scaled up 2x
            self.assertEqual(load(shots[1]).size, (2000, 1125))  # 2x would pass 3840: kept
            for s in shots:
                self.assertEqual(load(s).mode, "RGB")

    def test_shot_limits(self):
        self.assertTrue(bsa.shot_ok((1920, 1080)))
        self.assertFalse(bsa.shot_ok((300, 300)))  # side under 320
        self.assertFalse(bsa.shot_ok((4000, 2250)))  # side over 3840
        self.assertFalse(bsa.shot_ok((2100, 1000)))  # long side over 2x the short side


if __name__ == "__main__":
    unittest.main()
