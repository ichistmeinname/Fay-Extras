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
  spotObjs <- select (pack ".play-button")
  each addClick spotObjs
  gallery <- select galleryPictureId
  defaultCategoryString <- dataAttr "category" gallery
  let defaultCategory = readCategory defaultCategoryString
  navObj <- select (pack ("#" ++ defaultCategoryString))
  addClass activeClass navObj
  galleryElements <- selectClass galleryNavClass
  each (\d -> addChangeCategory (round d)) galleryElements
  each (addActive noAction noAction) galleryElements
  linkElements <- selectClass linkClass
  each addHref linkElements
  initiateGallery defaultCategory
  return ()
 where
  addClick idx element =
    select element >>= click (\_ -> select (pack ("#audio-" ++ show (idx+1))) >>= play)
     >> return True
  noAction _ = return ()
  
initiateGallery defaultCategory = do
  preloadGalleryImages 0 defaultCategory
  setupGallery 0 defaultCategory

-- preloadGallery names =
--   mapM_ (preloadGalleryImage False 1) names

preloadGalleryImages :: Int -> Category -> Fay ()
preloadGalleryImages _ cat = do
  mapM_ preloadGalleryImage
        (imagesForCategory cat)
 where
   preloadGalleryImage name = do
     object <- select (pack "#preload")
     appendString (pack (preloadText cat name)) object
     return ()

addChangeCategory :: Int -> Element -> Fay Bool
addChangeCategory index element = do
  let newCategory = case index of
        0 -> CI
        1 -> Web
        _ -> Etc
  object <- select element
  click (onClick newCategory) object
  return True
 where onClick category _ = setupGallery 0 category


setupGallery :: Int -> Category -> Fay ()
setupGallery index category = do
  gallery <- select galleryPictureId
  setAttr dataCategory (pack (showCategory category)) gallery
  setDataAttrDouble (pack "index") index gallery
  updateGallery index category
  return ()

updateGallery :: Int -> Category -> Fay ()
updateGallery index cat = do
  if cat == Etc && index == 4
    then select (pack ".play-button")
          >>= each (\_ e -> select e >>= unhide >> return True) --(hideButtons False)
    else select (pack ".play-button")
           >>= each (\_ e -> select e >>=  hide Instantly >> return True) -- (hideButtons True)
  let catImages = imagesForCategory cat
  setGalleryPicture ("images/gallery/" ++ showCategory cat ++ "/" ++ (catImages !! index))
  captionAndDescription ("images/gallery/" ++ showCategory cat ++ "/" ++ show (index+1) ++ ".html")
  updateArrowNavigation cat index
  return ()
 where
  hideButtons bool _ e =
    let prop = if bool then "none" else "block"
    in select e >>= setAttr (pack "display") (pack prop) >> return True

addArrowNavigation :: Category -> Double -> Element -> Fay Bool
addArrowNavigation cat dir element = do
   galleryPicture <- select galleryPictureId
   pictureIndexStr <- dataAttr "index" galleryPicture
   pictureIndex' <- dataAttrDouble "index" galleryPicture
   let pictureIndex = round pictureIndex'
   object <- select element
   turnOffClick object
   let newIndex = case dir of
                      0 -> pictureIndex - 1
                      1 -> pictureIndex + 1
   case dir of
     0 -> if outOfLeftBounds newIndex then arrowClick (Just (prevCat cat))
                                                      (length (imagesForCategory (prevCat cat)) - 1)
                                                      object
          else arrowClick Nothing newIndex object
     1 -> if outOfRightBounds newIndex then arrowClick (Just (nextCat cat)) 0 object
          else arrowClick Nothing newIndex object
   return True
 where
   arrowClick Nothing pIndex obj = click (\_ -> updateGallery pIndex cat) obj >> return ()
   arrowClick (Just nCat) pIndex obj = click (\_ -> changeCategory nCat >> updateGallery pIndex nCat) obj
                                       >> return ()
   changeCategory c = select (pack ("#" ++ showCategory c)) >>= trigger (pack "click")
   outOfLeftBounds  = (< 0)
   outOfRightBounds = (> (length (imagesForCategory cat) - 1))

nextCat CI  = Web
nextCat Web = Etc
nextCat Etc = CI

prevCat CI = Etc
prevCat Web = CI
prevCat Etc = Web

updateArrowNavigation dir index = do
  object <- select galleryPictureId
  setDataAttrDouble (pack "index") index object
  arrowElements <- select (mkClass arrowClass)
  each (addArrowNavigation dir) arrowElements

captionAndDescription path = do
  get' path doneCallback emptyCallback
 where
   doneCallback answer = do
     object <- select textId
     setHtml answer object
     object <- select textLowId
     setHtml answer object
     return ()
   get' str = get (pack str)
  -- tObj <- select (pack "#text")
  -- c1 <- select (pack "#caption1>p")
  -- c2 <- select (pack "#caption2>p")
  -- descr <- select (pack "#description>p")
  -- appendString (pack (preloadText cat name)) c1
  -- appendString (pack (preloadText cat name)) c2
  -- appendString (pack (preloadText cat name)) descr
  -- get path
  -- appendString (pack (preloadText cat name)) tObj

setGalleryPicture pngPath = do
  object <- select galleryPictureId
  setBackgroundImage pngPath object


galleryCategories :: [String]
galleryCategories = ["ci","etc","web"]

data Category = CI | Etc | Web
 deriving Eq

readCategory str = case str of
                         "ci"  -> CI
                         "etc" -> Etc
                         "web" -> Web

showCategory CI  = "ci"
showCategory Etc = "etc"
showCategory Web = "web"

imagesForCategory :: Category -> [String]
imagesForCategory CI  = ciImages
imagesForCategory Etc = etcImages
imagesForCategory Web = webImages

ciImages :: [String]
ciImages = [ "1_backpackers.png"
           , "2_tinkerbelle.png"
           , "3_mybiostoff.png"
           , "4_Schwanthalerhoehe.png"
           , "5_LevonSupreme.png"
           , "6_reisumdiewelt.png" ]

webImages :: [String]
webImages = ["1_NOI.png", "2_AGde.png", "3_redkiwi.png"]

etcImages :: [String]
etcImages = [ "1_Hanau1.png"
            , "2_Hanau2.png"
            , "3_Hanau3.png"
            , "4_FGB1.png"
            , "5_Radio.png"
            , "6_FGB2.png"
            , "7_Waterfall.png"
            , "8_Hochzeit.png"
            , "9_Hyundai.png"
            , "10_Sensuade.png" ]

preloadText :: Category -> String -> String
preloadText cat name= "<img src='images/gallery/" ++ showCategory cat ++ "/" ++ name ++ "' alt='preload'>"
