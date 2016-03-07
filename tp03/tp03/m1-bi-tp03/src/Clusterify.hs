{- |
  Module      :  $Header$
  Description :  
  Copyright   :  None
  License     :  None
  Maintainer  :  tydax@protonmail.ch
  Stability   :  unstable
  The $Header$ module describes all the types used in the application. Many of the types
  are here just to make the code easier to understand and read.
-}
module Clusterify (
  assignStep,
  checkChanged,
  computeCentre,
  distance,
  gatherData,
  kmean,
  updateStep
) where

import Types
import TypesUtils

-- |TODO The 'assignStep' function takes care of reassigning data objects to clusters.
assignStep :: [Data] -> [Cluster] -> [Cluster]
assignStep cs = cs

computeCentre :: [Double] -> Centre
computeCentre [] = []
computeCentre vss =
  let
    vs = map head vss
    mean = (sum vs) / (length vss)
    tails = map tail vss
  in (mean:computeCentre tails)

-- |TODO The 'distance' function computes the distance between two Data objects.
distance :: Data -> Data -> Distance
distance d1 d2 = 1

{-|TODO
  The 'kmean' function splits the specified data objects into the number of specified Cluster
-}
kmean :: [Data] -> Int -> [Cluster]
kmean ds n =
  let
    ct = 
    c = Cluster [] ct
  in (c:kmean ds (n-1)) 

-- |The 'updateStep' function represents the step where the clusters' centres are updated.
updateStep :: [Cluster] -> [Cluster]
updateStep (c:cs) =
  let
    c = Cluster ds _
    ct = computeCentre . gatherValues $ ds
    newc = Cluster ds ct
  in (newc:updateStep cs)