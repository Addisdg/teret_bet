#!/usr/bin/env python3
"""Verify the frozen pilot text, selected artwork, PDFs, and prompt coverage."""

from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PACKET_ID = "PILOT-FAMILY-R1-2026-07-05"
SLUGS = (
    "mouse_deer_prepared_early",
    "rat_kings_son",
    "cub_and_kid",
    "lion_and_mouse",
    "stone_soup",
)
TEXT_MANIFEST = (
    ROOT / "docs/pilot_drafts" / "PILOT_FAMILY_R1_2026-07-05.sha256"
)
VISUAL_MANIFEST = (
    ROOT / "docs/pilot_drafts" / "PILOT_FAMILY_R1_2026-07-05_VISUAL.sha256"
)
PROMPT_MANIFEST = ROOT / "docs/pilot_illustration_prompts_r1.json"


def digest(path: Path) -> str:
    value = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            value.update(chunk)
    return value.hexdigest()


def read_manifest(path: Path) -> dict[str, str]:
    entries: dict[str, str] = {}
    lines = path.read_text(encoding="ascii").splitlines()
    for line_number, raw_line in enumerate(lines, 1):
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        match = re.fullmatch(r"([0-9a-f]{64})  (.+)", line)
        if not match:
            raise RuntimeError(f"{path.name}:{line_number}: invalid checksum entry")
        checksum, relative_path = match.groups()
        if relative_path in entries:
            raise RuntimeError(f"{path.name}: duplicate path {relative_path}")
        entries[relative_path] = checksum
    return entries


def expected_visual_paths() -> set[str]:
    paths: set[str] = set()
    for slug in SLUGS:
        draft = ROOT / "docs/pilot_drafts" / f"{slug}.md"
        page_numbers = [
            int(value)
            for value in re.findall(r"^## Page (\d+)\s*$", draft.read_text(encoding="utf-8"), re.MULTILINE)
        ]
        for page_number in page_numbers:
            paths.add(
                f"assets/images/pilot_review/{slug}/page_{page_number:02d}_r1.png"
            )
        paths.add(f"output/pdf/{PACKET_ID}_{slug}.pdf")
    return paths


def verify_checksums(manifest_path: Path, entries: dict[str, str]) -> None:
    failures = []
    for relative_path, expected in sorted(entries.items()):
        path = ROOT / relative_path
        if not path.is_file():
            failures.append(f"missing: {relative_path}")
        elif digest(path) != expected:
            failures.append(f"changed: {relative_path}")
    if failures:
        raise RuntimeError(f"{manifest_path.name} failed:\n- " + "\n- ".join(failures))


def main() -> None:
    text_entries = read_manifest(TEXT_MANIFEST)
    visual_entries = read_manifest(VISUAL_MANIFEST)
    expected_visual = expected_visual_paths()

    if set(visual_entries) != expected_visual:
        missing = sorted(expected_visual - set(visual_entries))
        extra = sorted(set(visual_entries) - expected_visual)
        raise RuntimeError(f"Visual manifest coverage mismatch; missing={missing}, extra={extra}")

    expected_text = {f"docs/pilot_drafts/{slug}.md" for slug in SLUGS}
    if set(text_entries) != expected_text:
        raise RuntimeError("Text manifest does not cover exactly the five pilot drafts")

    prompt_data = json.loads(PROMPT_MANIFEST.read_text(encoding="utf-8"))
    prompt_paths = {asset["assetPath"] for asset in prompt_data["assets"]}
    visual_image_paths = {path for path in expected_visual if path.endswith(".png")}
    uncovered = sorted(visual_image_paths - prompt_paths)
    if uncovered:
        raise RuntimeError(f"Selected images lack prompt provenance: {uncovered}")

    verify_checksums(TEXT_MANIFEST, text_entries)
    verify_checksums(VISUAL_MANIFEST, visual_entries)
    image_count = sum(path.endswith(".png") for path in visual_entries)
    pdf_count = sum(path.endswith(".pdf") for path in visual_entries)
    print(
        f"{PACKET_ID}: verified 5 drafts, {image_count} selected images, "
        f"{pdf_count} reproducible PDFs, and prompt coverage"
    )


if __name__ == "__main__":
    main()
