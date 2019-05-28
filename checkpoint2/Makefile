all: apresentacao.lhs
	lhs2TeX apresentacao.lhs > apresentacao.tex && \
	pdflatex apresentacao.tex && \
	bibtex apresentacao && \
	pdflatex apresentacao.tex && \
	pdflatex apresentacao.tex 
