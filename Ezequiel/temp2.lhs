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




\begin{frame}{A short introdution}


\begin{itemize}
    \item<1-> In chapter 4 we've derived an AD algorithm that was generalized in figure 6 of the document
    \item<2-> With fully right-associated compositions this algoritm becomes a foward-mode AD and with fully left-associated becomes a reverse-mode AD
    \item<3-> We want to obtain generalized FAD and RAD algoritms 
    \item<4-> How do we describe this in Categorical notation?
\end{itemize}

\end{frame}




\begin{frame}{Converting morfisms}

Given a category k we can represent its morfisms using the intent to left-compose with another morfism:

|f :: a'k'b becomes (\circ f) :: (b'k'r) -> (a'k'r)| where r is any object of k.
If h is the morfism we'll compose with f then h is the continuation of f.

With this idea in mind we can derive a category based on it, creating a generalization of the RAD algoritm.

\end{frame}




\begin{frame}{Instance deduction}

We'll begin by creating a new data type:

|newtype  Cont_{k}^{r} a b = Cont((b'k'r) -> (a'k'r))|

And then defining a functor from it:
\begin{code}
cont :: Category k => (a 'k' b) -> Cont_{k}^{r} a b
cont f = Cont(\circ f)
\end{code}


With this we can derive new categorical isntances:

\end{frame}



\begin{frame}{Instance deduction}
\begin{code}

newtype  Cont_{k}^{r} a b = Cont((b'k'r) -> (a'k'r))

instance Category k => Category Cont_{k}^{r} where
  id = Cont id
  Cont g \circ Cont f = Cont(f \circ g)

instance Monoidal k => Monoidal Cont_{k}^{r} where
  Conf f \times Cont g = Cont(join \circ (f \times g) \circ unjoin)

instance Cartesian k => Cartesian Cont_{k}^{r} where
  exl = Cont(join \circ inl)
  exr = Cont(join \circ inr)
  dup = Cont(jam \circ unjoin)

instance Cocartesian k => Cocartesian Cont_{k}^{r} where
  inl = Cont(exl \circ unjoin)
  inr = Cont(exr \circ unjoin)
  jam = Cont(join \circ dup)

instance Scalable k a => Scalable Cont_{k}^{r} a where
  scale s = Cont(scale s)


\end{code}
\end{frame}







\section{Gradient and Duality}
\begin{frame}{Esboço}

Continuando da secção anterior vamos falar de um caso especial de RAD: computação de gradientes.

Dado um espeço vetorial A sobre um campo escalar s o dual de A é A \multimap s(mapas lineares para o campo s).
Como este espaço dual também é vetorial e A é finito concluimos que tanto o dual como o primal são isomorfos.

Em particular, cada mapa de A \multimap s pode ser exprimido na forma dot u para u :: A onde:

|class HasDot^{S} u where dot :: u -> (u \multimap s)|
|instance HasDot^{IR} where dot=scale|
|instance (HasDot^{S} a,HasDot^{S} b) => HasDot^{S} (a \times b) where dot(u,v) = dot u fork dot v|

Como o tipo |Cont_{k}^{r}| pode tomar qualquer tipo/objeto r, usaremos o valor do campo s para r.
Assim a representação interna de |Cont_{s}^{\multimap} a b| é |(b \multimap s) -> (a \multimap s)|, que 
,pela isomorfia de s e seu espaço dual, é isomorfo a |b -> a|.
A esta representação chamaremos dual(ou oposto) de k:
|newtype Dual_{k} a b = Dual(b 'k' a)|


Para criarmos representações duais de mapas lineares generalizados basta converter de |Cont_{k}^{s}| para
|Dual_{k}| através de um funtor que iremos derivar a seguir, sendo que a composição deste com a função
|cont::(a'k'b) -> Cont_{k}^{s} a b| nos dará um funtor de k para |Dual_{k}|.

O funtor em questão é

\begin{code}
asDual :: (HasDot^{S} a,HasDot^{S} b) => ((b \multimap s) -> (a \multimap s)) -> (b \multimap a)
asDual (Cont f) = Dual (onDot f)
\end{code}

,onde onDot é definido por:

\begin{code}
onDot :: (HasDot^{S} a,HasDot^{S} b) => ((b \multimap s) -> (a \multimap s)) -> (b \multimap a)
onDot f = dot^{"-1"} \circ f \circ dot
\end{code}

A partir deste novo funtor derivamos as isntâncias de categoria correspondentes(ver figura 10)
e provamos que asDual é homomorfismo nessas instâncias.

Adicionalmente obtemos o seguinte corolário:

|Dual f join Dual g = Dual(f fork g)|
|Dual f fork Dual g = Dual(f join g)|

Note-se que com base na representação do capitulo 8 de matrizes podemos
concluir que a dualidade de matrizes corresponde à transposição das mesmas,
e que |Dual_{k}| não involve calculos de matrizes sem que k também os envolva.


\end{frame}







\begin{frame}{A short introdution}

Due to it's widespread use in ML we'll talk about a specific case of RAD: computing gradients(derivatives of functions with scalar codomains)

A vector space A over a scalar field has |A \multimap s| as it's dual(i.e., the linear maps of the udnerlaying field of A are it's dual)
This dual space is also a vector space and if A is finite in dimention they are isomorfic.

Each linear map in |A \multimap s| can be represented in the form of dot u for some u :: A where

|class HasDot^{S} u where dot :: u -> (u \multimap s)|
|instance HasDot^{IR} IR where dot = scale |
|instance (HasDot^{S} a,HasDot^{S} b) => HasDot^{S} (a \times b) where dot(u,v) = dot u fork dot v|


\end{frame}



\begin{frame}{Instance deduction}

Since |Cont_{k}^{r}| works for any type/object r we can use it with the scalar field s.
The internal representation of |Cont_{\multimap}^{s} a b| is |(b \multimap s) -> (a \multimap s) and that this is isomorfic to (a -> b)|,
With this in mind we can call this representation as the dual/opposite of k:

|newtype Dual_{k} a b = Dual(b'k'a)|

\end{frame}




\begin{frame}{Instance deduction}

With this construction all we need to do to create dual representations of linear maps is to
convert from |Cont_{k}^{S}| to |Dual_{k}| using a functor that we'll now derive:

\begin{code}
asDual :: (HasDot^{S} a,HasDot^{S} b) => ((b \multimap s) -> (a \multimap s)) -> (b \multimap a)
asDual (Cont f) = Dual (onDot f)
\end{code}

where

\begin{code}
onDot :: (HasDot^{S} a,HasDot^{S} b) => ((b \multimap s) -> (a \multimap s)) -> (b \multimap a)
onDot f = dot^{"-1"} \circ f \circ dot
\end{code}

Given this we can now derive our new categorical instances

\end{frame}



\begin{frame}{Instance deduction}
\begin{code}

instance Category k => Category Dual_{k} where
  id = Dual id
  Dual g \circ Dual f = Dual (f \circ g)

instance Monoidal k => Monoidal Dual_{k} where
  Dual f \times Dual g = Dual (f \times g)

instance Cartesian k => Cartesian Dual_{k} where
  exl = Dual inl
  exr = Dual inr
  dup = Dual jam

instance Cocartesian k => Cocartesian Dual_{k} where
  inl = Dual exl
  inr = Dual exr
  jam = Dual dup

instance Scalable k => Scalable Dual_{k} where
  scale s = Dual(scale s)

\end{code}
\end{frame}



\begin{frame}{Final notes}

\begin{itemize}
  \item |join and fork| mutually dualize |(Dual f join Dual g = Dual (f fork g) and Dual f fork Dual g = Dual(f join g))|
  \item Using the definition from chapter 8 we can determine that the duality of a matrix corresponds to it's transposition
\end{itemize}

\end{frame}

















\section{Foward-Mode Automatic Differentiation(FAD)}
\begin{frame}{Esboço}

Tendo criado o Cont e o Dual podemos aplicar as mesmas técnicas para tentar criar composição
totalmente à direita de modo a definir um algoritmo generalizado para FAD que é mais apropriado
a dominios de baixa dimensão.

|newtype Begin_{k}^{r} a b = Begin((r 'k' a) -> (r 'k' b))|

\begin{code}

begin :: Category k => (a 'k' b) -> Begin_{k}^{r} a b
begin f = Begin(f \circ)

\end{code}


Após termos isto definido podemos aplicar o mesmo processo que feito anteriormente por especificação
homomorfica para begin, e escolhendo r como campo escalar de s notando que |s \multimap a| é isomorfico a a



\end{frame}







\begin{frame}{Fowards-mode Automatic Differentiation(FAD)}

We can use the same deductions we've done in Cont and Dual to derive a category with full right-side association, thus creating a generized FAD algorithm.
This algorithm is far more apropriated for low dimention domains.

|newtype Begin_{k}^{r} a b = Begin((r'k'a) -> (r'k'b))|

\begin{code}
begin :: Category k => (a 'k' b) -> Begin_{k}^{r} a b
begin f = Begin(f \circ)
\end{code}

We can derive categorical instances from the functor above and we can choose r to be the scalar field s, noting that |s \multimap a| is isomorfic to a.


\end{frame}














\end{document}


