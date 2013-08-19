{-# LANGUAGE NoImplicitPrelude #-}

module Fay.CKDesign.Gallery where

import Prelude
import FFI
import JQuery hiding ( not, filter )
import ConstantsAndHelpers
import FFIExtras
import FayDesign

main = do
  documentReady onReady document

onReady :: Event -> Fay ()
onReady _ = do
  win <- selectElement window
  width <- windowWidth win
  navigationElements <- selectClass navItemClass
  each addNavigationSlider navigationElements
  linkElements <- selectClass linkClass
  each addHref linkElements
  each addChangeCategory navigationElements
  initiateGallery
  return ()

initiateGallery = do
  query <- searchQuery
  if null query
   then choseDefaultCategory
   else do
     let currentCategory = tail $ dropWhile (isParam) query
     if null currentCategory
      then choseDefaultCategory
      else preloadGalleryImage currentCategory
 where
   isParam char = not (char == '=')
   choseDefaultCategory = do
     gallery <- select "#gallery-picture"
     defaultCategory <- dataAttr "category" gallery
     preloadGalleryImage True 1.0 defaultCategory

preloadGallery names =
  mapM_ (preloadGalleryImage False 1.0) names

preloadGalleryImage :: Bool -> Double -> String -> Fay ()
preloadGalleryImage init index name =
  get (path name (show index) ".jpg") (doneCallback) (failCallback)
   >> return ()
 where
   doneCallback _ = do
     preloadImage (galleryPrefix ++ name ++ "/") (show index) ".jpg"
     preloadImage (galleryPrefix ++ name ++ "/") (show index) ".png"
     preloadGalleryImage init (index + 1) name
   failCallback _ = do
     object <- select "#gallery-picture"
     setAttr ("data-"++name) (show (index - 2)) object
     if init then do
        let categories = deleteFromList name galleryCategories
        preloadGallery categories
        setupGallery name
      else return ()

deleteFromList elem [] = []
deleteFromList elem (x:xs) | x == elem = deleteFromList elem xs
deleteFromList elem (x:xs) = x: deleteFromList elem xs

addChangeCategory index element = do
  let newCategory = case index of
        0 -> "editorial"
        1 -> "multimedia"
        2 -> "ci"
        otherwise -> "etc"
  object <- selectElement element
  click (onClick newCategory) object
  return True
 where onClick category _ = setupGallery category

setupGallery category = do
  gallery <- select "#gallery-picture"
  setAttr "data-category" category gallery
  updateThumbnails category
  active <- select ".activeNav"
  removeClass navSlideClassName active
  removeClass "activeNav" active
  each addChangeMarginHover active
  navObject <- select categoryID
  turnOffHover navObject
  addClass "activeNav" navObject
  return ()
 where
   categoryID = "#" ++ category ++ "-nav"

updateThumbnails category = do
  thumbnailObjects <- select thumbnailClass
  each (addThumbnailEffects category) thumbnailObjects
  setGalleryPicture (path category "1" ".jpg")
  captionAndDescription (path category "1" ".html")
  setGalleryPictureHref (path category "1" "-link.html")
  updateArrowNavigation category 0


addThumbnailEffects dir index element = do
  galleryObject <- select "#gallery-picture"
  countString <- getAttr ("data-"++dir) galleryObject
  count <- attrDouble ("data-"++dir) galleryObject
  if null countString
   then get (path dir name ".png") doneCallback (\e -> failCallback)
         >> return ()
   else if (index <= count)
    then get (path dir name ".png") doneCallback emptyCallback >> return ()
    else failCallback
  return True
 where
   name = show (index+1)
   doneCallback _ = do
     addBubbleEffect index element
     addThumbNavigation dir index element
   failCallback = do
     object <- selectElement element
     setBackgroundImage "none" object
     turnOffHover object
     turnOffClick object

addThumbNavigation :: String -> Double -> Element -> Fay ()
addThumbNavigation dir index element = do
  object <- selectElement element
  setThumbnailPicture (path dir name ".png") object
  turnOffClick object
  click (onThumbnailClick dir index element) object
  return ()
 where
   name = show (index+1)

data Arrow = Left | Right

addArrowNavigation :: String -> Double -> Element -> Fay Bool
addArrowNavigation dir index element = do
   galleryPicture <- select "#gallery-picture"
   pictureIndex <- dataAttrDouble "index" galleryPicture
   object <- selectElement element
   turnOffClick object
   max <- dataAttrDouble dir galleryPicture
   case index of
     0 -> if outOfLeftBounds pictureIndex then return ()
          else arrowClick (pictureIndex - 1) object
     1 -> if outOfRightBounds pictureIndex max then return ()
          else arrowClick (pictureIndex - (-1)) object
   return True
 where
   arrowClick page obj = click (onThumbnailClick dir page element) obj
                         >> return ()
  outOfLeftBounds  = (<=) 0
  outOfRightBounds = (>=)

onThumbnailClick :: String -> Double -> Element -> Event -> Fay ()
onThumbnailClick dir index element _ = do
  setGalleryPicture (path dir name)
  captionAndDescription name
  setGalleryPictureHref (path dir name)
  updateArrowNavigation dir index
  return ()
 where name = show (index + 1)

updateArrowNavigation dir index = do
  object <- select "#gallery-picture"
  setDataAttr "index" (show index) object
  arrowElements <- select ".arrow"
  each (addArrowNavigation dir) arrowElements

setThumbnailPicture pngPath object = do
  setBackgroundImage pngURL object
 where pngURL = toURL pngPath

setGalleryPictureHref htmlPath =
  get htmlPath (doneCallback) (failCallback)
 where
   doneCallback htmlString = do
     object <- select "#content"
     appendString htmlString object
     return ()
   failCallback _ = do
     object <- select "#content>a"
     remove object
     return ()

captionAndDescription categoryName = do
  get (categoryName ++ ".html") doneCallback emptyCallback
 where
   doneCallback answer = do
     object <- select textID
     setHtml answer object
     return ()

setGalleryPicture jpgPath = do
  object <- select "#gallery-picture"
  setBackgroundImage jpgURL object
 where jpgURL = toURL jpgPath