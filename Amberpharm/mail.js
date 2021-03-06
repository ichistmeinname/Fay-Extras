$(document).ready( function() {
  $("#contact-button").click( function() {
      var name = $("#contact-name").val();  
      if (name == "") {  
          $("#name-error").css("display","inline-block");  
          $("#contact-name").focus();
          $("#contact-name").css("background-color","#6e90cf"); 
        return false;  
      } else {
          $("#name-error").css("display","none");
          $("#contact-name").css("background-color","lightgrey");
      }
      var email = $("#contact-mail").val();
      if (email == "" || !isEmail(email)) {
          $("#mail-error").css("display","inline-block");
          $("#contact-mail").css("background-color","#6e90cf");
          $("#contact-mail").focus();  
          return false;  
      } else {
          $("#contact-mail").css("background-color","lightgrey");
          $("#mail-error").css("display","none");  
      }
      var msg = $("#contact-msg").val();  
      if (msg == "") {
          $("#msg-error").css("display","inline-block");
          $("#contact-msg").focus();
          $("#contact-msg").css("background-color","#6e90cf");
          return false;  
      } else {
          $("#msg-error").css("display","none");
          $("#contact-msg").css("background-color","lightgrey");
      }
      var url = document.URL;
      $.ajax({
      type: "POST",
      url: url + "/mail.php",
      data: $("#mail-form").serialize(),
      success: function(data) {
          if (data == 1) { 
             $("#contact-form").css("display", "none");
             $("#message").css("display", "inline");
          } else if (data == "invalidMail") {
              $("#mail-error").show();
              $("#contact-mail").css("background-color","#6e90cf");
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