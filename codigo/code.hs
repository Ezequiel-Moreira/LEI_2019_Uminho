
--composição paralela de 2 funções
cross :: (a -> c) -> (b -> d) -> ((a,b) -> (c,d))
cross f g = \(a,b) -> (f a, g b)

