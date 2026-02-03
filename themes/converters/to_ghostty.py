#!/usr/bin/env python3
"""
Convert central theme palette to Ghostty format.
Usage: python3 to_ghostty.py <theme-file.toml>
"""

import sys
import tomllib
from pathlib import Path


def hex_to_rgb(hex_color: str) -> str:
    """Convert hex color (#rrggbb) to RGB format (r,g,b)."""
    hex_color = hex_color.lstrip('#')
    r = int(hex_color[0:2], 16)
    g = int(hex_color[2:4], 16)
    b = int(hex_color[4:6], 16)
    return f"{r},{g},{b}"


def convert_to_ghostty(theme_file: str) -> str:
    """Convert theme palette to Ghostty color configuration."""
    with open(theme_file, 'rb') as f:
        theme = tomllib.load(f)

    c = theme['colors']
    meta = theme['meta']

    # Build 16-color ANSI palette
    palette = [
        c['ansi']['black'], c['ansi']['red'], c['ansi']['green'], c['ansi']['yellow'],
        c['ansi']['blue'], c['ansi']['magenta'], c['ansi']['cyan'], c['ansi']['white'],
        c['bright']['black'], c['bright']['red'], c['bright']['green'], c['bright']['yellow'],
        c['bright']['blue'], c['bright']['magenta'], c['bright']['cyan'], c['bright']['white']
    ]

    config = f"""# {meta['name']} - {meta['description']}
# Generated from central theme palette

background = {hex_to_rgb(c['base']['background'])}
foreground = {hex_to_rgb(c['base']['foreground'])}
cursor-color = {hex_to_rgb(c['base']['cursor'])}
selection-background = {hex_to_rgb(c['base']['selection_bg'])}
selection-foreground = {hex_to_rgb(c['base']['selection_fg'])}

"""

    # Add ANSI palette
    for i, color in enumerate(palette):
        config += f"palette = {i}={hex_to_rgb(color)}\n"

    return config


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 to_ghostty.py <theme-file.toml>")
        sys.exit(1)

    theme_file = sys.argv[1]
    if not Path(theme_file).exists():
        print(f"Error: Theme file not found: {theme_file}")
        sys.exit(1)

    print(convert_to_ghostty(theme_file))
