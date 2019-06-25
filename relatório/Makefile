all: relatorio.lhs
	lhs2TeX relatorio.lhs > relatorio.tex && \
	pdflatex relatorio.tex && \
	bibtex relatorio && \
	pdflatex relatorio.tex && \
	pdflatex relatorio.tex 
