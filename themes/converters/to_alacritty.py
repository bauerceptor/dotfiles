#!/usr/bin/env python3
"""
Convert central theme palette to Alacritty TOML format.
Usage: python3 to_alacritty.py <theme-file.toml>
"""

import sys
import tomllib
from pathlib import Path


def convert_to_alacritty(theme_file: str) -> str:
    """Convert theme palette to Alacritty color configuration."""
    with open(theme_file, 'rb') as f:
        theme = tomllib.load(f)

    c = theme['colors']
    meta = theme['meta']

    toml = f"""# {meta['name']} - {meta['description']}
# Generated from central theme palette

[colors.primary]
background = "{c['base']['background']}"
foreground = "{c['base']['foreground']}"

[colors.cursor]
text = "{c['base']['background']}"
cursor = "{c['base']['cursor']}"

[colors.vi_mode_cursor]
text = "{c['base']['background']}"
cursor = "{c['base']['cursor']}"

[colors.selection]
text = "{c['base']['selection_fg']}"
background = "{c['base']['selection_bg']}"

[colors.search.matches]
foreground = "{c['base']['background']}"
background = "{c['semantic']['warning']}"

[colors.search.focused_match]
foreground = "{c['base']['background']}"
background = "{c['semantic']['info']}"

[colors.normal]
black   = "{c['ansi']['black']}"
red     = "{c['ansi']['red']}"
green   = "{c['ansi']['green']}"
yellow  = "{c['ansi']['yellow']}"
blue    = "{c['ansi']['blue']}"
magenta = "{c['ansi']['magenta']}"
cyan    = "{c['ansi']['cyan']}"
white   = "{c['ansi']['white']}"

[colors.bright]
black   = "{c['bright']['black']}"
red     = "{c['bright']['red']}"
green   = "{c['bright']['green']}"
yellow  = "{c['bright']['yellow']}"
blue    = "{c['bright']['blue']}"
magenta = "{c['bright']['magenta']}"
cyan    = "{c['bright']['cyan']}"
white   = "{c['bright']['white']}"
"""
    return toml


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 to_alacritty.py <theme-file.toml>")
        sys.exit(1)

    theme_file = sys.argv[1]
    if not Path(theme_file).exists():
        print(f"Error: Theme file not found: {theme_file}")
        sys.exit(1)

    print(convert_to_alacritty(theme_file))
