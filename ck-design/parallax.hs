{-# LANGUAGE NoImplicitPrelude #-}

module CKDesign.Parallax where

import Prelude
import FFI
import JQuery
import FayExtras -- hiding (addChangeMarginHover)
import ConstantsAndHelpers
import FFIExtras
import Fay.Text.Type (Text, pack)

main :: Fay ()
main = do
  win <- select window
  width <- windowWidth win
  -- fix: max-device-width instead of width
  scroll onScroll win
  -- touchMove onScroll win
  documentReady onReady document

onReady :: Event -> Fay ()
onReady _ = do
  win <- select window
  triggerScroll win
  width <- windowWidth win
  navigationElements <- selectClass navItemClass
  each (addScrollAnimation Vertical scrollSpeed) navigationElements
  each (addActive deactivateNavSlide (const (return ()))) navigationElements
  each addChangeMarginHover navigationElements
  linkElements <- selectClass linkClass
  each addHref linkElements
  return ()
 where
   scrollSpeed = 0.5
   deactivateNavSlide obj = removeClass navSlideClass obj >> return ()

-- Scroll Event Processing

onScroll :: Event -> Fay ()
onScroll _ = do
  win <- select window
  pos <- getScrollTop win
  movableObjects <- selectClass movableClass
  each (addParallaxEffect Vertical pos) movableObjects
  return ()

navigationPrefix  = "images/navigation/"
portfolioPrefix   = "images/portfolio/"

prependNavigationPrefix = (++) navigationPrefix
prependPortfolioPrefix  = (++) portfolioPrefix
