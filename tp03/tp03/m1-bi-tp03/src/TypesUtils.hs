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
  let Cluster ds _ = c
  in ds ++ gatherData cs

-- |The 'gatherValues' function computes the centre of a list of data objects.
gatherValues :: [Data] -> [Double]
gatherValues [] = []
gatherValues ds = map values ds