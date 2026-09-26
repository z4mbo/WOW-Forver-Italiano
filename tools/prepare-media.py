"""Resize generated project artwork to submission-ready PNG files."""

from pathlib import Path
from sys import argv

from PIL import Image, ImageOps


def main() -> None:
    if len(argv) != 3:
        raise SystemExit("usage: prepare-media.py AVATAR_SOURCE COVER_SOURCE")
    output = Path(__file__).resolve().parent.parent / "media"
    output.mkdir(parents=True, exist_ok=True)

    with Image.open(argv[1]) as source:
        avatar = ImageOps.fit(source.convert("RGB"), (400, 400), Image.Resampling.LANCZOS)
        avatar.save(output / "curseforge-avatar.png", optimize=True)
        in_game_icon = avatar.resize((64, 64), Image.Resampling.LANCZOS)
        icon_path = output.parent / "Addon" / "Media" / "Icon.tga"
        icon_path.parent.mkdir(parents=True, exist_ok=True)
        in_game_icon.save(icon_path)

    with Image.open(argv[2]) as source:
        cover = ImageOps.fit(source.convert("RGB"), (1600, 900), Image.Resampling.LANCZOS)
        cover.save(output / "cover-art.png", optimize=True)


if __name__ == "__main__":
    main()
