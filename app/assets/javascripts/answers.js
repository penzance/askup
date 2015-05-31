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

  //provide_feedback function for the STANDALONE page
  function single_provide_feedback(is_correct, notice_text) {
    $.ajax({
      url: window.location.pathname + "/feedback",
      type: "POST",
      data: { correct: is_correct }
    })
      .done(function( data ) {
        if ( console && console.log ) {
          console.log( "Sample of data:", data.slice( 0, 100 ) );
        }
        $('#single_alert_text').text(notice_text);
        $('.alert').slideDown();
    });
  };
 
//JAVASCRIPT FOR THE MODULE
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
  $('#respond-yes').fadeIn();
  ev.preventDefault(); // prevents bootstrap from automatically adding a hidden attribute
  provide_feedback("yes", "Great! Congrats! Try another question.", $('#respond-yes').data('q_id'));
  $('#response').hide("slow");
});

$('#respond-no').click(function(ev) {
  $('#respond-no').fadeIn();
  ev.preventDefault(); // prevents bootstrap from automatically adding a hidden attribute
  provide_feedback("no", "No worries. You'll get it next time. Onwards!", $('#respond-no').data('q_id'));
  $('#response').hide("slow");
});

//JAVASCRIPT FOR THE STANDALONE PAGE
 //Hiding the answers and response div for standalone question page
 $("#single-answers").hide();
 $("#single-response").hide();

// Defines function that disables/enables submit button depending on if there is text in the answer box
function single_enableSubmitAnswer() {
  if ($('#single-answer-text').val()) {
    $('#single-submit-answer').attr('disabled', false);
  } else {
    $('#single-submit-answer').attr('disabled', true); 
  }
}

// Function is called as soon as page is loaded so that submit button can be disabled initially 
single_enableSubmitAnswer(); 

// runs each time the user presses a key in the #answer_text form field
$('#single-answer-text').keyup(single_enableSubmitAnswer); 

// When a user submits an answer. The real answer and response form fade in. 
  $("#single-submit-answer").click(function(ev){
      // prevents bootstrap from automatically adding a hidden attribute; we are explicitly hiding and showing using jquery instead
       ev.preventDefault(); 
       $("#single-answers").fadeIn();
       $("#submit_answer").hide("slow");
       $("#single-response").fadeIn();
  });

  $('#single-respond-yes').click(function(ev) {
    $('#single-respond-yes').fadeIn();
    ev.preventDefault(); // prevents bootstrap from automatically adding a hidden attribute
    single_provide_feedback("yes", "Great! Congrats! Try another question.");
    $('#single-response').hide("slow");
  });

  $('#single-respond-no').click(function(ev) {
    $('#single-respond-no').fadeIn();
    ev.preventDefault(); // prevents bootstrap from automatically adding a hidden attribute
    single_provide_feedback("no", "No worries. You'll get it next time. Onwards!");
    $('#single-response').hide("slow");
  });

});


