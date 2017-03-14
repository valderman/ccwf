-- | Chalmers course 
module CCWF
  ( -- * Configuring and updating pages
    Website (..), Info (..), Materials (..)
  , URL, Teacher (..), Lecture (..)

    -- * Building the website
  , mkWebsite
  ) where
import CCWF.Config
import CCWF.Impl
