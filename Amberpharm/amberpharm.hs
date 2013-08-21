module Amberpharm.Amberpharm where

import Prelude
import JQuery
import FFIExtras
import FayExtras (selectClass, addScrollAnimation, ScrollDir(..), addActive
                 , addHover )
import FayDesign (addChangeImageOnHover)

main :: Fay ()
main = documentReady onReady document

onReady :: Event -> Fay ()
onReady _ = do
  body >>= animateScrollTop 0 100
  navigationElements <- selectClass navItemClass
  -- each (addChangeImageOnHover (Just navigationPrefix)) navigationElements
  -- each (addActive reactivateHover changeImageToActive) navigationElements
  select slideshowId >>= addSlideshow fadeDuration
  selectClass "kreis" >>= each addProductHover
  selectClass "product" >>= each addProductNavigation
  each addScrollNavigation navigationElements
  return ()
 where
  fadeDuration = 6000  -- millisecs

addProductNavigation _ element = do
  selectElement element >>= click onClick >> return True
 where
  onClick _ = do
    productId <- selectElement element >>= dataAttr "product"
    select productId >>= unhide
    select "#product-frame" >>= setCss "display" "block"
    -- select "#product-selection" >>= hide Instantly
    -- body >>= addClass "enlargeBody"
    body >>= animateScrollTop 525 500
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
    body >>= animateScrollTop 0 500
    -- body >>= addClass "enlargeBody"
    -- selectClass "product-frame" >>=
      -- each (\_ e -> selectElement e >>= hide Instantly >> return True)
    -- select "#product-frame" >>= hide Instantly
    -- select "#product-selection" >>= unhide
    obj <- select "#content"
    currentActive <- selectClass "active-nav"
    removeClass "active-nav" currentActive
    newActive <- selectElement element
    newNumber <- dataAttrDouble "navnumber" newActive
    currentNumber <- dataAttrDouble "navnumber" currentActive
    let moveValue = show (i * (-100.0)) ++ "%"
        duration  = abs (currentNumber - newNumber) * 500
    addClass "active-nav" newActive
    animateLeft moveValue duration obj
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
