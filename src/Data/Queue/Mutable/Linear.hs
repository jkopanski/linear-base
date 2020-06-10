{-# LANGUAGE GADTs #-}
{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE LinearTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE StrictData #-}
{-# LANGUAGE TypeApplications #-}
{-# OPTIONS_GHC -Wno-name-shadowing #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}


module Data.Queue.Mutable
  (
  )
where


import Data.Array.Mutable.Linear
import Data.Unrestricted.Linear
import Prelude.Linear
import qualified Unsafe.Linear as Unsafe
import qualified Prelude


data Queue a where
  -- Holds the index of the (first,last) element
  -- where first, last \in 0 .. length(array) -1
  -- and the queue goes by modulo length(array) from 
  -- first, first+1, first+2, ..., first+n ~ last
  Queue :: Array a #-> (Int, Int) -> Queue a



singleton :: Int -> a -> (Queue a #-> Unrestricted b) -> Unrestricted b
singleton maxSize init f = alloc maxSize init Prelude.$
  \arr -> f (Queue arr (0,0))


push :: Queue a #-> a -> Queue a
push = undefined

peek :: Queue a #-> (Queue a, a)
peek = undefined

pop :: Queue a #-> (Queue a, a)
pop = undefined

length :: Queue a #-> (Queue a, Int)
length = undefined

isEmpty :: Queue a #-> (Queue a, Bool)
isEmpty = undefined




