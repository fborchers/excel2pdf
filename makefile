



#infile:=input/curriculum1.ods
infile:=input/klasse-07.ods

intermfile:=$(patsubst input/%.ods,input/%.csv,$(infile))


curri1:= latex/curri1.txt
latex1:= latex/latex1.tex


# Extract from Libre Office file:
$(intermfile): $(infile)
	@# 124 for |, 34 for "", 0 (System char set), 1 no of first row, 2 cell format text, c.f. https://help.libreoffice.org/7.3/en-US/text/shared/guide/csv_params.html?DbPAR=SHARED
	@soffice --headless --convert-to csv:"Text - txt - csv (StarCalc)":124,34,0,1,2 --outdir ./input/ $(infile) 1>/dev/null 2>/dev/null

# Add | at beginning and end of each line, split double pipes (||):
$(curri1): $(intermfile)
	@sed \
	-e 's/^/| /g' \
	-e 's/$$/ |/g' \
	-e 's/||/| |/g' \
	$(intermfile) > $@

$(latex1): $(curri1)
	pandoc -f dokuwiki -t latex $< | \
	sed -e 's/llll/p{3cm}p{10cm}p{5cm}p{4cm}/' > $@


# LaTeX
# get the file name of the source tex file;
# the file name must coincide with the directory's name:
jobname := curriculum
texfile := $(jobname).tex

texfiles := $(texfile) $(latex1)

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

all: $(latex1)

clean: 
	@rm -rf $(curri1)
	@rm -rf $(latex1)

distclean: clean
	@rm -rf $(intermfile)
	@rm -rf $(pdffile)