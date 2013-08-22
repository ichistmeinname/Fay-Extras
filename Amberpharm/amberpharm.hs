module Amberpharm.Amberpharm where

import Prelude
import JQuery
import FFIExtras
import FayExtras (selectClass, addScrollAnimation, ScrollDir(..), addActive
                 , addHover, movement, visibility)
import FayDesign (addChangeImageOnHover)

main :: Fay ()
main = documentReady onReady document

onReady :: Event -> Fay ()
onReady _ = do
  body >>= animateScrollTop 0 100
  -- activate home as current navigation item
  select "#navv-item1" >>= addClass "active-nav"
  navigationElements <- selectClass navItemClass
  selectClass "movable" >>= each addStartValues
  selectClass "layer1" >>= addXValue (-1.4)
  selectClass "layer2" >>= addXValue (-1)
  selectClass "layer3" >>= addXValue (-0.6)
  -- each (addChangeImageOnHover (Just navigationPrefix)) navigationElements
  -- each (addActive reactivateHover changeImageToActive) navigationElements
  select slideshowId >>= addSlideshow fadeDuration
  selectClass "kreis" >>= each addProductHover
  selectClass "product" >>= each addProductNavigation
  each addScrollNavigation navigationElements
  return ()
 where
  fadeDuration = 6000  -- millisecs
  addStartValues _ element = do
    object <- selectElement element
    startX <- cssDouble "left" object
    startY <- cssDouble "top" object
    setDataAttrDouble "startx" startX object
    setDataAttrDouble "starty" startY object
    return True
  addXValue factor obj = do
    width <- body >>= getWidth
    setDataAttrDouble "x" (width * factor) obj

parallaxBubbles index duration = do
  movableElements <- selectClass "movable"
  each (addParallaxEffect index duration) movableElements
  return ()

addParallaxEffect :: Double -> Double -> Double -> Element -> Fay Bool
addParallaxEffect navIndex duration _ element = do
  object <- selectElement element
  xPos <- dataAttrDouble "x" object
  yPos <- dataAttrDouble "y" object
  startX <- dataAttrDouble "startx" object
  startY <- dataAttrDouble "starty" object
  putStrLn (show xPos ++ "\n" ++ show yPos ++ "\n" ++ show navIndex)
  putStrLn (show startX ++ "\n" ++ show startY)
  animateLeftTop (show ((xPos * navIndex) + startX))
                 (show ((yPos * navIndex) + startY))
                 (duration * 2)
                 object
  return True

addProductNavigation _ element = do
  selectElement element >>= click onClick >> return True
 where
  onClick _ = do
    -- hide last selected product
    selectClass "active-product" >>= hide Instantly
                                 >>= removeClass "active-product"
    -- show new selected product
    productId <- selectElement element >>= dataAttr "product"
    select productId >>= unhide >>= addClass "active-product"
    -- calculate scroll position and product-frame height
    height <- body >>= getHeight
    select "#products" >>= setCss "height" (show $ height * (2/3))
    select "#product-frame" >>= setCss "height" (show (height / 2))
    select "#product-frame" >>= setCss "marginTop" (show height)
    -- show product-frame
    select "#product-frame" >>= setCss "display" "block"
    select "#product-selection" >>= animateTop "-400" 500
    select "#product-frame" >>= animateMarginTop "0" 500
    -- scroll to product-frame
    -- body >>= animateScrollTop height 750
    return ()

addProductHover _ element = do
  obj <- selectElement element
  addHover obj enter leave
 where
  enter obj _ = do
    dummyId <- dataAttr "dummy" obj
    dummyObj <- select dummyId
    productId <- dataAttr "product" obj
    select productId >>= addClass "product-hover"
    fadeOutE 500 (\_ -> return obj) dummyObj
    return ()
  leave obj _ = do
    dummyId <- dataAttr "dummy" obj
    dummyObj <- select dummyId
    productId <- dataAttr "product" obj
    select productId >>= removeClass "product-hover"
    fadeInE 500 (\_ -> return dummyObj) dummyObj
    return ()

addScrollNavigation i element =
  selectElement element >>= click onClick >> return True
 where
  onClick _ = do
    -- body >>= animateScrollTop 0 500
    obj <- select "#content"
    currentActive <- selectClass "active-nav"
    removeClass "active-nav" currentActive
    newActive <- selectElement element
    newNumber <- dataAttrDouble "navnumber" newActive
    currentNumber <- dataAttrDouble "navnumber" currentActive
    let moveValue = show (i * (-100.0)) ++ "%"
        duration  = abs (currentNumber - newNumber) * 1000
    addClass "active-nav" newActive
    select "#product-selection" >>= animateTop "0" 500
    height <- body >>= getHeight
    select "#product-frame" >>= animateMarginTop (show height) 500
    animateLeft moveValue duration obj
    parallaxBubbles i duration
    return ()

addSlideshow :: Double -> JQuery -> Fay ()
addSlideshow duration obj = do
  slideshowCount <- dataAttrDouble slideCountData obj
  startObj <- selectClass firstSlideClass
  let nextImage i obj
        | i < slideshowCount = do
           nextObj <- next obj
           triggerAnimation obj nextObj
           setTimeout (nextImage (i+1.0) nextObj) duration
        | otherwise          = do
           triggerAnimation obj startObj
           setTimeout (nextImage 1.0 startObj) duration
      triggerAnimation obj nextObj = do
        fadeOutE 1000.0 (\_ -> return obj) obj
        fadeInE 2000.0 (\_ -> return nextObj) nextObj
        return ()

  setTimeout (nextImage 1.0 startObj) duration
  return ()

-- -- | Turn on hover for navigation elements after beeing active
-- reactivateHover :: JQuery -> Fay ()
-- reactivateHover obj = do
--   each (addChangeImageOnHover (Just navigationPrefix)) obj
--   triggerMouseLeave obj
--   return ()

-- -- | Change navigation image to _active and turn off hover
-- changeImageToActive :: JQuery -> Fay ()
-- changeImageToActive obj = do
--   activeImage <- dataAttr activeData obj
--   setBackgroundImage (navigationPrefix ++ activeImage) obj
--   turnOffHover obj
--   return ()

firstSlideClass = "first-slide"
slideshowId = "#slideshow"
slideCountData = "slidecount"
slideshowData = "slideshow"
navItemClass = "nav-item"
navigationPrefix = "Navigation/"
activeData = "active"
mouseLeaveData = "mouseleave"
