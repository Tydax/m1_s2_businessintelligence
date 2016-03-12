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

-- |The 'assignStep' function takes care of reassigning data objects to clusters.
assignStep :: [Data] -> [Cluster] -> [Cluster]
assignStep [] cs = cs
assignStep (d:ds) cs = 
  let
    distClusts = map (distanceFromCluster d) cs -- Computing all the distances 
    minDist = minimum $ map fst distClusts -- Getting the minimum distance
    c = lookup minDist distClusts -- Getting the cluster associated with the distance
    Cluster datas ct index = c
    newData = Data {
      changed = (cluster d != index) -- Did the cluster changed?
      cluster = index
      distanceCentre = minDist
      values = values d
    }
    newCluster = Cluster newData:(filter (== d) datas) ct index
    newcs = newCluster:filter (== c) cs
  in
    assignStep ds newcs

-- |The 'computeCentre' function computes all the centres using the specified values.
computeCentre :: [[Double]] -> Centre
computeCentre [] = []
computeCentre vss =
  let
    heads = map head vss -- Take the first value of each list
    mean = mean heads -- Compute the arithmetic mean
    tails = map tail vss -- Take the tails of each list
  in mean:computeCentre tails

-- |The 'reevaluateCentre' reevaluates the centre of the specified cluster.
reevaluateCentre :: Cluster -> Cluster
reevaluateCentre (Cluster ds _ index) =
  let ct = computeCentre $ gatherValues ds
  in Cluster ds ct index

-- |The 'updateCentreStep' reevaluates the centres of all the specified clusters.
updateCentreStep :: [Cluster] -> [Cluster]
updateCentreStep = map reevaluateCentre

-- |TODO The 'distance' function computes the distance between two Data objects.
-- Formula : sqrt(E { ((x1 - x2) / (max - min))^2 })
distance :: [Double] -> [Double] -> [Double] -> [Double] -> Double
distance v1s v2s maxs mins =
  let
    num = zipwith (-) v1s v2s -- (x1 - x2)
    den = zipWith (-) maxs mins -- max - min
    squares = zipwith (\x y -> (x / y)^2) num den -- div ^ 2
  in
    sqrt $ sum squares

-- |The 'distanceFromCluster' computes the distance between the data object and the centre of the cluster.
distanceFromCluster :: Data -> Cluster -> (Double, Cluster)
distanceFromCluster d c = (distance d (centre c), c)

{-|TODO
  The 'kmean' function splits the specified data objects into the number of specified Cluster
-}
kmean :: [Data] -> Int -> [Cluster]
kmean _  0 = []
kmean ds n =
  let
    ct = 
    c = Cluster [] ct n
  in (c:kmean ds (n-1)) 
