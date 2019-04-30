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
%format ->+ = "\rightarrow^+ "
%format join = " \bigtriangleup "
%format fork = " \bigtriangledown "
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

\section{Nelson}

\begin{frame}{titulo}
\end{frame}


\section{Ezequiel}

\begin{frame}{titulo}
\end{frame}

\section{Fork e Join}
\begin{frame}{Fork e Join}
    \begin{itemize}
        \item
            $(\bigtriangleup)$ :: Cartesian k $\Rightarrow$ (a 'k' c) $\to$ (a 'k' d) $\to$ (a 'k' (c $\times$ d))
        \item
            $(\bigtriangledown)$ :: Cartesian k $\Rightarrow$ (c 'k' a) $\to$ (d 'k' a) $\to$ ((c $\times$ d) 'k' a)
    \end{itemize}
\end{frame}
\begin{frame}{instancia de $\to^+$}
    \textbf{newtype} a $\to^+$ b = AddFun (a → b)\\
    \vspace{2mm} 
    \textbf{instance} Category ($\to^+$) \textbf{where}\\
        \hspace{1cm}type Obj ($\to^+$) = Additive\\
        \hspace{1cm}id = AddFun id\\
        \hspace{1cm}AddFun g $\circ$ AddFun f = AddFun (g $\circ$ f )\\
    \vspace{2mm} 
    \textbf{instance} Monoidal ($\to^+$) \textbf{where}\\
        \hspace{1cm}AddFun f × AddFun g = AddFun (f × g)\\
    \vspace{2mm} 
    \textbf{instance} Cartesian ($\to^+$) \textbf{where}\\
        \hspace{1cm}exl = AddFun exl\\
        \hspace{1cm}exr = AddFun exr\\
        \hspace{1cm}dup = AddFun dup\\
\end{frame}
\begin{frame}{instancia de $\to^+$}
    \textbf{instance} Cocartesian ($\to^+$) \textbf{where}\\
        \hspace{1cm} inl = AddFun inlF\\
        \hspace{1cm} inr = AddFun inrF\\
        \hspace{1cm} jam = AddFun jamF\\
    \vspace{2mm} 
    inlF :: Additive b ⇒ a → a × b\\ 
    inrF :: Additive a ⇒ b → a × b\\
    jamF :: Additive a ⇒ a × a → a\\
    \vspace{2mm} 
    inlF = $\lambda$a → (a, 0)    \\ 
    inrF = $\lambda$b → (0, b)    \\
    jamF = $\lambda$(a, b) → a + b\\ 
\end{frame}

\section{Operacoes Numericas}
\begin{frame}{definição de NumCat}
    \textbf{class} NumCat k a \textbf{where}\\
        \hspace{1cm}negateC :: a ‘k‘ a\\
        \hspace{1cm}addC :: (a × a) ‘k‘ a\\
        \hspace{1cm}mulC :: (a × a) ‘k‘ a\\
        \hspace{1cm}...\\
    \vspace{2mm} 
    \textbf{instance} Num a ⇒ NumCat (→) a \textbf{where}\\
        \hspace{1cm}negateC = negate\\
        \hspace{1cm}addC = uncurry (+)\\
        \hspace{1cm}mulC = uncurry (·)\\
        \hspace{1cm}...\\
\end{frame}
\begin{frame}
    D (negate u) = negate (D u)\\
    D (u + v) = D u + D v\\
    D (u · v) = u · D v + v · D u\\
    \begin{itemize}
        \item
            Impreciso na natureza de u e v.
        \item
            Algo mais preciso seria defenir a diferenciação das operações em si.
    \end{itemize}
\end{frame}
\begin{frame}
    \textbf{class} Scalable k a \textbf{where}\\
        \hspace{1cm}scale :: a → (a ‘k‘ a)\\
    \vspace{2mm} 
    \textbf{instance} Num a ⇒ Scalable ($\to^+$) a \textbf{where}\\
        \hspace{1cm}scale a = AddFun ($\lambda$da → a · da)\\
    \vspace{5mm} 
    \textbf{instance} NumCat D \textbf{where}\\
        \hspace{1cm}negateC = linearD negateC\\
        \hspace{1cm}addC = linearD addC\\
        \hspace{1cm}mulC = D ($\lambda$(a, b) → (a · b, scale b $\bigtriangledown$ scale a))\\
\end{frame}

\section{Generalizing Automatic Differentiation}
\begin{frame}{Generalizing Automatic Differentiation}
    newtype $D_k$ a b = D (a → b × (a ‘k‘ b))\\
    \vspace{2mm} 
    linearD :: (a → b) → (a ‘k‘ b) → $D_k$ a b\\
    linearD f f'= D ($\lambda$a → (f a, f'))\\
    \vspace{2mm} 
    \textbf{instance} Category k ⇒ Category $D_k$ \textbf{where}\\
        \hspace{1cm}type Obj $D_k$ = Additive ∧ Obj k ...\\
    \vspace{2mm} 
    \textbf{instance} Monoidal k ⇒ Monoidal $D_k$ \textbf{where} ...\\
    \vspace{2mm} 
    \textbf{instance} Cartesian k ⇒ Cartesian $D_k$ \textbf{where} ...\\
    \vspace{2mm} 
    \textbf{instance} Cocartesian k ⇒ Cocartesian $D_k$ \textbf{where}\\
        \hspace{1cm}inl = linearD inlF inl\\
        \hspace{1cm}inr = linearD inrF inr\\
        \hspace{1cm}jam = linearD jamF jam\\
    \vspace{2mm} 
\end{frame}

\begin{frame}
    \textbf{instance} Scalable k s ⇒ NumCat $D_k$ s \textbf{where}\\
        \hspace{1cm}negateC = linearD negateC negateC\\
        \hspace{1cm}addC = linearD addC addC\\
        \hspace{1cm}mulC = D ($\lambda$(a, b) → (a · b, scale b $\bigtriangledown$ scale a))\\
\end{frame}

\section{Exemplos}
\begin{frame}{Exemplos}
\end{frame}

\section{Generalizar}
\begin{frame}{Generalizar}
\end{frame}

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


