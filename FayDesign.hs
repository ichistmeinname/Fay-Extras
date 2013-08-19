module FayDesign where

import FayExtras
import ConstantsAndHelpers
import Prelude
import JQuery
import FFIExtras

-- selectId = select . (:) '#'

-- galleryCategories = ["ci","etc","editorial","multimedia"]

-- galleryPath :: String -> Double -> String
-- galleryPath category index =
--   "gallery/" ++ category ++ "/" ++ show index

-- preloadGallery =
--   mapM_ preloadCategories galleryCategories

-- preloadCategory :: String -> Fay ()
-- preloadCategory category =
--   mapM_ (\index -> get (path category index ++ ".html")
--                        (doneCallback index)
--                        emptyCallback)
--         [1..7]
--  where
--    doneCallback _ = do
--      preloadGalleryImage (path category index)
--      object <- selectId category
--      print index
--      setDataAttr category (show index) object
--    failCallback _ = return ()

-- descriptionData = "descr"

-- preloadGalleryImage path =
--   preloadImage (path ++ ".jpg")
--   preloadImage (path ++ ".png")

addNavigationSlider i element = do
  hoverObject <- selectElement element
  addHover hoverObject (addNavSlide) (removeNavSlide)
 where
  addNavSlide object _  =
    addClass navSlideClass object >> return ()
  removeNavSlide object _ = do
    hasActiveClass <- hasClass activeClass object
    if hasActiveClass
       then return ()
       else removeClass navSlideClass object >> return ()

addChangeImageOnHover mPrefix i element = do
  hoverObject <- selectElement element
  addHover hoverObject (onChange mouseEnterData) (onChange mouseLeaveData)
 where
  onChange pictureData pictureObject _   = do
    pictureName <- dataAttr pictureData pictureObject
    let imageOver = case mPrefix of
          Nothing     -> pictureName
          Just prefix -> prefix ++ "/" ++ pictureName
    preloadImage imageOver
    setBackgroundImage imageOver pictureObject

addResizeEffect i element = do
  resizeObject <- selectElement element
  addHover resizeObject (resize addClass) (resize removeClass)
 where
  resize updateClass _ _ = do
    resizeObject <- selectElement element
    hoverClassName <- dataAttr hoverClassData resizeObject
    updateClass hoverClassName resizeObject
    return ()
