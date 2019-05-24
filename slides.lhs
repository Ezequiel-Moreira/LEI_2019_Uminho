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

\begin{frame}
  \titlepage
\end{frame}

\begin{frame}{Index}
  \tableofcontents
\end{frame}

% - Exactly two or three sections (other than the summary).
% - At *most* three subsections per section.
% - Talk about 30s to 2min per frame. So there should be between about
%   15 and 30 frames, all told.

%Ne1

\begin{frame}
\frametitle{Definition of Derivative}
\vspace{5mm}

\begin{defi}
		Let $f:\R \to \R$ be a function. The derivative of $f$ at point $x \in \R$ is defined the following way:
	\begin{align*}
	\textit{$f $$'$ $(x)$} = \ \lim_{\varepsilon \to 0} \frac{\textit{$f$($x$ $+$ $\varepsilon$) - $f(x)$}}{\varepsilon}
	\end{align*}
\end{defi}
\vspace{5mm}
\pause
This definition will also work with functions of types $\C \hspace{0.5mm}\to \C$ and $\R\hspace{0.6mm} \to \R^{n}$.

\end{frame}
%%%
\begin{frame}
\frametitle{Definition of Derivative}
\vspace{10mm}
For functions $F$ of types $\R^{m}\hspace{-0.3mm} \to \R$ and $\R^{m}\hspace{-0.3mm}\to \R^{n}$ (with $n>1$), we need a different definition.
\pause
\vspace{1mm}
    \begin{itemize}
    \item  For functions of type $\R^{m}\hspace{-0.3mm} \to \R$, it is necessary the introduction of the notion of parcial derivatives, $\frac{\partial F}{\partial x_{j}}\hspace{0.3mm}$, with $j \in$ \{$1,...,m$\}.
    
    \pause
    \vspace{3mm}
    \item For functions of type $\R^{m}\hspace{-0.3mm}\to \R^{n}$ (with $n>1$), apart from the use of parcial derivatives, it is necessary the use of Jacobian matrices $\mathbf{J}_{i,j} =\frac{\partial F_{i}}{\partial x_{j}}$, where $i \in$ \{$1,...,n$\} and $F_{i}$ is a function $\R^{m}\hspace{-0.3mm}\to \R$.
    \end{itemize} 
\end{frame}
%%%
\begin{frame}
\frametitle{Generalization and Chain Rule}
\vspace{15mm}
Let $\mathbf{A}$ and $\mathbf{B}$ be two Jacobian matrices. 

The chain rule in $\R^{m}\hspace{-0.3mm}\to \R^{n}$ is:
\begin{align*}
(\mathbf{A} \cdotp \mathbf{B})_{i,j}= \sum_{k=1}^{m} \mathbf{A}_{i,k} \cdotp \mathbf{B}_{k,j}
\end{align*}
\end{frame}
%%%
\begin{frame}
\frametitle{Generalization and Chain Rule}
\vspace{15mm}
Assuming that the notion of derivatives that we need matches with a linear map, where it is accepted the chain rule previously seen, we will define a new generalization:
\pause

\begin{align*}
\hspace{-2mm} \lim_{\varepsilon \to 0} \frac{\textit{$f$($x$ $+$ $\varepsilon$) - $f(x)$}}{\varepsilon} - \textit{$f $$'$ $(x)$} = 0 \hspace{0.5mm} 
\Leftrightarrow \hspace{0.5mm} \lim_{\varepsilon \to 0} \frac{\textit{$f$($x$ $+$ $\varepsilon$) - ($f(x)$)} + \varepsilon \cdotp \textit{$f $$'$ $(x)$}}{\varepsilon} = 0 \\
& 
\hspace{-6.6cm}  \Leftrightarrow  
\lim_{\varepsilon \to 0} 
\frac{
\norm{ \textit{$f$($x$ $+$ $\varepsilon$) - ($f(x)$)} + \varepsilon \cdotp \textit{$f'(x)$} } 
}{
\norm{ \varepsilon }
} 
= 0
\end{align*}

\end{frame}
%%%
\begin{frame}
\begin{center}
	\frametitle{Derivate as a linear map} 
\end{center}
\begin{defi}
	Let $f::a \to b$ be a function, where $a$ and $b$ are vectorial spaces that share a common underlying field. The first derivative definition is the following:
	\begin{code} 
	bigD :: (a -> b) -> (a -> (a sto b))
	\end{code}
    If we differentiate two times, we have:
    \begin{code} 
     bigDsquared = bigD . bigD :: (a -> b) -> (a -> (a sto a sto b ))
    \end{code}
\end{defi}

\end{frame}

\begin{frame}
\frametitle{Rules for Differentiation - Sequential Composition}
\vspace{15mm}
\begin{teor}
	
	Let $f:: a \to b$ and $g:: b \to c$ be two functions. Then the derivative of the composition of $f$ and $g$ is:
	\begin{align*}
	\mathcal{D} \ (g \circ f ) \ a= \mathcal{D} \hspace{0.9mm} g \hspace{1.0mm}  (f \hspace{0.5mm} a)   \hspace{0.6mm} \circ \hspace{0.6mm} \mathcal{D} \hspace{0.6mm} f \ a
	\end{align*}
\end{teor}
\end{frame}
\begin{frame}
\frametitle{Rules for Differentiation - Sequential Composition}
Unfortunately the previous theorem isn't a efficient recipe for composition. As such we will introduce a second derivative definition:
\begin{code}
bigDplus0 :: (a -> b) -> ((a -> b) >< (a -> (a sto b))) 
bigDplus0 f = (f, bigD f)
\end{code}
\pause

With this, the chain rule will have the following expression:

$\mathcal{D}_{0}^{+} \hspace{0.5mm} (g \circ f) $ 

\{definition of $\mathcal{D}_{0}^{+}$\}\\
$= (g \circ f,\hspace{0.2mm} \mathcal{D} \hspace{0.5mm} (g \circ f) \hspace{0.5mm})$ \hspace{3.3cm} \\
\{theorem and definition of $g \circ f$\}\\

$= (\lambda a \to g (f \hspace{0.5mm} a),\hspace{0.2mm} \lambda a \to \mathcal{D} \hspace{0.9mm} g \hspace{1.0mm}  (f \hspace{0.5mm} a)   \hspace{0.5mm} \circ \hspace{0.5mm} \mathcal{D} \hspace{0.5mm} f \hspace{0.5mm} a )$ \hspace{1.5mm} \\
\end{frame}
\begin{frame}
\frametitle{Rules for Differentiation - Sequential Composition} 
Having in mind optimizations, we introduce the third and last derivative definition:
\begin{code}
bigDplus :: (a -> b) -> (a -> (b >< (a sto b))) 
bigDplus f a = (f a, bigD f a)
\end{code}
\pause

As $\times$ has more priority than $\to$ and $\multimap$, we can rewrite $\mathcal{D}^{+} $ as:
\begin{code}
bigDplus :: (a -> b) -> (a -> b >< (a sto b)) 
bigDplus f a = (f a, bigD f a)
\end{code}
\end{frame}

\begin{frame}
\frametitle{Rules for Differentiation - Sequential Composition} 
\begin{coro}
	$\mathcal{D}^{+}$ is efficiently compositional in relation to $(\circ)$, that is, in Haskell:
	\begin{code}
	bigDplus (g . f) a = let {(b, f') = bigDplus f a; (c, g') = bigDplus g b} 
            in (c, g' . f') 
	\end{code}
\end{coro}
\vspace{-3mm}

\begin{eqnarray*}
\xymatrix@@C=4em{
  |DS A B ((DS B C C))|
      \ar[d]_-{|(id >< (uncurry (.))) . assocr|}
&
  |DS A B B|
      \ar[l]_-{|der g >< id|}
&
  |A|
      \ar[l]_-{|der f|}
      \ar[dll]^-{|der((g.f))|}
\\
  |DS A C C|
}
\end{eqnarray*}
\end{frame}

\begin{frame}
\frametitle{Rules for Differentiation - Parallel Composition} 
\vspace{10mm}
Another important way of combining functions is the operation cross, that combines two functions in parallel:
\begin{code}
(><) :: (a -> c) -> (b -> d) -> (a >< b -> c >< d) 
f >< g = \(a, b) -> (f a,g b) 
\end{code}
\pause
\begin{teor}	
	Let $f :: a \to c$ and $g :: b \to d$ be two function. Then the cross rule is the following:
	\begin{align*}
	\mathcal{D} \hspace{0.5mm} (f \boldsymbol{\times} g) \hspace{0.5mm} (a,\hspace{0.2mm} b) = \mathcal{D} \hspace{0.5mm} f \hspace{0.9mm} a \boldsymbol{\times} \mathcal{D} \hspace{0.5mm} g \hspace{0.9mm} b
	\end{align*}
\end{teor}
\end{frame}
%%%
\begin{frame}
\frametitle{Rules for Differentiation - Parallel Composition} 
\vspace{15mm}
\begin{coro}
	The function $\mathcal{D}^{+}$ is compositional in relation to $(\boldsymbol{\times})$
\begin{code}
	bigDplus (f >< g) (a, b) = let {(c, f') = bigDplus f a; (d, g') = bigDplus g b} 
            in ((c, d), f' >< g') 
\end{code}
\end{coro}
\end{frame}
%%%
\begin{frame}
\frametitle{Derivative and Linear Functions} 
\vspace{5mm}
\begin{defi}
	A function $f$ is said to be linear when preserves addition and scalar multiplication.
	\vspace{2mm}
	
	\hspace{5mm} $f(a + a')= f \hspace{0.5mm} a + f \hspace{0.5mm} a'$
	
	\vspace{1mm}
	\hspace{5mm} $f(s \cdot a)= s \cdot f \hspace{0.5mm} a$

\end{defi}
\pause
\vspace{4mm}
\begin{teor}
	For all linear functions $f$, $\mathcal{D} \hspace{0.5mm} f \hspace{0.9mm} a = f $.
\end{teor}
\pause
\vspace{2mm}
\begin{coro}
	For all linear functions  $f$, $\mathcal{D}^{+} \hspace{0.5mm} f = \lambda a \to (fa,\hspace{0.5mm} f)$.

\end{coro}
\end{frame}

%Ez1
\section{Categories}

\begin{frame}{A short introdution}
\begin{itemize}
 \item<1-> We want to calculate |bigDplus|.
 \item<2-> However, |bigD| is not computable.
 \item<3-> Solution: reimplement corollaries using category theory
\end{itemize}

\end{frame}



\begin{frame}{A short introdution}

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




\begin{frame}{Categories}

A category is a collection of objects (sets and types) and morphisms(operation between objects),
with 2 basic operations (identity and composition) of morfisms, and 2 laws:

\begin{itemize}
    \item (C.1)  $id \circ f = f \circ id = f$
    \item (C.2)  $f \circ (g \circ h) = (f \circ g) \circ h$
\end{itemize}

\begin{block}{Note}
For this paper, objects are data types and morfisms are functions
\end{block}

\begin{columns}
\begin{column}{0.6\textwidth}
\begin{code}
class Category k where
    id::(a'k'a)
    (.)::(b'k'c)->(a'k'b)->(a'k'c)
\end{code}
\end{column}

\begin{column}{0.6\textwidth}
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
    \item given any object t $\in$ |bigU| there exists an object F t $\in$ |bigV|
    \item given any morphism m :: a |->| b $\in$ |bigU| there exists a morphism F m :: F a |->| F b $\in$ |bigV|
    \item F id ($\in$ |bigU|) = id ($\in$ |bigV|)
    \item F (f $\circ$ g) = F f $\circ$ F g
\end{itemize}

\begin{block}{Note}
Given this papers category properties (objects are data types) functors map types to themselves
\end{block}

\end{frame}



\begin{frame}{Objective}
\begin{block}{|bigD| definition}
|newtype bigD a b = bigD (a -> b >< (a sto b))|
\end{block}
\begin{block}{Adapted definition for |bigD| type}
\begin{code}

bigDhat :: (a -> b) -> bigD a b
bigDhat f = bigD(bigDplus f)

\end{code}
\end{block}

Our objective is to deduce an instance of a Category for |bigD| where |bigDhat| is a functor.

\end{frame}




\begin{frame}{Instance deduction}

Using corollaries 3.1 and 1.1 we can determine that

\begin{itemize}
    \item (DP.1) |bigDplus id = \ a -> (id a,id)|
    \item (DP.2)    
\begin{code}
    bigDplus (g . f) = \ a -> let{(b,f') = bigDplus f a; (c,g') = bigDplus g b } 
        in (c,g' . f')
\end{code}
\end{itemize}

Saying that |bigDhat| is a functor is equivalent to, for all f and g functions of apropriate types:

    |id = bigDhat id = bigD (bigDplus id)|

    |bigDhat g . bigDhat f = bigDhat (g . f) = bigD (bigDhat (g . f))|


\end{frame}



\begin{frame}{Instance deduction}

Based on  (DP.1) and (DP.2) we'll rewrite the above into the following definition:

|id = bigD (\ a -> (id a,id))|

|bigDhat g . bigDhat f = bigD (\ a -> let{(b,f') = bigDplus f a; (c,g') = bigDplus g b} in (c,g' . f'))|
\vspace{5mm}

\pause
The first equation shown above has a trivial solution.
\vspace{3mm}

\pause
To solve the second we'll first solve a more general one:

|bigD g . bigD f = bigD (\ a -> let{(b,f') = f a; (c,g') = g b} in (c,g' . f'))|

This condition also leads us to a trivial solution inside our instance.

\end{frame}





\begin{frame}{Instance deduction}

\begin{block}{ |bigDhat| definition for linear functions}
\begin{code}
linearD :: (a -> b) -> bigD a b
linearD f = bigD(\a -> (f a,f))
\end{code}
\end{block}


\begin{block}{Categorical instance we've deduced}
\begin{code}
instance Category bigD where
    id = linearD id
    bigD g . bigD f = 
    bigD( \a -> let{(b,f') = f a;(c,g') = g b} in (c,g' . f'))
\end{code}
\end{block}
\end{frame}




\begin{frame}{Instance proof}

In order to prove that the instance is correct we must check if it follows laws (C.1) and (C.2).

First we must make a concession: that we only use morfisms arising from |bigDplus|.
If we do, then |bigDplus| is a functor.


\begin{block}{(C.1) proof}

id $\circ$ |bigDhat| f \\
\{ functor law for id (specification of |bigDhat|) \}\\
= |bigDhat| id $\circ$ |bigDhat| f \\
\{ functor law for ($\circ$) \}\\
= |bigDhat| (id $\circ$ f) \\
\{ categorical law \}\\
= |bigDhat| f 
\end{block}

\end{frame}


\begin{frame}{Instance proof}

\begin{block}{(C.2) proof}

|bigDhat| h $\circ$ (|bigDhat| g $\circ$ |bigDhat| f)\\
\{ 2x functor law for ($\circ$) \}\\
= |bigDhat| (h $\circ$ (g $\circ$ f))\\ 
\{ categorical law \}\\
= |bigDhat| ((h $\circ$ g) $\circ$ f)\\
\{ 2x functor law for ($\circ$) \}\\
= (|bigDhat| h $\circ$ |bigDhat| g) $\circ$ |bigDhat| f 

\end{block}

\begin{alertblock}{Note}
This proofs don't require anything from |bigD and bigDhat| aside from functor laws.
As such, all other instances of categories created from a functor won't require further proving like this one did.

\end{alertblock}
\end{frame}

\begin{frame}{Monoidal categories and functors}

Generalized parallel composition shall be defined using a monoidal category:


\begin{code}


class Category k => Monoidal k where
    (><) :: (a 'k' c) -> (b 'k' d) -> ((a >< b) 'k' (c >< d)) 


instance Monoidal (->) where
    f >< g = \(a,b) -> (f a,g b)

\end{code}



\begin{block}{Monoidal Functor definition}

A monoidal functor F between categories |bigU and bigV| is such that:
\begin{itemize}
    \item F is a functor
    \item F (f $\times$ g) = F f $\times$ F g
\end{itemize}
\end{block}
\end{frame}


\begin{frame}{Instance deduction}

From corollary 2.1 we can deduce that:

|bigDplus (f >< g) = \ (a,b) -> let{(c,f')=bigDplus f a;(d,g')= bigDplus g b}| 

|    in ((c,d),f' >< g')|

\vspace{3mm}
\pause
Deriving F from |bigDhat| leaves us with the following definition:

|bigD (bigDplus f) >< bigD (bigDplus g) = bigD (bigDplus (f >< g))|

\vspace{3mm}
\pause
Using the same method as before, we replace |bigDplus| with it's definition and generalize the condition:

|bigD f >< bigD g =|

|bigD (\ (a,b) -> let{(c,f') = f a; (d,g') = g b} in ((c,d),f' >< g'))|

and this is enough for our new instance.
\end{frame}



\begin{frame}{Instance deduction}
\begin{block}{Categorical instance we've deduced}
\begin{code}

instance Monoidal bigD where
    bigD f >< bigD g = bigD(\(a,b) -> let{(c,f') = f a;(d,g') = g b} 
                                     in ((c,d),f' >< g'))

\end{code}
\end{block}
\end{frame}




\begin{frame}{Cartesian categories and functors}
\begin{code}

class Monoidal k => Cartesian k where
    exl :: (a,b)'k'a
    exr :: (a,b)'k'b
    dup :: a 'k' (a,a)

instance Cartesian (->) where
    exl = \(a,b) -> a
    exr = \(a,b) -> b
    dup = \a -> (a,a)

\end{code}

\vspace{-3mm}
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

From corollary 3.1 and from exl, exr and dup being linear functions we can deduce that:

|bigDplus exl = \ p -> (exl p,exl)|

|bigDplus exr = \ p -> (exr p,exr)|

|bigDplus dup = \ p -> (dup a,dup)|

\vspace{3mm}
With this in mind we can arrive at our instance:

|exl = bigD(bigDplus exl)|

|exr = bigD(bigDplus exr)|

|dup = bigD(bigDplus dup)|

\end{frame}



\begin{frame}{Instance deduction} 

Replacing |bigDplus| with it's definition and remembering linearD's definition we can obtain:

exl = linearD exl

exr = linearD exr

dup = linearD dup

\vspace{2mm}
and  convert this directly into a new instance:

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

This type of categories is the dual of the cartesian type of categories.

\begin{block}{Note}
In this paper coproducts are categorical products, i.e., biproducts
\end{block}

\begin{block}{Definition}
\begin{code}

class Category k => Cocartesian k where
    inl :: a 'k' (a,b)
    inr :: b 'k' (a,b)
    jam :: (a,a) 'k' a

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

%Ar1
\section{Fork and Join}
\begin{slide}{Fork and Join}
    \begin{itemize}
        \item
            |forku :: Cartesian k => (a 'k' c) -> (a 'k' d) -> (a 'k' (c >< d))|
            \xymatrix@@R=5mm{
                & c \\
                a \ar[ur]\ar[dr] \\
                & d
            }
        \item
            |joinu :: Cartesian k => (c 'k' a) -> (d 'k' a) -> ((c >< d) 'k' a)|
            \xymatrix@@R=5mm{
                c\ar[dr]\\
                & a \\
                d\ar[ur]
            }
    \end{itemize}
\end{slide}

\begin{slide}{Instance of |->+|}
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
\end{slide}

\begin{slide}{Instance of |->+|}
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
\end{slide}

\section{Numeric operations}
\begin{slide}{NumCat definition}
\begin{code}
    class NumCat k a where
        negateC :: a ‘k‘ a
        addC :: (a >< a) ‘k‘ a
        mulC :: (a >< a) ‘k‘ a
        ...
     
    instance Num a => NumCat (->) a where
        negateC = negate
        addC = uncurry (+)
        mulC = uncurry (*)
        ...
\end{code}
\end{slide}

\begin{frame}
    |bigD (negate u) = negate (bigD u)|\\
    |bigD (u + v) = bigD u + bigD v|\\
    |bigD (u * v) = u * bigD v + v * bigD u|\\
    \begin{itemize}
        \item
            Imprecise on the nature of u and v.
        \item
            A precise and simpler definition would be to differentiate the operations themselves.
    \end{itemize}
\end{frame}

\begin{frame}
\begin{code}
    class Scalable k a where
        scale :: a -> (a ‘k‘ a)
     
    instance Num a => Scalable (->+) a where
        scale a = AddFun (\da -> a * da)

    instance NumCat D where
        negateC = linearD negateC
        addC = linearD addC
        mulC = D (\(a, b) -> (a * b, scale b joinu scale a))

    instance FloatingCat D where
        sinC = D(\a -> (sin a, scale (cos a)))
        cosC = D(\a -> (cos a, scale (-sin a)))
        expC = D(\a -> let e=exp a in (e, scale e))
        ...
        
\end{code}
\end{frame}

\begin{frame}{Examples}
\begin{code}
    sqr :: Num a => a -> a
    sqr a = a*a

    magSqr :: Num a => a >< a -> a
    magSqr (a, b) = sqr a + sqr b

    cosSinProd :: Floating a => a >< a -> a >< a
    cosSinProd (x, y) = (cos z, sin z) where z=x*y
\end{code}
\begin{block}{With a compiler plugin we can obtain}
|sqr = mulC . (id forku id)|\\
|magSqr = addC . (mulC . (exl forku exl) forku mulC . (exr forku exr))|\\
|cosSinProd = (cosC forku sinC) . mulC|\\
\end{block} 
\end{frame}

\section{Generalizing Automatic Differentiation}
\begin{frame}{Generalizing Automatic Differentiation}
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
\begin{frame}
\begin{code}
    instance Scalable k s ⇒ NumCat Dk s where
        negateC = linearD negateC negateC
        addC = linearD addC addC
        mulC = D (\(a, b) -> (a * b, scale b joinu scale a))
\end{code}
\end{frame}

%Ne2

\begin{frame}{Matrices}
There exists three, non-exclusive, possibilities for a nonempty matrix $W$:
\vspace{1mm}
\begin{itemize}
	\item width $W$ = height $W$ = $1$;
	\vspace{1.5mm}
	\item W is the horizontal juxtaposition of two matrices $U$ and $V$,\\
	 where height $W$ = height $U$ = height $V$ and\\
	 width $W$ = width $U$ $+$ width $V$;
	 \vspace{1.5mm}
	\item W is the vertical juxtaposition of two matrices $U$ and $V$,\\
	 where width $W$ = width $U$ = width $V$ and\\ 
	 height $W$ = height $U$ $+$ height $V$.
\end{itemize}

\end{frame}

\begin{frame}{Extracting a Data Representation}

%In addition to what we have used so far, we also need a Data Representation. 
In machine learning, a Gradient-based optimization works by searching for local
minima in the domain of a differentiable function $f :: a \to s$. Each step in the search is in the direction opposite of the gradient of $f$, which is a vector form of $\mathcal{D}\ f$.

\pause
\vspace{5mm}
Given a linear map  $f' :: U \multimap V$ represented as a function, it is possible to extract a Jacobian
matrix by applying $f$ to every vector in a basis of $U$.

\end{frame}

\begin{frame}{Generalized Matrices}
Given a scalar field $s$, a free vector space has the form $p \to s$ for some $p$, where the
cardinality of $p$ is the dimension of the vector space and there exists a finite number of values for $p$.

\pause

\vspace{5mm}

In particular, we can represent vector spaces over a given field as a representable functor, i.e., a functor F such that: $$\exists p\ \forall s\ F\ s\ \cong\ p \to s$$
\end{frame}

%Ez2
\section{Reverse-Mode Automatic Differentiation(RAD)}


\begin{frame}{A short introdution}

\begin{itemize}
    \item We've derived and generalized an AD algorithm using categories
    \item With fully right-associated compositions this algorithm becomes a foward-mode AD and with fully left-associated becomes a reverse-mode AD
    \item We want to obtain generalized FAD and RAD algorithms 
    \item How do we describe this in Categorical notation?
\end{itemize}

\end{frame}




\begin{frame}{Converting morfisms}

Given a category k we can represent its morfisms the following way:

\begin{block}{Left-Compose functions}
|f :: a 'k' b => (. f) :: (b 'k' r) -> (a 'k' r)| where r is any object of k.
\end{block}

If h is the morfism we'll compose with f then h is the continuation of f.
\end{frame}




\begin{frame}{Instance deduction}

\begin{block}{Defining new type}
\begin{code}
newtype Contkr a b = Cont((b 'k' r) -> (a 'k' r))
\end{code}
\end{block}

\begin{block}{Functor derived from type}
\begin{code}
cont :: Category k => (a 'k' b) -> Contkr a b
cont f = Cont(. f)
\end{code}
\end{block}

\end{frame}



\begin{frame}{Instance deduction}
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







\section{Gradient and Duality}

\begin{frame}{A short introdution}

Due to it's widespread use in ML we'll talk about a specific case of RAD: computing gradients(derivatives of functions with scalar codomains)

A vector space A over a scalar field s has A $\multimap$ s as its dual.

Each linear map in A $\multimap$ s can be represented in the form of dot u for some u :: A where

\begin{block}{Definition and instanciation}
\begin{code}
class HasDot(S) u where dot :: u -> (u sto s)

instance HasDot(IR) IR where dot = scale 

instance (HasDot(S) a,HasDot(S) b) 
  => HasDot(S) (a >< b) 
  where dot(u,v) = dot u forku dot v
\end{code}
\end{block}

\end{frame}



\begin{frame}{Instance deduction}

The internal representation of $Cont_{\multimap}^{s}$ a b is (b $\multimap$ s) |->| (a $\multimap$ s) which is isomorfic to (a |->| b).

\begin{block}{Type definition for duality}
\begin{code}
newtype Dualk a b = Dual(b 'k' a)
\end{code}
\end{block}

\end{frame}




\begin{frame}{Instance deduction}

All we need to do to create dual representations of linear maps is to
convert from $Cont_{k}^{S}$ to $Dual_{k}$ using a functor:

\begin{block}{Functor definition}
\begin{code}
asDual :: (HasDot(S) a,HasDot(S) b) => 
  ((b sto s) -> (a sto s)) -> (b sto a)
asDual (Cont f) = Dual (onDot f)
\end{code}

where

\begin{code}
onDot :: (HasDot(S) a,HasDot(S) b) => 
  ((b sto s) -> (a sto s)) -> (b sto a)
onDot f = inv dot . f . dot
\end{code}
\end{block}

\end{frame}



\begin{frame}{Instance deduction}
\begin{code}

instance Category k => Category Dualk where
  id = Dual id
  Dual g . Dual f = Dual (f . g)

instance Monoidal k => Monoidal Dualk where
  Dual f >< Dual g = Dual (f >< g)

instance Cartesian k => Cartesian Dualk where
  exl = Dual inl ;  exr = Dual inr
  dup = Dual jam

instance Cocartesian k => Cocartesian Dualk where
  inl = Dual exl ; inr = Dual exr
  jam = Dual dup

instance Scalable k => Scalable Dualk where
  scale s = Dual(scale s)

\end{code}
\end{frame}



\begin{frame}{Final notes}

\begin{itemize}
  \item |(joinu) and (forku)| mutually dualize 
  
  |(Dual f joinu Dual g) = Dual (f forku g) and Dual f forku Dual g = Dual(f joinu g))|
  \item Using the definition from chapter 8 we can determine that the duality of a matrix corresponds to it's transposition
\end{itemize}

\end{frame}


\section{Foward-Mode Automatic Differentiation(FAD)}

\begin{frame}{Fowards-mode Automatic Differentiation(FAD)}

We can use the same deductions we've done in Cont and Dual to derive a category with full right-side association, thus creating a generized FAD algorithm.

This algorithm is far more apropriated for low dimention domains.


\begin{block}{Type definition and functor from type}
\begin{code}
newtype Beginkr a b = Begin((r 'k' a) -> (r 'k' b))

begin :: Category k => (a 'k' b) -> Beginkr a b
begin f = Begin(f .)
\end{code}
\end{block}

We can derive categorical instances from the functor above and we can choose r to be the scalar field s, noting that s $\multimap$ a is isomorfic to a.


\end{frame}

%Ar2
\section{Scaling Up}
\begin{frame}{Scaling Up}
\begin{itemize}
\item
Practical applications often involve high-dimensional spaces.
\item
Binary products are a very inefficient and unwieldy way of encoding high-dimensional spaces.
\item
A practical alternative is to consider n-ary products as representable functors(?)
\end{itemize}
\begin{code}
    class Category k => MonoidalI k h where
        crossI :: h(a ‘k‘ b) -> (h a ‘k‘ h b)

    instance Zip h => MonoidalI (->) h where
        crossI = zipWith id
\end{code}

\end{frame}

\begin{frame}
\begin{code}
    class MonoidalI k h => CartesianI k h where
        exI     :: h (h a ‘k‘ a)
        replI   :: a ‘k‘ h a

    instance (Representable h, Zip h, Pointed h) => 
            CartesianI (->) h where
        exI = tabulate (flip index)
        replI = point
\end{code}
\begin{itemize}
\item
    The following is not the class the author was thinking
\end{itemize}
\begin{code} 
    class Representable h where
        type Rep h :: *
        tabulate :: (Rep h -> a) -> h a
        index    :: h a -> Rep h -> a
    
\end{code}
\end{frame}

\begin{frame}
\begin{code}
    class MonoidalI k h => CocartesianI k h where
        inI :: h (a ‘k‘ h a)
        jamI :: h a ‘k‘ a

    instance (MonoidalI k h, Zip h) => MonoidalI Dk h where
        crossI fs = D ((id >< crossI) . unzip . crossI (fmap unD fs))

    instance (CocartesianI (->) h, CartesianI k h, Zip h) =>
            CartesianI Dk h where
        exI = linearD exI exI
        replI = zipWith linearD replI replI

    instance (CocartesianI k h, Zip h) => CocartesianI Dk h where
        inI = zipWith linearD  inIF inl 
        jamI = linearD sum jamI    
 
\end{code}
\end{frame}

\begin{frame}
\begin{code}
    class MonoidalI k h => CocartesianI k h where
        inI :: h (a ‘k‘ h a)
        jamI :: h a ‘k‘ a

    instance (MonoidalI k h, Zip h) => MonoidalI Dk h where
        crossI fs = D ((id >< crossI) . unzip . crossI (fmap unD fs))

    instance (CocartesianI (->) h, CartesianI k h, Zip h) =>
            CartesianI Dk h where
        exI = zipWith linearD exI exI
        replI = linearD replI replI

    instance (CocartesianI k h, Zip h) => CocartesianI Dk h where
        inI = zipWith linearD  inIF inl 
        jamI = linearD sum jamI    
 
\end{code}
\end{frame}
\section{Related Work and conlusion}
\begin{frame}{Conclusion}
\begin{itemize}
\item
    Suggests that some of the work referred to does just a part of this paper.
\item
    This paper ([Elliott 2018]\cite{Elliott:2018}) is a follow up of [Elliott 2017]\cite{Elliott:2017} 
\item
    Suggests that this implementation is simple, efficient, it can free memory dinamically (RAD) and is naturally parallel.
\item
    Future work are detailed performace analysis; higher-order differentiation and automatic incrementation (continuing previous work [Elliott 2017]\cite{Elliott:2017})
\end{itemize}
\end{frame}

\section{Bibliography}
\bibliographystyle{acm}%{ACM-Reference-Format}
\bibliography{slides}
%fim

\end{document}


