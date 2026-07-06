#!/usr/bin/env python3
"""Build one ready-to-send pilot session archive without storing private data."""

from __future__ import annotations

import argparse
import hashlib
import re
import zipfile
from pathlib import Path

from build_pilot_reviewer_bundles import (
    PACKET_ID,
    ROOT,
    SHARED_FILES,
    STORIES,
    instructions,
)
from verify_pilot_review_packet import main as verify_packet


OUTPUT_DIR = ROOT / "output" / "reviewer_sessions"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Build one privacy-safe, ready-to-send pilot review session."
    )
    parser.add_argument("--story", required=True, choices=sorted(STORIES))
    parser.add_argument(
        "--session-code",
        required=True,
        help="Anonymous code such as PILOT-LION-MOUSE-R01-A34-AM-01.",
    )
    parser.add_argument(
        "--return-file",
        required=True,
        type=Path,
        help="Private plain-text return instructions stored outside this repository.",
    )
    return parser.parse_args()


def validate_session_code(code: str, revision_suffix: str) -> None:
    pattern = rf"PILOT-{re.escape(revision_suffix)}-[RC]\d{{2}}-A(?:34|56)-(?:AM|EN)-\d{{2}}"
    if not re.fullmatch(pattern, code):
        raise ValueError(
            "Session code must match "
            f"PILOT-{revision_suffix}-R01-A34-AM-01 "
            "(R or C reviewer; A34 or A56; AM or EN)."
        )


def read_private_return_instructions(path: Path) -> str:
    resolved = path.expanduser().resolve()
    if resolved.is_relative_to(ROOT):
        raise ValueError("Keep the private return-instructions file outside the repository.")
    if not resolved.is_file():
        raise FileNotFoundError(f"Private return-instructions file not found: {resolved}")
    value = resolved.read_text(encoding="utf-8").strip()
    if not value:
        raise ValueError("Private return instructions cannot be empty.")
    if len(value) > 1000:
        raise ValueError("Private return instructions must be 1000 characters or fewer.")
    return value


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    args = parse_args()
    title, revision_suffix = STORIES[args.story]
    validate_session_code(args.session_code, revision_suffix)
    return_instructions = read_private_return_instructions(args.return_file)
    verify_packet()

    revision = f"{PACKET_ID}-{revision_suffix}"
    pdf = ROOT / "output/pdf" / f"{PACKET_ID}_{args.story}.pdf"
    required = (pdf, *SHARED_FILES)
    missing = [str(path.relative_to(ROOT)) for path in required if not path.is_file()]
    if missing:
        raise FileNotFoundError("Missing session input(s): " + ", ".join(missing))

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    destination = OUTPUT_DIR / f"{args.session_code}.zip"
    session_text = instructions(
        title,
        revision,
        session_code=args.session_code,
        return_instructions=return_instructions,
    )
    with zipfile.ZipFile(destination, "w", compression=zipfile.ZIP_DEFLATED) as archive:
        archive.write(pdf, pdf.name)
        for shared in SHARED_FILES:
            archive.write(shared, shared.name)
        archive.writestr("SESSION_INSTRUCTIONS.md", session_text)

    checksum_path = destination.with_suffix(".zip.sha256")
    checksum_path.write_text(
        f"{digest(destination)}  {destination.name}\n",
        encoding="ascii",
    )
    print(f"{destination.relative_to(ROOT)}: verified")
    print(f"{checksum_path.relative_to(ROOT)}: written")


if __name__ == "__main__":
    main()
