
--composição paralela de 2 funções
cross :: (a -> c) -> (b -> d) -> ((a,b) -> (c,d))
cross f g = \(a,b) -> (f a, g b)

--derivada de função
--https://wiki.haskell.org/Functional_differentiation
--note-se que está a calcular a derivada num certo ponto h,
--sendo que a nossa solução é dada por um lim quando h->0
derive :: (Fractional a) => a -> (a -> a) -> (a -> a)
derive h f x = (f (x+h) - f x) / h

--alternativa "equivalente" à anterior 
--mas mais conveniente para calcular limite
deriveAlt :: (Fractional a) => (a -> a) -> a -> (a-> a)
deriveAlt f x h = (f (x+h) - f x) / h

--lim dado certo valor x
--extremamente complexo para casos limite, rever mais tarde
--temporariamente retornará 2 valores ao lado do valor pedido
lim :: (RealFloat a) => (a -> a) -> a -> (a,a)
lim f x = if isNaN(f x)
          then (limAux (-0.000001) f x,limAux (0.000001) f x)
          else (f x,f x)

--limite recursiva auxiliar para a função acima
limAux :: (RealFloat a) => a -> (a -> a) -> a -> a
limAux h f x = if isNaN(f x)
               then limAux h f (x+h)
               else f x

--calcular valor da derivada de função f para um ponto x quando perto de h
--versão inicial
--note-se que como o lim não está bem definido, este também não o estará
d :: (Fractional a,RealFloat a) => (a -> a) -> a -> (a,a)
d f x = let fd = deriveAlt f x
        in lim fd 0
