<?php
  $name = $_POST['name'];
  $mail = $_POST['mail'];
  $msg = $_POST['msg'];

  $to = "admin@carinamitc.de";
  $subject = "Kontaktformularnachricht von " + $name;
 
    if ((!empty($name))&&(!empty($mail))&&(!empty($msg))) {
      mail($to, $subject, $msg, 'From:' . $email); //Mail versenden 
      return true;
    } else {
      return false;
    }
?>