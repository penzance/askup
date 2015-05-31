$(document).ready(function(q){

    $("#mine-radio").click(function(){
      $('.my-question').removeClass('hidden');
      $('.other-question').addClass('hidden');
    });

    $('#other-radio').click(function(){
      $('.my-question').addClass('hidden');
      $('.other-question').removeClass('hidden');
    });
  
// Defines function that disables/enables submit button depending on if there is text in the answer box
function enableSubmitAnswer() {
  if ($('#answer_text').val()) {
    $('#submit_answer').attr('disabled', false);
  } else {
    $('#submit_answer').attr('disabled', true); 
  }
}

// Creates the javscript for the modal that allows it to be populated with the data recieved upon clicking the modal link
$('#question_display_Modal').on('show.bs.modal', function (event) {
  
  // Creates the initial view of the modal. The submit answer is shown as well as an empty text box. 
  // The answer is initally hidden and so is the response + alert forms. 
  $("#submit_answer").show();
  $('#answer_text').val("");
    // initially hides the answers and response form in the modal 
  $("#response, #answers, #alert_text_container").hide();
  enableSubmitAnswer();  

  var question_link = $(event.relatedTarget) // element that triggered the modal. question_link is populated with the data from the click 

  // Creates variables with data that we will later use to populate certain parts of the modal 
  var text_question = question_link.data('question') 
  var first_answer = question_link.data('answer')  
  
  // Setting up the response buttons to have the correct q_id to send to the analytics.log and to also trigger the right feedback form
  $('#respond-yes').data('q_id', question_link.data('q_id')); 
  $('#respond-no').data('q_id', question_link.data('q_id'));  

 
  // Searches the modal and populates the indicated classes with the data recieved when the modal was clicked
  var modal = $(this)
  modal.find('.modal-title').text(text_question)
  modal.find('.first-answer').text(first_answer)
})


// Defines function that disables/enables submit button depending on if there is text in the question and answer boxes
function enableSubmitQuestion() {
  if ($('#question_text').val() && $('#question_answers_attributes_0_text').val()) {
    $('#submit_question').attr('disabled', false);
  } else {
    $('#submit_question').attr('disabled', true);
  }
}

enableSubmitQuestion(); 

// runs each time the user presses a key in the #answer_text form field
$('#question_text, #question_answers_attributes_0_text').keyup(enableSubmitQuestion);

}); 

