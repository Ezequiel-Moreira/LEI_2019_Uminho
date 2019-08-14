

{-# LANGUAGE TypeApplications,
             TypeOperators,
             ConstraintKinds,
             AllowAmbiguousTypes,
             KindSignatures,
             FlexibleContexts,
             GADTs,
             MultiParamTypeClasses,
             FlexibleInstances #-}

import qualified Control.Category as C
import Data.Kind as K
import Prelude hiding (id, (.), either)

class CategoryDom (d :: * -> Constraint) (k :: * -> * -> *) where
    id  :: d a => a `k` a
    (.) :: (d a, d b, d c) => b `k` c -> a `k` b -> a `k` c

instance CategoryDom d (->) where
    id = \a -> a
    f . g = \a -> f (g a) 

class CategoryDom d k => MonoidalDom d k where
    (><) :: (d a, d b, d c, d e) => (a `k` c) -> (b `k` e) -> ((a, b) `k` (c, e))

instance MonoidalDom d (->) where
    f >< g = \(a,b) -> (f a, g b)

class MonoidalDom d k => CartesianDom d k where
    exl :: (d a, d b) => (a, b) `k` a
    exr :: (d a, d b) => (a, b) `k` b
    dup :: d a => a `k` (a, a)

instance CartesianDom d (->) where
    exl = \(a, b) -> a
    exr = \(a, b) -> b
    dup = \a -> (a, a)

class Additive a where
    zero :: a
    (<+>)  :: a -> a -> a

instance Additive Int where
    zero = 0
    (<+>) = (+)

instance Additive Float where
    zero = 0.0
    (<+>) = (+)

instance (Additive a, Additive b) => Additive (a, b) where
    zero = (zero, zero)
    (a, b) <+> (c, d) = (a <+> c, b <+> d)

class CategoryDom d k => CocartesianDom d k where
    inl :: (d a, d b) => a `k` (a, b)
    inr :: (d a, d b) => b `k` (a, b)
    jam :: d a => (a, a) `k` a

data (->+) :: * -> * -> * where
    AddFun :: (Additive a, Additive b) => (a -> b) -> a ->+ b

instance CategoryDom Additive (->+) where
    id = AddFun (\x -> x)
    (AddFun g) . (AddFun f) = AddFun (((.) @Additive) g f)

instance MonoidalDom Additive (->+) where
    (AddFun f) >< (AddFun g) = AddFun (((><) @Additive) f g)

instance CartesianDom Additive (->+) where
    exl = AddFun (exl @Additive)
    exr = AddFun (exr @Additive)
    dup = AddFun (dup @Additive)

inlF :: (Additive a, Additive b) => a -> (a, b)
inrF :: (Additive a, Additive b) => b -> (a, b)
jamF :: Additive a => (a, a) -> a

inlF = \a -> (a, zero)
inrF = \b -> (zero, b)
jamF = \(a,b) -> a <+> b

instance CocartesianDom Additive (->+) where
    inl = AddFun inlF
    inr = AddFun inrF
    jam = AddFun jamF

split :: (CartesianDom Additive k, Additive a, Additive b, Additive c) => a `k` b -> a `k` c -> a `k` (b,c)
split f g = ((.) @Additive) (((><) @Additive) f g) (dup @Additive)
-- split f g = (f >< g) . dup

either :: (MonoidalDom Additive k, CocartesianDom Additive k, Additive a, Additive b, Additive c) => 
    b `k` a -> c `k` a -> (b,c) `k` a
either f g = ((.) @Additive) (jam @Additive) (((><) @Additive) f g)
-- either f g = jam . (f >< g)

fork (f,g) = f `split` g
unfork h = (((.) @Additive) exl h,((.) @Additive) exr h)
-- unfork h = (exl . h, exr . h)

join (f,g) = either f g
unjoin h = (((.) @Additive) h inl,((.) @Additive) h inr)
-- unjoin h = (h . inl, h . inr)


class NumCat k a where
    negateC :: k a a
    addC    :: k (a,a) a
    mulC    :: k (a,a) a

class FloatingCat k a where
    sinC :: k a a
    cosC :: k a a
    expC :: k a a
--    expBC :: k (a,a) a

instance Num a => NumCat (->) a where
    negateC = negate
    addC    = uncurry (+)
    mulC    = uncurry (*)

instance (Num a, Additive a) => NumCat (->+) a where
    negateC = AddFun negate
    addC    = AddFun $ uncurry (+)
    mulC    = AddFun $ uncurry (*)

instance Floating a => FloatingCat (->) a where
    sinC = sin 
    cosC = cos
    expC = exp
--    expBC = uncurry (**)

instance (Floating a, Additive a) => FloatingCat (->+) a where
    sinC = AddFun sin 
    cosC = AddFun cos
    expC = AddFun exp
--    expBC = AddFun $ uncurry (**)

class Scalable k a where
    scale :: a -> a `k` a

instance (Num a, Additive a) => Scalable (->+) a where
    scale a = AddFun (\da -> a*da)

newtype D k a b = D (a -> (b, a `k` b))

linearD :: (a -> b) -> (k a b) -> D k a b
linearD f f' = D (\a -> (f a, f'))

-- we need to have (d `and` Additive)
-- :k and
-- > (* -> Constraint) -> (* -> Constraint) -> * -> Constraint
instance CategoryDom Additive k => CategoryDom Additive (D k) where
    id = linearD (\x -> x) (id @Additive)
    (D g) . (D f) = D (\a -> 
        let{(b, f') = f a;
            (c, g') = g b}
        in (c, (.) @Additive g' f'))

instance MonoidalDom Additive k => MonoidalDom Additive (D k) where
    (D f) >< (D g) = D (\(a,b) -> 
        let{(c, f') = f a;
            (d, g') = g b}
        in ((c,d), (><) @Additive f' g'))

instance CartesianDom Additive k => CartesianDom Additive (D k) where
    exl = linearD (exl @Additive) (exl @Additive)
    exr = linearD (exr @Additive) (exr @Additive)
    dup = linearD (dup @Additive) (dup @Additive)

instance CocartesianDom Additive k => CocartesianDom Additive (D k) where
    inl = linearD inlF (inl @Additive) 
    inr = linearD inrF (inr @Additive) 
    jam = linearD jamF (jam @Additive) 

instance (Scalable k s, NumCat k s, Num s, MonoidalDom Additive k, CocartesianDom Additive k, Additive s) => 
        NumCat (D k) s where
    negateC = linearD negateC negateC
    addC = linearD addC addC
    mulC = D (\(a,b) -> (a*b, (scale b) `either` (scale a)))

instance (Floating s, Additive s, Scalable k s, MonoidalDom Additive k, CocartesianDom Additive k) => 
        FloatingCat (D k) s where
    sinC = D (\a -> (sinC a, scale (cosC a)))
    cosC = D (\a -> (cosC a, scale (negateC $ sinC a)))
    expC = D (\a -> let e = expC a 
                    in (e, scale e))
--    expBC = D(\(u,v) -> let l = scale (v*u**(v-1))
--                            r = scale ((u**v)*(log u))
--                        in (expBC (u,v), l `either` r))

instance (Num a, Additive a) => Scalable (D (->+)) a where
    scale a = D (\da -> (da*a, AddFun (\d -> a))) 

-- helpfull syntax --
ida :: (CategoryDom Additive k, Additive a) => a `k` a
ida = id @Additive

cpa :: (CategoryDom Additive k, Additive a, Additive b, Additive c) =>
    b `k` c -> a `k` b -> a `k` c
cpa = (.) @Additive

exla :: (CartesianDom Additive k, Additive a, Additive b) =>
    (a, b) `k` a
exla = exl @Additive

exra :: (CartesianDom Additive k, Additive a, Additive b) =>
    (a, b) `k` b
exra = exr @Additive

dupa :: (CartesianDom Additive k, Additive a) =>
    a `k` (a, a)
dupa = dup @Additive

constD a = linearD (const a) (AddFun (\x->zero)) 
---------------------


unD (D f) = f
unAddFun (AddFun f) = f

mulxy :: (Num a, Additive a) => D (->+) (a,a) a
mulxy = mulC

sqr :: (Num a, Additive a) => D (->+) a a
sqr = mulC `cpa` (ida `split` ida)

magSqr :: (Num a, Additive a) => D (->+) (a,a) a
magSqr = addC `cpa`  
    (   (mulC `cpa` (exla `split` exla)) 
        `split`
        (mulC `cpa` (exra `split` exra))
    )

cosSinProd :: (Floating a, Additive a) => D (->+) (a,a) (a,a)
cosSinProd = (cosC `split` sinC) `cpa` mulC

--exp2 :: (Floating a, Additive a) => D (->+) a a
--exp2 = expBC `cpa` ((constD 2.0) `split` ida)




deriv :: Show b => D (->+) a b -> a -> a -> b
deriv f a s = (unAddFun $ snd $ unD f $ a) s
