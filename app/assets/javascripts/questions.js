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

$('#question_display_Modal').on('show.bs.modal', function (event) {
  
  $("#submit_answer").show();
  $('#answer_text').val(""); 
  enableSubmitAnswer(); 
  $("#answers").hide();


  var button = $(event.relatedTarget) // Button that triggered the modal
  var recipient = button.data('question') 
  var first_answer = button.data('answer')// Extract info from data-* attributes
  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
  
  // reset all the elements that I need to reset --> specifically submit
  var modal = $(this)
  modal.find('.modal-title').text(recipient)
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

// Function is called as soon as page is loaded so that submit button can be disabled initially 
enableSubmitQuestion(); 

// runs each time the user presses a key in the #answer_text form field
$('#question_text, #question_answers_attributes_0_text').keyup(enableSubmitQuestion);

}); 

