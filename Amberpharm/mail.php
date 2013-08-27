<?php

  $name = $_POST['name'];
  $mail = $_POST['mail'];
  $msg = $_POST['msg'];

  $to = "info@amberpharm.de";
  $subject = "Amberpharm Kontaktformular";

  /* $umlautArray = Array(”/ä/”,”/ö/”,”/ü/”,”/Ä/”,”/Ö/”,”/Ü/”,”/ß/”); */
  /* $replaceArray = Array(”&auml;”,”&ouml;”,”&uuml;”,”&Auml;”,”&Ouml;”,”&Uuml;”,”&szlig;”); */
  /* $msg = preg_replace($umlautArray , $replaceArray , $msg); */

  $header .= 'From:' . $name . '<' . $mail . '>';

    if ((!empty($name))&&(!empty($mail))&&(!empty($msg))) {
      // this line checks that we have a valid email address
      if (filter_var($mail, FILTER_VALIDATE_EMAIL)) {
        $send = mail($to, $subject, $msg, $header); //Mail versenden
        echo $send;
      } else {
        echo "invalidMail";
      }
    }

?>