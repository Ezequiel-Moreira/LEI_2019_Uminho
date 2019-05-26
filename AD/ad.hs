import qualified Control.Category as C
import Data.Kind as K

class CategoryNum k where
    idn :: Num a => k a a
    cpn :: (Num a, Num b, Num c) => k b c -> k a b -> k a c

instance CategoryNum (->) where
    idn = \a -> a
    cpn = \f -> \g -> f Prelude.. g

class C.Category k => Monoidal k where
    cross :: (k a c) -> (k b d) -> (k (a, b) (c, d))

class CategoryNum k => MonoidalNum k where
    crossn :: (Num a, Num b, Num c) => (k a c) -> (k b d) -> (k (a, b) (c, d))

instance Monoidal (->) where
    cross f g = \(a,b) -> (f a, g b)

instance MonoidalNum (->) where
    crossn f g = \(a,b) -> (f a, g b)

class Monoidal k => Cartesian k where
    exl :: k (a, b) a
    exr :: k (a, b) b
    dup :: k a (a, a)

class MonoidalNum k => CartesianNum k where
    exln :: (Num a, Num b)  => k (a, b) a
    exrn :: (Num a, Num b)  => k (a, b) b
    dupn :: Num a           => k a (a, a)

instance Cartesian (->) where
    exl = \(a, b) -> a
    exr = \(a, b) -> b
    dup = \a -> (a, a)

instance CartesianNum (->) where
    exln = \(a, b) -> a
    exrn = \(a, b) -> b
    dupn = \a -> (a, a)

instance (Num a, Num b) => Num (a,b) where
    (a,b) + (x,y)   = (a + x, b + y)
    (a,b) - (x,y)   = (a - x, b - y)
    (a,b) * (x,y)   = (a * x, b * y)
    negate (a,b)    = (negate a, negate b)
    abs (a,b)       = (abs a, abs b)
    signum (a,b)    = (signum a, signum b)
    fromInteger i   = (fromInteger i, fromInteger i)

class CategoryNum k => Cocartesian k where
    inl :: (Num a, Num b)   => k a (a, b)
    inr :: (Num a, Num b)   => k b (a, b)
    jam :: Num a            => k (a, a) a

data S_arr a b where
    AddFun :: (Num a, Num b) => (a -> b) -> S_arr a b

instance CategoryNum S_arr where
    idn = AddFun id
    cpn (AddFun g) (AddFun f) = AddFun (g Prelude.. f)

instance MonoidalNum S_arr where
    crossn (AddFun f) (AddFun g) = AddFun (crossn f g)

instance CartesianNum S_arr where
    exln = AddFun exln
    exrn = AddFun exrn
    dupn = AddFun dupn

inlF :: (Num a, Num b)  => a -> (a, b)
inrF :: (Num a, Num b)  => b -> (a, b)
jamF :: (Num a)         => (a, a) -> a

inlF = \a -> (a, 0)
inrF = \b -> (0, b)
jamF = \(a,b) -> a + b

instance Cocartesian S_arr where
    inl = AddFun inlF
    inr = AddFun inrF
    jam = AddFun jamF

split :: Cartesian k => k a c -> k a d -> k a (c,d)
split f g = (cross f g) C.. dup

splitn :: (CartesianNum k, Num a, Num c, Num d) => 
    k a c -> k a d -> k a (c,d)
splitn f g = (crossn f g) `cpn` dupn

either :: (MonoidalNum k, Cocartesian k, Num a, Num c, Num d) => 
    k c a -> k d a -> k (c,d) a
either f g = jam `cpn` (crossn f g)

fork (f,g) = f `split` g
forkn (f,g) = f `splitn` g

unfork h = (exl C.. h, exr C.. h)
unforkn h = (exln `cpn` h, exrn `cpn` h)

join (f,g) = f `Main.either` g
unjoin h = (h `cpn` inl, h `cpn` inr)

{-# LANGUAGE MultiParamTypeClasses #-}

class NumCat k a where
    negateC :: k a a
    addC    :: k (a,a) a
    mulC    :: k (a,a) a

class FloatingCat k a where
    sinC :: k a a
    cosC :: k a a
    expC :: k a a

instance Num a => NumCat (->) a where
    negateC = negate
    addC    = uncurry (+)
    mulC    = uncurry (*)

instance Num a => NumCat S_arr a where
    negateC = AddFun negate
    addC    = AddFun $ uncurry (+)
    mulC    = AddFun $ uncurry (*)

instance Floating a => FloatingCat (->) a where
    sinC = sin 
    cosC = cos
    expC = exp

class Scalable k a where
    scale :: a -> k a a

instance Num a => Scalable S_arr a where
    scale a = AddFun (\da -> a*da)

newtype D k a b = D (a -> (b, k a b))

linearD :: (a -> b) -> (k a b) -> D k a b
linearD f f' = D (\a -> (f a, f'))

instance CategoryNum k => CategoryNum (D k) where
    idn = linearD Prelude.id idn
    (D g) `cpn` (D f) = D (\a -> 
        let{(b, f') = f a;
            (c, g') = g b}
        in (c, g' `cpn` f'))

instance MonoidalNum k => MonoidalNum (D k) where
    (D f) `crossn` (D g) = D (\(a,b) -> 
        let{(c, f') = f a;
            (d, g') = g b}
        in ((c,d), f' `crossn` g'))

instance CartesianNum k => CartesianNum (D k) where
    exln = linearD exln exln
    exrn = linearD exrn exrn
    dupn = linearD dupn dupn

instance Cocartesian k => Cocartesian (D k) where
    inl = linearD inlF inl 
    inr = linearD inrF inr 
    jam = linearD jamF jam 

instance (Scalable k s, Num s, NumCat k s, MonoidalNum k, Cocartesian k) => 
        NumCat (D k) s where
    negateC = linearD negateC negateC
    addC = linearD addC addC
    mulC = D (\(a,b) -> (a*b, (scale b) `Main.either` (scale a)))

instance (Floating s, Scalable k s) => 
        FloatingCat (D k) s where
    sinC = D (\a -> (sinC a, scale (cosC a)))
    cosC = D (\a -> (cosC a, scale (negateC $ sinC a)))
    expC = D (\a -> let e = expC a 
                    in (e, scale e))

unD (D f) = f
unAddFun (AddFun f) = f

sqr :: Num a => D S_arr a a
sqr = mulC `cpn` (idn `splitn` idn)

magSqr :: Num a => D S_arr (a,a) a
magSqr = addC `cpn` ((mulC `cpn` (exln `splitn` exln)) `splitn` (mulC `cpn` (exrn `splitn` exrn)))

cosSinProd :: Floating a => D S_arr (a,a) (a,a)
cosSinProd = (cosC `splitn` sinC) `cpn` mulC

deriv f a = (unAddFun $ snd $ unD f $ a) 1
