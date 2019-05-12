all: slides.lhs
	lhs2TeX slides.lhs > slide.tex && \
	pdflatex slides.tex && \
	pdflatex slides.tex && \
	zathura --fork slides.pdf
