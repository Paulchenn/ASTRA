# Makefile fuer LaTeX-thesis mit BibLaTeX und nomencl, ohne latexmk

MAIN = main
PDF = $(MAIN).pdf
BIB = bibliography.bib
PLOT_WRAPPER = plot_wrapper
PGF ?= figures/pgf/my_file.pgf
PGF_NAME := $(notdir $(basename $(PGF)))
PDF_OUT_DIR := figures/pdf

LATEX = pdflatex -interaction=nonstopmode --extra-mem-top=1000000000

VERBOSE ?= 0

ifeq ($(OS),Windows_NT)
  RM     = cmd /C del /Q /F
  CP     = cmd /C copy /Y
  MV    := cmd /C move /Y
  MKDIR := powershell -Command New-Item -ItemType Directory -Force -Path
  REDIR_NULL = > NUL 2>&1
else
  RM    = rm -f
  CP    = cp
  MV   := mv
  MKDIR := mkdir -p
  REDIR_NULL = > /dev/null 2>&1
endif

ifeq ($(VERBOSE),1)
  REDIR =
else
  REDIR = $(REDIR_NULL)
endif

# Standard: Voller Build (alles)
all: full

# Alias fuer Kompatibilitaet
compile: full

# Vollstaendiger Build: pdflatex + biber + nomencl + pdflatex x2
full:
	@echo "Vollstaendiger Build (pdflatex + biber + nomencl + pdflatex x2)..."
	$(LATEX) $(MAIN) $(REDIR)
	biber $(MAIN) $(REDIR)
	makeindex $(MAIN).nlo -s nomencl.ist -o $(MAIN).nls $(REDIR)
	$(LATEX) $(MAIN) $(REDIR)
	$(LATEX) $(MAIN) $(REDIR)

# Schneller Build: nur einmal pdflatex
fast:
	@echo "Schneller Build (einmal pdflatex)..."
	$(LATEX) $(MAIN) $(REDIR)

# Alias fuer fast
pdflatex: fast

# Nur Literatur aktualisieren (ohne pdflatex)
biber:
	@echo "Biber-Lauf ohne pdflatex..."
	biber $(MAIN) $(REDIR)

# Nur Nomenklatur aktualisieren (ohne pdflatex)
nomen:
	@echo "Nomenklatur-Lauf ohne pdflatex..."
	makeindex $(MAIN).nlo -s nomencl.ist -o $(MAIN).nls $(REDIR)

# PGF → PDF
# Verwendung: make pgf PGF=figures/pgf/subdir/myplot.pgf
ifeq ($(OS),Windows_NT)
pgf:
	@echo "Rendere PGF-Plot -> $(PGF_NAME).pdf ..."
	$(LATEX) -jobname="$(PGF_NAME)" "\def\pgfFilePath{$(PGF)}\input{$(PLOT_WRAPPER)}" $(REDIR)
	-$(MKDIR) $(subst /,\,$(PDF_OUT_DIR))
	$(MV) $(subst /,\,$(PGF_NAME).pdf) $(subst /,\,$(PDF_OUT_DIR)\$(PGF_NAME).pdf)
	-$(RM) $(PGF_NAME).aux $(PGF_NAME).log $(PGF_NAME).nlo $(PGF_NAME).out
	@echo "Fertig: $(PDF_OUT_DIR)/$(PGF_NAME).pdf"
else
pgf:
	@echo "Rendere PGF-Plot -> $(PGF_NAME).pdf ..."
	$(LATEX) -jobname="$(PGF_NAME)" "\\def\\pgfFilePath{$(PGF)}\\input{$(PLOT_WRAPPER)}" $(REDIR)
	-$(MKDIR) $(PDF_OUT_DIR)
	$(MV) $(PGF_NAME).pdf $(PDF_OUT_DIR)/$(PGF_NAME).pdf
	-$(RM) $(PGF_NAME).aux $(PGF_NAME).log $(PGF_NAME).nlo $(PGF_NAME).out
	@echo "Fertig: $(PDF_OUT_DIR)/$(PGF_NAME).pdf"
endif

# Aufraeumen der Hilfsdateien (rekursiv in alle Unterverzeichnisse)
ifeq ($(OS),Windows_NT)
clean:
	-cmd /C del /S /Q /F *.aux *.log *.toc *.lof *.lot *.bbl *.blg *.out *.tdo \
	                     *.fls *.fdb_latexmk *.nav *.snm *.vrb *.thm *.bcf \
	                     *.run.xml *.nlo *.nls *.ilg *.synctex.gz 2>nul
	@echo "Cleaned auxiliary files."
else
clean:
	-find . \( -name "*.aux"        -o -name "*.log"         \
	          -o -name "*.toc"      -o -name "*.lof"         \
	          -o -name "*.lot"      -o -name "*.bbl"         \
	          -o -name "*.blg"      -o -name "*.out"         \
	          -o -name "*.fls"      -o -name "*.fdb_latexmk" \
	          -o -name "*.nav"      -o -name "*.snm"         \
	          -o -name "*.vrb"      -o -name "*.thm"         \
	          -o -name "*.bcf"      -o -name "*.run.xml"     \
	          -o -name "*.nlo"      -o -name "*.nls"         \
	          -o -name "*.ilg" 		-o -name "*.tdo" \) -delete
	@echo "Cleaned auxiliary files."
endif

# Alles inkl. PDF entfernen
fclean: clean
	-$(RM) $(PDF) 

.PHONY: all full fast pdflatex biber nomen clean fclean compile pgf