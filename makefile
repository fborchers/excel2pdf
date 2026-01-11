

 ######     ###    ##       ##       #### ##    ##  ######   
##    ##   ## ##   ##       ##        ##  ###   ## ##    ##  
##        ##   ##  ##       ##        ##  ####  ## ##        
##       ##     ## ##       ##        ##  ## ## ## ##   #### 
##       ######### ##       ##        ##  ##  #### ##    ##  
##    ## ##     ## ##       ##        ##  ##   ### ##    ##  
 ######  ##     ## ######## ######## #### ##    ##  ######   


# Sub-directories are:
INPUT:=input
CSV:=csv
DOKUWIKI:= dokuwiki
LATEX:= latex
BUILD:= build

# Source files are the Excel sheets:
infiles:= $(sort $(wildcard $(INPUT)/*.xlsx))

# Intermediate files are:
csvfiles:= $(patsubst $(INPUT)/%.xlsx,$(CSV)/%.csv,$(infiles))
dokufiles:=$(patsubst $(INPUT)/%.xlsx,$(DOKUWIKI)/%.txt,$(infiles))
texfiles:= $(patsubst $(INPUT)/%.xlsx,$(LATEX)/%.tex,$(infiles))


# Build Routine for the Calling Card ---

# TeX input routine to be used in creating the calling card:
define texinput
	"\clearpage\subsection{$(1)}\input{$(1)}"
endef

# Each of texfiles in the latex/ directory will be called by pdflatex:
callingcard:= $(BUILD)/callingcard
$(callingcard).txt: | $(texfiles)
	@# Initialise:
	@printf '%s\n\n' '% Calling card für das Curriculum --------' > $@
	@# Call all the texfiles present in the latex/ sub-directory:
	@printf '%s\n\n' \
	$(foreach file,$(texfiles),$(call texinput,$(file))) >> $@

# Exchange the file name for a proper section heading:
$(callingcard).tex: $(callingcard).txt
	@sed \
		 -e 's#{latex/klasse-07.tex#{Klasse  7#' \
		 -e 's#{latex/klasse-08.tex#{Klasse  8#' \
		 -e 's#{latex/klasse-09.tex#{Klasse  9   -- Gymnasium#' \
		-e 's#{latex/klasse-09r.tex#{Klasse  9   -- Realschulbildungsgang#' \
		-e 's#{latex/klasse-09z.tex#{Klasse  9   -- Hauptschulbildungsgang#' \
		 -e 's#{latex/klasse-10.tex#{Klasse 10   -- Gymnasium#' \
		-e 's#{latex/klasse-10r.tex#{Klasse 10   -- Realschulbildungsgang#' \
		-e 's#{latex/klasse-10z.tex#{Klasse 10   -- Hauptschulbildungsgang#' \
		-e 's#{latex/klasse-11.1-elehre.tex#{Halbjahr 11.1: Elektrizitätslehre   -- Qualifikationsphase Abitur#' \
		-e 's#{latex/klasse-11.1-elektromgn.tex#{Halbjahr 11.1-2: Elektromagnetismus   -- Qualifikationsphase Abitur#' \
		-e 's#{latex/klasse-11.2-ScWeWo.tex#{Halbjahr 11.2: Schwingungen und Wellen   -- Qualifikationsphase Abitur#' \
		-e 's#{latex/klasse-12.1-quanten.tex#{Halbjahr 12.1: Quantenphysik   -- Qualifikationsphase Abitur#' \
		-e 's#{latex/klasse-12.2-atom.tex#{Halbjahr 12.1: Atomphysik   -- Qualifikationsphase Abitur#' \
		-e 's#{latex/klasse-12.3-kern.tex#{Halbjahr 12.2: Kernphysik   -- Qualifikationsphase Abitur#' \
	   -e 's#{latex/qphase-11.1.tex#{Halbjahr 11.1 -- Qualifikationsphase Abitur#' \
	   -e 's#{latex/qphase-11.2.tex#{Halbjahr 11.2 -- Qualifikationsphase Abitur#' \
	   -e 's#{latex/qphase-12.1.tex#{Halbjahr 12.1 -- Qualifikationsphase Abitur#' \
	   -e 's#{latex/klasse-12.4-astro.tex#{Halbjahr 12.2 -- Wahlbereich Astronomie#' \
	   -e 's#{latex/qphase-12.2-relativity.tex#{Halbjahr 12.2 -- Wahlbereich Relativitätstheorie#' \
		$< > $@








########  ####  ######  ######## 
##     ##  ##  ##    ##    ##    
##     ##  ##  ##          ##    
##     ##  ##  ##          ##    
##     ##  ##  ##          ##    
##     ##  ##  ##    ##    ##    
########  ####  ######     ##    


# DICTIONARY ---
# Spezieller LaTeX-Code aus dem dictionary wird ersetzt. Dazu wird das dictionary erzeugt aus der Datei ''lib/dictionary.txt'':
DICT := lib/dictionary.csv
SEDSCRIPT:= $(BUILD)/dictionary.sed

# Use the dictionary to build a sed-compatible scriptfile. This SEDSCRIPT 
# will be used to generate the TeX code (see below). 
$(SEDSCRIPT): $(DICT)
	@#  's#^#s|#'  add a 's|' at the beginning of the line
	@#  's#\t#|#'  replace a \tab with a pipe |
	@#  's#$$#|g#' add a slash |g at the end of the line 
	@# 			   (make will collaps $$ to $ for bash.)
	@#  's#[#\\[#g'
	@sed -e 's#^#s|#' -e 's#\t\t#|#' -e 's#\t#|#' -e 's#$$#|g#' $< >$@
# This script file will be used with all the tex-files below.










#######   ######## ##    ## ######## ########  ####  ######  
##    ##  ##       ###   ## ##       ##     ##  ##  ##    ## 
##        ##       ####  ## ##       ##     ##  ##  ##       
##   #### ######   ## ## ## ######   ########   ##  ##       
##    ##  ##       ##  #### ##       ##   ##    ##  ##       
##    ##  ##       ##   ### ##       ##    ##   ##  ##    ## 
 ######   ######## ##    ## ######## ##     ## ####  ######  

.PRECIOUS: $(csvfiles) $(dokufiles)


# xlsx to CSV
# Extract from the infiles. This is a generic rule that will apply to 
# all input files:
$(CSV)/%.csv: $(INPUT)/%.xlsx
	@# 124 for |, 34 for "", 0 (System char set), 1 no of first row, 2 cell format text, c.f. https://help.libreoffice.org/7.3/en-US/text/shared/guide/csv_params.html?DbPAR=SHARED
	@soffice --headless --convert-to csv:"Text - txt - csv (StarCalc)":124,34,0,1,2 --outdir ./$(CSV)/ $< 1>/dev/null 2>/dev/null


# CSV to DokuWiki format
# Create the txt-file in DokuWiki format. To do so, 
#	add a pipe | at the end ($$) of each line,
#	split double pipes (||),
#	replace | by ^ in the first line of each file.
#  	-e 's/^/| /g' # matches the beginning of a line
$(DOKUWIKI)/%.txt: $(CSV)/%.csv
	@sed \
	-e 's/||/| |/g' \
	-e 's/$$/ |/g'  \
	-e '1 s/|/^/g' \
	$< > $@


# Prepare the LaTeX conversion ---
# This is a workaround to keep the line breaks. The
# intermediate file $(LATEX)/%.txt has ''NEWLINE'' placeholders. The
# placeholders will later be replaced by \newline (see below).
$(LATEX)/%.txt: $(DOKUWIKI)/%.txt
	@sed -e 's/\\\\ /NEWLINE /g' $< > $@
# This code will then be used to create the texfiles. But first we 
# need to build the dictionary SEDSCRIPT with the LaTeX supplementaries.


# Prepare the LaTeX file ---
# I add specific column widths. Note the difference between
#   \raggedright (no hyphenation) and
#   \RaggedRight (with hyphenation, from ragged2e package)
columnsspecified := @{}\
p{8.0cm}<{\\RaggedRight}\
p{2.5cm}<{\\RaggedRight}@{}\
p{0.9cm}<{\\RaggedRight}@{}\
p{7.5cm}<{\\RaggedRight}\
p{5.5cm}<{\\RaggedRight}\
@{}


# After converting to tex with pandoc the routine //sed// will be called:
# The NEWLINE placeholders have to be changed to ''\newline{}'' 
# commands in LaTeX. We then use the columns specified above.
# Zeilenumbrüche \\ werden ersetzt durch Zeilenumbrüche mit Trennlinie, 
# also mit ''\\ \midrule''. 
# Die letzte midrule einer Datei muss noch entfernt werden.
# Das dictionary SEDSCRIPT wird verwendet, um speziellen LaTeX-Code 
# einzufügen, z.B. Formeln und andere Mathematik.
$(LATEX)/%.tex: $(LATEX)/%.txt $(SEDSCRIPT)
	@pandoc -f dokuwiki -t latex $< | \
	sed \
	-e 's/NEWLINE/\\newline{}/g' \
	-e 's/@{}lllll@{}/$(columnsspecified)/g' \
	-e 's/\\\\/\\\\ \\midrule/g' | \
	sed -f $(SEDSCRIPT) \
	> $@












##          ###    ######## ######## ##     ## 
##         ## ##      ##    ##        ##   ##  
##        ##   ##     ##    ##         ## ##   
##       ##     ##    ##    ######      ###    
##       #########    ##    ##         ## ##   
##       ##     ##    ##    ##        ##   ##  
######## ##     ##    ##    ######## ##     ## 

# Das Kompilieren mit LaTeX ---
# get the file name of the source tex file;
# the file name must coincide with the directory's name:
jobname := excel2pdf
texfile := $(jobname).tex


# main build files:
dvifile:= $(BUILD)/$(jobname).dvi
psfile := $(BUILD)/$(jobname).ps
pdffile:= $(BUILD)/$(jobname).pdf
outfile:= $(jobname).pdf

# Logfiles
LOG = $(BUILD)/compile.log


# BUILD PROCESS --------
.PHONY: pdf dvi ps pdf view

dvi: $(dvifile)
ps : $(psfile)
pdf: $(outfile)

view: | $(outfile)
	@open $(outfile)



$(pdffile): $(texfile) $(texfiles) $(callingcard).tex
	@echo "\tpdflatex --output-directory=build $(texfile)"
	@pdflatex --output-directory=$(BUILD) $(texfile) >> $(LOG) 2>&1

$(outfile): $(pdffile)
	@cp $< $@


########  ##     ##  #######  ##    ## ##    ## 
##     ## ##     ## ##     ## ###   ##  ##  ##  
##     ## ##     ## ##     ## ####  ##   ####   
########  ######### ##     ## ## ## ##    ##    
##        ##     ## ##     ## ##  ####    ##    
##        ##     ## ##     ## ##   ###    ##    
##        ##     ##  #######  ##    ##    ##    

.PHONY: csv tex all clean echo test

echo:
	@echo $(jobname)
	@echo $(infiles)

csv: $(csvfiles)
	@echo "  " $(csvfiles)

tex: $(texfiles)
	@echo "  " $(texfiles)

doku:$(dokufiles)
	@#echo "  " $(dokufiles)

all: tex $(callingcard).tex


######## ########  ######  ######## 
   ##    ##       ##    ##    ##    
   ##    ##       ##          ##    
   ##    ######    ######     ##    
   ##    ##             ##    ##    
   ##    ##       ##    ##    ##    
   ##    ########  ######     ##    

test:
	@echo "...Looking for pdflatex..."
	pdflatex -v
	@echo "\n...Looking for LibreOffice's soffice ..."
	soffice --version


#######  ##       ########    ###    ##    ## 
##    ## ##       ##         ## ##   ###   ## 
##       ##       ##        ##   ##  ####  ## 
##       ##       ######   ##     ## ## ## ## 
##       ##       ##       ######### ##  #### 
##    ## ##       ##       ##     ## ##   ### 
 ######  ######## ######## ##     ## ##    ## 

clean: 
	@rm -f $(pdffile)
	@rm -f $(dvifile)
	@rm -f $(outfile)
	@rm -f $(callingcard).txt
	@rm -f $(callingcard).tex
	@rm -f $(LOG)
	@rm -f $(texfiles)



distclean: clean
	@rm -f $(csvfiles)
	@rm -f $(dokufiles)
	@rm -f $(BUILD)/$(jobname).aux
	@rm -f $(BUILD)/$(jobname).log
	@rm -f $(BUILD)/$(jobname).out
	@rm -f $(BUILD)/$(jobname).toc
	@# Next, remove the sed script of the dictionary,
	@# it will rebuild in the next run:
	@rm -f $(SEDSCRIPT)

