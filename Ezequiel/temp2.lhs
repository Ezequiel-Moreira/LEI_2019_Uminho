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


\section{Reverse-Mode Automatic Differentiation(RAD)}


\begin{frame}{A short introdution}

\begin{itemize}
    \item<1-> In chapter 4 we've derived an AD algorithm that was generalized in figure 6 of the document
    \item<2-> With fully right-associated compositions this algorithm becomes a foward-mode AD and with fully left-associated becomes a reverse-mode AD
    \item<3-> We want to obtain generalized FAD and RAD algorithms 
    \item<4-> How do we describe this in Categorical notation?
\end{itemize}

\end{frame}




\begin{frame}{Converting morfisms}

Given a category k we can represent its morfisms the following way:

\begin{block}{Left-Compose functions}
f :: a'k'b |=>| ($\circ$ f) :: (b'k'r) |->| (a'k'r) where r is any object of k.
\end{block}

If h is the morfism we'll compose with f then h is the continuation of f.
\end{frame}




\begin{frame}{Instance deduction}

\begin{block}{Defining new type}
\begin{code}
newtype Cont(k,r) a b = Cont((b'k'r) -> (a'k'r))
\end{code}
\end{block}

\begin{block}{Functor derived from type}
\begin{code}
cont :: Category k => (a 'k' b) -> Cont(k,r) a b
cont f = Cont(. f)
\end{code}
\end{block}

\end{frame}



\begin{frame}{Instance deduction}
\begin{code}

instance Category k => Category Cont(k,r)where
  id = Cont id
  Cont g . Cont f = Cont(f . g)

instance Monoidal k => Monoidal Cont(k,r)where
  Conf f x Cont g = Cont(join . (f x g) . unjoin)

instance Cartesian k => Cartesian Cont(k,r) where
  exl = Cont(join . inl) ; exr = Cont(join . inr) 
  dup = Cont(jam . unjoin)

instance Cocartesian k => Cocartesian Cont(k,r) where
  inl = Cont(exl . unjoin) ; inr = Cont(exr . unjoin) 
  jam = Cont(join . dup)

instance Scalable k a => Scalable Cont(k,r) a where
  scale s = Cont(scale s)


\end{code}
\end{frame}







\section{Gradient and Duality}

\begin{frame}{A short introdution}

Due to it's widespread use in ML we'll talk about a specific case of RAD: computing gradients(derivatives of functions with scalar codomains)

A vector space A over a scalar field has A $\multimap$ s as its dual.

Each linear map in A $\multimap$ s can be represented in the form of dot u for some u :: A where

\begin{block}{Definition and instanciation}
\begin{code}
class HasDot(S) u where dot :: u -> (u -o s)

instance HasDot(IR) IR where dot = scale 

instance (HasDot(S) a,HasDot(S) b) 
  => HasDot(S) (a x b) 
  where dot(u,v) = dot u fork dot v
\end{code}
\end{block}

\end{frame}



\begin{frame}{Instance deduction}

The internal representation of $Cont_{\multimap}^{s}$ a b is (b $\multimap$ s) -> (a $\multimap$ s) which is isomorfic to (a -> b).

\begin{block}{Type definition for duality}
\begin{code}
newtype Dual(K) a b = Dual(b'k'a)
\end{code}
\end{block}

\end{frame}




\begin{frame}{Instance deduction}

All we need to do to create dual representations of linear maps is to
convert from $Cont_{k}^{S}$ to $Dual_{k}$ using a functor:

\begin{block}{Functor definition}
\begin{code}
asDual :: (HasDot(S) a,HasDot(S) b) => 
  ((b -o s) -> (a -o s)) -> (b -o a)
asDual (Cont f) = Dual (onDot f)
\end{code}

where

\begin{code}
onDot :: (HasDot(S) a,HasDot(S) b) => 
  ((b -o s) -> (a -o s)) -> (b -o a)
onDot f = dot^-1 . f . dot
\end{code}
\end{block}

\end{frame}



\begin{frame}{Instance deduction}
\begin{code}

instance Category k => Category Dual(k) where
  id = Dual id
  Dual g . Dual f = Dual (f . g)

instance Monoidal k => Monoidal Dual(k) where
  Dual f x Dual g = Dual (f x g)

instance Cartesian k => Cartesian Dual(k) where
  exl = Dual inl ;  exr = Dual inr ;  dup = Dual jam

instance Cocartesian k => CocartesianDual(k) where
  inl = Dual exl ; inr = Dual exr ; jam = Dual dup

instance Scalable k => Scalable Dual(k) where
  scale s = Dual(scale s)

\end{code}
\end{frame}



\begin{frame}{Final notes}

\begin{itemize}
  \item |join and fork| mutually dualize 
  
  |(Dual f join Dual g = Dual (f fork g) and Dual f fork Dual g = Dual(f join g))|
  \item Using the definition from chapter 8 we can determine that the duality of a matrix corresponds to it's transposition
\end{itemize}

\end{frame}







\section{Foward-Mode Automatic Differentiation(FAD)}

\begin{frame}{Fowards-mode Automatic Differentiation(FAD)}

We can use the same deductions we've done in Cont and Dual to derive a category with full right-side association, thus creating a generized FAD algorithm.

This algorithm is far more apropriated for low dimention domains.


\begin{block}{Type definition and functor from type}
\begin{code}
newtype Begin(k,r) a b = Begin((r'k'a) -> (r'k'b))

begin :: Category k => (a 'k' b) -> Begin(k,r) a b
begin f = Begin(f .)
\end{code}
\end{block}

We can derive categorical instances from the functor above and we can choose r to be the scalar field s, noting that s $\multimap$ a is isomorfic to a.


\end{frame}



\end{document}


