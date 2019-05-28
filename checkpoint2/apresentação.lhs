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

\begin{frame}{Relembrar}
Documento estudado: "The simple essence of automatic differentiation"

Objetivo: criar uma formalização genérica do conceito de ML para aprendizagem supervisionada 
\end{frame}





\section{Conceitos base}

\begin{frame}{Definição de |bigD| e conversão em |bigDplus|}
|bigD| - aproximação linear de uma função

\begin{defi}
  Let $f::a \to b$ be a function, where $a$ and $b$ are vectorial spaces that share a common underlying field. 
  The first derivative definition is the following:
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





\section{Objetivo}

\begin{frame}{Objetivo}
Criar uma implementação de |bigDplus| através da transcrição dos seus corolários para teoria de categorias
de modo a obter um algoritmo generalizado para AD.
\end{frame}





\section{Introdução breve a categorias e funtores}

\begin{frame}{Categorias e funtores}

Categoria: conjunto de objetos e morfismos com duas operações base(id e composição) e 2 regras:
\begin{itemize}
    \item $id \circ f = f \circ id = f$
    \item $f \circ (g \circ h) = (f \circ g) \circ h$
\end{itemize}


Funtor: mapeia uma categoria noutra, preservando a estrutura
\begin{itemize}
    \item Dado um objeto t $\in$ |bigU| existe um objeto correspondente F t $\in$ |bigV| 
    \item  Dado um morfismo m :: a |->| b $\in$ |bigU| existe um morfismo correspondente F m :: F a |->| F b $\in$ |bigV|
    \item F id ($\in$ |bigU|) = id ($\in$ |bigV|)
    \item F (f $\circ$ g) = F f $\circ$ F g
\end{itemize}

\end{frame}


\section{Adaptação de definições}

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






\section{Dedução de instâncias em categorias}

\begin{frame}{Passos para obter a instância a partir da definição do funtor}

\begin{itemize}
    \item Passo 1 - Assumir que |bigDhat| é funtor de uma instância de |bigD| a determinar
    \item Passo 2 - Substituir pelo que determinamos nos corolários
    \item Passo 3 - Generalizar condições se necessário para obtermos instância
\end{itemize}

Este processo é o mesmo para vários tipos de categorias.

\end{frame}



\begin{frame}{Exemplo para categorias}
\begin{block}{Passo 1}

|id = bigDhat id = bigD (bigDplus id)|

|bigDhat g . bigDhat f = bigDhat (g . f) = bigD (bigDhat (g . f))|

\end{block}


\begin{block}{Passo 2}

|id = bigD (\ a -> (id a,id))|

|bigDhat g . bigDhat f = bigD (\ a -> let{(b,f') = bigDplus f a; (c,g') = bigDplus g b} in (c,g' . f'))|

\end{block}

\begin{block}{Passo 3}

Para a nossa instância a primeira equação que determinamos serve como definição da identidade.

Para definir a composição generalizamos a condição:

|bigD g . bigD f = bigD (\ a -> let{(b,f') = f a; (c,g') = g b} in (c,g' . f'))|

\end{block}
\end{frame}


\section{Instâncias deduzidas}
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
\end{frame}



\begin{frame}{Instâncias que deduzimos - caso |(->+)|}
\begin{code}
newtype a ->+ b=AddFun(a->b)

instance Category (->+) where
   type Obj (->+) = Additive
   id = AddFun id
   AddFun g . AddFun f = AddFun (g . f )

instance Monoidal (->+) where
   AddFun f >< AddFun g = AddFun (f >< g)

instance Cartesian (->+) where
   exl = AddFun exl
   exr = AddFun exr
   dup = AddFun dup
\end{code}
\end{frame}

\begin{frame}{Instâncias que deduzimos - caso |(->+)|}
\begin{code}
instance Cocartesian (->+) where
  inl = AddFun inlF
  inr = AddFun inrF
  jam = AddFun jamF

inlF :: Additive b => a -> a >< b
inrF :: Additive a => b -> a >< b
jamF :: Additive a => a >< a -> a

inlF = \a -> (a, 0)
inrF = \b -> (0, b)
jamF = \(a, b) -> a + b

\end{code}
\end{frame}








\section{Algoritmo AD generalizado}

\begin{frame}{Instância deduzida para AD genérico}
\begin{code}
    newtype Dk a b = D (a -> b >< (a ‘k‘ b))

    linearD :: (a -> b) -> (a ‘k‘ b) -> Dk a b
    linearD f f'= D (\a -> (f a, f'))

    instance Category k => Category Dk where
        type Obj Dk = Additive ∧ Obj k ...
     
    instance Monoidal k => Monoidal Dk where ...
     
    instance Cartesian k => Cartesian Dk where ...
     
    instance Cocartesian k => Cocartesian Dk where
        inl = linearD inlF inl
        inr = linearD inrF inr
        jam = linearD jamF jam
     
\end{code}

\end{frame}
\begin{frame}{Generalização de AD}
\begin{code}
    instance Scalable k s ⇒ NumCat Dk s where
        negateC = linearD negateC negateC
        addC = linearD addC addC
        mulC = D (\(a, b) -> (a * b, scale b joinu scale a))
\end{code}
\end{frame}







\section{RAD e FAD generalizados}

\begin{frame}{Generalizando RAD e FAD}

Obter FAD e RAD de algoritmo AD genérico: forçar a direção da composição de morfismos

\begin{block}{Conversão da escrita de funções}
|f :: a 'k' b => (. f) :: (b 'k' r) -> (a 'k' r)| para r objeto de categoria k.
\end{block}

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








\section{Scaling up}

...





\section{Bibliografia}

...



\end{document}


