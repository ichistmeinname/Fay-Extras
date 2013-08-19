module FayDesign where

import FayExtras

addActiveNavigation :: Double -> Element -> Fay Bool
addActiveNavigation _ element = do
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

addChangeImageOnHover i element = do
  hoverObject <- selectElement element
  addHover hoverObject (onChange True) (onChange False)
 where
  onChange isEnter pictureObject _   = do
    let pictureData = if isEnter then mouseEnterData else mouseLeaveData
    pictureName <- dataAttr pictureData pictureObject
    let imageOver = prependPortfolioPrefix pictureName
    preloadImage imageOver
    setBackgroundImage imageOver pictureObject
