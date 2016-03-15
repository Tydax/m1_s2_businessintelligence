{- |
  Module      :  $Header$
  Description :  Different types used in algorithms
  Copyright   :  None
  License     :  None
  Maintainer  :  tydax@protonmail.ch
  Stability   :  unstable
  The $Header$ module describes all the types used in the algorithms. Many of the types
  are here just to make the code easier to understand and read.
-}
module Types (
  Centre,
  Cluster(Cluster),
  Data(Data, changed, cluster, distanceCentre, values),
  Distance
) where

-- |The 'Cluster' type describes a cluster of data which distance is short.
data Cluster = Cluster [Data] Centre Int deriving (Show) -- Int is used as an index

-- |The 'Centre' type is an alias to describe the centre of a cluster.
type Centre = [Double]

-- |The 'Data' type describes a type used to represent the data to clusterify.
data Data = Data {
    changed :: Bool
  , cluster :: Int
  , distanceCentre :: Double
  , values :: [Double]
  } deriving (Show)

-- |The 'Distance' type describes a function taking two sets of values and computing a distance.
type Distance = Data -> Data -> Double -> Double -> Double