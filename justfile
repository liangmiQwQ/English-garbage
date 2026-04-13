# English Exam Paper Builder
#
# Requirements (weasyprint, default):
#   brew install pandoc just
#   pip install weasyprint

PANDOC_FLAGS := "--standalone -f markdown+fenced_divs+raw_html"

# Default: build all PDFs
default: all

# Build all PDFs — auto-detects every papers/paper*_questions.md file
all: dist
    #!/usr/bin/env bash
    set -euo pipefail
    shopt -s nullglob
    files=(papers/paper*_questions.md)
    if [[ ${#files[@]} -eq 0 ]]; then
        echo "No paper*_questions.md files found in papers/." >&2
        exit 1
    fi
    for qfile in "${files[@]}"; do
        base=$(basename "$qfile" _questions.md)   # e.g. paper1
        n=${base#paper}                            # e.g. 1
        afile="papers/answers/${base}_answers.md"
        echo "Building paper ${n}..."
        pandoc "$qfile" \
            {{PANDOC_FLAGS}} \
            --css=styles/style.css \
            --pdf-engine=weasyprint \
            -o "dist/${base}_questions.pdf"
        pandoc "$afile" \
            {{PANDOC_FLAGS}} \
            --css=styles/style-answers.css \
            --pdf-engine=weasyprint \
            -o "dist/${base}_answers.pdf"
        echo "  Paper ${n} done."
    done
    echo "All done! PDFs are in ./dist/"

# Create output directory
dist:
    mkdir -p dist

# Remove generated PDFs
clean:
    rm -rf dist
    @echo "Cleaned dist/."

# Build and open all PDFs (macOS)
open: all
    #!/usr/bin/env bash
    shopt -s nullglob
    for pdf in dist/paper*_questions.pdf dist/paper*_answers.pdf; do
        open "$pdf"
    done
