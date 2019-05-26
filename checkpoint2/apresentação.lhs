\documentclass{beamer}

\mode<presentation>
{
  \usetheme{JuanLesPins}

  \setbeamercovered{transparent}
}


\usepackage[english]{babel}
\usepackage[utf8x]{inputenc}
%\usepackage[latin1]{inputenc}

\usepackage{times}
\usepackage[T1]{fontenc}
% Note that the encoding and the font should match. If T1
% does not look nice, try deleting the line with the fontenc.
\usepackage[all]{xy}

\newtheorem{teor}{Theorem}[section]
\newtheorem{coro}{Corollary}[section]
\theoremstyle{definition}
\newtheorem{defi}{Definition}[section]
\theoremstyle{definition}
\newtheorem{exemplo}{example}[section]
\theoremstyle{theorem}
\newtheorem{propo}{Proposicion}[section]
\newtheorem{nota}{Note}[section]
\def\N{\mathbb{N}}
\def\R{\mathbb{R}}
\def\C{\mathbb{C}}
\newcommand{\norm}[1]{\left\lVert#1\right\rVert}

%---------- lhs2tex ---------------------------------
%include polycode.fmt
%format -> = "\rightarrow "
%format ->+ = "\rightarrow^+ "
%format sto = "\multimap "
%format forku = " \Delta "
%format joinu = " \nabla "
%format bigD = "\mathcal{D}"
%format bigDplus = "\mathcal{D}^{+}"
%format bigDsquared = "\mathcal{D}^{2}"
%format bigDplus0 = "\mathcal{D}^{+}_{0}"
%format bigDhat = "\mathcal{\hat{D}}"
%format bigU = "\mathcal{U}"
%format bigV = "\mathcal{V}"
%format Contkr = "Cont^{r}_{k}"
%format Beginkr = "Begin^{r}_{k}"
%format Dualk = " Dual_k "
%format => = "\Rightarrow"
%format Dk = " D_k "
%format >< = " \times "
%format (inv (x)) = x "^{-1}"
%format (der (f)) = "{\cal D}^+ " f
%format (DS (a) (b) (c)) = "{" c "}\times " b "^{" a "}"
%----------------------------------------------------

\newenvironment{slide}[1]{\begin{frame}\frametitle{#1}}{\end{frame}}

\title
{Simple essence of AD}

\author[Artur, Ezequiel, Nelson] 
{Artur \and Ezequiel \and Nelson}

\institute
{Universidade do Minho}

\date
{24 de Maio}

\subject{Talks}

% If you have a file called "university-logo-filename.xxx", where xxx
% is a graphic format that can be processed by latex or pdflatex,
% resp., then you can add a logo as follows:

% \pgfdeclareimage[height=0.5cm]{university-logo}{university-logo-filename}
% \logo{\pgfuseimage{university-logo}}

% Delete this, if you do not want the table of contents to pop up at
% the beginning of each subsection:

\AtBeginSubsection[]
{
  \begin{frame}<beamer>{Outline}
    \tableofcontents[currentsection,currentsubsection]
  \end{frame}
}


% If you wish to uncover everything in a step-wise fashion, uncomment
% the following command: 

%\beamerdefaultoverlayspecification{<+->}


\begin{document}

\begin{frame}
  \titlepage
\end{frame}

\begin{frame}{Index}
  \tableofcontents
\end{frame}


\section{Nota}

ISTO É UM ESBOÇO(por agora)



\section{Relembrar}

\begin{frame}{Relembrar}
Documento estudado: "The simple essence of automatic differentiation"

Objetivo: criar uma formalização genérica do conceito de ML para aprendizagem supervisionada 
\end{frame}





\section{Conceitos base}

\begin{frame}{Definição de |bigD| e conversão em |bigDplus|}
|bigD| - aproximação linear de uma função

\begin{defi}
	Let $f::a \to b$ be a function, where $a$ and $b$ are vectorial spaces that share a common underlying field. The first derivative definition is the following:
	\begin{code} 
	bigD :: (a -> b) -> (a -> (a sto b))
	\end{code}
\end{defi}

|bigDplus| - versão de D com composição eficiente 

\begin{code}
bigDplus :: (a -> b) -> (a -> (b >< (a sto b))) 
bigDplus f a = (f a, bigD f a)
\end{code}

\end{frame}


\begin{frame}{Corolários associados a |bigDplus|}

\begin{block}{Corollary 1.1}
\begin{code}
	bigDplus (g . f) a = let {(b, f') = bigDplus f a; (c, g') = bigDplus g b} 
            in (c, g' . f') 
\end{code}
\end{block}
    
\begin{block}{Corollary 2.1}
\begin{code}
	bigDplus (f >< g) (a, b) = let {(c, f') = bigDplus f a; (d, g') = bigDplus g b} 
            in ((c, d), f' >< g') 
\end{code}
\end{block}
    
\begin{block}{Corollary 3.1}
	For all linear functions  $f$, $\mathcal{D}^{+} \hspace{0.5mm} f = \lambda a \to (fa,\hspace{0.5mm} f)$.
\end{block}

\end{frame}





\section{Objetivo do documento}

\begin{frame}{Objetivo do documento}
Criar uma implementação de |bigDplus| através da transcrição dos seus corolários para teoria de categorias
de modo a obter um algoritmo generalizado para AD.
\end{frame}





\section{Introdução breve a categorias e funtores}

\begin{frame}{Categorias e funtores}

Categoria: conjunto de objetos e morfismos com 2 de base(id e composição) e 2 regras

\begin{itemize}
    \item (C.1)  $id \circ f = f \circ id = f$
    \item (C.2)  $f \circ (g \circ h) = (f \circ g) \circ h$
\end{itemize}


Funtor: mapeia uma categoria noutra, preservando a estrutura

\begin{itemize}
    \item given any object t $\in$ |bigU| there exists an object F t $\in$ |bigV|
    \item given any morphism m :: a |->| b $\in$ |bigU| there exists a morphism F m :: F a |->| F b $\in$ |bigV|
    \item F id ($\in$ |bigU|) = id ($\in$ |bigV|)
    \item F (f $\circ$ g) = F f $\circ$ F g
\end{itemize}

\end{frame}







\section{Dedução de instâncias em categorias}






\section{Algoritmo AD generalizado}






\section{Matrizes}







\section{RAD e FAD generalizados}






\section{Scaling up}






\section{bibliografia e links}




\end{document}


