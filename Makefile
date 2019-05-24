all: slides.lhs
	lhs2TeX slides.lhs > slides.tex && \
	pdflatex slides.tex && \
	bibtex slides && \
	pdflatex slides.tex && \
	pdflatex slides.tex 
