# English Exam Paper Builder
#
# Requirements (weasyprint, default):
#   brew install pandoc
#   pip install weasyprint
#
# Optional (xelatex, for LaTeX workflow):
#   brew install --cask mactex-no-gui
#   sudo tlmgr install xecjk collection-fontsrecommended enumitem

PANDOC_FLAGS := "--standalone -f markdown+fenced_divs+raw_html"

# Default: build all PDFs
default: all

# Build all PDFs
all: dist term1 term2
    @echo "Done! PDFs are in ./dist/"

# Convert Term 1 papers
term1: dist
    pandoc papers/term1_questions.md \
        {{PANDOC_FLAGS}} \
        --css=papers/style.css \
        --pdf-engine=weasyprint \
        -o dist/term1_questions.pdf
    pandoc papers/answers/term1_answers.md \
        {{PANDOC_FLAGS}} \
        --css=papers/style-answers.css \
        --pdf-engine=weasyprint \
        -o dist/term1_answers.pdf
    @echo "Term 1 done."

# Convert Term 2 papers
term2: dist
    pandoc papers/term2_questions.md \
        {{PANDOC_FLAGS}} \
        --css=papers/style.css \
        --pdf-engine=weasyprint \
        -o dist/term2_questions.pdf
    pandoc papers/answers/term2_answers.md \
        {{PANDOC_FLAGS}} \
        --css=papers/style-answers.css \
        --pdf-engine=weasyprint \
        -o dist/term2_answers.pdf
    @echo "Term 2 done."

# Alternative: build using xelatex (requires MacTeX/BasicTeX)
# Each .md file must use LaTeX raw blocks for this to work.
# Kept here for reference if migrating to a LaTeX workflow.
# all-latex: dist
#     pandoc papers/term1_questions.md --pdf-engine=xelatex -o dist/term1_questions.pdf
#     pandoc papers/term2_questions.md --pdf-engine=xelatex -o dist/term2_questions.pdf

# Create output directory
dist:
    mkdir -p dist

# Remove generated PDFs
clean:
    rm -rf dist
    @echo "Cleaned dist/."

# Build and open all PDFs (macOS)
open: all
    open dist/term1_questions.pdf
    open dist/term2_questions.pdf
    open dist/term1_answers.pdf
    open dist/term2_answers.pdf
