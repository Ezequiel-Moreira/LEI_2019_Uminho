\documentclass{beamer}

\mode<presentation>
{
  \usetheme{Warsaw}

  \setbeamercovered{transparent}
}


\usepackage[english]{babel}
\usepackage[utf8x]{inputenc}
%\usepackage[latin1]{inputenc}

\usepackage{times}
\usepackage[T1]{fontenc}
% Note that the encoding and the font should match. If T1
% does not look nice, try deleting the line with the fontenc.

%---------- lhs2tex ---------------------------------
%include polycode.fmt
%format -> = "\rightarrow "
%format ->+ = "\rightarrow^+ "
%format join = " \bigtriangleup "
%format fork = " \bigtriangledown "
%format bigD = "\mathcal{D}"
%format bigDplus = "\mathcal{D}^{+}"
%format bigDhat = "\mathcal{\hat{D}}"
%format bigU = "\mathcal{U}"
%format bigV = "\mathcal{V}"
%format => = "\Rightarrow"
%----------------------------------------------------

\newenvironment{slide}[1]{\begin{frame}\frametitle{#1}}{\end{frame}}

\title
{...Machine Learning...}

\author[Artur, Ezequiel, Nelson] 
{Artur \and Ezequiel \and Nelson}

\institute
{Universidade do Minho}

\date
{26 de Abril}

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




\section{Ezequiel 2}




\section{Reverse-Mode Automatic Differentiation(RAD)}
\begin{frame}{Esboço}

O algoritmo AD que derivamos nas categorias(capitulo 4) e cuja instância se encontra generalizada na
figura 6 do documento pode ser visto como familia de algoritmos que pode tomar forma de FAD caso usemos
apenas composição à direita ou de RAD caso usemos apenas composição à esquerda(podendo tomar outras formas
se não usarmos exclusivamente uma composição, mas não nos interressa muito isso para este papel).

Sabendo que queremos definir RAD e sabendo o que temos do parágrafo anterior uma pergunta aparece:
como forçar a composição à esquerda?

Dada uma qualquer categoria k podemos representar os seus morfismos de forma a indicar
que queremos compor à esquerda com um morfismo h que ainda iremos definir.

Para tal um morfismo f :: a 'k' b é representado pela função |(\circ f) :: (b 'k' r) -> (a 'k' r)|,
com r objeto em k.

Ao morfismo h chamaremos continuação de f, e a construção de uma categoria à volta desta ideia
permite-nos garantir a propriedade que queremos: todas as composições são feitas à esquerda.

Nesta instância de categoria as composições na computação transformam-se em computações na continuação.
Por exemplo, |g \circ f| com continuação k (|k \circ (g \circ f)|) transforma-se em f com continuação
|g \circ g| ((k \circ g) \circ f).

Nota: a composição inicial para qualquer morfismo é id (|id \circ f =  id|)

Usando a mesma ideia estabelecida no capitulo 4 criamos um novo tipo de dados e geramos a categoria associada:

|newtype Cont_{k}^{r} a b = Cont((b 'k' r) -> (a 'k' r))|

\begin{code}
cont :: Category k => (a 'k' b) -> Cont_{k}^{r} a b
cont f = Cont(\circ f)
\end{code}

e derivamos uma instância(ver figura 7), provando que cont é homomorfismo nessa derivação.



\end{frame}




\section{Gradient and Duality}
\begin{frame}{Esboço}

Continuando da secção anterior vamos falar de um caso especial de RAD: computação de gradientes.

Dado um espeço vetorial A sobre um campo escalar s o dual de A é A \multimap s(mapas lineares para o campo s).
Como este espaço dual também é vetorial e A é finito concluimos que tanto o dual como o primal são isomorfos.

Em particular, cada mapa de A \multimap s pode ser exprimido na forma dot u para u :: A onde:

|class HasDot^{S} u where dot :: u -> (u \multimap s)|
|instance HasDot^{IR} where dot=scale|
||


\end{frame}




\section{Foward-Mode Automatic Differentiation(FAD)}
\begin{frame}{Esboço}




\end{frame}














\end{document}


