{-# LANGUAGE NoImplicitPrelude #-}

module Fay.CKDesign.Gallery where

import Prelude
import FFI
import JQuery hiding ( not, filter )
import ConstantsAndHelpers
import FFIExtras
import FayExtras
import FayDesign
import Fay.Text (pack, Text)

main = do
  documentReady onReady document

onReady :: Event -> Fay ()
onReady _ = do
  win <- select window
  width <- windowWidth win
  navigationElements <- selectClass navItemClass
  each (addActive changeBGImage changeBGImage) navigationElements
  linkElements <- selectClass linkClass
  each addHref linkElements
  each addChangeCategory navigationElements
  initiateGallery
  return ()
  

initiateGallery = do
  query <- searchQuery
  choseDefaultCategory
  -- if null query
  --  then choseDefaultCategory
  --  else do
  --    let currentCategory = tail $ dropWhile (isParam) query
  --    if null currentCategory
  --     then choseDefaultCategory
  --     else preloadGallery [currentCategory]
 where
   isParam char = not (char == '=')
   choseDefaultCategory = do
     gallery <- select galleryPictureId
     defaultCategory <- dataAttr "category" gallery
     preloadGalleryImage True 1.0 defaultCategory

preloadGallery names =
  mapM_ (preloadGalleryImage False 1.0) names

preloadGalleryImage :: Bool -> Double -> String -> Fay ()
preloadGalleryImage init index name = do
  get' (path name (show index) ".jpg") (doneCallback) (failCallback)
  return ()
 where
   doneCallback _ = do
     putStrLn (path name (show index) ".suffix")
     preloadImage (path name (show index) ".jpg")
     preloadImage (path name (show index) ".png")
     preloadGalleryImage init (index + 1) name
   failCallback _ = do
     object <- select galleryPictureId
     setAttr (mkDataAttr (pack name)) (pack (show (index - 2))) object
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
  object <- select element
  click (onClick newCategory) object
  return True
 where onClick category _ = setupGallery category

setupGallery category = do
  gallery <- select galleryPictureId
  setAttr dataCategory (pack category) gallery
  updateGallery category
  active <- select (mkClass activeNavClass)
  removeClass navSlideClass active
  removeClass activeNavClass active
  each addChangeMarginHover active
  navObject <- select categoryID
  turnOffHover navObject
  addClass activeNavClass navObject
  return ()
 where
   categoryID = pack ("#" ++ category ++ "-nav")

updateGallery category = do
  setGalleryPicture (path category "1" ".jpg")
  captionAndDescription (path category "1" ".html")
  setGalleryPictureHref (path category "1" "-link.html")
  updateArrowNavigation category 0
  putStrLn "updateGallery"


-- addThumbnailEffects dir index element = do
--   galleryObject <- select "#gallery-picture"
--   countString <- getAttr ("data-"++dir) galleryObject
--   count <- attrDouble ("data-"++dir) galleryObject
--   if null countString
--    then get (path dir name ".png") doneCallback (\e -> failCallback)
--          >> return ()
--    else if (index <= count)
--     then get (path dir name ".png") doneCallback emptyCallback >> return ()
--     else failCallback
--   return True
--  where
--    name = show (index+1)
--    doneCallback _ = do
--      addBubbleEffect index element
--      addThumbNavigation dir index element
--    failCallback = do
--      object <- select element
--      setBackgroundImage "none" object
--      turnOffHover object
--      turnOffClick object

-- addThumbNavigation :: String -> Double -> Element -> Fay ()
-- addThumbNavigation dir index element = do
--   object <- select element
--   setThumbnailPicture (path dir name ".png") object
--   turnOffClick object
--   click (onThumbnailClick dir index element) object
--   return ()
--  where
--    name = show (index+1)

data Arrow = Left | Right

addArrowNavigation :: String -> Double -> Element -> Fay Bool
addArrowNavigation dir index element = do
   galleryPicture <- select galleryPictureId
   pictureIndexStr <- dataAttr "index" galleryPicture
   let pictureIndex = readPrec 0 pictureIndexStr
   putStrLn "Arrow"
   print pictureIndex
   object <- select element
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
  setGalleryPicture (path dir name "jpg")
  captionAndDescription name
  setGalleryPictureHref (path dir name "html")
  updateArrowNavigation dir index
  return ()
 where name = show (index + 1)

updateArrowNavigation dir index = do
  putStrLn "updateArrow"
  object <- select galleryPictureId
  setAttr (mkDataAttr (pack "index")) (pack (show index)) object
  arrowElements <- select arrowClass
  each (addArrowNavigation dir) arrowElements

setGalleryPictureHref htmlPath =
  get' htmlPath (doneCallback) (failCallback)
 where
   doneCallback htmlString = do
     object <- select contentId
     appendString htmlString object
     return ()
   failCallback _ = do
     object <- select contentIdA
     remove object
     return ()

captionAndDescription categoryName = do
  get' (categoryName ++ ".html") doneCallback emptyCallback
 where
   doneCallback answer = do
     object <- select textId
     setHtml answer object
     return ()

setGalleryPicture jpgPath = do
  object <- select galleryPictureId
  setBackgroundImage jpgPath object


-- Helpers

get' :: String -> (Text -> Fay ()) -> (Text -> Fay ()) -> Fay ()
get' str = get (pack str)

galleryPrefix :: String
galleryPrefix     = "gallery/"

path :: String -> String -> String -> String
path dir name suffix =
  galleryPrefix ++ dir ++ "/" ++ name ++ suffix

galleryCategories :: [String]
galleryCategories = ["ci","etc","editorial","multimedia"]
