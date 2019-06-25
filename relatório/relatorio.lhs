\documentclass[11pt,a4]{article}
\usepackage[utf8x]{inputenc}

\usepackage[]{hyperref}
\setlength{\parindent}{1em}
\setlength{\parskip}{0.5em}

\usepackage{csquotes}
\usepackage{amsmath,amssymb,mathrsfs,amsthm}
\usepackage{array}
\usepackage{cite}

\usepackage{epstopdf}
\usepackage[T1]{fontenc}

\usepackage[all]{xy}

\usepackage{hyperref}
\usepackage{stmaryrd}
\usepackage{graphicx,color}
\usepackage{url}
\textwidth 15cm
\textheight 22cm
\hoffset -1.5cm
\voffset -1cm
\def\N{\mathbb{N}}
\def\R{\mathbb{R}}
\def\C{\mathbb{C}}
\def \RAP {$\rightarrow^{+}$}
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


\title{Studying Automatic Differentiation}
\author{Group 114:\\
	Artur Queiroz PG38014, Ezequiel Moreira PG38413, Nelson Loureiro PG37020}
\date{June 2019}

\newtheorem{teor}{Theorem}[section]
\newtheorem{propo}{Proposi\c c\~ao}[section]
\newtheorem{coro}{Corollary}[section]
\newtheorem{lema}{Lema}[section]
\theoremstyle{definition}
\newtheorem{defi}{Definition}[section]
\theoremstyle{Definition}
\newtheorem{exemplo}{Example}[section]
\theoremstyle{Definition}
\newtheorem{nota}{Note}[section]

\begin{document}
	
	\maketitle
	
	\section{Introduction}
	\paragraph{} The objective of this document is to expose the work done for the project of the course \emph{Laboratórios de Engenharia Informática} for the period of 2018/2019 whose major work was the study of an article about
	Automatic Differentiation (\cite{Elliott:2018}), under the guidance of supervisors José Nuno Oliveira and Pedro Patrício. This project was proposed to our group and was chosen thanks to the fact that the article has a semi-implemented Automatic Differentiation algorithm with Correct By Construction techniques, a subject that has been growing in influence the last few years. 
	\par We have also implemented the ideas expressed in the article with moderate success.
	
	
	%1-3
	
\section{Differentiable function}
	
	Since automatic differentiation (AD) has to do with computing derivatives, let’s begin by considering
	what derivatives are. Using the definitions from chapter 2 of Michael Spivak's book (\cite{book}):
	
	\begin{defi}
		A function $f:\R \to \R$ is differentiable at $x \in \R$, if there exists a real \newline $f $$'$ $(x)$ such that
		\begin{align*}
		\lim_{\varepsilon \to 0} \frac{\textit{$f(x+\varepsilon)-f(x)$}}{\varepsilon} \ = \textit{$f'(x)$}  
		\end{align*}
	\end{defi}
	
	This is, we can say that the derivate of $f$ at $x$, represented as $f $$'$ $(x)$, is a local linear approximation of $f$ at $x$.
	But this definition is one case of a more general definition. \par 
	Using simple transformations in the above equation, we have the following \newline equivalences:
		\begin{align*}
		\hspace{-3mm} \lim_{\varepsilon \to 0} \frac{\textit{$f(x+\varepsilon)-f(x)$}}{\varepsilon} - \textit{$f'(x)$} = 0 \hspace{0.5mm} 
		\Leftrightarrow \hspace{0.5mm} \lim_{\varepsilon \to 0} \frac{\textit{$f(x+\varepsilon)-f(x)$} - (\varepsilon \cdotp \textit{$f'(x)$})}{\varepsilon} = 0 
		\end{align*}
	And with this, we can show the referred more general definition.
	\begin{defi}
		A function $f:\R^{m} \to \R^{n}$ is differentiable at $x \in \R^{m}$, if there exists
		a unique linear transformation $\mu:\R^{m} \to \R^{n}$ such that
		\begin{align*}
		\lim_{\varepsilon \to 0} \frac{ \norm{ \textit{$f(x+\varepsilon)-f(x)-$} \mu (\varepsilon) } }{ \norm{ \varepsilon }} = 0
		\end{align*}
	\end{defi}
	
	Since $f $$'$ $(x)$ is a linear transformation, we can represent the derivative of a function as a Jacobian Matrix, where in the Definition 2.1, we can represent the derivative as a matrix with a single element. We reached a good generalization and let's now move on to an implementation in Haskell.
	
	\subsection{First Definition of Derivative}
	
	Let $f::a \to b$ be a function, where $a$ and $b$ are vectorial spaces that share a common underlying field. The derivative of $f$ at some value in $a$ is a linear transformation from $a$ to $b$, which we will write as \enquote*{$a \multimap b$}. The numbers, vectors and matrices mentioned above are all different representations of linear maps.
	Written in Haskell style:
	
	\quad $\mathcal{D} :: (a \to b) \to (a \to (a \multimap b))$
	
	where the function $\mathcal{D}$ receives a function of type ($a \to b$) and a value of its domain has its input and yields a linear transformation of type $(a \multimap b)$. 
	
	If we differentiate two times, we have:
	
	\quad $ \mathcal{D}^{2} = \mathcal{D} \circ \mathcal{D} :: (a \to b) \to (a \to (a \multimap a \multimap b ))$
	
	The type ($a \multimap a \multimap b$) is a linear map that yields a linear map, which is the curried form of
	a bilinear map.
	
	\subsection{Sequential Composition}
	Turning now to the composition of functions, we have the following Theorem, known as Chain Rule.
	\begin{teor}
		
		Let  $f:: a \to b$ and $g:: b \to c$ be two functions. Then the derivative of the composition between $f$ and $g$ is
		\begin{align*}
		\mathcal{D} \ (g \circ f ) \ a= \mathcal{D} \hspace{0.9mm} g \hspace{1.0mm}  (f \hspace{0.5mm} a)   \hspace{0.6mm} \circ \hspace{0.6mm} \mathcal{D} \hspace{0.6mm} f \ a
		\end{align*}
	\end{teor}
	
	\begin{nota}
		From the definition of composition, we know that $g \circ f$ has type ($a \to c$), then $\mathcal{D} \ (g \hspace{0.5mm} \circ f) \ a $\hspace{0.5mm} has type ($a \multimap c$). We also know that $\mathcal{D} \hspace{0.6mm} f \ a$ has type ($a \multimap b$) and $\mathcal{D} \hspace{0.9mm} g \hspace{1.0mm}  (f \hspace{0.5mm} a)   \hspace{0.6mm}$ has type ($b \multimap c$), so the composition of these two functions has type ($a \multimap c$). Thus, both sides of the
		equation have the same type.
	\end{nota}
	
	Unfortunately, Theorem 2.1 does not give us a good compositional recipe for differentiating sequential compositions because $\mathcal{D} \ (g \circ f )$ is not constructed solely from $\mathcal{D} \hspace{0.5mm} f$ and $\mathcal{D} \hspace{0.5mm} g$, it also needs $f$ itself.
	
	For that reason it would be better to propose a second derivative definition.
	\vspace{13mm}
	\subsection{Second Derivative Definition}
	
	The second derivative definition is the following:
	
	$\mathcal{D}_{0}^{+} :: (a \to b) \to ((a \to b) \times (a \to (a \multimap b)))$ 
	
	$\mathcal{D}_{0}^{+} \hspace{0.5mm} f =(f,\hspace{0.5mm} \mathcal{D} f)$
	
	As desired, this altered specification is compositional:
	
	$\mathcal{D}_{0}^{+} \hspace{0.5mm} (g \circ f)= $ 
	
	\{definition of $\mathcal{D}_{0}^{+}$\}
	
	$= (g \circ f,\hspace{0.2mm} \mathcal{D} \hspace{0.5mm} (g \circ f) \hspace{0.5mm})$ \hspace{3.3cm} 
	
	\{theorem 2.1 and definition of $g \circ f$\}
	
	$= (\lambda a \to g (f \hspace{0.5mm} a),\hspace{0.2mm} \lambda a \to \mathcal{D} \hspace{0.9mm} g \hspace{1.0mm}  (f \hspace{0.5mm} a)   \hspace{0.5mm} \circ \hspace{0.5mm} \mathcal{D} \hspace{0.5mm} f \hspace{0.5mm} a )$ \hspace{1.5mm} 
	
	
	The derivative of the composition $\mathcal{D}_{0}^{+} \hspace{0.5mm} (g \circ f) $ is entirely obtained from the components of $\mathcal{D}_{0}^{+} \hspace{0.5mm} g $ and $\mathcal{D}_{0}^{+} \hspace{0.5mm} f $. Note that the two components of the definition use $(f \hspace{0.1mm} a)$, requiring redundant work, resulting in an impractically expensive algorithm. Because of this we need a new derivative specification.
	
	
	\subsection{Third Derivative Definition}
	
	The third derivative definition is the following:
	
	$\mathcal{D}^{+} :: (a \to b) \to (a \to b \times (a \multimap b))$
	
	$\mathcal{D}^{+} \hspace{0.5mm} f \hspace{0.9mm} a = (f \hspace{0.5mm} a,\hspace{0.5mm} \mathcal{D} \hspace{0.5mm} f \hspace{0.5mm} a )$
	
	With this last optimization we have the following Corollary: 
	
	\begin{coro}
		$\mathcal{D}^{+}$ is (efficiently) compositional with 
		respect to $(\circ)$. Specifically, in \newline Haskell,
		
		\quad $\mathcal{D}^{+} \hspace{0.5mm} (g \circ f) \hspace{0.9mm} a$ = $\bf let$  $\{(b,\hspace{0.5mm} f') = \mathcal{D}^{+} \hspace{0.5mm} f \hspace{0.9mm} a; \hspace{0.5mm} (c,\hspace{0.5mm} g')=\mathcal{D}^{+} \hspace{0.5mm} g \hspace{0.9mm} b \}$ $\bf in$  $(c,\hspace{0.5mm} g' \circ f') $
	\end{coro}
	
	\subsection{Parallel Composition}
	
	Now let's introduce another important way of combining functions, the \ \enquote*{cross} operation, that combines two functions in parallel. The cross operation is as follows:
	
	$(\boldsymbol{\times}) :: (a \to c) \to (b \to d) \to (a \times b \to c \times d)$
	
	$f \boldsymbol{\times} g = \lambda(a,\hspace{0.5mm} b) \to (f \hspace{0.5mm} a,\hspace{0.5mm} g \hspace{0.5mm} b) $
	
	
	The following Theorem, designated Cross Rule, combines the above derivative definition and the cross operation.
	
	\begin{teor}
		Let $f :: a \to c$ and $g :: b \to d$ be two functions. Then the cross rule is the following:
		\begin{align*}
		\mathcal{D} \hspace{0.5mm} (f \boldsymbol{\times} g) \hspace{0.5mm} (a,\hspace{0.5mm} b) = \mathcal{D} \hspace{0.5mm} f \hspace{0.9mm} a \boldsymbol{\times} \mathcal{D} \hspace{0.5mm} g \hspace{0.9mm} b
		\end{align*}
	\end{teor}
	
	\begin{nota}
		
		The function $\mathcal{D} \hspace{0.6mm} f \ a$ has the type ($a \multimap c$) and $\mathcal{D} \hspace{0.6mm} g \ b$ has the type ($b \multimap d$), so both sides of the equation are of the type $(a \times b \multimap c \times d)$.
	\end{nota}
	
	The Theorem 2.2 gives us what is necessary to write the next Corollary.
	
	\begin{coro}
		The function $\mathcal{D}^{+}$ is compositional with respect to $(\boldsymbol{\times})$. Specifically,
		
		\quad $\mathcal{D}^{+} \hspace{0.5mm} (f \boldsymbol{\times} g) \hspace{0.9mm} (a,\hspace{0.5mm} b)$ = $\bf let$ $\{(c,\hspace{0.5mm} f') = \mathcal{D}^{+} \hspace{0.5mm} f \hspace{0.9mm} a; \hspace{0.5mm} (d,\hspace{0.5mm} g')=\mathcal{D}^{+} \hspace{0.5mm} g \hspace{0.9mm} b \}$ $\bf in$  $((c,\hspace{0.5mm} d), \hspace{0.5mm} f' \boldsymbol{\times} g' ) $
		
	\end{coro}
	
	The compositions we've talked about thus far preserve linearity, which we'll explain  in greater detail next section. 
	
	\subsection{Linear Functions}
	A function $f$ is said to be linear when it distributes over (preserves the structure of) vector addition
	and scalar multiplication, i.e.,
	
	\quad $f(a + a')= f \hspace{0.5mm} a + f \hspace{0.5mm} a'$
	
	\quad $f(s \cdot a)= s \cdot f \hspace{0.5mm} a$
	
	\begin{teor}
		For all linear functions $f$, $\mathcal{D} \hspace{0.5mm} f \hspace{0.9mm} a = f $.
	\end{teor}
	
	Since the derivative of a function is a local linear approximation of $f$ at $a$, this Theorem tells us that linear functions are their own perfect linear approximations.
	
	For example, considering the function $id =  \lambda a \to a $, the previous Theorem tells us that $\mathcal{D} \hspace{0.5mm} id \hspace{0.9mm} a = id $. Expressing in matrix form, the derivative of $id$ can be represented by the matrix [$1$] (matrix with the single element $1$) or by an identity matrix.
	
	The following Corollary of Theorem 2.3 tells us how to construct $\mathcal{D}^{+} \hspace{0.5mm} f$ for all linear functions.
	
	\begin{coro}
		For all linear functions $f$, $\mathcal{D}^{+} \hspace{0.5mm} f = \lambda a \to (fa,\hspace{0.5mm} f)$.
	\end{coro}

	
	
	
	
	%4.1-4.4
	
	\newpage
    
    \section{Automatic Differentiation(AD) algorithm}

In order to achieve the major goal of the article we must implement |bigDplus|.
But there's a problem: |bigD| is not computable.

However through the use of the corollaries we've defined so far we can deduce an alternative implementation using category theory as its basis.

\subsection{Category and respective functor}

A category consists in a collection of objects (generalisation of sets and types) and morphisms (operations between objects).

Every category has defined in it |id :: a -> a| (identity for objects of a category) and morphism composition |(.)|, such that for 2 morphisms |f :: a ->  b| and |g :: b -> c| of a given category we can define |g . f :: a -> c|.
Furthermore, there are a couple of categorical laws that must be followed: 
\begin{itemize}
    \item (C.1) $id \circ f = f \circ id = f$ 
    \item (C.2) $f \circ (g \circ h) = (f \circ g) \circ h$
\end{itemize}

With this in mind we can express categories as an Haskell class and present an instance for |(->)|:
\begin{code}
class Category k where
    id::(a'k'a)
    (.)::(b'k'c)->(a'k'b)->(a'k'c)
\end{code}
\vspace{-6mm}
\begin{code}
instance Category (->) where
    id = \a -> a 
    g . f = \a -> g (f a)  
\end{code}

An F functor between |bigU| and |bigV| categories is such that a) for each u object of |bigU| we have that F u is an object in |bigV| and b) for a morphism |f :: a -> b| of |bigU| there exists |F f :: F a -> F b| morphism in |bigV| .

In addition to this a functor must preserve categorical structure.
For this particular case, F id $\in$ |bigU| = id ($\in$ |bigV|) and F (f $\circ$ g) = F f $\circ$ F g must be true for F functor.

Given the prior definitions and taking into account the various corollaries we'll deduce how to implement |bigDplus|.

\subsubsection{Instance deduction}

To do this we first define a new type of data:

|newtype bigD a b = bigD (a -> b >< (a sto b))|

With this new type we adapt |bigDplus| definition to use it, creating |bigDhat|:

\begin{code}

bigDhat :: (a -> b) -> bigD a b
bigDhat f = bigD(bigDplus f)

\end{code}

With this in mind we must now deduce a categorical instance for |bigD| such that |bigDhat| is a valid functor.


(1) |bigDhat| functor is equivalent to, for all f and g morphisms of appropriate type,

    |id = bigDhat id = bigD (bigDplus id)|

    |bigDhat g . bigDhat f = bigDhat (g . f) = bigD (bigDplus (g . f))|
    
(2) From corollaries 2.3 and 2.1 we know that

\begin{itemize}
    \item |bigDplus id = \ a -> (id a,id)|
    \item  |bigDplus (g . f) = \ a -> let{(b,f') = bigDplus f a; (c,g') = bigDplus g b } in (c,g' . f')|
\end{itemize}

Replacing what we have in (1) using what we've determined in (2) we can conclude that

|id = bigD (\ a -> (id a,id))|

|bigDhat g . bigDhat f = bigD (\ a -> let{(b,f') = bigDplus f a; (c,g') = bigDplus g b} in (c,g' . f'))|

From this we can trivially obtain the identity definition for our instance, but morphism composition needs further work.

In order to use the morphism composition we'll first generalise the condition derived above:

|bigD g . bigD f = bigD (\ a -> let{(b,f') = f a; (c,g') = g b} in (c,g' . f'))|

As we can see, this condition can be used directly in our new instance, and as such we've arrived at our new instance.


\subsubsection{Deduced Instance}

\begin{code}
instance Category bigD where
    id = linearD id
    bigD g . bigD f = 
    bigD( \a -> let{(b,f') = f a;(c,g') = g b} in (c,g' . f'))
\end{code}

where |linearD| is equivalent to the definition of |bigDhat| for linear functions:

\begin{code}
linearD :: (a -> b) -> bigD a b
linearD f = bigD(\a -> (f a,f))
\end{code}

\subsection{Instance proof}

In order to prove that the instance we've arrived at is well constructed we must prove that it follows laws (C.1) and (C.2).

In order to simplify these proofs we assume that |bigDplus| is a functor. In order to do this we must make a concession: all morphisms we're considering arise from |bigDplus|, i.e., we only use |f' :: bigD a b| where |f' = bigDhat f| for some |f :: a -> b| morphism of |bigD|.

This becomes possible by making |bigD| a b an abstract type.

With this in mind we can now prove that our instance obeys the rules:

\subsubsection{C.1 proof}

|id| $\circ$ |bigDhat| |f| \\
\{ functor law for |id| (specification of |bigDhat| \}\\
= |bigDhat| |id| $\circ$ |bigDhat| |f|\ \\
\{ functor law for ($\circ$) \}\\
= |bigDhat| (|id| $\circ$ |f|) \\
\{ categorical law \}\\
= |bigDhat| |f| 


\subsubsection{C.2 proof}

|bigDhat| |h| $\circ$ (|bigDhat| |g| $\circ$ |bigDhat| |f|)\\
\{ 2x functor law for ($\circ$) \}\\
= |bigDhat| (|h| $\circ$ (|g| $\circ$ |f|))\\ 
\{ categorical law \}\\
= |bigDhat| ((|h| $\circ$ |g|) $\circ$ |f|)\\
\{ 2x functor law for ($\circ$) \}\\
= (|bigDhat| |h| $\circ$ |bigDhat| |g|) $\circ$ |bigDhat| |f|

As a final note these proofs required nothing from |bigD| and |bigDhat| besides the functor laws, meaning we can avoid presenting this proof for all other categorical instances arising from a functor.

\newpage

\subsection{Monoidal category and respective functor}

As noted before we want our algorithm to have parallel composition in it. To do this we must use a new type of category: the monoidal category.

\begin{code}


class Category k => Monoidal k where
    (><) :: (a 'k' c) -> (b 'k' d) -> ((a >< b) 'k' (c >< d)) 


instance Monoidal (->) where
    f >< g = \(a,b) -> (f a,g b)

\end{code}

We also define the monoidal functor in the same manner as the previous category type, noting that it must obey the following rules:

\begin{itemize}
    \item F is a functor
    \item F (|f| $\times$ |g|) = F |f| $\times$ F |g|
\end{itemize}

\subsubsection{Instance deduction}

Deducing a instance of our new category type is done using the same method as before:

(1) |bigDhat| monoidal functor is equivalent to, for all |f| and |g| morphisms of appropriate type,

|bigD (bigDplus f) >< bigD (bigDplus g) = bigD (bigDplus (f >< g))|

\smallskip

(2) From corollary 2.1 we know that

|bigDplus (f >< g) = \ (a,b) -> let{(c,f')=bigDplus f a;(d,g')= bigDplus g b} in ((c,d),f' >< g')|

\smallskip

Replacing what we have in (1) using what we've determined in (2) we can conclude that

|bigD f >< bigD g =|

|bigD (\ (a,b) -> let{(c,f') = f a; (d,g') = g b} in ((c,d),f' >< g'))|

\smallskip

and we can use this directly in our new instance.

\subsubsection{Deduced Instance}

\begin{code}

instance Monoidal bigD where
    bigD f >< bigD g = bigD(\(a,b) -> let{(c,f') = f a;(d,g') = g b} in ((c,d),f' >< g'))

\end{code}

\newpage

\subsection{Cartesian and Cocartesian  category and respective functors}

Monoidal category gives us the ability to combine functions, but not to split data, nor does it give us a way to duplicate or remove it.

In order to add  these functionalities we must use 2 new types of categories: cartesian and cocartesian categories, noting that these 2 types of categories are dual to one another.

We also take note that for this paper co-products coincide with categorical products. As such, we cannot instantiate for |(->)| in the cocartesian category type as we've done before.

With that noted we define our categories 

\begin{code}

class Monoidal k => Cartesian k where
    exl :: (a,b)'k'a
    exr :: (a,b)'k'b
    dup :: a 'k' (a,a)

instance Cartesian (->) where
    exl = \(a,b) -> a
    exr = \(a,b) -> b
    dup = \a -> (a,a)
    
class Category k => Cocartesian k where
inl :: a 'k' (a,b)
inr :: b 'k' (a,b)
jam :: (a,a) 'k' a

\end{code}

and note the following properties must be followed by the respective functors:

\subsubsection{Cartesian functor properties}

\begin{itemize}
    \item F is a monoidal functor
    \item F exl = exl
    \item F exp = exp
    \item F dup = dup
\end{itemize}


\subsubsection{Cocartesian functor properties}

\begin{itemize}
    \item F is a functor
    \item F inl = inl
    \item F inr = inr
    \item F jam = jam
\end{itemize}

We note that due to the duality of the 2 categories we'll only show the deduction for the cartesian category.


\subsubsection{Instance deduction}

We follow the same process as before:

(1) |bigDhat| cartesian functor is equivalent to

|exl = bigD(bigDplus exl)|

|exr = bigD(bigDplus exr)|

|dup = bigD(bigDplus dup)|

(2) From corollary 3.1 and exl, exr and dup's linearity we deduce that

|bigDplus exl = \ p -> (exl p,exl)|

|bigDplus exr = \ p -> (exr p,exr)|

|bigDplus dup = \ p -> (dup a,dup)|

After replacing what we have in (1) using what we've determined in (2), we can take the result and directly use it in our new instance.

\subsubsection{Deduced Instance}

\begin{code}

instance Cartesian D where
    exl = linearD exl
    exr = linearD exr
    dup = linearD dup

\end{code}

	%4.5-7
	
	\section{Fork and Join}
	We can derive this two useful operations with just the operators defined earlier.
    
    |forku :: Cartesian k => (a 'k' c) -> (a 'k' d) -> (a 'k' (c >< d))|	
    
    | f forku g = (f >< g) . dup|
    
    |joinu :: Cartesian k => (c 'k' a) -> (d 'k' a) -> ((c >< d) 'k' a)|
    
    | f joinu g = jam . (f >< g)| 
	
    \newpage
	
	\section{Instance of |->+|}
    We can now describe Additive Functions: functions that transform something that is Additive to something that is also Additive, and using these we can derive instances for every categorical type discussed before for (|->+|)

\begin{code}
    
newtype a ->+ b=AddFun(a->b)
\end{code}
\vspace{-10mm}
\begin{code}
instance Category (->+) where
   type Obj (->+) = Additive
   id = AddFun id
   AddFun g . AddFun f = AddFun (g . f )
\end{code}
\vspace{-10mm}
\begin{code}
instance Monoidal (->+) where
   AddFun f >< AddFun g = AddFun (f >< g)
\end{code}
\vspace{-10mm}
\begin{code}
instance Cartesian (->+) where
   exl = AddFun exl
   exr = AddFun exr
   dup = AddFun dup
\end{code} 
\vspace{-10mm}
 \begin{code} 
instance Cocartesian (->+) where
    inl = AddFun inlF
    inr = AddFun inrF
    jam = AddFun jamF
\end{code}
\vspace{-10mm}
\begin{code}
inlF :: Additive b => a -> a >< b
inrF :: Additive a => b -> a >< b
jamF :: Additive a => a >< a -> a
\end{code}
\vspace{-10mm}
\begin{code}
inlF = \a -> (a, 0)
inrF = \b -> (0, b)
jamF = \(a, b) -> a + b

\end{code}

\section{Numeric operations}
	To describe numerical operations in a k category we can use the definitions above, noting that the same process can be done for the Floating type.
    \begin{code}
    class NumCat k a where
        negateC :: a ‘k‘ a
        addC :: (a >< a) ‘k‘ a
        mulC :: (a >< a) ‘k‘ a
        ...
     \end{code}
     \newpage

     \begin{code}
    instance Num a => NumCat (->) a where
        negateC = negate
        addC = uncurry (+)
        mulC = uncurry (*)
        ...
\end{code}

When we observe the mathematical definition for differentiation it can be seen that neither u or v is defined in a concrete way, and they can mean different things in different contexts, like functions, numbers, tuples, etc. This requires us to define each one of them separately.

    |bigD (negate u) = negate (bigD u)|\\
    |bigD (u + v) = bigD u + bigD v|\\
    |bigD (u * v) = u * bigD v + v * bigD u|\\
    
    To make this definition more uniform and simple we can differentiate not the expression but the operations themselves. For example the \textit{negate} and the \textit{+} can be seen as linear because they don't require the inputs from the expression, but the \textit{*} operation cannot, and has such requires an alternative definition such as: 

    |bigD  mulC (a, b) = scale b joinu scale a|

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

\newpage
Some examples of functions:
\begin{code}
    sqr :: Num a => a -> a
    sqr a = a*a

    magSqr :: Num a => a >< a -> a
    magSqr (a, b) = sqr a + sqr b

    cosSinProd :: Floating a => a >< a -> a >< a
    cosSinProd (x, y) = (cos z, sin z) where z=x*y
\end{code}

With a compiler plugin referenced in the article we can convert the above to our derived instances of categories:
    
|sqr = mulC . (id forku id)|

|magSqr = addC . (mulC . (exl forku exl) forku mulC . (exr forku exr))|

|cosSinProd = (cosC forku sinC) . mulC|

\newpage

\section{Generalising Automatic Differentiation}
	In the other sections we've used the definition of |bigD| with the $\multimap$, but how do we define a linear map? To be more expressive we can define |bigD| for any given "linear" category k.
    
\begin{code}
    newtype Dk a b = D (a -> b >< (a ‘k‘ b))

    linearD :: (a -> b) -> (a ‘k‘ b) -> Dk a b
    linearD f f'= D (\a -> (f a, f'))
\end{code}
\vspace{-6mm}   
\begin{code}
    instance Category k => Category Dk where
        type Obj Dk = Additive ∧ Obj k 
        id = linearD id id
        bigD g . bigD f = bigD (\ a -> let{(b,f') = f a; (c,g') = g b} in (c,g' . f'))
 \end{code}
\vspace{-6mm}
\begin{code}

instance Monoidal Category k => Category Dk where
    bigD f >< bigD g = bigD(\(a,b) -> let{(c,f') = f a;(d,g') = g b} in ((c,d),f' >< g'))

\end{code}
\vspace{-6mm}
\begin{code}

instance Cartesian Category k => Category Dk where
    exl = linearD exl exl
    exr = linearD exr exr
    dup = linearD dup dup

\end{code}
\vspace{-6mm}
\begin{code}
instance Category k => Cocartesian k where
    inl = linearD inlF inl
    inr = linearD inrF inr
    jam = linearD jamF jam
\end{code}
\vspace{-6mm}
\begin{code}
    instance NumCat D where
        negateC = linearD negateC negateC
        addC = linearD addC addC
        mulC = D (\(a, b) -> (a * b, scale b joinu scale a))
\end{code}

	\newpage
	
	\section{Matrices}
	Let us now consider matrices. There are three non-exclusive possibilities for a non-zero $W$ matrix:
	\begin{itemize}
		\item width $W$ = height $W$ = $1$;
		\item W is the horizontal juxtaposition of two matrices $U$ and $V$, where height $W$ =\newline height $U$ = height $V$ and width $W$ = width $U$ $+$ width $V$;
		\item W is the vertical juxtaposition of two matrices $U$ and $V$, where width $W$ =\newline width $U$ = width $V$ and height $W$ = height $U$ $+$ height $V$.
	\end{itemize}
	
	These operations that have been mentioned before,

	|scale :: a -> (a ‘k‘ a)|
    
    |(joinu) :: (c ‘k‘ a) -> (d ‘k‘ a) -> ((c >< d) ‘k‘ a)|

    |(forku) :: (a ‘k‘ c) -> (a ‘k‘ d) -> (a ‘k‘ (c >< d))|	
    

	correspond exactly to the three possibilities seen above, where in linear maps, the domain and the co-domain are determined, respectively, by the width and height of the matrix together with the type of matrix elements. This happens if we use the convention of matrix on the left multiplied by a column vector on the right.
	
	\subsection{Extracting a Data Representation}
	
	In addition to what we have used so far, we will also need a data representation for the linear map.
	
	For example, in machine learning gradient-based optimisation works by searching for local
	minima in the domain of a differentiable function $f$. Each step in the search is in the direction opposite of the gradient of $f$ ,
	which is a vector form of $\mathcal{D} f$.
	
	Given a linear map $f' :: U \multimap V$ represented as a function, it is possible to extract a Jacobian matrix by applying $f'$ to every vector in a basis of $U$. If $U$ has dimension $m$ (for example $U=\R^n$), this sampling requires $m$ passes. 
	\par In the case where $m$ is a relatively small number, then the method of Jacobian matrix extraction is reasonably efficient. The problem is that it worsens significantly as dimension grows. In particular, many useful problems involve gradient-based optimization over very high-dimensional spaces, which makes this technique inefficient. The next section gives us an alternative.
	
	\newpage
	
	\subsection{Generalised Matrices}
	
	Rather than representing derivatives as functions and then extracting a (Jacobian) matrix, a more
	conventional alternative is to construct and combine matrices in the first place.These matrices are
	usually rectangular arrays that represent $ \R^m \multimap \R^n$. The problem with this alternative is that interferes with the composability we get from organising around binary cartesian products.
	\par There is, however, an especially convenient perspective on linear algebra: free vector spaces. Given a scalar field $s$, any free vector space has the form $p \to s$, for some $p$, where the cardinality of $p$ is the dimension of the vector space (and only finitely many $p$ values can have non-zero images). Scaling a vector $v :: p \to s$ or adding two such vectors is defined in the usual way for functions.
	
	\par Thus, rather than directly using functions as representations, we can alternatively use any representation isomorphic to such a function. In particular, we can represent vector spaces over a given field as a representable functor, i.e., a functor $F$ such that
	
	$\exists p$ $\forall s$ $F$ $s$ $\cong$ $p \to s$.
	
	This method is convenient in a richly typed functional language like Haskell, which comes with libraries of functor-level building blocks. Four such building blocks are functor product, functor composition and their corresponding identities, which are the unit functor (containing no elements) and the identity functor (containing one element).
	\par All of these functors give data representations of functions that save recomputation over a native
	function representation. They also provide a composable, type-safe alternative to the more commonly used multi-dimensional arrays (often called \enquote*{tensors}) in machine learning libraries.

%12-14    
    
\newpage
    
\section{Generalised RAD algorithm}

Earlier in this document we derived and generalised an AD (automatic differentiation) algorithm, and now we desire a generalisation for an RAD (reverse-mode AD) and FAD (forward mode AD) algorithm derived from this more generic one. Let's start with RAD.

In order to achieve an RAD algorithm from our generalised AD we must have it so all compositions of morfisms are left-associated. 

To achieve this we start by converting the way we write morfisms in a category k:

|f :: a 'k' b => (. f) :: (b 'k' r) -> (a 'k' r)| where r is any object of k.

If we build a category based around this concept we'll arrive at our algorithm.

To do that we start by defining a data type and constructing a functor that uses it:

|newtype Contkr a b = Cont((b 'k' r) -> (a 'k' r))|

|cont :: Category k => (a 'k' b) -> Contkr a b|

|cont f = Cont(. f)|

From these we do the same we've done before for |bigD| and |bigDhat|, and we derive all the various instances for our new data type of the numerous categorical types.

\subsection{Deduced Instances}

\begin{code}
instance Category k => Category Contkr where
  id = Cont id
  Cont g . Cont f = Cont(f . g)
\end{code}
\vspace{-10mm}  
\begin{code}
instance Monoidal k => Monoidal Contkr where
  Conf f >< Cont g = Cont(join . (f >< g) . unjoin)
\end{code}
\vspace{-10mm}
\begin{code}
instance Cartesian k => Cartesian Contkr where
  exl = Cont(join . inl)  
  exr = Cont(join . inr) 
  dup = Cont(jam . unjoin)
\end{code}
\vspace{-10mm}
\begin{code}
instance Cocartesian k => Cocartesian Contkr where
  inl = Cont(exl . unjoin)  
  inr = Cont(exr . unjoin) 
  jam = Cont(join . dup)
\end{code}
\vspace{-10mm}
\begin{code}
instance Scalable k a => Scalable Contkr a where
  scale s = Cont(scale s)
\end{code}

With these instances derived we have created a generalised RAD algorithm.

\section{Gradients and duality}


Due to its widespread use in machine learning we'll talk about a specific case of an AD algorithm: computing gradients (derivatives of functions with scalar co-domains).

A vector space A over a scalar field s has A $\multimap$ s as its dual, and the dual space of A is not only a vector space but also isomorphic to A if it has finite dimension.

As such we can represent each linear map in A $\multimap$ s using the form  dot u for some u :: A where

\begin{code}
class HasDot(S) u where dot :: u -> (u sto s)
\end{code}
\vspace{-10mm}
\begin{code}
instance HasDot(IR) IR where dot = scale 
\end{code}
\vspace{-10mm}
\begin{code}
instance (HasDot(S) a,HasDot(S) b) => HasDot(S) (a >< b) 
  where dot(u,v) = dot u forku dot v
\end{code}

\subsection{Duality}

Using the construction |Contkr| from the previous section and taking |r| to be the scalar field s, we observe that the internal representation of $Cont_{\multimap}^{s}$ a b is (b $\multimap$ s) |->| (a $\multimap$ s) , which is isomorphic to (a |->| b).

To this representation we'll call the dual of k:

|newtype Dualk a b = Dual(b 'k' a)|

With this definition we can achieve the dual representations of generalised linear maps by converting them from $Cont_{k}^{S}$ to |Dualk| using a functor:

\begin{code}
asDual :: (HasDot(S) a,HasDot(S) b) => ((b sto s) -> (a sto s)) -> (b sto a)
asDual (Cont f) = Dual (onDot f)
\end{code}
\vspace{-1mm}
where
\vspace{-1mm}
\begin{code}
onDot :: (HasDot(S) a,HasDot(S) b) => ((b sto s) -> (a sto s)) -> (b sto a)
onDot f = inv dot . f . dot
\end{code}

\newpage

From the new data type and the functor derived from it we can now do the same process as before and determine the instances for our new category:

\begin{code}

instance Category k => Category Dualk where
  id = Dual id
  Dual g . Dual f = Dual (f . g)
\end{code}
\vspace{-10mm}
\begin{code}
instance Monoidal k => Monoidal Dualk where
  Dual f >< Dual g = Dual (f >< g)
\end{code}
\vspace{-10mm}
\begin{code}
instance Cartesian k => Cartesian Dualk where
  exl = Dual inl ;  exr = Dual inr
  dup = Dual jam
\end{code}
\vspace{-10mm}
\begin{code}
instance Cocartesian k => Cocartesian Dualk where
  inl = Dual exl ; inr = Dual exr
  jam = Dual dup
\end{code}
\vspace{-10mm}
\begin{code}
instance Scalable k => Scalable Dualk where
  scale s = Dual(scale s)
\end{code}

This new instances dualize a computation exactly.

As final notes to this chapter we have that |(joinu)| and |(forku)| mutually dualize and that by that using the first definition of matrices that was derived in this paper,  dualizing a matrix is equivalent to transposing it, with the advantage of not requiring any matrix computations unless k requires them.

\section{Generalised FAD algorithm}

To derive a generalised FAD algorithm from the generalised AD algorithm and calculate gradients from it all that needs to be done has already been show in the previous 2 sections, taking into account we can simply consider 

\begin{code}
newtype Beginkr a b = Begin((r 'k' a) -> (r 'k' b))

begin :: Category k => (a 'k' b) -> Beginkr a b
begin f = Begin(f .)
\end{code}

for the instance deduction and that we can choose |r| to be the scalar field |s| knowing that |s| $\multimap$ |a| is isomorphic to |a| for the gradient calculation.

%15-end

\section{Scaling Up}
	A practical application of differentiation often involves high-dimensional spaces (we can see this in Artificial Neural Networks). \\
	With this in mind, we easily observe that binary products are a very unwieldy and inefficient way of encoding high-dimensional spaces.\\
	A practical alternative is to consider n-ary product as representable functors.
    
\begin{code}
    class Category k => MonoidalI k h where
        crossI :: h(a ‘k‘ b) -> (h a ‘k‘ h b)

    instance Zip h => MonoidalI (->) h where
        crossI = zipWith id
\end{code}
\vspace{-8mm}
\begin{code}
    class MonoidalI k h => CartesianI k h where
        exI     :: h (h a ‘k‘ a)
        replI   :: a ‘k‘ h a

    instance (Representable h, Zip h, Pointed h) => 
            CartesianI (->) h where
        exI = tabulate (flip index)
        replI = point    
\end{code}
\vspace{-8mm}
\begin{code}
    class MonoidalI k h => CocartesianI k h where
        inI :: h (a ‘k‘ h a)
        jamI :: h a ‘k‘ a

    instance (MonoidalI k h, Zip h) => MonoidalI Dk h where
        crossI fs = D ((id >< crossI) . unzip . crossI (fmap unD fs))

    instance (CocartesianI (->) h, CartesianI k h, Zip h) => CartesianI Dk h where
        exI = linearD exI exI
        replI = zipWith linearD replI replI

    instance (CocartesianI k h, Zip h) => CocartesianI Dk h where
        inI = zipWith linearD  inIF inl 
        jamI = linearD sum jamI    
 
\end{code}

\section{Implementation}
	\paragraph{} In order to implement several ideas of the article we've had to use a few language extensions.
	\paragraph{} The majority of the \textit{pseudo-code} in the article was already valid in Haskell with the aforementioned language extensions, but there were still things we had to add to the code.
	\begin{enumerate}
		\item 
		The first thing we thought was to use the already made Category in \textit{Control.Category}, but that proved to not be enough because in the article the author indicates the object types of a Category.
        
		In the already made Category, we could do something with Kinds to achieve this, but it would be strange to specify a Kind Additive with Data Kinds. So we decided to create a new Category, named CategoryDom, with kind (* \RAP Constraint) \RAP (* \RAP * \RAP *) \RAP Constraint, that receives a class which restricts the objects of a Category and the Category itself. Furthermore, the |id| and |(.)| are restricted by the first argument.
		\item
		The Additive also needed to have an instance with pair of Additive objects, so we could utilise dup without problems.
		\item 
		We've had to add Constraints in the context of some instances and change some code to fix certain subtle errors.
	\end{enumerate}
	\paragraph{} The code for the implementation can be found in the git project(\cite{project})
	
	\section{Future Work}
	\begin{itemize}
		\item 
		Generalise the idea to calculate second derivatives.
		\item 
		Implement the more efficient way that was introduced.
	\end{itemize}
	
	
	
	\newpage

\section{Bibliography}
\bibliographystyle{acm}%{ACM-Reference-Format}
\bibliography{relatorio}

    \end{document}
	
    