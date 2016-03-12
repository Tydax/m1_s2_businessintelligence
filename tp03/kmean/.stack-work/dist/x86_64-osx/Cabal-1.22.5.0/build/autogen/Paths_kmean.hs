module Paths_kmean (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/tydax/Development/m1_s2_businessintelligence/tp03/kmean/.stack-work/install/x86_64-osx/lts-5.6/7.10.3/bin"
libdir     = "/Users/tydax/Development/m1_s2_businessintelligence/tp03/kmean/.stack-work/install/x86_64-osx/lts-5.6/7.10.3/lib/x86_64-osx-ghc-7.10.3/kmean-0.1.0.0-5JEEfmIQrfSIKbQqfnKg0B"
datadir    = "/Users/tydax/Development/m1_s2_businessintelligence/tp03/kmean/.stack-work/install/x86_64-osx/lts-5.6/7.10.3/share/x86_64-osx-ghc-7.10.3/kmean-0.1.0.0"
libexecdir = "/Users/tydax/Development/m1_s2_businessintelligence/tp03/kmean/.stack-work/install/x86_64-osx/lts-5.6/7.10.3/libexec"
sysconfdir = "/Users/tydax/Development/m1_s2_businessintelligence/tp03/kmean/.stack-work/install/x86_64-osx/lts-5.6/7.10.3/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "kmean_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "kmean_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "kmean_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "kmean_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "kmean_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
