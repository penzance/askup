$(document).ready(function(q){

    $("#mine-radio").click(function(){
      $('.my-question').removeClass('hidden');
      $('.other-question').addClass('hidden');
    });

    $('#other-radio').click(function(){
      $('.my-question').addClass('hidden');
      $('.other-question').removeClass('hidden');
    });


// Defines function that disables/enables submit button depending on if there is text in the question and answer boxes
function enableSubmitQuestion() {
  if ($('#question_text').val() && $('#question_answers_attributes_0_text').val()) {
    $('#submit_question').attr('disabled', false);
  } else {
    $('#submit_question').attr('disabled', true);
  }
}

// Function is called as soon as page is loaded so that submit button can be disabled initially 
enableSubmitQuestion(); 

// runs each time the user presses a key in the #answer_text form field
$('#question_text, #question_answers_attributes_0_text').keyup(enableSubmitQuestion);