{-# LANGUAGE NoImplicitPrelude #-}

module FayExtras where

import Prelude
import FFI
import JQuery
import ConstantsAndHelpers
import FFIExtras

data Visibility = Always | Range Double Double

data ScrollDir = Horizontal | Vertical

selectClass :: String -> Fay JQuery
selectClass className = select ('.':className)

-- Adds a hyperref for the given element as an onclick-action
-- Example:
-- HTML-Snippet
--    <div id="logo" class="link" data-href="index.html" data-click="#logo">
-- Fay Code
--    onClickForLinkClass :: Fay ()
--    onClickForLinkClass = do
--      linkElements <- selectClass "link"
--       each addHref linkElements
--       return ()
addHref :: Double -> Element -> Fay Bool
addHref _ element = do
  object <- selectElement element
  href <- dataAttr hrefData object
  clickObject <- dataAttr clickData object >>= select
  click (onClick href) clickObject
  return True
 where
   onClick href _ = setLocation href

-- Adds onclick-event for the given element and adds ".active" class.
-- Runs then given action when the element is clicked.
-- Html-Snippet
--    <div id="nav-item" class="active"/>
-- Fay Code
--    navigation :: Fay ()
--    navigation = do
--      navigationElements <- selectClass "nav-item"
--      each addActive navigationElements
--      return ()
addActive :: (JQuery -> Fay ()) -> Double -> Element -> Fay Bool
addActive action _ element =
  selectElement element >>= click onClick >> return True
 where
   onClick _ = do
     -- "unmark" current active object
     activeObject <- selectClass activeClass
     removeClass activeClass activeObject
     -- "mark" current active object
     obj <- selectElement element
     addClass "active" obj
     -- do some actions
     action obj

-- Adds ".active" class to the given element based on the position
--   ().
-- Html Snippet
--    <div id="nav-item1" class="nav-item" data-start="350" data-end="1000">
-- Fay Code
--    scrollNavigation :: Fay ()
--    scrollNavigation = do
--      pos <- body >>= getScrollTop
--      navItems <- selectClass "nav-item"
--      each (updateNavItem pos) navItems
--      return ()
updateNavItem :: Double
              -> (JQuery -> Fay ())
              -> (JQuery -> Fay ())
              -> Double
              -> Element
              -> Fay Bool
updateNavItem pos activateAction deactiveAction _ element = do
  navObject <- selectElement element
  start <- dataAttrDouble startData navObject
  end <- dataAttrDouble endData navObject
  if pos `isInRange` (start,end)
     then activateAction navObject
          >> addClass activeClass navObject
     else deactiveAction navObject
          >> removeClass activeClass navObject
  return True

isInRange :: Double -> (Double, Double) -> Bool
isInRange pos (start, end) = pos >= start && pos <= end

-- Adds parallax-effect for a given element; the element scrolls in a
--   different speed than the background in the given ScrollDir.
-- Html Snippet
--    <div id="vita_title" class="movable"
--         data-speed="-1.25" data-offset="1400" data-vis="always">
-- Fay Code
--    onScroll :: Event -> Fay ()
--    onScroll _ = do
--      win <- selectElement window
--      pos <- getScrollTop win
--      movableObjects <- select ".movable"
--      each (addParallaxEffect Horizontal pos) movableObjects
--      return ()
--    main :: Fay ()
--    main = selectElement window >>= scroll onScroll
addParallaxEffect :: ScrollDir -> Double -> Double -> Element -> Fay Bool
addParallaxEffect dir pos _ element = do
  object <- selectElement element
  speed <- dataAttrDouble speedData object
  offset <- dataAttrDouble offsetData object
  vis <- visibility object
  case movement vis speed offset pos of
       Nothing -> hide Instantly object >> return ()
       Just newPosition -> do
         jshow Instantly object
         let setPosition = case dir of
               Horizontal -> setPositionY
               Vertical -> setPositionX
         setPosition newPosition object
  return True

movement :: Visibility -> Double -> Double -> Double -> Maybe Double
movement Always speed c pos = Just (speed * pos + c)
movement (Range start end) speed c pos
  | pos `isInRange` (start,end) = Just (speed * pos + c)
  | otherwise                   = Nothing

visibility :: JQuery -> Fay Visibility
visibility obj = do
  visibility <- dataAttr visibilityData obj
  case visibility of
    "always" -> return Always
    "range"  -> do
      start <- dataAttrDouble startData obj
      end   <- dataAttrDouble endData obj
      return (Range start end)

-- Adds scroll-animation as onclick-action for the given element.
-- When the element is clicked, the scroll-position is changed to the
--  corresponding scrollPos. ScrollDir indicates the scrolling direction.
addScrollAnimation :: ScrollDir -> Double -> Double -> Element -> Fay Bool
addScrollAnimation dir scrollSpeed _ element =
  selectElement element >>= click onClick >> return True
 where
  onClick _ = do
    bodyElem <- body
    oldPosition <- getScrollTop bodyElem
    object <- selectElement element
    position <- dataAttrDouble scrollPositionData object
    let duration = abs (oldPosition - position) * scrollSpeed
        scrollTo = case dir of
          Horizontal -> animateScrollTop
          Vertical -> animateScrollLeft
    scrollTo position duration bodyElem

-- Adds a hover effect for given element according to the given enter- and
--   leaveAction.
-- Html Snippet
--    <div id="nav-item1" class="nav-item" data-hoverobj="#nav-item1"/>
-- CSS Snippet
--    .nav-item { margin-left: -38px;
--                transition: margin-left 0.5s ease-out;
--                -webkit-transition: margin-left 0.5s ease-out;
--                -moz-transition: margin-left 0.5s ease-out;
--                -ms-transition: margin-left 0.5s ease-out;
--                -o-transition: margin-left 0.5s ease-out;
--               }
--    .nav-slide { margin-left: 0; }
-- Fay Code
--    addChangeMarginHover i element = do
--      addHover i element (addNavSlide) (removeNavSlide)
--     where
--      addNavSlide object _  _  =
--        addClass "nav-slide" object >> return ()
--      removeNavSlide object _ _ = do
--        hasActiveClass <- hasClass ".active" object
--        if hasActiveClass then return ()
--        else removeClass "nav-slide" object >> return ()
addHover :: JQuery
         -> (JQuery -> Event -> Fay ())
         -> (JQuery -> Event -> Fay ())
         -> Fay Bool
addHover object enterAction leaveAction = do
  hoverName <- dataAttr hoverObjectData object
  hoverObject <- select hoverName
  hoverEnterLeave (enterAction object)
                  (leaveAction object)
                  hoverObject
  return True

-- Preloads image for the given picturePath.
-- Html file needs to have the following line: <div id="preload"></div>
preloadImage :: String -> Fay ()
preloadImage picturePath = do
  divPreload <- select preloadId
  prependString imgSrc divPreload
 where
  imgSrc = "<img src='" ++ picturePath ++ "' alt='preload'/>"