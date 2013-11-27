# For ideas on makefiles for LaTeX see [1], kahen answer.
#
# [1]: http://tex.stackexchange.com/questions/45/how-can-i-speed-up-latex-compilation

PDFLATEX = pdflatex -interaction=batchmode
PDFCROP  = pdfcrop
RM       = /usr/bin/rm

InputTeXFiles = ch3-tes-theory.tex ch4-sys-design.tex ch8-subarray.tex ch9-imaging.tex
SAGFiles = $(wildcard drawings/*.tex)
PDFSAGFiles = $(SAGFiles:.tex=.pdf) 
ImageFiles = images/*

default : thesis.pdf

thesis.pdf : thesis.tex $(InputTeXFiles) $(ImageFiles) $(PDFSAGFiles)
	$(PDFLATEX) $<

drawings/%.pdf: drawings/%.tex
	cd drawings && $(PDFLATEX) $(notdir $<) && $(PDFCROP) $(notdir $@) $(notdir $@)

clean : .PHONY
	find . -regex ".*\(aux\|bbl\|blg\|log\|bcf\|synctex\.gz\|fls\|fdb_latexmk\)" -type f -delete
	$(RM) -fr -- drawings/*.pdf

distclean : clean
	$(RM) -f -- thesis.pdf

.PHONY :
