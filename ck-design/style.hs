{-# LANGUAGE OverloadedStrings #-}

import Clay

import Data.Text


main :: IO ()
main =
  -- writeFile "clayTest.css" (render ckStyle)
  putCss ckStyle

noRepeatBackground :: Text -> Css
noRepeatBackground img = do
  backgroundImage (url img)
  backgroundRepeat noRepeat

ckStyle :: Css
ckStyle = do
  body ? do
    background white
    height (px 3200)

  "#logo" ? do
    noRepeatBackground "images/image1.png"
    position fixed
    height (px 236)
    width (px 303)
    -- left (pct 50)
    marginLeft (px (negate 152))

  "#picture" ? do
    noRepeatBackground "images/image2.png"
    position fixed
    height (px 315)
    width (px 325)
    -- left (pct 50)
    marginLeft (px 350)

  "#vita" ? do
    position fixed
    -- left (pct 50)
    marginLeft (px 100)

  "#vita_text" ? do
    noRepeatBackground "images/image3.png"
    position fixed
    height (px 339)
    width (px 419)

  "#vita_title" ? do
    noRepeatBackground "images/image4.png"
    height (px 211)
    width (px 363)
    position fixed
    marginLeft (px 25)

  "#portfolio" ? do
    backgroundImage (url "images/image5.png")
    backgroundRepeat noRepeat
    height (px 194)
    width (px 769)
    position fixed
    -- left (pct 50)
    marginLeft (px (negate 385))

  "#gallery" ? do
    backgroundImage (url "images/image6.png")
    backgroundRepeat noRepeat
    position fixed
    height (px 460)
    width (px 990)
    -- left (pct 50)
    marginLeft (px 485)

  "#contact" ? do
    position fixed
    -- left (pct 50)
    marginLeft (px (negate 341))

  "#contact_title" ? do
    backgroundImage (url "images/image7.png")
    backgroundRepeat noRepeat
    position fixed
    height (px 192)
    width (px 682)


-- #contact_text{
--     /* background-image: url('images/image8.png'); */
--     /* background-repeat: no-repeat; */
--     height: 121px;
--     width: 194px;
--     position: fixed;
--     margin-left: 488px;
--     z-index: 1;
-- }

-- #contact_text>p{
--     line-height: 1em;
--     letter-spacing: 0.11em;
--     font-size: 16;
--     font-family: Helvetica;
--     font-weight: lighter;
--     color: rgb(115,117,120);
--     text-align: right;
-- }

-- a:link#mail {
--     font-weight: bold;
--     text-decoration: none;
--     color: rgb(115,117,120);
--     border: 1px dotted;
--     border-color: white;
-- }

-- a:hover#mail {
--     border: 1px dotted;
--     border-color: rgb(71,176,184);
-- }

-- #impressum {
--     background-image: url('images/image9.png');
--     background-repeat: no-repeat;
--     height: 211px;
--     width: 879px;
--     position: fixed;
--     left: 50%;
--     margin-left: -400px;
--     z-index: 1;
-- }

-- #impressum_text {
--     background-image: url('images/image10.png');
--     background-repeat: no-repeat;
--     height: 265px;
--     width: 663px;
--     position: fixed;
--     left: 50%;
--     margin-left: -330px;
--     z-index: 1;
-- }

-- ul {
--     list-style-type: none;
--     margin-left: -40px;
-- }

-- #nav {
--     position: fixed;
--     top: 50%;
--     left: 0%;
--     margin-top: -150px;
--     z-index: 2000;
-- }

-- #nav-item1 {
--     background-image: url('images/nav1.png');
--     background-repeat: no-repeat;
--     height: 46px;
--     width: 127px;
-- }

-- #nav-item2 {
--     background-image: url('images/nav2.png');
--     background-repeat: no-repeat;
--     height: 46px;
--     width: 127px;
-- }

-- #nav-item3 {
--     background-image: url('images/nav3.png');
--     background-repeat: no-repeat;
--     height: 46px;
--     width: 127px;
-- }

-- #nav-item4 {
--     background-image: url('images/nav4.png');
--     background-repeat: no-repeat;
--     height: 46px;
--     width: 127px;
-- }

-- #gallery-box {
--     height: 500px;
--     width: 825px;
--     border: 2px solid;
--     border-color: rgb(71,176,184);
--     box-shadow: 1px 1px 5px 5px rgb(175,177,180);
--     position: fixed;
--     left: 50%;
--     margin-left: -350px;
--     margin-top: 5%;
-- }

-- #rightarrow:before, #rightarrow:after {
--     content: '';
--     margin-top: 240px;
--     width: 20px;
--     display:block;
--     height: 20px;
--     background: rgb(71,176,184);
--     float: right;
--     margin-right: 10px;
--     -webkit-transform: rotate(-45deg);
-- }

-- #rightarrow:after {
--     margin-right: -17.5px;
--     background: white;
-- }

-- #leftarrow:before, #leftarrow:after {
--     content: '';
--     margin-top: 240px;
--     width: 20px;
--     display:block;
--     height: 20px;
--     background: rgb(71,176,184);
--     float: left;
--     margin-left: 10px;
--     -webkit-transform: rotate(45deg);
-- }

-- #leftarrow:after {
--     margin-left: -17.5px;
--     background: white;
-- }

-- .gallery-thumbnail {
--   position: fixed;
--   height: 75px;
--   width: 75px;
--   border: 1.5px solid;
--   border-color: rgb(71,176,184);
--   left: 50%;
--   margin-top: 525px;
-- }

-- #gallery-thumbnail1 {
--   margin-left: -350px;
-- }

-- #gallery-thumbnail2 {
--   margin-left: -225px;
-- }

-- #gallery-thumbnail3 {
--   margin-left: -100px;
-- }

-- #gallery-thumbnail4 {
--   margin-left: 25px;
-- }

-- #gallery-thumbnail5 {
--   margin-left: 150px;
-- }

-- #gallery-thumbnail6 {
--   margin-left: 275px;
-- }

-- #gallery-thumbnail7 {
--   margin-left: 400px;
-- }

-- .nav-item {
--     background-repeat: no-repeat;
--     height: 46px;
--     width: 127px;
-- }

-- #nav-gallery-item1 {
--     background-image: url('images/nav-gallery1.png');
-- }

-- #nav-gallery-item2 {
--     background-image: url('images/nav-gallery2.png');
-- }

-- #nav-gallery-item3 {
--     background-image: url('images/nav-gallery3.png');
-- }

-- #nav-gallery-item4 {
--     background-image: url('images/nav-gallery4.png');
-- }

-- #nav-gallery-item5 {
--     background-image: url('images/nav-gallery5.png');
-- }