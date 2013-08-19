{-# LANGUAGE NoImplicitPrelude #-}

module CKDesign.Parallax where

import Prelude
import FFI
import JQuery
import FayExtras
import ConstantsAndHelpers
import FFIExtras

main :: Fay ()
main = do
  win <- selectElement window
  width <- windowWidth win
  -- fix: max-device-width instead of width
  when (width > 768) (scroll onScroll win)
  documentReady onReady document

onReady :: Event -> Fay ()
onReady _ = do
  win <- selectElement window
  triggerScroll win
  width <- windowWidth win
  bubbleImages <- select bubbleImageClass
  if width <= 768
   then each turnOffBubbleEffect bubbleImages
   else do
     blackWhiteElements <- selectClass blackWhiteClass
     each (addChangeImageHover (Just "images/portfolio/")) blackWhiteElements
     each addBubbleEffect bubbleImages
  navigationElements <- selectClass navItemClass
  each (addScrollAnimation Horizontal scrollSpeed) navigationElements
  each (addActive deactivateNavSlide (const (return ())) navigationElements
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
  win <- selectElement window
  pos <- getScrollTop win
  movableObjects <- selectClass movableClass
  each (addParallaxEffect Horizontal pos) movableObjects
  return ()

addChangeImageHover mPrefix i element = do
  hoverObject <- selectElement element
  addHover hoverObject (onChange mouseEnterData) (onChange mouseLeaveData)
 where
  -- onChange isEnter pictureObject _   = do
  --   let pictureData = if isEnter then mouseEnterData else mouseLeaveData
  --   pictureName <- dataAttr pictureData pictureObject
  --   let imageOver = prependPortfolioPrefix pictureName
  --   preloadImage imageOver
  --   setBackgroundImage imageOver pictureObject
 onChange pictureData pictureObject _   = do
    pictureName <- dataAttr pictureData pictureObject
    let imageOver = case mPrefix of
          Nothing     -> pictureName
          Just prefix -> prefix ++ pictureName
    preloadImage imageOver
    setBackgroundImage imageOver pictureObject

addChangeMarginHover i element = do
  hoverObject <- selectElement element
  addHover hoverObject (addNavSlide) (removeNavSlide)
 where
  addNavSlide object _  =
    putStrLn "add" >>
    addClass navSlideClass object >> return ()
  removeNavSlide object _ = do
    putStrLn "remove"
    hasActiveClass <- hasClass activeClass object
    if hasActiveClass
       then return ()
       else removeClass navSlideClass object >> return ()

addBubbleEffect i element = do
  bubbleObject <- selectElement element
  addHover bubbleObject (changeBubble addClass) (changeBubble removeClass)
 where
  changeBubble updateClass _ _ = do
    bubbleObject <- selectElement element
    hoverClassName <- dataAttr hoverClassData bubbleObject
    updateClass hoverClassName bubbleObject
    return ()

turnOffBubbleEffect _ element = do
  object <- selectElement element
  removeClass scaleZeroClass object
  return True

hoverElement :: JQuery -> Fay JQuery
hoverElement object = dataAttr hoverObjectData object >>= select

navigationPrefix  = "images/navigation/"
portfolioPrefix   = "images/portfolio/"

prependNavigationPrefix = (++) navigationPrefix
prependPortfolioPrefix  = (++) portfolioPrefix
