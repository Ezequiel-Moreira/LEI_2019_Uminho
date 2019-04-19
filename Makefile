all: example.tex
	pdflatex example.tex;
	pdflatex example.tex;
	evince example.pdf
