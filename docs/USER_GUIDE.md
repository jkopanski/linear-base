# User Guide

This guide provides a _minimal_ list of things you need
to know to write practical linear code with linear-base.

## Naming Conventions & Layout

Typically, variants of common haskell tools and facilities
share the same name with a `Linear` postfix. For instance,
`Data.Bool.Linear` provides the linear versions of `not`
and `&&`.

The module names follow the typical hierarchical module
naming scheme with top-level names like `Control`, `Data`, `System`
and so on.

## Temporary Limitations

### Case statements don't work -- use tail-recursion instead

The following program will **fail**:

```haskell
maybeFlip :: Int #-> Int #-> (a,a) -> a
maybeFlip i j (x,y) = case i < j of
  True -> x
  False -> y
```

If we use a tail-recursive function with the argument `i<j`
it won't fail.

```haskell
maybeFlip :: Int #-> Int #-> (a,a) -> a
maybeFlip i j ((x :: a),y) = fromCompare (i Linear.< j) (x,y)
  where
    fromCompare :: Bool #-> (a,a) -> a
    fromCompare True (x,y) = x
    fromCompare False (x,y) = y
```

### `let` and `where` bindings don't work

The following will **! fail !**:

```haskell
idBad1 :: a #-> a
idBad1 x = y
  where
    y = x

idBad2 :: a #-> a
idBad2 x =  let y = x in y
```

Inline these or use tail-recursion.


## Non-linear and linear code interactions

All throughout linear haskell code, you will need to interface
between non-linear and linear code. All the tools you need to do this
are in [Data.Unrestricted].

This is basically done through type classes. Types that can be used in
a non-linear way even when they are bound in a linear function have
instances of one or more of these things: `Consumable, Dupable,
Moveable`.

## Design patterns

### `f :: X -> (SomeType #-> Unrestricted b) -> b` functions

Many functions that want you to use `SomeType` provide some
kind of consumer function that takes a **linear** continuation of
type `SomeType #-> Unrestricted b`. The idea is that any _linear_
continuation that is made with the given API for `SomeType` enforces
some desirable properties about how `SomeType` is used.

Then, since the return type is captured in `Unrestricted` we can't
have `SomeType` escape a context where it isn't bound linearly.
Thus, the continuation actually produces some result that is not
linearly bound.

## New Linear Things

Here's a list of _new_ tools made possible by linear types:

  1. Mutable arrays, hashmaps, vectors, sets with a pure API
     See `Data.Array.Mutable.Linear` for example.
  2. Push and Pull arrays: a way to control when arrays are allocated
  and force array fusion. See `Data.Array.Polarized`.
  3. A linear API for system heap (not GC) allocation of values.
     See `Foreign.Marshall.Pure`.

[Data.Unrestricted]: https://github.com/tweag/linear-base/blob/master/src/Data/Unrestricted/Linear.hs
