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

\begin{code}

(f x g)(a,b) = (f a,g b)

(f = undefined)
\end{code}


\begin{slide}{Instance of |->+|}
\begin{code}


newtype a ->+ b=AddFun(a->b)

instance Category (->+) where
   type Obj (->+) = Additive
   id = AddFun id
   AddFun g . AddFun f = AddFun (g . f )

instance Monoidal (->+) where
   AddFun f × AddFun g = AddFun (f × g)

instance Cartesian (->+) where
   exl = AddFun exl
   exr = AddFun exr
   dup = AddFun dup
\end{code}
\end{slide}

\begin{slide}{Fork and Join}
    \begin{itemize}
        \item
            |fork :: Cartesian k => (a 'k' c) -> (a 'k' d) -> (a 'k' (c × d))|
        \item
            |join :: Cartesian k => (c 'k' a) -> (d 'k' a) -> ((c + d) 'k' a)|
    \end{itemize}
\end{slide}

\begin{frame}
  \titlepage
\end{frame}

\begin{frame}{Indice}
  \tableofcontents
\end{frame}

% - Exactly two or three sections (other than the summary).
% - At *most* three subsections per section.
% - Talk about 30s to 2min per frame. So there should be between about
%   15 and 30 frames, all told.




















\section{Ezequiel}


\section{Categorias}

\begin{frame}{A short introdution}
\begin{itemize}
 \item<1-> We want to calculate |bigD|.
 \item<2-> However, |bigD| is not computable.
 \item<3-> Solution: reimplement corollaries using category teory
\end{itemize}

\end{frame}



\begin{frame}{A short introdution}

    \begin{block}{Corollary 1.1}
    NOTA: adicionar definição do corolário 1.1 aqui
    \end{block}
    
    \begin{block}{Corollary 2.1}
    NOTA: adicionar definição do corolário 2.1 aqui
    \end{block}
    
    \begin{block}{Corollary 3.1}
    NOTA: adicionar definição do corolário 3.1 aqui
    \end{block}
 
\end{frame}




\begin{frame}{Categories}

A category is a collection of objects(sets and types) e morphisms(operation between objects),
with 2 basic operations(identity and composition) of morfisms, and 2 laws:

\begin{itemize}
    \item (C.1)  $id \circ f = id \circ f = f$
    \item (C.2)  $f \circ (g \circ h) = (f \circ g) \circ h$
\end{itemize}

\begin{block}
Note: for this paper, objects are data types and morfisms are functions
\end{block}

\begin{columns}
\begin{column}{0.5\textwidth}
\begin{code}
class Category k where
    id :: (a'k'a)
    (.) :: (b'k'c) -> (a'k'b) -> (a'k'c)
\end{code}
\end{column}

\begin{column}{0.5\textwidth}
\begin{code}
instance Category (->) where
    id = \a -> a 
    g . f = \a -> g (f a)  
\end{code}
\end{column}
\end{columns}
\end{frame}




\begin{frame}{Functors}

A functor F between 2 categories |bigU and bigV| is such that:
\begin{itemize}
    \item given any object |t \in bigU| there exists a object |F t \in bigV|
    \item given any morphism |m :: a -> b \in bigU| there exists a morphism |F m :: F a -> F b \in bigV|
    \item |F id (\in bigU) = id (\in bigV)| 
    \item |F (f $\circ$ g) = F f $\circ$ F g|
\end{itemize}

\begin{block}{Note}
Given this papers category properties(objects are data types) we have that functors map types to themselfs
\end{block}

\end{frame}



\begin{frame}{Objective}

Let's start by defining a new data type:

|newtype bigD a b = bigD (a -> b x (a $\multimap$ b))|

and adapting |bigDplus| to use it:

\begin{block}{Adapted definition}
\begin{code}

bigDhat :: (a -> b) -> bigD a b
bigDhat f = bigD(bigDplus f)

\end{code}
\end{block}

Our objective is to deduce an instance of Category for |bigD where bigDhat| is a functor.

\end{frame}




\begin{frame}{Instance deduction}

Using corollaries 3.1 and 1.1 we deduce that

\begin{itemize}
    \item (DP.1) |---- bigDplus id = $\lambda$ a -> (id a,id)|
    \item (DP.2) ----    
    |bigDplus(g $\circ$ f) = $\lambda$ a -> let{(b,f') = bigDplus f a; (c,g') = bigDplus g b } in (c,g' $\circ$ f')|   
\end{itemize}
|saying that bigDhat a functor is equivalent to, for all f e g functions of correct types:|

    |id = bigDhat id = bigD (bigDplus id)|
    |bigDhat g $\circ$ bigDhat f = bigDhat  (g $\circ$ f) = bigD (bigDhat (g $\circ$ f))|


\end{frame}



\begin{frame}{Instance deduction}

Based on  (DP.1) e (DP.2) we'll rewrite the above into the following defenition:

    |id = bigD ($\lambda$ a -> (id a,id))|
    |bidDhat g $\circ$ bigDhat f = bigD ($\lambda$ a -> let{(b,f') = bigDplus f a; (c,g') = bigDplus g b} in (c,g' $\circ$ f'))|


The first equasion has a trivial solution(define id of instance as |bigD($\lambda$ a -> (id a,id))|)

To solve the secound we'll first solve a more general one:
|bigD g $\circ$ bigD f = bigD($\lambda$ a -> let{(b,f') = f a; (c,g') = g b \} in(c,g' $\circ$ f'))|
, and this has an equivalently trivial solution in our instance.

\end{frame}





\begin{frame}{Instance deduction}

\begin{block}{ |bigDhat| definition for linear functions}
\begin{code}
linearD :: (a -> b) -> bigD a b
linearD f = bigD(\a -> (f a,f))
\end{code}
\end{block}s

\begin{block}{Categorical instance we've deduced}
\begin{code}
instance Category bigD where
    id = linearD id
    bigD g . bigD f = bigD( \a -> let{(b,f') = f a;(c,g') = g b} in (c,g' . f'))
\end{code}
\end{block}
\end{frame}




\begin{frame}{Instance proof}

In order to prove that the instance is correct we must observe if it follows laws (C.1) and (C.2).

First we must make a concession: that we only use morfisms arising from |bigDplus|(we can force this by transforming |bigD| into an abstract type).
If we do, then |bigDplus| is a functor.


\begin{block}{(C.1) proof}

|id $\circ$ bigDhat|
|= bigDhat id $\circ$ bigDhat f - functor law for id (specification of bigDhat)|
|= bigDhat (id $\circ$ f) - functor law for ($\circ$)|
|= bigDhat f - cathegorical law|
\end{block}

\end{frame}


\begin{frame}{Instance proof}

\begin{block}{(C.2) proof}

|bigDhat h $\circ$ (bigDhat g $\circ$ bigDhat f)|
|= bigDhat h $\circ$ bigDhat (g $\circ$ f) - functor law for ($\circ$)|
|= bigDhat (h $\circ$ (g $\circ$ f)) - functor law for ($\circ$)|
|= bigDhat ((h $\circ$ g) $\circ$ f) - categorical law|
|= bigDhat (h $\circ$ g) $\circ$ bigDhat f - functor law for ($\circ$)|
|= (bigDhat h $\circ$ bigDhat g) $\circ$ bigDhat f - functor law for ($\circ$)|

\end{block}

\begin{alertblock}{Note}
This proofs don't require anything from |bigD and bigDhat| aside from functor laws.
As such, all other instances of categories created from a functor won't require further proofs.

\end{alertblock}
\end{frame}





\begin{frame}{Monoidal categories and functors}

Generalized parallel composition will be defined using a monoidal category:


\begin{columns}
\begin{column}{0.5\textwidth}
\begin{code}


class Category k => Monoidal k where
    (x) :: (a 'k' c) -> (b 'k' d) -> ((a x b) 'k' (c x d)) 

\end{code}
\end{column}
\begin{column}{0.4\textwidth}
\begin{code}

instance Monoidal (->) where
    f x g = \(a,b) -> (f a,g b)

\end{code}
\end{column}
\end{columns}


\begin{block}{Monoidal Functor definition}

A monoidal functor F between categories |bigU and bigV| is such that:
\begin{itemize}
    \item F is a functor
    \item F (f |$\times$| g) = F f |$\times$| F g
\end{itemize}
\end{block}
\end{frame}


\begin{frame}{Instance deduction}

From corollary 2.1 we can deduce that:
|bigDplus (f $\times$ g) = $\lambda$ (a,b) -> let{(c,f')=bigDplus f a;(d,g')= bigDplus g b} in ((c,d),f' $\times$ g')|

Defining F from |bigDhat| leaves us with the following definition:

|bigD (bigDplus f) $\times$ bigD (bigDplus g) = bigD (bigDplus (f $\times$ g))|

Using the same method as before, we replace |bigDplus| with it's definition and generalize the condition:

|bigD f $\times$ bigD g = bigD ($\lambda$ (a,b) -> let{(c,f') = f a; (d,g') = g b} in ((c,d),f' $\times$ g'))|

and this is enouth for our new instance.
\end{frame}



\begin{frame}{Instance deduction}
\begin{block}{Categorical instance we've deduced}
\begin{code}

instance Monoidal bigD where
    bigD f x bigD g = bigD(\(a,b) -> let{(c,f') = f a;(d,g') = g b} in ((c,d),f' x g'))

\end{code}
\end{block}
\end{frame}




\begin{frame}{Cartesian categories and functors}
\begin{columns}
\begin{column}{0.5\textwidth}
\begin{code}

class Monoidal k => Cartesean k where
    exl :: (a,b)'k'a
    exr :: (a,b)'k'b
    dup :: a'k'(a,a)

\end{code}
\end{column}
\begin{column}{0.4\textwidth}
\begin{code}

instance Cartesean (->) where
    exl = \(a,b) -> a
    exr = \(a,b) -> b
    dup = \a -> (a,a)

\end{code}
\end{column}
\end{columns}


\begin{block}

A cartesian functor F between categories |bigU and bigV| is such that:

\begin{itemize}
    \item F is a monoidal functor
    \item F exl = exl
    \item F exp = exp
    \item F dup = dup
\end{itemize}
\end{block}
\end{frame}




\begin{frame}{Instance deduction}

From corollary 3.1 and from exl,exr and dup beeing linear function we can deduce that:

|bigDplus exl \p -> (exl p,exl)|
|bigDplus exr \p -> (exr p,exr)|
|bigDplus dup \p -> (dup a,dup)|


With this in mind we'll deduce the instance:
    exl = |bigD(bigDplus exl)|
    exr = |bigD(bigDplus exr)|
    dup = |bigD(bigDplus dup)|

\end{frame}



\begin{frame}{Instance deduction} 

Replacing |bigDplus| with it's definition and remembering linearD we can obtain:

exl = linearD exl
exr = linearD exr
dup = linearD dup

and we can directly convert this into a new instance:

\begin{block}{Categorical instance we've deduced}
\begin{code}

instance Cartesian D where
    exl = linearD exl
    exr = linearD exr
    dup = linearD dup

\end{code}
\end{block}
\end{frame}



\begin{frame}{Cocartesian category}

This type of categories are the dual of the cartesian categories.

\begin{block}{Note}
In this paper coproducts are categorical products, i.e., biproducts
\end{block}

\begin{block}{Definition}
\begin{code}

class Category k => Cocartesian k where:
    inl :: a'k'(a,b)
    inr :: b'k'(a,b)
    jam :: (a,a)'k'a

\end{code}
\end{block}
\end{frame}



\begin{frame}{Cocartesian functors}

\begin{block}{Cocartesian functor definition}

A cocartesian functor F between categories |bigU and bigV| is such that:
\begin{itemize}
    \item F is a functor
    \item F inl = inl
    \item F inr = inr
    \item F jam = jam
\end{itemize}
\end{block}
\end{frame}



\end{document}

