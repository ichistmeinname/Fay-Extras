<?php
  function mail() {
  $name = $_POST['name'];
  $mail = $_POST['mail'];
  $subject = "Anfrage";
  $msg = $_POST['msg'];

  $to = "admin@carinamitc.de";
  $subject = "Kontaktformularnachricht " + $subject  + " " + $name;
 
    if ((!empty($name))&&(!empty($mail))&&(!empty($msg))) {
 
      mail($to, $subject, $msg, 'From:' . $email); //Mail versenden
 
      //redirect("http://carinamitc.de/Amberpharm/amberpharm.html", 302);
    }
    else {
      //redirect("http://carinamitc.de/Amberpharm/amberpharm.html", 302);
    }
  }

  function redirect($url, $statusCode = 303) {
    header('Location: ' . $url, true, $statusCode);
    die();
  }
?>