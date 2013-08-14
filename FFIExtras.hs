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

dataAttr :: String -> JQuery -> Fay String
dataAttr = ffi "%2.data(%1)"

dataAttrDouble :: String -> JQuery -> Fay Double
dataAttrDouble = ffi "%2.data(%1)"

hoverEnterLeave :: (Event -> Fay ()) -> (Event -> Fay ()) -> JQuery -> Fay ()
hoverEnterLeave = ffi "%3.hover(%1, %2)"

cssDouble :: String -> JQuery -> Fay Double
cssDouble = ffi "%2.css(%1)"

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

animateMarginLeft :: String -> Double -> JQuery -> Fay ()
animateMarginLeft = ffi "%3.animate({'marginLeft': %1}, %2)"

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
triggerHover = ffi "%1['trigger']('scroll')"

windowWidth :: JQuery -> Fay Double
windowWidth = ffi "%1.width()"

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