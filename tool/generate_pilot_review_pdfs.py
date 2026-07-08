from __future__ import annotations

import argparse
import re
from pathlib import Path

import reportlab
from PIL import Image as PilImage
from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen.canvas import Canvas
from reportlab.platypus import (
    KeepTogether,
    Image as ReviewImage,
    Flowable,
    PageBreak,
    Paragraph,
    SimpleDocTemplate,
    Spacer,
    Table,
    TableStyle,
)
from pypdf import PdfReader


ROOT = Path(__file__).resolve().parents[1]
FONT_PATH = ROOT / "assets/fonts/NotoSansEthiopic-Variable.ttf"
REPORTLAB_FONT_DIR = Path(reportlab.__file__).resolve().parent / "fonts"
OUTPUT_DIR = ROOT / "output/pdf"
PACKET_ID = "PILOT-FAMILY-R1-2026-07-05"
IMAGE_ROOT = ROOT / "assets/images/pilot_review"
PDF_IMAGE_CACHE = ROOT / "tmp/pdfs/pilot_images"

STORIES = [
    ("mouse_deer_prepared_early", "The Rat Who Prepared Early"),
    ("rat_kings_son", "The Rat King's Son"),
    ("cub_and_kid", "The Cub and the Kid"),
    ("lion_and_mouse", "The Lion and the Mouse"),
    ("stone_soup", "Stone Soup"),
]


class InvariantCanvas(Canvas):
    """Use stable PDF metadata and document IDs for reproducible builds."""

    def __init__(self, *args, **kwargs) -> None:
        kwargs["invariant"] = 1
        super().__init__(*args, **kwargs)


class FixedLabel(Flowable):
    def __init__(
        self,
        text: str,
        *,
        font_size: float,
        leading: float,
        color: colors.Color,
        font_name: str,
        space_after: float = 0,
    ) -> None:
        super().__init__()
        self.text = text
        self.font_size = font_size
        self.leading = leading
        self.color = color
        self.font_name = font_name
        self.space_after = space_after
        self.height = leading + space_after

    def wrap(self, avail_width, avail_height):
        return avail_width, self.height

    def draw(self) -> None:
        self.canv.setFont(self.font_name, self.font_size)
        self.canv.setFillColor(self.color)
        self.canv.drawString(0, self.space_after + 2, self.text)


def parse_story(path: Path) -> dict:
    text = path.read_text(encoding="utf-8")
    title = re.search(r"^# (.+)$", text, re.MULTILINE).group(1)
    revision = re.search(r"Review revision: `([^`]+)`", text).group(1)
    audience = re.search(r"Draft audience: (.+)", text).group(1)
    origin = re.search(r"Origin basis: (.+)", text).group(1)
    page_matches = list(re.finditer(r"^## Page (\d+)\s*$", text, re.MULTILINE))
    pages = []

    for index, match in enumerate(page_matches):
        end = page_matches[index + 1].start() if index + 1 < len(page_matches) else len(text)
        block = text[match.end():end]
        amharic = re.search(
            r"\*\*Amharic\*\*\s*(.*?)\s*\*\*English\*\*",
            block,
            re.DOTALL,
        ).group(1).strip()
        english = re.search(
            r"\*\*English\*\*\s*(.*?)\s*\*\*Illustration beat:\*\*",
            block,
            re.DOTALL,
        ).group(1).strip()
        illustration = re.search(
            r"\*\*Illustration beat:\*\*\s*(.*?)(?:\n\n|$)",
            block,
            re.DOTALL,
        ).group(1).strip()
        pages.append(
            {
                "number": int(match.group(1)),
                "amharic": amharic,
                "english": english,
                "illustration": illustration,
            }
        )

    return {
        "title": title,
        "revision": revision,
        "audience": audience,
        "origin": origin,
        "pages": pages,
    }


def styles(
    ethiopic_font: str,
    latin_font: str,
    latin_bold_font: str,
) -> dict[str, ParagraphStyle]:
    base = getSampleStyleSheet()
    return {
        "cover_title": ParagraphStyle(
            "CoverTitle",
            parent=base["Title"],
            fontName=ethiopic_font,
            fontSize=25,
            leading=34,
            alignment=TA_CENTER,
            textColor=colors.HexColor("#4D2A20"),
            spaceAfter=8 * mm,
        ),
        "cover_subtitle": ParagraphStyle(
            "CoverSubtitle",
            parent=base["Heading2"],
            fontName=latin_bold_font,
            fontSize=14,
            leading=20,
            alignment=TA_CENTER,
            textColor=colors.HexColor("#8E4B32"),
            spaceAfter=5 * mm,
        ),
        "heading": ParagraphStyle(
            "Heading",
            parent=base["Heading1"],
            fontName=latin_bold_font,
            fontSize=19,
            leading=25,
            textColor=colors.HexColor("#6E3525"),
            spaceAfter=6 * mm,
        ),
        "label": ParagraphStyle(
            "Label",
            parent=base["Heading3"],
            fontName=latin_bold_font,
            fontSize=11,
            leading=15,
            textColor=colors.HexColor("#9A5035"),
            spaceBefore=3 * mm,
            spaceAfter=2 * mm,
        ),
        "amharic": ParagraphStyle(
            "Amharic",
            parent=base["BodyText"],
            fontName=ethiopic_font,
            fontSize=15,
            leading=24,
            textColor=colors.HexColor("#2D211D"),
            alignment=TA_LEFT,
            spaceAfter=4 * mm,
        ),
        "body": ParagraphStyle(
            "Body",
            parent=base["BodyText"],
            fontName=latin_font,
            fontSize=11,
            leading=17,
            textColor=colors.HexColor("#2D211D"),
            spaceAfter=4 * mm,
        ),
        "note": ParagraphStyle(
            "Note",
            parent=base["BodyText"],
            fontName=latin_font,
            fontSize=9.5,
            leading=14,
            textColor=colors.HexColor("#5E534E"),
            spaceAfter=3 * mm,
        ),
        "footer": ParagraphStyle(
            "Footer",
            parent=base["BodyText"],
            fontName=latin_font,
            fontSize=8,
            leading=10,
            textColor=colors.HexColor("#766B66"),
            alignment=TA_CENTER,
        ),
    }


def page_decor(canvas, doc) -> None:
    canvas.saveState()
    canvas.setStrokeColor(colors.HexColor("#E8C8B8"))
    canvas.setLineWidth(0.7)
    canvas.line(18 * mm, 14 * mm, 192 * mm, 14 * mm)
    canvas.setFont(doc.review_latin_font, 8)
    canvas.setFillColor(colors.HexColor("#766B66"))
    canvas.drawCentredString(
        A4[0] / 2,
        9 * mm,
        f"{PACKET_ID}  |  Not text locked  |  Page {doc.page}",
    )
    canvas.restoreState()


def blank_lines(count: int, width: float = 168 * mm) -> Table:
    rows = [[""] for _ in range(count)]
    table = Table(rows, colWidths=[width], rowHeights=[9 * mm] * count)
    table.setStyle(
        TableStyle(
            [
                ("LINEBELOW", (0, 0), (-1, -1), 0.4, colors.HexColor("#B9AAA3")),
            ]
        )
    )
    return table


def page_image_path(slug: str, page_number: int) -> Path:
    story_dir = IMAGE_ROOT / slug
    candidate = story_dir / f"page_{page_number:02d}_r1.png"
    if candidate.exists():
        return candidate
    raise FileNotFoundError(f"Missing current pilot image: {candidate}")


def pdf_image_path(slug: str, page_number: int) -> Path:
    source = page_image_path(slug, page_number)
    output_dir = PDF_IMAGE_CACHE / slug
    output_dir.mkdir(parents=True, exist_ok=True)
    output = output_dir / f"page_{page_number:02d}.jpg"
    with PilImage.open(source) as image:
        image = image.convert("RGB")
        image.thumbnail((1200, 900), PilImage.Resampling.LANCZOS)
        image.save(output, "JPEG", quality=84, optimize=True, progressive=True)
    return output


def build_pdf(slug: str, english_title: str) -> Path:
    source = ROOT / "docs/pilot_drafts" / f"{slug}.md"
    story = parse_story(source)
    output = OUTPUT_DIR / f"{PACKET_ID}_{slug}.pdf"
    safe_slug = slug.replace("_", "")
    ethiopic_font = f"NotoEthiopic{safe_slug}"
    latin_font = f"ReviewLatin{safe_slug}"
    latin_bold_font = f"ReviewLatinBold{safe_slug}"
    pdfmetrics.registerFont(TTFont(ethiopic_font, str(FONT_PATH)))
    pdfmetrics.registerFont(
        TTFont(latin_font, str(REPORTLAB_FONT_DIR / "Vera.ttf"))
    )
    pdfmetrics.registerFont(
        TTFont(latin_bold_font, str(REPORTLAB_FONT_DIR / "VeraBd.ttf"))
    )
    style = styles(ethiopic_font, latin_font, latin_bold_font)
    doc = SimpleDocTemplate(
        str(output),
        pagesize=A4,
        leftMargin=20 * mm,
        rightMargin=20 * mm,
        topMargin=20 * mm,
        bottomMargin=19 * mm,
        title=f"{story['title']} - {english_title}",
        author="Teret Bet",
        subject="Family read-aloud review copy",
    )
    doc.review_latin_font = latin_font
    flow = []

    flow.extend(
        [
            Spacer(1, 22 * mm),
            Paragraph(story["title"], style["cover_title"]),
            Paragraph(english_title, style["cover_subtitle"]),
            Spacer(1, 7 * mm),
            Paragraph(f"Review revision: {story['revision']}", style["body"]),
            Paragraph(f"Audience: {story['audience']}", style["body"]),
            Paragraph(f"Origin basis: {story['origin']}", style["body"]),
            Paragraph(f"Story pages: {len(story['pages'])}", style["body"]),
            Spacer(1, 8 * mm),
            Paragraph("For adult family/cultural review", style["heading"]),
            Paragraph(
                "Read naturally with a child in one sitting. This reviews the story, not the child. "
                "Mark the page when wording changes aloud, attention drops, a transition feels rushed, "
                "or a moment creates confusion, fear, delight, prediction, or a request to continue.",
                style["body"],
            ),
            Paragraph(
                "Do not record a child's name, exact age, contact details, school, location, photo, audio, "
                "video, medical information, or other identifying details. Use the assigned anonymous "
                "session code and broad age band only.",
                style["note"],
            ),
            Paragraph(
                "This copy is not text or image locked. The artwork is a review candidate. "
                "Please mark visual mismatches, confusing details, cultural concerns, inconsistent "
                "characters, emotional-safety concerns, or important content lost when cropped.",
                style["note"],
            ),
            PageBreak(),
        ]
    )

    for page in story["pages"]:
        image_path = pdf_image_path(slug, page["number"])
        page_suffix = f"{safe_slug}P{page['number']}"
        page_ethiopic_font = f"NotoEthiopic{page_suffix}"
        page_latin_font = f"ReviewLatin{page_suffix}"
        page_latin_bold_font = f"ReviewLatinBold{page_suffix}"
        pdfmetrics.registerFont(TTFont(page_ethiopic_font, str(FONT_PATH)))
        pdfmetrics.registerFont(
            TTFont(page_latin_font, str(REPORTLAB_FONT_DIR / "Vera.ttf"))
        )
        pdfmetrics.registerFont(
            TTFont(page_latin_bold_font, str(REPORTLAB_FONT_DIR / "VeraBd.ttf"))
        )
        page_style = styles(
            page_ethiopic_font,
            page_latin_font,
            page_latin_bold_font,
        )
        image = ReviewImage(str(image_path), width=148 * mm, height=111 * mm)
        image.hAlign = "CENTER"
        bilingual_table = Table(
            [
                [
                    Paragraph(
                        f"<b>Amharic</b><br/>{page['amharic']}",
                        page_style["amharic"],
                    ),
                    Paragraph(
                        f"<b>English</b><br/>{page['english']}",
                        page_style["body"],
                    ),
                ]
            ],
            colWidths=[82 * mm, 82 * mm],
            style=TableStyle(
                [
                    ("VALIGN", (0, 0), (-1, -1), "TOP"),
                    ("BOX", (0, 0), (-1, -1), 0.5, colors.HexColor("#D8B9AA")),
                    ("INNERGRID", (0, 0), (-1, -1), 0.4, colors.HexColor("#E7D2C8")),
                    ("BACKGROUND", (0, 0), (-1, -1), colors.HexColor("#FFFDFC")),
                    ("LEFTPADDING", (0, 0), (-1, -1), 3 * mm),
                    ("RIGHTPADDING", (0, 0), (-1, -1), 3 * mm),
                    ("TOPPADDING", (0, 0), (-1, -1), 2.5 * mm),
                    ("BOTTOMPADDING", (0, 0), (-1, -1), 1.5 * mm),
                ]
            ),
        )
        story_page = [
                FixedLabel(
                    f"Story page {page['number']}",
                    font_size=19,
                    leading=25,
                    color=colors.HexColor("#6E3525"),
                    font_name=page_latin_bold_font,
                    space_after=3 * mm,
                ),
                Table(
                    [[image]],
                    colWidths=[164 * mm],
                    style=TableStyle(
                        [
                            ("ALIGN", (0, 0), (-1, -1), "CENTER"),
                            ("BOX", (0, 0), (-1, -1), 0.7, colors.HexColor("#C99E89")),
                            ("LEFTPADDING", (0, 0), (-1, -1), 2 * mm),
                            ("RIGHTPADDING", (0, 0), (-1, -1), 2 * mm),
                            ("TOPPADDING", (0, 0), (-1, -1), 2 * mm),
                            ("BOTTOMPADDING", (0, 0), (-1, -1), 2 * mm),
                        ]
                    ),
                ),
                Spacer(1, 3 * mm),
                bilingual_table,
                Spacer(1, 2 * mm),
                KeepTogether(
                    [
                        FixedLabel(
                            "Image-text review",
                            font_size=11,
                            leading=15,
                            color=colors.HexColor("#9A5035"),
                            font_name=page_latin_bold_font,
                            space_after=2 * mm,
                        ),
                        Table(
                            [[Paragraph(
                                f"Expected beat: {page['illustration']}<br/>"
                                "Does the picture match both texts? Are characters, setting, clothing, "
                                "objects, expressions and scale clear and consistent? Any cultural, "
                                "safety, cropping or child-appeal concern?",
                                page_style["note"],
                            )]],
                            colWidths=[168 * mm],
                            style=TableStyle(
                                [
                                    ("BACKGROUND", (0, 0), (-1, -1), colors.HexColor("#FFF3EC")),
                                    ("BOX", (0, 0), (-1, -1), 0.6, colors.HexColor("#E3BDAA")),
                                    ("LEFTPADDING", (0, 0), (-1, -1), 4 * mm),
                                    ("RIGHTPADDING", (0, 0), (-1, -1), 4 * mm),
                                    ("TOPPADDING", (0, 0), (-1, -1), 3 * mm),
                                    ("BOTTOMPADDING", (0, 0), (-1, -1), 2 * mm),
                                ]
                            ),
                        ),
                    ]
                ),
                Spacer(1, 2 * mm),
                FixedLabel(
                    "Adult text and image notes",
                    font_size=11,
                    leading=15,
                    color=colors.HexColor("#9A5035"),
                    font_name=page_latin_bold_font,
                    space_after=2 * mm,
                ),
                blank_lines(2),
            ]
        flow.extend([KeepTogether(story_page), PageBreak()])

    flow.extend(
        [
            Paragraph("Session scorecard", style["heading"]),
            Paragraph(
                "Anonymous session code: ____________________    Broad age band: 3-4 / 5-6",
                style["body"],
            ),
            Paragraph(
                "Language: Amharic / English    Adult role: parent / caregiver / educator / other",
                style["body"],
            ),
            Paragraph("Completed story: Yes / No", style["body"]),
            Spacer(1, 4 * mm),
            Paragraph(
                "Rate 1 (serious problem) to 5 (ready), or mark N/A.",
                style["note"],
            ),
            Table(
                [
                    ["Measure", "1-5", "Page/evidence"],
                    ["Language sounded natural aloud", "", ""],
                    ["Sentences were easy to read", "", ""],
                    ["Child followed the story flow", "", ""],
                    ["Page pacing felt unhurried", "", ""],
                    ["Conflict felt emotionally safe", "", ""],
                    ["Ending felt clear and satisfying", "", ""],
                    ["Child remained interested", "", ""],
                    ["Images match both language versions", "", ""],
                    ["Characters remain visually consistent", "", ""],
                    ["Culture and setting feel respectful", "", ""],
                    ["Images remain clear when cropped", "", ""],
                ],
                colWidths=[86 * mm, 18 * mm, 64 * mm],
                rowHeights=[8 * mm] * 12,
                style=TableStyle(
                    [
                        ("FONTNAME", (0, 0), (-1, -1), latin_font),
                        ("FONTSIZE", (0, 0), (-1, -1), 8.5),
                        ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#F5D8C8")),
                        ("GRID", (0, 0), (-1, -1), 0.4, colors.HexColor("#A98D80")),
                        ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
                        ("LEFTPADDING", (0, 0), (-1, -1), 2.5 * mm),
                    ]
                ),
            ),
            PageBreak(),
            Paragraph("Observations and recommendation", style["heading"]),
            Paragraph(
                "Words changed aloud; confusing or rushed pages; child questions; delight or prediction; "
                "fear or discomfort; remembered part; suggested revision:",
                style["body"],
            ),
            blank_lines(12),
            Spacer(1, 5 * mm),
            Paragraph(
                "Recommendation: Pass / Revise wording / Revise page flow / Reconsider age band / "
                "Cultural review / Safety review / Replace",
                style["body"],
            ),
            Paragraph(
                "Return this adult scorecard through the owner's private route. Remove identifying child "
                "details before submission.",
                style["note"],
            ),
        ]
    )

    doc.build(
        flow,
        onFirstPage=page_decor,
        onLaterPages=page_decor,
        canvasmaker=InvariantCanvas,
    )
    return output


def verify_pdf(path: Path, source: dict) -> None:
    reader = PdfReader(str(path))
    expected_pages = len(source["pages"]) + 3
    if len(reader.pages) != expected_pages:
        raise RuntimeError(
            f"{path.name}: expected {expected_pages} pages, found {len(reader.pages)}"
        )

    for index, story_page in enumerate(source["pages"], start=1):
        extracted = reader.pages[index].extract_text() or ""
        required = [
            f"Story page {story_page['number']}",
            "Amharic",
            "English",
            "Image-text review",
            "Adult text and image notes",
        ]
        missing = [label for label in required if label not in extracted]
        if missing:
            raise RuntimeError(
                f"{path.name} page {index + 1}: missing labels {missing}"
            )
        if not reader.pages[index].images:
            raise RuntimeError(
                f"{path.name} page {index + 1}: embedded illustration is missing"
            )

    scorecard = reader.pages[-2].extract_text() or ""
    observations = reader.pages[-1].extract_text() or ""
    if "Session scorecard" not in scorecard:
        raise RuntimeError(f"{path.name}: scorecard page is missing")
    if "Observations and recommendation" not in observations:
        raise RuntimeError(f"{path.name}: observations page is missing")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Generate structurally verified pilot reviewer PDFs."
    )
    parser.add_argument(
        "--story",
        choices=[slug for slug, _ in STORIES],
        help="Rebuild only one story PDF; omit to rebuild the complete packet.",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    selected = [story for story in STORIES if not args.story or story[0] == args.story]
    outputs = [build_pdf(slug, title) for slug, title in selected]
    for (slug, _), output in zip(selected, outputs):
        source = parse_story(ROOT / "docs/pilot_drafts" / f"{slug}.md")
        verify_pdf(output, source)
        print(f"{output.relative_to(ROOT)}: verified")


if __name__ == "__main__":
    main()
