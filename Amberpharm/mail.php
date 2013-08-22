<?php
  /* === Daten aus dem Formular auslesen und in Variablen speichern === */
  $name = $_POST['name'];
  $mail = $_POST['mail'];
  $subject = "Anfrage";
  $msg = $_POST['msg'];
 
  /* === Empfängeradresse und Betreff === */
  $to = 'admin@carinamitc.de';
  $subject = "Kontaktformularnachricht | $subject | $name ";
 
  /* === Wenn Bedingung erfüllt, dann E-Mail abschicken - andernfalls Fehlermeldung ausgeben === */
    if ((!empty($name))&&(!empty($mail))&&(!empty($msg))) {
 
      mail($to, $subject, $msg, 'From:' . $email); //Mail versenden
 
      ob_start(); // ensures anything dumped out will be caught

      // clear out the output buffer
      while (ob_get_status())  {
        ob_end_clean();
      }
      
      header("Location: http://carinamitc.de/Amberpharm/amberpharm.html");
    }
    else {
      ob_start(); // ensures anything dumped out will be caught

      // clear out the output buffer
      while (ob_get_status())  {
        ob_end_clean();
      }
      
      header("Location: http://carinamitc.de/Amberpharm/amberpharm.html");
    }
?>