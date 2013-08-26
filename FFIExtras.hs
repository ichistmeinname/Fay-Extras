{-# LANGUAGE NoImplicitPrelude #-}

module FFIExtras where

import Prelude
import FFI
import JQuery

searchQuery :: Fay String
searchQuery = ffi "$(location).attr('search')"

get :: String -> (String -> Fay ()) -> (String -> Fay ()) ->  Fay ()
get = ffi "jQuery.get(%1).done(%2).fail(%3)"

appendString :: String -> JQuery -> Fay ()
appendString = ffi "%2.append(%1)"

prependString :: String -> JQuery -> Fay ()
prependString = ffi "%2.prepend(%1)"

attrDouble :: String -> JQuery -> Fay Double
attrDouble = ffi "%2.attr(%1)"

setDataAttr :: String -> String -> JQuery -> Fay ()
setDataAttr = ffi "%3.data(%1, %2)"

setDataAttrDouble :: String -> Double -> JQuery -> Fay ()
setDataAttrDouble = ffi "%3.data(%1, %2)"

dataAttr :: String -> JQuery -> Fay String
dataAttr = ffi "%2.data(%1)"

dataAttrDouble :: String -> JQuery -> Fay Double
dataAttrDouble = ffi "%2.data(%1)"

hoverEnterLeave :: (Event -> Fay ()) -> (Event -> Fay ()) -> JQuery -> Fay ()
hoverEnterLeave = ffi "%3.hover(%1, %2)"

cssDouble :: String -> JQuery -> Fay Double
cssDouble = ffi "parseInt(%2.css(%1), 10)"

setMarginLeft :: Double -> JQuery -> Fay ()
setMarginLeft = ffi "%2.css(\"margin-left\", %1)"

setBackgroundImage :: String -> JQuery -> Fay ()
setBackgroundImage imageName = setBackgroundImage' (toURL imageName)
 where
  toURL image = "url(" ++ image ++ ")"

setBackgroundImage' :: String -> JQuery -> Fay ()
setBackgroundImage' = ffi "%2.css(\"background-image\", %1)"

setPositionY :: Double -> JQuery -> Fay ()
setPositionY = ffi "%2.css(\"top\", %1)"

setPositionX :: Double -> JQuery -> Fay ()
setPositionX = ffi "%2.css(\"left\", %1)"

animateLeft :: String -> Double -> JQuery -> Fay ()
animateLeft = ffi "%3.animate({'left': %1}, %2)"

animateLeftEaseOutBack :: String -> String -> Double -> JQuery -> Fay ()
animateLeftEaseOutBack = ffi "%4.animate(\
  \ {'left': %1}, {'duration': %3 * 0.7, 'easing': 'swing'}).animate(\
  \ {'left': %2}, {'duration': %3 * 0.3, 'easing': 'swing'})"

animateTop :: String -> Double -> JQuery -> Fay ()
animateTop = ffi "%3.animate({'top': %1}, %2)"

animateScale :: String -> Double -> JQuery -> Fay ()
animateScale = ffi "\
  \ %3.animate({  'borderSpacing': %1 }, {\
  \ 'step': function(now,fx) {\
     \ %3.css('-webkit-transform','scale('+(now/100)+','+(now/100)+')');\
   \ },duration:'slow'},'linear')"

animateLeftTop :: String -> String -> Double -> JQuery -> Fay ()
animateLeftTop = ffi "%4.animate({'left': %1, 'top': %2}, %3)"

animateMarginLeft :: String -> Double -> JQuery -> Fay ()
animateMarginLeft = ffi "%3.animate({'marginLeft': %1}, %2)"

animateMarginTop :: String -> Double -> JQuery -> Fay ()
animateMarginTop = ffi "%3.animate({'marginTop': %1}, %2)"

animateScrollTop :: Double -> Double -> JQuery -> Fay ()
animateScrollTop = ffi "%3.animate({'scrollTop': %1}, %2)"

animateScrollLeft :: Double -> Double -> JQuery -> Fay ()
animateScrollLeft = ffi "%3.animate({'scrollLeft': %1}, %2)"

unbind :: String -> JQuery -> Fay ()
unbind = ffi "%2.unbind(%1)"

triggerScroll :: JQuery -> Fay ()
triggerScroll = ffi "%1['trigger']('scroll')"

turnOffClick :: JQuery -> Fay ()
turnOffClick = unbind "click"

turnOffHover :: JQuery -> Fay ()
turnOffHover object = do
  unbind "mouseenter" object
  unbind "mouseleave" object

triggerHover :: JQuery -> Fay ()
triggerHover = ffi "%1['trigger']('hover')"

triggerMouseLeave :: JQuery -> Fay ()
triggerMouseLeave = ffi "%1['trigger']('mouseleave')"

fadeInE :: Double -> (() -> Fay JQuery) -> JQuery -> Fay JQuery
fadeInE = ffi "%3.fadeIn(%1, %2)"

fadeOutE :: Double -> (() -> Fay JQuery) -> JQuery -> Fay JQuery
fadeOutE = ffi "%3.fadeOut(%1, %2)"

windowWidth :: JQuery -> Fay Double
windowWidth = ffi "%1.width()"

setTimeout :: Fay () -> Double -> Fay ()
setTimeout = ffi "setTimeout( %1, %2 )";

setLocation :: String -> Fay ()
setLocation = ffi "window.location = %1"

body :: Fay JQuery
body = select "body"

window :: Element
window = ffi "window"

document :: Document
document = ffi "document"

log :: String -> Fay ()
log = ffi "console.log(%1)"