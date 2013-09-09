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
  -- loading screen
  selectClass "loading-img" >>= setCss "display" "none"
  addLoadingAnimation 1.0
  selectElement window >>= load onLoad

addLoadingAnimation :: Double -> Fay ()
addLoadingAnimation i
  | i == 3    = setActive i >> setTimeout (addLoadingAnimation 0) 500
  | i == 0    = do
    selectClass "loading-img" >>= setCss "display" "none"
    setTimeout (addLoadingAnimation (i+1)) 500
  | otherwise = setActive i >> setTimeout (addLoadingAnimation (i+1)) 500
 where
  setActive i =
    select ("#loading" ++ (show i)) >>= setCss "display" "block"

onLoad :: Event -> Fay ()
onLoad _ = do
  -- hide loading screen and fade in main page
  obj <- select "#container"
  select "#loading" >>= \o -> fadeOutE 1000 (\_ -> hide Instantly o >> return o) o
  select "#container" >>= \o -> fadeInE 2000 (\_ -> jshow Instantly o >> return o) o
  putStrLn "fade out"
  -- activate home as current navigation item
  select "#nav-item1" >>= addClass "active-nav"
  -- change active navigation after submit contact form
  select "#back-button" >>= click showSelection
  navigationElements <- selectClass navItemClass
  selectClass "movable" >>= each addStartValues
  selectClass "layer1" >>= addXValue (-1.4)
  selectClass "layer2" >>= addXValue (-1)
  selectClass "layer3" >>= addXValue (-0.6)
  select slideshowId >>= addSlideshow fadeDuration
  selectClass "kreis" >>= each addProductHover
  selectClass "product" >>= each addProductNavigation
  each addScrollNavigation navigationElements
  return ()
 where
  fadeDuration = 6000  -- millisecs
  showSelection _ = do
    deactivateProductFrame
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
  startX <- dataAttrDouble "startx" object
  let leftValue = xPos * navIndex + startX
  currentLeft <- cssDouble "left" object
  let (val1,val2) = if currentLeft < leftValue
                       then (leftValue + 50, leftValue)
                       else if currentLeft > leftValue
                               then (leftValue, leftValue + 50)
                               else (leftValue, leftValue)
  animateLeftEaseOutBack (show val1)
                         (show val2)
                         (duration * 2)
                         object
  return True

addProductNavigation _ element = do
  selectElement element >>= click onClick
  deactivateProductFrame
  return True
 where
  onClick _ = do
    -- hide last selected product
    selectClass "active-product" >>= removeClass "active-product"
    -- show new selected product
    productId <- selectElement element >>= dataAttr "product"
    select productId >>= addClass "active-product"
    -- calculate scroll position and product-frame height
    height <- select "#container" >>= getHeight
    select "#products" >>= setCss "height" (show $ height * (2/3))
    select "#product-frame" >>= setCss "height" (show (height / 2))
    select "#back-button" >>= setCss "top" (show height)
    select "#product-frame" >>= setCss "marginTop" (show height)
    -- reset product-frame scroll position
    select "#product-frame" >>= setScrollTop 0
    -- show product-frame
    select "#product-frame" >>= setCss "display" "block"
    select "#back-button" >>= setCss "display" "block"
    select "#product-selection" >>= animateTop "-400" 500
    select "#back-button" >>= animateTop "-50" 500
    select "#product-frame" >>= animateMarginTop "0" 500
    return ()

addProductHover _ element = do
  obj <- selectElement element
  addHover obj enter leave
 where
  enter obj _ = do
    dummyId <- dataAttr "dummy" obj
    dummyObj <- select dummyId
    productId <- dataAttr "product" obj
    select productId >>= animateScale "100" 500
    productText <- dataAttr "text" obj
    select productText >>= setCss "color" "#253d6c"
    fadeOutE 500 (\_ -> return obj) dummyObj
    return ()
  leave obj _ = do
    dummyId <- dataAttr "dummy" obj
    dummyObj <- select dummyId
    productId <- dataAttr "product" obj
    select productId >>= removeClass "product-hover"
    select productId >>= animateScale "85" 500
    productText <- dataAttr "text" obj
    select productText >>= setCss "color" "#323232"
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
    animateLeft moveValue duration obj
    parallaxBubbles i duration
    selectClass "active-product" >>= \obj -> do
      currentId <- getAttr "id" currentActive
      newId     <- getAttr "id" newActive
      if currentId == "nav-item3" && currentId == newId
         then deactivateProductFrame
         else if currentId == "nav-item3"
                 then setTimeout (deactivateProductFrame >> hide Instantly obj
                                 >> removeClass "active-product" obj
                                 >> return ())
                                 1000
                 else if currentId == "nav-item4"
                      -- reset contact site
                        then do
                             selectClass "error" >>= hide Slow
                             select "#message" >>= hide Slow
                             select "#contact-form" >>= jshow Slow
                             select "#mail-form" >>=
                               each (\_ e -> reset e >> return True)
                             return ()
                        else return ()

deactivateProductFrame :: Fay ()
deactivateProductFrame = do
  select "#product-selection" >>= animateTop "0" 500
  height <- select "#container" >>= getHeight
  select "#product-frame" >>= animateMarginTop (show height) 500
  select "#back-button" >>= animateTop (show height) 500

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
