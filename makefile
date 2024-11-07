


 ######     ###    ##       ##       #### ##    ##  ######   
##    ##   ## ##   ##       ##        ##  ###   ## ##    ##  
##        ##   ##  ##       ##        ##  ####  ## ##        
##       ##     ## ##       ##        ##  ## ## ## ##   #### 
##       ######### ##       ##        ##  ##  #### ##    ##  
##    ## ##     ## ##       ##        ##  ##   ### ##    ##  
 ######  ##     ## ######## ######## #### ##    ##  ######   

# Calling Card -- source files are:
odsfiles:= $(sort $(wildcard input/*.ods))
csvfiles:= $(patsubst input/%.ods,input/%.csv,$(odsfiles))
dokufiles:=$(patsubst input/%.ods,dokuwiki/%.txt,$(odsfiles))
texfiles:= $(patsubst input/%.ods,latex/%.tex,$(odsfiles))

.intermediate: $(dokufiles)

# TeX input routine to be used in creating the calling card:
define texinput
	"\input{$(1)}"
endef

# Each of the ods-files in the input/ directory will be called:
callingcard:= build/callingcard.tex
$(callingcard): | $(odsfiles)
	@printf '%s\n' \
	$(foreach file,$(texfiles),$(call texinput,$(file))) > $@







#######   ######## ##    ## ######## ########  ####  ######  
##    ##  ##       ###   ## ##       ##     ##  ##  ##    ## 
##        ##       ####  ## ##       ##     ##  ##  ##       
##   #### ######   ## ## ## ######   ########   ##  ##       
##    ##  ##       ##  #### ##       ##   ##    ##  ##       
##    ##  ##       ##   ### ##       ##    ##   ##  ##    ## 
 ######   ######## ##    ## ######## ##     ## ####  ######  


# Extract from Libre Office file -- now a generic rule:
input/%.csv: input/%.ods
	@# 124 for |, 34 for "", 0 (System char set), 1 no of first row, 2 cell format text, c.f. https://help.libreoffice.org/7.3/en-US/text/shared/guide/csv_params.html?DbPAR=SHARED
	@soffice --headless --convert-to csv:"Text - txt - csv (StarCalc)":124,34,0,1,2 --outdir ./input/ $< 1>/dev/null 2>/dev/null

# Create the txt-file in DokuWiki format. To do so, add a
# pipe | at the end of each line, split double pipes (||):
#  	-e 's/^/| /g' # Zeilenanfang
dokuwiki/%.txt: input/%.csv
	@sed \
	-e 's/||/| |/g' \
	-e 's/$$/ |/g'  \
	$< > $@


# Convert to DokuWiki-Code ---
# This is a workaround to keep the line breaks. The
# intermediate file latex/%.txt has ''NEWLINE'' placeholders:
latex/%.txt: dokuwiki/%.txt
	@sed -e 's/\\\\ /NEWLINE /g' $< > $@


# Prepare the LaTeX file ---

# I add specific column widths:
columnsspecified := @{}\
p{8.0cm}<{\\raggedright}\
p{2.5cm}<{\\raggedright}@{}\
p{0.8cm}<{\\raggedright}@{}\
p{7.5cm}<{\\raggedright}\
p{5.5cm}<{\\raggedright}\
@{}

# After converting to tex with pandoc
# the placeholders have to be changed to ''\newline{}'' 
# commands in LaTeX. Then I use the columns specified above.
# Zeilenumbrüche \\ werden ersetzt durch Zeilenumbrüche mit Trennlinie, 
# also \\ \midrule. Die letzte midrule einer Datei muss noch entfernt werden.
latex/%.tex: latex/%.txt
	@pandoc -f dokuwiki -t latex $< | \
	sed \
	-e 's/NEWLINE/\\newline{}/g' \
	-e 's/@{}lllll@{}/$(columnsspecified)/g' \
	-e 's/\\\\/\\\\ \\midrule/g' \
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
jobname := curriculum
texfile := $(jobname).tex


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


$(pdffile): $(texfile) $(texfiles) $(callingcard)
	pdflatex --output-directory=build $(texfile) >> $(LOG) 2>&1




########  ##     ##  #######  ##    ## ##    ## 
##     ## ##     ## ##     ## ###   ##  ##  ##  
##     ## ##     ## ##     ## ####  ##   ####   
########  ######### ##     ## ## ## ##    ##    
##        ##     ## ##     ## ##  ####    ##    
##        ##     ## ##     ## ##   ###    ##    
##        ##     ##  #######  ##    ##    ##    

.PHONY: all clean echo test

echo:
	@echo $(csvfiles)

test: $(texfiles)
	@echo $(texfiles)



clean: 
	@rm -f $(pdffile)
	@rm -f $(callingcard)
	@rm -f $(LOG)



distclean: clean
	@rm -f $(texfiles)
	@rm -f $(csvfiles)
