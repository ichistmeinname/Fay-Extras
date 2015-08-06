{-# LANGUAGE NoImplicitPrelude #-}

module ConstantsAndHelpers where

import Prelude
import JQuery
import Fay.Text (Text, pack, unpack)

type IdName = Text

preloadId :: IdName
preloadId = pack "#preload"

textId :: IdName
textId = pack "#text"

textLowId :: IdName
textLowId = pack "#text-low"

galleryPictureId :: IdName
galleryPictureId = pack "#gallery-picture"

contentId :: IdName
contentId = pack "#content"

contentIdA :: IdName
contentIdA = pack "#content>a"

mkDataAttr :: Text -> Text
mkDataAttr = pack . ("data-" ++) . unpack

dataCategory :: Text
dataCategory = pack "data-category"
         
type Attr = Text
type Class = Text
type ClassName = String

mkClass :: Text -> Text
mkClass = pack . ('.' :) . unpack

arrowClass :: Class
arrowClass = pack "arrow"
          
linkClass :: Class
linkClass = pack "link"

movableClass :: Class
movableClass = pack "movable"

galleryNavClass :: Class
galleryNavClass = pack "gallery-navigation"

navItemClass :: Class
navItemClass = pack "nav-item"

activeClass :: Class
activeClass = pack "active"

activeNavClass :: Class
activeNavClass = pack "activeNav"

blackWhiteClass :: Class
blackWhiteClass = pack "black_white"

bubbleImageClass :: Class
bubbleImageClass = pack ".bubble"

thumbnailClass :: Class
thumbnailClass = pack "thumbnail"

scaleZeroClass :: Class
scaleZeroClass = pack "scaleZero"

navSlideClass :: Class
navSlideClass = pack "navSlide"

type DataName = String

mouseEnterData :: DataName
mouseEnterData = "mouseenter"

mouseLeaveData :: DataName
mouseLeaveData = "mouseleave"

hoverObjectData :: DataName
hoverObjectData = "hoverobj"

scrollPositionData :: DataName
scrollPositionData = "scrollpos"

hrefData:: DataName
hrefData = "href"

clickData :: DataName
clickData = "click"

startData :: DataName
startData = "start"

endData :: DataName
endData = "end"

speedData :: DataName
speedData = "speed"

offsetData :: DataName
offsetData = "offset"

hoverClassData :: DataName
hoverClassData = "hoverclass"

linkTagData :: DataName
linkTagData = "click"

visibilityData :: DataName
visibilityData = "vis"
