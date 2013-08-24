<?php

  $name = $_POST['name'];
  $mail = $_POST['mail'];
  $msg = $_POST['msg'];

  $to = "admin@carinamitc.de";
  $subject = "Kontaktformularnachricht von " + $name;
 
    if ((!empty($name))&&(!empty($mail))&&(!empty($msg))) {
      // this line checks that we have a valid email address
      if (filter_var($mail, FILTER_VALIDATE_EMAIL)) {
        $send = mail($to, $subject, $msg, 'From:' . $mail); //Mail versenden
        echo $send;
      } else {
        echo "invalidMail";
      }
    }

?>