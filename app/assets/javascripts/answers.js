//hide and show answers
$(document).ready(function(e){

// Defines function that gives the user feedback once they state whether or not they have gotten the question right. 
// This function also stores the user response in the development_analytics.log using an ajax call. 
    function provide_feedback(is_correct, notice_text, q_id) {
      $.ajax({
        url: window.location.pathname + "/" + q_id + "/feedback",
        type: "POST",
        data: { correct: is_correct }
      })
        .done(function( data ) {
          if ( console && console.log ) {
            console.log( "Sample of data:", data.slice( 0, 100 ) );
          }
          $('#alert_text').text(notice_text);
          $('.alert').slideDown();
      });
    };

  // initially hides the answers and response form in th modal 
  $("#answers").hide();
  $("#response").hide();
 
 
// Defines function that disables/enables submit button depending on if there is text in the answer box
function enableSubmitAnswer() {
  if ($('#answer_text').val()) {
    $('#submit_answer').attr('disabled', false);
  } else {
    $('#submit_answer').attr('disabled', true); 
  }
}

// Function is called as soon as page is loaded so that submit button can be disabled initially 
enableSubmitAnswer(); 

// runs each time the user presses a key in the #answer_text form field
$('#answer_text').keyup(enableSubmitAnswer); 

// When a user submits an answer. The real answer and response form fade in. 
  $("#submit_answer").click(function(ev){
      // prevents bootstrap from automatically adding a hidden attribute; we are explicitly hiding and showing using jquery instead
       ev.preventDefault(); 
       $("#answers").fadeIn();
       $("#submit_answer").hide("slow");
       $("#response").fadeIn();
  });

  $('#respond-yes').click(function(ev) {
    ev.preventDefault(); // prevents bootstrap from automatically adding a hidden attribute
    provide_feedback("yes", "Great! Congrats! Try another question.", $('#respond-yes').data('q_id'));
    $('#response').hide("slow");
  });

  $('#respond-no').click(function(ev) {
    ev.preventDefault(); // prevents bootstrap from automatically adding a hidden attribute
    provide_feedback("no", "No worries. You'll get it next time. Onwards!", $('#respond-no').data('q_id'));
    $('#response').hide("slow");
  });

});
