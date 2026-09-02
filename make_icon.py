# -*- coding: utf-8 -*-
"""从结合版 PNG 生成脱敏马多尺寸 ICO 与商店素材"""
from PIL import Image
import os

SRC = os.path.join(os.path.dirname(os.path.abspath(__file__)), "assets", "candidate_merge.png")
OUT_DIR = os.path.dirname(os.path.abspath(__file__))

def make_icon():
    if not os.path.exists(SRC):
        raise FileNotFoundError("源图不存在: " + SRC)
    im = Image.open(SRC).convert("RGBA")
    # 统一为正方形（源图已是 1024x1024）
    if im.width != im.height:
        side = min(im.width, im.height)
        left = (im.width - side) // 2
        top = (im.height - side) // 2
        im = im.crop((left, top, left + side, top + side))

    # 多尺寸 ICO
    sizes = [(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)]
    ico_path = os.path.join(OUT_DIR, "tuominma.ico")
    im.save(ico_path, format="ICO", sizes=sizes)
    print("OK: tuominma.ico 生成（16/24/32/48/64/128/256）")

    # 商店素材：512x512 / 256x256 PNG
    for sz in (512, 256):
        resized = im.resize((sz, sz), Image.LANCZOS)
        out = os.path.join(OUT_DIR, "assets", "icon_%d.png" % sz)
        resized.save(out, "PNG")
        print("OK: assets/icon_%d.png" % sz)

if __name__ == "__main__":
    make_icon()
