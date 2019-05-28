all: apresentação.lhs
	lhs2TeX apresentação.lhs > apresentação.tex && \
	pdflatex apresentação.tex && \
	bibtex apresentação && \
	pdflatex apresentação.tex && \
	pdflatex apresentação.tex 
