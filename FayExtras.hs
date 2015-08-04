{-# LANGUAGE NoImplicitPrelude #-}

module FayExtras where

import Prelude
import JQuery
import ConstantsAndHelpers
import FFIExtras
import Fay.Text.Type (Text, pack, unpack)

data Visibility = Always | Range Double Double

data ScrollDir = Horizontal | Vertical

selectClass :: Class -> Fay JQuery
selectClass className = select (mkClass className)


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
  object <- select element
  href <- dataAttr hrefData object
  clickObject <- dataAttr clickData object >>= select . pack
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
--      each (addActive deactivateNavSlide) navigationElements
--      return ()
--  where
--      deactivateNavSlide obj = removeClass navSlideClass obj >> return ()
addActive :: (JQuery -> Fay ())
          -> (JQuery -> Fay ())
          -> Double
          -> Element
          -> Fay Bool
addActive actionWithActive actionWithObj _ element =
  select element >>= click onClick >> return True
 where
   onClick _ = do
     -- "unmark" current active object
     activeObject <- selectClass activeClass
     removeClass activeClass activeObject
     actionWithActive activeObject
     -- "mark" current active object
     obj <- select element
     addClass activeClass obj
     -- do some actions
     actionWithObj obj

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
  navObject <- select element
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
--      win <- select window
--      pos <- getScrollTop win
--      movableObjects <- select ".movable"
--      each (addParallaxEffect Horizontal pos) movableObjects
--      return ()
--    main :: Fay ()
--    main = select window >>= scroll onScroll
addParallaxEffect :: ScrollDir -> Double -> Double -> Element -> Fay Bool
addParallaxEffect dir pos _ element = do
  object <- select element
  speed <- dataAttrDouble speedData object
  offset <- dataAttrDouble offsetData object
  vis <- visibility object
  case movement vis speed offset pos of
       Nothing -> hide Instantly object >> return ()
       Just newPosition -> do
         jshow Instantly object
         let setPosition = case dir of
               Vertical -> setPositionY
               Horizontal -> setPositionX
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
  select element >>= click onClick >> return True
 where
  onClick _ = do
    bodyElem <- body
    oldPosition <- case dir of
      Vertical -> getScrollTop bodyElem
      Horizontal -> getScrollLeft bodyElem
    object <- select element
    position <- dataAttrDouble scrollPositionData object
    let duration = abs (oldPosition - position) * scrollSpeed
        scrollTo = case dir of
          Vertical -> animateScrollTop
          Horizontal -> animateScrollLeft
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
--      addHover element (addNavSlide) (removeNavSlide)
--     where
--      addNavSlide object _  =
--        addClass "nav-slide" object >> return ()
--      removeNavSlide object _ = do
--        hasActiveClass <- hasClass ".active" object
--        if hasActiveClass then return ()
--        else removeClass "nav-slide" object >> return ()
addHover :: JQuery
         -> (JQuery -> Event -> Fay ())
         -> (JQuery -> Event -> Fay ())
         -> Fay Bool
addHover object enterAction leaveAction = do
  hoverName <- dataAttr hoverObjectData object
  hoverObject <- select (pack hoverName)
  mouseenter (enterAction object) hoverObject
  mouseleave (leaveAction object) hoverObject
  -- hoverEnterLeave (enterAction object)
                  -- (leaveAction object)
                  -- hoverObject
  return True

-- Preloads image for the given picturePath.
-- Html file needs to have the following line: <div id="preload"></div>
preloadImage :: String -> Fay ()
preloadImage picturePath = do
  divPreload <- select preloadId
  prependString imgSrc divPreload
 where
  imgSrc = "<img src='" ++ picturePath ++ "' alt='preload'/>"

addChangeMarginHover :: Double -> Element -> Fay Bool                       
addChangeMarginHover _ element = do
  hoverObject <- select element
  addHover hoverObject (addNavSlide) (removeNavSlide)
 where
  addNavSlide object _  = do
    addClass navSlideClass object
    return ()
  removeNavSlide object _ = do
    hasActiveClass <- hasClass activeClass object
    if hasActiveClass
       then return ()
       else removeClass navSlideClass object >> return ()
addBubbleEffect :: Double -> Element -> Fay Bool
addBubbleEffect _ element = do
  bubbleObject <- select element
  addHover bubbleObject (changeBubble addClass) (changeBubble removeClass)
 where
  changeBubble :: (Text -> JQuery -> Fay JQuery) -> JQuery -> Event -> Fay ()
  changeBubble updateClass _ _ = do
    bubbleObject <- select element
    hoverClassName <- dataAttr hoverClassData bubbleObject
    updateClass (pack hoverClassName) bubbleObject
    return ()

turnOffBubbleEffect :: Double -> Element -> Fay Bool
turnOffBubbleEffect _ element = do
  object <- select element
  removeClass scaleZeroClass object
  return True
