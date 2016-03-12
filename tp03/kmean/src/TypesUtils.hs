{- |
  Module      :  $Header$
  Description :  Different types used in algorithms
  Copyright   :  None
  License     :  None
  Maintainer  :  tydax@protonmail.ch
  Stability   :  unstable
  The $Header$ module describes util functions for created types.
-}
module TypesUtils (
  gatherData,
  gatherValues
) where

import Types

-- |The 'gatherData' function gathers every data object from cluster into a single list.
gatherData :: [Cluster] -> [Data]
gatherData [] = []
gatherData (c:cs) =
  let Cluster ds _ _ = c
  in ds ++ gatherData cs

-- |The 'gatherValues' function gathers every values object.
gatherValues :: [Data] -> [[Double]]
gatherValues ds = map values ds

-- |The 'mean' function computes the arithmetic mean of all the specified values.
mean :: [Data] -> Double
mean ds = sum ds / (length ds)