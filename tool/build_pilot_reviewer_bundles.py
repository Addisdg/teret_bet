#!/usr/bin/env python3
"""Build privacy-safe, single-story pilot reviewer ZIP bundles."""

from __future__ import annotations

import hashlib
import zipfile
from pathlib import Path

from verify_pilot_review_packet import main as verify_packet


ROOT = Path(__file__).resolve().parents[1]
PACKET_ID = "PILOT-FAMILY-R1-2026-07-05"
OUTPUT_DIR = ROOT / "output" / "reviewer_bundles"

SHARED_FILES = (
    ROOT / "docs" / "PILOT_FAMILY_REVIEW_GUIDE.md",
    ROOT / "docs" / "PILOT_FAMILY_REVIEW_SCORECARD.md",
)

STORIES = {
    "mouse_deer_prepared_early": ("The Rat Who Prepared Early", "MOUSE-RAT"),
    "rat_kings_son": ("The Rat King's Son", "RAT-KING"),
    "cub_and_kid": ("The Cub and the Kid", "CUB-KID"),
    "lion_and_mouse": ("The Lion and the Mouse", "LION-MOUSE"),
    "stone_soup": ("Stone Soup", "STONE-SOUP"),
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def instructions(title: str, revision: str) -> str:
    return f"""# Teret Bet pilot review session

Story: {title}
Revision: {revision}
Anonymous session code: [OWNER ADDS BEFORE SENDING]
Private feedback return route: [OWNER ADDS BEFORE SENDING]

Please read the included review guide before the session. Read this one story
naturally with a child in the assigned broad age band. This reviews the story
and illustrations; it is not a test of the child.

Do not send names, exact ages, contact details, school details, photos, audio,
video, medical information, or other identifying child information. Keep raw
notes and completed scorecards outside the project repository. Return feedback
only through the private route supplied by the owner.

The PDF contains the bilingual story pages, illustrations, page-level note
space, a visual scorecard, and an observations sheet. Amharic and English are
best reviewed in separate sittings when practical.
"""


def build_bundle(slug: str, title: str, revision_suffix: str) -> Path:
    revision = f"{PACKET_ID}-{revision_suffix}"
    pdf = ROOT / "output" / "pdf" / f"{PACKET_ID}_{slug}.pdf"
    required = (pdf, *SHARED_FILES)
    missing = [str(path.relative_to(ROOT)) for path in required if not path.is_file()]
    if missing:
        raise FileNotFoundError("Missing bundle input(s): " + ", ".join(missing))

    destination = OUTPUT_DIR / f"{PACKET_ID}_{slug}_review_bundle.zip"
    with zipfile.ZipFile(destination, "w", compression=zipfile.ZIP_DEFLATED) as archive:
        archive.write(pdf, pdf.name)
        for shared in SHARED_FILES:
            archive.write(shared, shared.name)
        archive.writestr("SESSION_INSTRUCTIONS.md", instructions(title, revision))
    return destination


def main() -> None:
    verify_packet()
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    bundles = [
        build_bundle(slug, title, revision_suffix)
        for slug, (title, revision_suffix) in STORIES.items()
    ]
    checksums = "".join(f"{sha256(path)}  {path.name}\n" for path in bundles)
    checksum_path = OUTPUT_DIR / "SHA256SUMS"
    checksum_path.write_text(checksums, encoding="ascii")

    for path in bundles:
        print(f"{path.relative_to(ROOT)}: verified")
    print(f"{checksum_path.relative_to(ROOT)}: written")


if __name__ == "__main__":
    main()
