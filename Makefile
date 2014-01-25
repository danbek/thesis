# For ideas on makefiles for LaTeX see [1], kahen answer.
#
# [1]: http://tex.stackexchange.com/questions/45/how-can-i-speed-up-latex-compilation

PDFLATEX = pdflatex -interaction=batchmode
LUALATEX = lualatex -interaction=batchmode
PDFCROP  = pdfcrop
RM       = /usr/bin/rm

InputTeXFiles = ch3-tes-theory.tex ch4-sys-design.tex ch5-det-design.tex ch7-subarray.tex ch8-imaging.tex
SAGFiles = $(wildcard drawings/*.tex)
PDFSAGFiles = $(SAGFiles:.tex=.pdf) 
ImageFiles = images/*

default : thesis.pdf

thesis.pdf : thesis.tex $(InputTeXFiles) $(ImageFiles) $(PDFSAGFiles) thesis.sty
	$(PDFLATEX) $<

drawings/ch7-cm-plots.pdf: drawings/ch7-cm-plots.tex thesis.sty
	cd drawings && $(LUALATEX) $(notdir $<) && $(PDFCROP) $(notdir $@) $(notdir $@)

drawings/%.pdf: drawings/%.tex thesis.sty
	cd drawings && $(PDFLATEX) $(notdir $<) && $(PDFCROP) $(notdir $@) $(notdir $@)

clean : .PHONY
	find . -regex ".*\(aux\|bbl\|blg\|log\|bcf\|synctex\.gz\|fls\|fdb_latexmk\)" -type f -delete
	$(RM) -fr -- drawings/*.pdf

distclean : clean
	$(RM) -f -- thesis.pdf

.PHONY :
