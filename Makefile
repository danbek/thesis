# For ideas on makefiles for LaTeX see [1], kahen answer.
#
# [1]: http://tex.stackexchange.com/questions/45/how-can-i-speed-up-latex-compilation

PDFLATEX = pdflatex -interaction=batchmode
LUALATEX = lualatex -interaction=batchmode
PDFCROP  = pdfcrop
RM       = rm

InputTeXFiles = ch1-intro.tex ch2-specs.tex ch3-tes-theory.tex ch4-sys-design.tex ch5-det-design.tex ch6-subarray.tex ch7-imaging.tex ch8-summary.tex
SAGFiles = $(wildcard drawings/*.tex)
PDFSAGFiles = $(SAGFiles:.tex=.pdf) 
ImageFiles = images/*

default : thesis.pdf

thesis.pdf : thesis.tex $(InputTeXFiles) $(ImageFiles) $(PDFSAGFiles) thesis.sty
	$(PDFLATEX) $<

drawings/ch6-cm-plots.pdf: drawings/ch6-cm-plots.tex thesis.sty
	cd drawings && $(LUALATEX) $(notdir $<) && $(PDFCROP) $(notdir $@) $(notdir $@)

drawings/ch4-feed-spill.pdf: drawings/ch4-feed-spill.tex thesis.sty
	cd drawings && $(PDFLATEX) --enable-write18 $(notdir $<) && $(PDFCROP) $(notdir $@) $(notdir $@)

drawings/%.pdf: drawings/%.tex thesis.sty
	cd drawings && $(PDFLATEX) $(notdir $<) && $(PDFCROP) $(notdir $@) $(notdir $@)

topclean : .PHONY
	$(RM) -f *.aux
	$(RM) -f *.bbl
	$(RM) -f *.blg
	$(RM) -f *.log
	$(RM) -f *.bcf
	$(RM) -f *.toc
	$(RM) -f *.run.xml
	$(RM) -f *.lot
	$(RM) -f *.lof
	$(RM) -f *.synctex.gz
	$(RM) -f *.pdf

clean : topclean
	find . -regex ".*\(aux\|bbl\|blg\|log\|bcf\|synctex\.gz\|fls\|fdb_latexmk\)" -type f -delete
	$(RM) -fr -- drawings/*.pdf

distclean : clean
	$(RM) -f -- thesis.pdf

full: default
	biber thesis
	$(PDFLATEX) thesis.tex
	$(PDFLATEX) thesis.tex

.PHONY :
