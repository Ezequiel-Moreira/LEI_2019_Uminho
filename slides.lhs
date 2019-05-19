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
%format fork = " \Delta "
%format join = " \nabla "
%format bigD = "\mathcal{D}"
%format bigDplus = "\mathcal{D}^{+}"
%format bigDhat = "\mathcal{\hat{D}}"
%format bigU = "\mathcal{U}"
%format bigV = "\mathcal{V}"
%format o = " \circ "
%format => = "\Rightarrow"
%format Dk = " D_k "
%format >< = " \times "
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

\section{Nelson}

\begin{frame}{titulo}
\end{frame}



\section{Categories}

\begin{frame}{Uma curta introdução}
\begin{itemize}
 \item<1-> Queremos calcular $\mathcal{D}^{+}$.
 \item<2-> Problema: $\mathcal{D}$ não é computável.
 \item<3-> Solução: observar corolários apresentados e implementar recorrendo a categorias.
\end{itemize}

\end{frame}



\begin{frame}{Uma curta introdução}

    \begin{block}{Corolário 1.1}
    NOTA: adicionar definição do corolário 1.1 aqui
    \end{block}
    
    \begin{block}{Corolário 2.1}
    NOTA: adicionar definição do corolário 2.1 aqui
    \end{block}
    
    \begin{block}{Corolário 3.1}
    NOTA: adicionar definição do corolário 3.1 aqui
    \end{block}
 
\end{frame}



\begin{frame}{Categorias clássicas}

Uma categoria é um conjunto de objetos(conjuntos e tipos) e de morfismos(operações entre objetos), tendo definidas 2 operações básicas, identidade e composição de morfismos, e 2 leis:

\begin{itemize}
    \item<1-> (C.1) ---- $id \circ f = id \circ f = f$ 
    \item<2-> (C.2) ---- $f \circ (g \circ h) = (f \circ g) \circ h$
\end{itemize}


\begin{block}

Para os efeitos deste papel, objetos são tipos de dados e morfismos são funções

\end{block}

\begin{block}

\begin{columns}
 
\column{0.5\textwidth}
class \textit{Category k} where

\hspace{0.2cm}id :: (a'k'a)
    
\hspace{0.2cm}($\circ$) :: (b'k'c) → (a'k'b) → (a'k'c)
 
\column{0.5\textwidth}
instance \textit{Category (→)} where

\hspace{0.2cm}id = $\lambda$a → a 

\hspace{0.2cm}$g \circ f = \lambda$a → g (f a)  

\end{columns}

\end{block}

\end{frame}




\begin{frame}{Functores clássicos}


Um functor \textit{F} entre categorias $\mathcal{U}$ e $\mathcal{V}$ é tal que:
\begin{itemize}
    \item para qualquer objeto t $\in \mathcal{U}$ temos que \textit{F} t $\in \mathcal{V}$
    \item para qualquer morfismo m :: a → b $\in \mathcal{U}$ temos que \textit{F} m :: \textit{F} a → \textit{F} b $\in \mathcal{V}$
    \item \textit{F} id ($\in \mathcal{U}$) = id ($\in \mathcal{V}$)
    \item \textit{F} ($f \circ g$) = \textit{F} f $\circ$ \textit{F} g
\end{itemize}


\begin{block}{Nota}
Devido à definição de categoria deste papel(objetos são tipos de dados) os functores mapeiam tipos neles próprios.
\end{block}

\end{frame}

\begin{frame}{Objetivo}

Começamos por definir um novo tipo de dados:

newtype $\mathcal{D}$ a b = $\mathcal{D}$($a → b \times (a \multimap b)$)

Depois adaptamos $\mathcal{D}^{+}$ para usar este tipo de dados:

\begin{block}{Definição adaptada}

$\mathcal{\hat{D}}$ :: (a → b) → $\mathcal{D}$ a b

$\mathcal{\hat{D}}$ f = $\mathcal{D}$($\mathcal{D}^{+}$ f)

\end{block}

O nosso objetivo é a dedução de uma instância de categoria para $\mathcal{D}$ onde $\mathcal{\hat{D}}$ seja functor.


\end{frame}



\begin{frame}{Dedução da instância}

Recordando os corolários 3.1 e 1.1 deduzimos que
\begin{itemize}
    \item (DP.1) ---- $\mathcal{D}^{+} id$ = $\lambda$a → (id a,id)
    \item (DP.2) ----
    
    $\mathcal{D}^{+}(g \circ f)$ = $\lambda a → let\{(b,f')$ = $\mathcal{D}^{+}$ f a; $(c,g') = \mathcal{D}^{+}$ g b \} in $(c,g' \circ f'$)   
\end{itemize}

$\mathcal{\hat{D}}$ ser functor é equivalente a dizer que, para todas as funções f e g de tipos apropriados:

\begin{itemize}
    \item id = $\mathcal{\hat{D}}$ id = $\mathcal{D} (\mathcal{D}^{+} id)$
    \item $\mathcal{\hat{D}}$ g $\circ$ $\mathcal{\hat{D}}$ f = $\mathcal{\hat{D}}$  (g $\circ$ f) = $\mathcal{D} (\mathcal{D}^{+} (g \circ f))$
\end{itemize}

\end{frame}


\begin{frame}{Dedução da instância}

Com base em (DP.1) e (DP.2) podemos reescrever como sendo:
\begin{itemize}
    \item id = $\mathcal{D} (\lambda$a → (id a,id))
    \item $\mathcal{\hat{D}}$ g $\circ$ $\mathcal{\hat{D}}$ f = $\mathcal{D}$ ( $\lambda a → let\{(b,f')$ = $\mathcal{D}^{+}$ f a; $(c,g') = \mathcal{D}^{+}$ g b \} in $(c,g' \circ f'$) )
\end{itemize}

Resolver a primeira equação é trivial(definir id da instância como sendo $\mathcal{D} (\lambda$a → (id a,id))).


A segunda equação será resolvida resolvendo uma condição mais geral:
$\mathcal{D} g \circ \mathcal{D} f$ = $\mathcal{D}$($\lambda a → let\{(b,f')$ = f a; $(c,g')$ = g b \} in $(c,g' \circ f'$)), cuja solução é igualmente trivial.


\end{frame}

\begin{frame}{Dedução da instância}


\begin{block}{Definição de $\mathcal{\hat{D}}$ para funções lineares}
linearD :: (a → b) → $\mathcal{D}$ a b

linearD f = $\mathcal{D}$($\lambda$a → (f a,f))
\end{block}

\begin{block}{Instância da categoria que deduzimos}

instance \textit{Category $\mathcal{D}$} where

\hspace{0.2cm}id = linearD id

\hspace{0.2cm}$\mathcal{D} g \circ \mathcal{D} f$ = $\mathcal{D}$($\lambda a → let\{(b,f')$ = f a; $(c,g')$ = g b \} in $(c,g' \circ f'$))

\end{block}


\end{frame}



\begin{frame}{Prova da instância}

Antes de continuarmos devemos verificar se esta instância obedece às leis (C.1) e (C.2).

Se considerarmos apenas morfismos $\hat{f}$ :: $\mathcal{D}$ a b tal que $\hat{f}$ = $\mathcal{D}^{+}$ f para f :: a → b(o que podemos garantir se transformarmos $\mathcal{D}$ a b em tipo abstrato) podemos garantir que $\mathcal{D}^{+}$ é functor.


\begin{block}{Prova de (C.1)}

id $\circ \mathcal{\hat{D}}$ 

=  $\mathcal{\hat{D}} id \circ \mathcal{\hat{D}}$ f -lei functor de id (especificação de $\mathcal{\hat{D}}$)

= $\mathcal{\hat{D}}$ (id $\circ$ f) - lei functor para ($\circ$)

= $\mathcal{\hat{D}}$ f - lei de categoria
\end{block}


\end{frame}

\begin{frame}{Prova da instância}

\begin{block}{Prova de (C.2)}

$\mathcal{\hat{D}}$ h $\circ$ ($\mathcal{\hat{D}}$ g $\circ$ $\mathcal{\hat{D}}$ f)

= $\mathcal{\hat{D}}$ h $\circ$ $\mathcal{\hat{D}}$ (g $\circ$ f) - lei functor para ($\circ$)

= $\mathcal{\hat{D}}$ (h $\circ$ (g $\circ$ f)) - lei functor para ($\circ$)

= $\mathcal{\hat{D}}$ ((h $\circ$ g) $\circ$ f) - lei de categoria

= $\mathcal{\hat{D}}$ (h $\circ$ g) $\circ$ $\mathcal{\hat{D}}$  f - lei functor para ($\circ$)

= ($\mathcal{\hat{D}}$ h $\circ$ $\mathcal{\hat{D}}$ g) $\circ$ $\mathcal{\hat{D}}$ f - lei functor para ($\circ$)

\end{block}

\begin{alertblock}{Nota}
Estas provas não requerem nada de $\mathcal{D}$ e $\mathcal{\hat{D}}$ para além das leis do functor, logo nas próximas instâncias deduzidas de um functor não precisamos de voltar a realizar estas provas.

\end{alertblock}

\end{frame}




\begin{frame}{Categorias e functores monoidais}

A versão generalizada da composição paralela será definida através de uma categoria monoidal:

\begin{block}


\begin{columns}
 
\column{0.5\textwidth}
class \textit{Category k} $\Rightarrow$ \textit{Monoidal k} where

\hspace{0.2cm}($\times$)::(a'k'c)→(b'k'd)→((a$\times$b)'k'(c$\times$d))
 
\column{0.4\textwidth}
instance \textit{Monoidal (→)} where

\hspace{0.2cm}$f \times g= \lambda$(a,b)→(f a,g b)  

\end{columns}

\end{block}


\begin{block}{Definição de functor monoidal}

Um functor \textit{F} monoidal entre categorias $\mathcal{U}$ e $\mathcal{V}$ é tal que:
\begin{itemize}
    \item \textit{F} é functor clássico
    \item \textit{F} (f $\times$ g) = \textit{F} f $\times$ \textit{F} g
\end{itemize}

\end{block}

\end{frame}



\begin{frame}{Dedução da instância}

A partir do corolário 2.1 deduzimos que:

$\mathcal{D}^{+}$ (f $\times$ g) = $\lambda$(a,b) → let\{(c,f' )= $\mathcal{D}^{+}$ f a; (d,g') = $\mathcal{D}^{+}$ g b \} in ((c,d),f'$\times$g')

Se definirmos o functor F a partir de $\mathcal{\hat{D}}$ chegamos à seguinte condição:

$\mathcal{D}$($\mathcal{D}^{+}$ f) $\times$ $\mathcal{D}$($\mathcal{D}^{+}$ g) = $\mathcal{D}$($\mathcal{D}^{+}$ (f $\times$ g))

Substituindo e fortalecendo-a obtemos:

$\mathcal{D}$ f $\times$ $\mathcal{D}$ g = $\mathcal{D}$($\lambda$(a,b) → let\{(c,f') = f a; (d,g') =  g b \} in ((c,d),f'$\times$g'))

e esta condição é suficiente para obtermos a nossa instância.

\end{frame}


\begin{frame}{Dedução da instância}

\begin{block}{Instância da categoria que deduzimos}

instance \textit{Monoidal $\mathcal{D}$} where

\hspace{0.2cm}$\mathcal{D}$ f $\times$ $\mathcal{D}$ g = $\mathcal{D}$($\lambda$(a,b) → let\{(c,f') = f a; (d,g') =  g b \} in ((c,d),f'$\times$g'))

\end{block}

\end{frame}



\begin{frame}{Categorias e funtores cartesianas}

\begin{block}

\begin{columns}
 
\column{0.5\textwidth}
class \textit{Monoidal k} $\Rightarrow$ \textit{Cartesean k} where

\hspace{0.2cm}exl :: (a$\times$b)'k'a

\hspace{0.2cm}exr :: (a$\times$b)'k'b

\hspace{0.2cm}dup :: a'k'(a$\times$a)
 
\column{0.4\textwidth}
instance \textit{Cartesean (→)} where

\hspace{0.2cm}exl = $\lambda$(a,b) → a

\hspace{0.2cm}exr = $\lambda$(a,b) → b

\hspace{0.2cm}dup = $\lambda$a → (a,a)

\end{columns}

\end{block}


\begin{block}


Um functor \textit{F} cartesiano entre categorias $\mathcal{U}$ e $\mathcal{V}$ é tal que:
\begin{itemize}
    \item \textit{F} é functor monoidal
    \item \textit{F} exl = exl
    \item \textit{F} exp = exp
    \item \textit{F} dup = dup
\end{itemize}


\end{block}


\end{frame}




\begin{frame}{Dedução da instância}

Pelo corolário 3.1 e pelo facto que exl,exr e dup são linerares deduzimos que:

$\mathcal{D}^{+}$ exl $\lambda$p → (exp p, exl)

$\mathcal{D}^{+}$ exr $\lambda$p → (exr p, exr)

$\mathcal{D}^{+}$ dup $\lambda$a → (dup a, dup)

Após esta dedução podemos continuar a determinar a instância:

exl = $\mathcal{D}$($\mathcal{D}^{+}$ exl)

exr = $\mathcal{D}$($\mathcal{D}^{+}$ exr)

dup = $\mathcal{D}$($\mathcal{D}^{+}$ dup)

\end{frame}



\begin{frame}{Dedução da instância} 

Substituindo e usando a definição de linearD obtemos:

exl = linearD exl

exr = linearD exr

dup = linearD dup

E podemos converter a dedução acima diretamente em instância:

\begin{block}{Instância da categoria que deduzimos}

instance \textit{Cartesian $\mathcal{D}$} where

\hspace{0.2cm}exl = linearD exl

\hspace{0.2cm}exr = linearD exr

\hspace{0.2cm}dup = linearD dup

\end{block}

\end{frame}



\begin{frame}{Categorias cocartesianas}

São o dual das categorias cartesianas.
\begin{block}{Nota}
Neste papel os coprodutos correspondem aos produtos das categorias, i.e., categorias de biprodutos.
\end{block}

\begin{block}

class \textit{Category k} $\Rightarrow$ \textit{Cocartesian k} where:

\hspace{0.2cm}inl :: a'k'(a$\times$b)

\hspace{0.2cm}inlr:: b'k'(a$\times$b)

\hspace{0.2cm}jam :: (a$\times$a)'k'a

\end{block}


\end{frame}


\begin{frame}{Functores cocartesianos}

\begin{block}{Definição de functor cocartesiano}


Um functor \textit{F} cartesiano entre categorias $\mathcal{U}$ e $\mathcal{V}$ é tal que:
\begin{itemize}
    \item \textit{F} é functor 
    \item \textit{F} inl = inl
    \item \textit{F} inr = inr
    \item \textit{F} jam = jam
\end{itemize}


\end{block}


\end{frame}

\section{Fork and Join}
\begin{slide}{Fork and Join}
    \begin{itemize}
        \item
            |fork :: Cartesian k => (a 'k' c) -> (a 'k' d) -> (a 'k' (c >< d))|
        \item
            |join :: Cartesian k => (c 'k' a) -> (d 'k' a) -> ((c >< d) 'k' a)|
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

\section{Operacoes Numericas}
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
        mulC = D (\(a, b) -> (a * b, scale b join scale a))

    instance FloatingCat D where
        sinC = D(\a -> (sin a, scale (cos a)))
        cosC = D(\a -> (cos a, scale (-sin a)))
        expC = D(\a -> let e=exp a in (e, scale e))
        ...
        
\end{code}
\end{frame}

\section{Examples}
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
|sqr = mulC o (id fork id)|\\
|magSqr = addC o (mulC o (exl fork exl) fork mulC o (exr fork exr))|\\
|cosSinProd = (cosC fork sinC) o mulC|\\
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
        mulC = D (\(a, b) -> (a * b, scale b join scale a))
\end{code}
\end{frame}

% Part 2
\section{Scaling Up}
\begin{frame}
\begin{itemize}
\item
Practical applications often involves high-dimensional spaces.
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

    class (Representable h, Zip h, Pointed h) => 
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
        crossI fs = D ((id >< crossI) o unzip o crossI (fmap unD fs))

    instance (CocartesianI (->) h, CartesianI k h, Zip h) =>
            CartesianI Dk h where
        exl = linearD exl exl
        replI = zipWith linearD replI replI

    instance (CocartesianI k h, Zip h) => CocartesianI Dk h where
        inI = zipWith linearD  inIF inl 
        jamI = linearD sum jamI    
 
\end{code}
\end{frame}

\section{Related Work and conlusion}
\begin{frame}
\begin{itemize}
\item
    Suggests that some of the work refered does just a part of this paper.
\item
    This paper was a continuation of the [Elliot 2017]
\item
    Suggests that this implementation is simple, efficient, it can free memory dinamically (RAD) and is naturally parallel.
\item
    Future work are detailed performace analysis; higher-order differentiation and automatic incrementation (continuing previous work [Elliot 2017])
\end{itemize}
\end{frame}



%fim

%============================EXEMPLO==========================
%\section{Introduction}
%
%\subsection[Short First Subsection Name]{First Subsection Name}
%
%\begin{frame}{Make Titles Informative. Use Uppercase Letters.}{Subtitles are optional.}
%  % - A title should summarize the slide in an understandable fashion
%  %   for anyone how does not follow everything on the slide itself.
%
%  \begin{itemize}
%  \item
%    Use \texttt{itemize} a lot.
%  \item
%    Use very short sentences or short phrases.
%  \end{itemize}
%\end{frame}
%
%\begin{frame}{Make Titles Informative.}
%
%  You can create overlays\dots
%  \begin{itemize}
%  \item using the \texttt{pause} command:
%    \begin{itemize}
%    \item
%      First item.
%      \pause
%    \item    
%      Second item.
%    \end{itemize}
%  \item
%    using overlay specifications:
%    \begin{itemize}
%    \item<3->
%      First item.
%    \item<4->
%      Second item.
%    \end{itemize}
%  \item
%    using the general \texttt{uncover} command:
%    \begin{itemize}
%      \uncover<5->{\item
%        First item.}
%      \uncover<6->{\item
%        Second item.}
%    \end{itemize}
%  \end{itemize}
%\end{frame}
%
%\begin{frame}{}
%\end{frame}
%
%\subsection{Second Subsection}
%
%\begin{frame}{Make Titles Informative.}
%\end{frame}
%
%
%
%\section{Summary}
%
%\subsection{coisas1}
%
%\begin{frame}{Summary}
%
%  % Keep the summary *very short*.
%  \begin{itemize}
%  \item
%    The \alert{first main message} of your talk in one or two lines.
%  \item
%    The \alert{second main message} of your talk in one or two lines.
%  \item
%    Perhaps a \alert{third message}, but not more than that.
%  \end{itemize}
%  
%  % The following outlook is optional.
%  \vskip0pt plus.5fill
%  \begin{itemize}
%  \item
%    Outlook
%    \begin{itemize}
%    \item
%      Something you haven't solved.
%    \item
%      Something else you haven't solved.
%    \end{itemize}
%  \end{itemize}
%\end{frame}
%
%\subsection{coisas2}
%\begin{frame}{coisas2}
%
%
%\end{frame}
%=================================================================

\end{document}


