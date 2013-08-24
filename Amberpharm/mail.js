$(document).ready( function() {
  $("#contact-button").click( function() {
      var name = $("#contact-name").val();  
      if (name == "") {  
        $("#contact-name").css("margin-top","0");
        $("#name-error").show();  
        $("#contact-name").focus();  
        return false;  
      } else {
          $("#contact-name").css("margin-top","18");
          $("#name-error").hide();  
      }
      var email = $("#contact-mail").val();
      if (email == "" || !isEmail(email)) {
          $("#contact-name").css("margin-bottom","2");
          $("#mail-error").show();  
          $("#contact-mail").focus();  
          return false;  
      } else {
          $("#contact-name").css("margin-bottom","20");
          $("#mail-error").hide();  
      }
      var msg = $("#contact-msg").val();  
      if (msg == "") {
          $("#contact-mail").css("margin-bottom","2");
          $("#msg-error").show();  
          $("#contact-msg").focus();  
          return false;  
      } else {
          $("#contact-mail").css("margin-bottom","20");
          $("#msg-error").hide();  
      }
      $.ajax({
      type: "POST",
      url: "http://carinamitc.de/Amberpharm/mail.php",
      data: $("#mail-form").serialize(),
      success: function(data) {
          if (data == 1) { 
             $("#contact-form").css("display", "none");
             $("#message").css("display", "inline-block");
             console.log("success");
          } else if (data == "invalidMail") {
              $("#mail_invalid_error").show();  
          } else {
              $("#error").show();
          }
    }});
      return false;
    });

    function isEmail(email) {
        var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
        return regex.test(email);
    }
});