



#infile:=input/curriculum1.ods
infile:=input/klasse-07.ods

intermfile:=$(patsubst input/%.ods,input/%.csv,$(infile))


dokufile:= $(patsubst input/%.ods,latex/%.txt,$(infile))
latexfile:= $(patsubst input/%.ods,latex/%.tex,$(infile))


# Extract from Libre Office file, 
# now a generic rule:
input/%.csv: input/%.ods
	@# 124 for |, 34 for "", 0 (System char set), 1 no of first row, 2 cell format text, c.f. https://help.libreoffice.org/7.3/en-US/text/shared/guide/csv_params.html?DbPAR=SHARED
	@soffice --headless --convert-to csv:"Text - txt - csv (StarCalc)":124,34,0,1,2 --outdir ./input/ $(infile) 1>/dev/null 2>/dev/null

# Create the txt-file in DokuWiki format. To do so, add a
# pipe | at the end of each line, split double pipes (||):
#  	-e 's/^/| /g' # Zeilenanfang
dokuwiki/%.txt: input/%.csv
	@sed \
	-e 's/||/| |/g' \
	-e 's/$$/ |/g'  \
	$< > $@

# This is a workaround to keep the line breaks. The
# intermediate file latex/%.txt has ''NEWLINE'' placeholders:
latex/%.txt: dokuwiki/%.txt
	sed -e 's/\\\\ /NEWLINE /g' $< > $@

# After converting to tex the placeholders become ''\newline{}''
# commands in LaTeX. I also add specific column widths.
latex/%.tex: latex/%.txt
	pandoc -f dokuwiki -t latex $< | \
	sed \
	-e 's/NEWLINE/\\newline{}/g' \
	-e 's/@{}lllll@{}/@{}p{7cm}p{2.5cm}p{1cm}@{}p{7cm}p{5cm}@{}/g' \
	> $@


# LaTeX
# get the file name of the source tex file;
# the file name must coincide with the directory's name:
jobname := curriculum
texfile := $(jobname).tex

texfiles := $(texfile) $(latexfile)

# main build files:
dvifile:= build/$(jobname).dvi
psfile := build/$(jobname).ps
pdffile:= build/$(jobname).pdf

# Logfiles
LOG = build/compile.log


# BUILD PROCESS --------
.PHONY: pdf dvi ps pdf view

dvi: $(dvifile)
ps : $(psfile)
pdf: $(pdffile)
view: | $(pdffile)
	@open $(pdffile)

# Engine:
TX := latex


$(pdffile): $(texfiles)
	pdflatex --output-directory=build $(texfile) >> $(LOG) 2>&1



.PHONY: all clean echo test

echo:
	@echo $(infile)

test: $(texfiles)
	@echo $(texfiles)

all: $(latexfile)

clean: 
	@rm -rf $(dokufile)
	@rm -rf $(latexfile)

distclean: clean
	@rm -rf $(intermfile)
	@rm -rf $(pdffile)