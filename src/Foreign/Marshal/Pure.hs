{-# LANGUAGE GADTs #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE ScopedTypeVariables #-}

-- | This module introduces primitives to /safely/ allocate and discard
-- in-memory storage for values /explicitly/. Values discarded explicitly don't
-- need to be managed by the garbage collector (GC), which therefore has less
-- work to do. Less work for the GC can sometimes mean more predictable request
-- latencies in multi-threaded and distributed applications.
--
-- This module is meant to be imported qualified.
--
-- == Examples
--
-- You can find example data structure implementations in @Foreign.List@ and
-- @Foreign.Heap@ of the @example@ directory in the source repository.
--
-- == Pools
--
-- The module interface is structured around a notion of memory 'Pool'. Passing
-- linear pool arguments is an alternative to passing continuations to
-- functions. Passing continuations can break tail-recursion in certain cases.
--
-- Pools play another role: resilience to exceptions. If an exception is raised,
-- all the data in the pool is deallocated.
--
-- Data from one pool can refer to data in another pool and vice versa.

module Foreign.Marshal.Pure
  ( Pool
  , withPool
  , Box
  , alloc
  , deconstruct
  ) where

import Foreign.Marshal.Alloc
import Foreign.Ptr
import Foreign.Storable
import Prelude.Linear
import System.IO.Unsafe
import qualified Unsafe.Linear as Unsafe

-- TODO: ignoring exceptions for the moment. So that I can get some tests to
-- work first.

-- TODO: Briefly explain the Dupable-reader style of API, below, and fix
-- details.

-- | Pools represent collections of values. A 'Pool' can be 'consume'-ed. This
-- is a no-op: it does not deallocate the data in that pool. It cannot do so,
-- because accessible values might still exist. Consuming a pool simply makes it
-- impossible to add new data to the pool.
data Pool = Pool

-- TODO: document individual functions

withPool :: (Pool ->. Unrestricted b) ->. Unrestricted b
withPool scope = scope Pool

instance Consumable Pool where
  consume Pool = ()

instance Dupable Pool where
  dup Pool = (Pool, Pool)

-- | 'Box a' is the abstract type of manually managed data. It can be used as
-- part of data type definitions in order to store linked data structure off
-- heap. See @Foreign.List@ and @Foreign.Pair@ in the @examples@ directory of
-- the source repository.
data Box a where
-- XXX: this indirection is possibly not necessary. It's here because the inner
-- Ptr must be unrestricted (in order to implement deconstruct at the moment).
  Box :: Ptr a -> Box a

-- XXX: if Box is a newtype, can be derived
instance Storable (Box a) where
  sizeOf _ = sizeOf (undefined :: Ptr a)
  alignment _ = alignment (undefined :: Ptr a)
  peek ptr = Box <$> (peek (castPtr ptr :: Ptr (Ptr a)))
  poke ptr (Box ptr') = poke (castPtr ptr :: Ptr (Ptr a)) ptr'

-- TODO: a way to store GC'd data using a StablePtr

-- TODO: reference counted pointer. Remarks: rc pointers are Dupable but not
-- Movable. In order to be useful, need some kind of borrowing on the values, I
-- guess. 'Box' can be realloced, but not RC pointers.

-- XXX: We brazenly suppose that the `Storable` API can be seen as exposing
-- linear functions. It's not very robust. This also ties in the next point.

-- TODO: Ideally, we would like to avoid having a boxed representation of the
-- data before a pointer is created. A better solution is to have a destination
-- passing-style API (but there is still some design to be done there). This
-- alloc primitive would then be derived (but most of the time we would rather
-- write bespoke constructors).
alloc :: forall a. Storable a => a ->. Pool ->. Box a
alloc a Pool =
    Unsafe.toLinear mkPtr a
  where
    mkPtr :: a -> Box a
    mkPtr a' = unsafeDupablePerformIO $ do
      ptr <- malloc
      poke ptr a'
      return (Box ptr)

deconstruct :: Storable a => Box a ->. a
deconstruct (Box ptr) = unsafeDupablePerformIO $ do
  res <- peek ptr
  free ptr
  return res