\documentclass{beamer}

\mode<presentation>
{
  \usetheme{Singapore}

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
{29 de Maio}

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

\begin{frame}{Relembrar}
Documento estudado: "The simple essence of automatic differentiation"([Elliott 2018]\cite{Elliott:2018})

Objetivo: Estudo e implementação de um algoritmo AD genérico

\end{frame}





\section{Conceitos base}

\begin{frame}{Definição de |bigD| e conversão em |bigDplus|}
|bigD| - aproximação linear de uma função

\begin{block}{Definição}
  Seja $f::a \to b$ uma função onde $a$ e $b$ são espaços vetoriais sobre um corpo comum.
  A primeira definição de derivada é:
	\begin{code} 
	bigD :: (a -> b) -> (a -> (a sto b))
	\end{code}
\end{block}

|bigDplus| - versão de D com composição eficiente 

\begin{code}
bigDplus :: (a -> b) -> (a -> (b >< (a sto b))) 
bigDplus f a = (f a, bigD f a)
\end{code}

\end{frame}

\begin{frame}{Teoremas}

\begin{block}{Teorema 1}
  Sejam $f:: a \to b$ e $g:: b \to c$ duas funções. A derivada da composição $f$ e $g$ é:
	\begin{align*}
	\mathcal{D} \ (g \circ f ) \ a= \mathcal{D} \hspace{0.9mm} g \hspace{1.0mm}  (f \hspace{0.5mm} a)   \hspace{0.6mm} \circ \hspace{0.6mm} \mathcal{D} \hspace{0.6mm} f \ a
	\end{align*}
\end{block}


\begin{block}{Teorema 2}
  Sejam $f:: a \to b$ e $g:: b \to c$ duas funções. A regra de "cross" é a seguinte:
	\begin{align*}
	\mathcal{D} \hspace{0.5mm} (f \boldsymbol{\times} g) \hspace{0.5mm} (a,\hspace{0.2mm} b) = \mathcal{D} \hspace{0.5mm} f \hspace{0.9mm} a \boldsymbol{\times} \mathcal{D} \hspace{0.5mm} g \hspace{0.9mm} b
	\end{align*}
\end{block}


\begin{block}{Teorema 3}
  Para todas as funções lineares $f$, $\mathcal{D} \hspace{0.5mm} f \hspace{0.9mm} a = f $.
\end{block}

\end{frame}


\begin{frame}{Corolários associados a |bigDplus|}

\begin{block}{Corolário 1.1}
\begin{code}
	bigDplus (g . f) a = let {(b, f') = bigDplus f a; (c, g') = bigDplus g b} 
            in (c, g' . f') 
\end{code}
\end{block}
    
\begin{block}{Corolário 2.1}
\begin{code}
	bigDplus (f >< g) (a, b) = let {(c, f') = bigDplus f a; (d, g') = bigDplus g b} 
            in ((c, d), f' >< g') 
\end{code}
\end{block}
    
\begin{block}{Corolário 3.1}
	Para todas as funções lineares $f$, $\mathcal{D}^{+} \hspace{0.5mm} f = \lambda a \to (fa,\hspace{0.5mm} f)$.
\end{block}

\end{frame}





\section{Categorias e funtores}

\begin{frame}{Objetivo}
Criar uma implementação de |bigDplus| através da transcrição dos seus corolários para teoria de categorias
de modo a obter um algoritmo generalizado para AD.
\end{frame}






\begin{frame}{Categorias e funtores}

Categoria: conjunto de objetos e morfismos com duas operações base(id e composição) e 2 regras:
\begin{itemize}
    \item $id \circ f = f \circ id = f$
    \item $f \circ (g \circ h) = (f \circ g) \circ h$
\end{itemize}

\pause

Funtor: mapeia uma categoria noutra, preservando a estrutura
\begin{itemize}
    \item Dado um objeto t $\in$ |bigU| existe um objeto correspondente F t $\in$ |bigV| 
    \item  Dado um morfismo m :: a |->| b $\in$ |bigU| existe um morfismo correspondente F m :: F a |->| F b $\in$ |bigV|
    \item F id ($\in$ |bigU|) = id ($\in$ |bigV|)
    \item F (f $\circ$ g) = F f $\circ$ F g
\end{itemize}

\end{frame}


\begin{frame}{Adaptação de definições}

\begin{block}{Definição de tipo |bigD|}
|newtype bigD a b = bigD (a -> b >< (a sto b))|
\end{block}
\begin{block}{Definição de |bigDhat|}
\begin{code}

bigDhat :: (a -> b) -> bigD a b
bigDhat f = bigD(bigDplus f)

\end{code}
\end{block}


\begin{block}{ Definição de |bigDhat| para funções lineares}
\begin{code}
linearD :: (a -> b) -> bigD a b
linearD f = bigD(\a -> (f a,f))
\end{code}
\end{block}


\end{frame}






\section{Dedução de instâncias}

\begin{frame}{Passos para obter a instância a partir da definição do funtor}

\begin{itemize}
    \item Passo 1 - Assumir que |bigDhat| é funtor de uma instância de |bigD| a determinar
    \item Passo 2 - Substituir pelo que determinamos nos corolários
    \item Passo 3 - Generalizar condições se necessário para obtermos instância
\end{itemize}

\end{frame}



\begin{frame}{Exemplo para categorias}
\begin{block}{Passo 1}

|id = bigDhat id = bigD (bigDplus id)|

|bigDhat g . bigDhat f = bigDhat (g . f) = bigD (bigDhat (g . f))|

\end{block}

\pause

\begin{block}{Passo 2}

|id = bigD (\ a -> (id a,id))|

|bigDhat g . bigDhat f = bigD (\ a -> let{(b,f') = bigDplus f a; (c,g') = bigDplus g b} in (c,g' . f'))|

\end{block}

\pause

\begin{block}{Passo 3}

Para a nossa instância a primeira equação que determinamos serve como definição da identidade.

Para definir a composição generalizamos a condição:

|bigD g . bigD f = bigD (\ a -> let{(b,f') = f a; (c,g') = g b} in (c,g' . f'))|

\end{block}
\end{frame}


\begin{frame}
\begin{block}{Definição da classe de categoria}
\begin{code}
class Category k where
    id::(a'k'a)
    (.)::(b'k'c)->(a'k'b)->(a'k'c)
\end{code}
\end{block}

\begin{block}{Instância deduzida para a categoria}
\begin{code}
instance Category bigD where
    id = linearD id
    bigD g . bigD f = 
    bigD( \a -> let{(b,f') = f a;(c,g') = g b} in (c,g' . f'))
\end{code}
\end{block}
\end{frame}



\begin{frame}
\begin{block}{Definição da classe de categoria monoidal}
\begin{code}
class Category k => Monoidal k where
    (><) :: (a 'k' c) -> (b 'k' d) -> ((a >< b) 'k' (c >< d)) 
\end{code}
\end{block}


\begin{block}{Instância deduzida para a categoria monoidal}
\begin{code}

instance Monoidal bigD where
    bigD f >< bigD g = bigD(\(a,b) -> let{(c,f') = f a;(d,g') = g b} 
                                     in ((c,d),f' >< g'))

\end{code}
\end{block}
\end{frame}




\begin{frame}

\begin{block}{Definição da classe de categoria cartesiana}
\begin{code}
class Monoidal k => Cartesian k where
  exl :: (a,b)'k'a
  exr :: (a,b)'k'b
  dup :: a 'k' (a,a)
\end{code}
\end{block}

\begin{block}{Instância deduzida para a categoria cartesiana}
\begin{code}
instance Cartesian D where
    exl = linearD exl
    exr = linearD exr
    dup = linearD dup
\end{code}
\end{block}

\end{frame}

\begin{frame}
\begin{block}{Definição da classe de categoria cocartesiana}
\begin{code}
class Category k => Cocartesian k where
    inl :: a 'k' (a,b)
    inr :: b 'k' (a,b)
    jam :: (a,a) 'k' a
\end{code}
\end{block}

\pause

\begin{block}{Dedução de|(->+)|}
\hspace*{\fill}
\xymatrix@@R=2mm{
    a \ar[rd] &  \\
      & a+b?\\
    b \ar[ru] &  \\
}
\hspace*{\fill}
\begin{itemize}
\item 
    Queremos uma categoria que os seus objetos tenham adição e seja capaz de multiplicar por constantes (scaling).
\end{itemize}
\end{block}
\end{frame}


\begin{frame}{Instância deduzida para AD genérico}
\begin{block}{Dedução de |Dk|}
\begin{itemize}
\item
    Queremos ter um |Dk| tal que seja o |bigD| mas com uma categoria
de genérica, pois nunca fizemos nada de específico com a |sto|.
\item
    Queremos definir também as operações usuais nesta categoria, como a soma, multiplicação, sin, cos, etc. 
\end{itemize}
\end{block}

\end{frame}







\section{RAD e FAD generalizados}

\begin{frame}{Generalizando RAD e FAD}

Obter RAD e FAD de algoritmo AD genérico: forçar a direção da composição de morfismos

\pause

\begin{block}{Conversão da escrita de morfismos}
|f :: a 'k' b => (. f) :: (b 'k' r) -> (a 'k' r)| para r objeto de categoria k.
\end{block}


\pause

\begin{block}{Definição de novo tipo}
\begin{code}
newtype Contkr a b = Cont((b 'k' r) -> (a 'k' r))
\end{code}
\end{block}

\begin{block}{Funtor derivado dele}
\begin{code}
cont :: Category k => (a 'k' b) -> Contkr a b
cont f = Cont(. f)
\end{code}
\end{block}

\end{frame}


\begin{frame}{Instância deduzida para RAD genérico}
\begin{code}

instance Category k => Category Contkr where
  id = Cont id
  Cont g . Cont f = Cont(f . g)

instance Monoidal k => Monoidal Contkr where
  Conf f >< Cont g = Cont(join . (f >< g) . unjoin)

instance Cartesian k => Cartesian Contkr where
  exl = Cont(join . inl) ; exr = Cont(join . inr) 
  dup = Cont(jam . unjoin)

instance Cocartesian k => Cocartesian Contkr where
  inl = Cont(exl . unjoin) ; inr = Cont(exr . unjoin) 
  jam = Cont(join . dup)

instance Scalable k a => Scalable Contkr a where
  scale s = Cont(scale s)


\end{code}
\end{frame}








\section{Demonstração prática}

\begin{frame}{Demonstração prática}

Demonstração prática

Link do projeto git: [LEI 2019] \cite{LEI:2019}

\end{frame}


\bibliographystyle{acm}%{ACM-Reference-Format}
\bibliography{apresentacao}



\end{document}


