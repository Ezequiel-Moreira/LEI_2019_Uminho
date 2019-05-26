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


\section{Relembrar}


\section{Conceitos base}


\section{Objetivo do documento}


\section{Dedução de instâncias em categorias}


\section{Algoritmo AD generalizado}


\section{Matrizes}


\section{RAD e FAD generalizados}


\section{Scaling up}


\section{bibliografia e links}




\end{document}


