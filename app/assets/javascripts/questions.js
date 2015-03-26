$(document).ready(function(q){

    $("#mine-radio").click(function(){
      $('.my-question').removeClass('hidden');
      $('.other-question').addClass('hidden');
    });

    $('#other-radio').click(function(){
      $('.my-question').addClass('hidden');
      $('.other-question').removeClass('hidden');
    });

// Runs when the page loads and disables the submit button. Checks that both the answer and question text boxes are blank
  if ($('#question_text').val() || $('#question_answers_attributes_0_text').val() == "") 
   {$('#submit_question').attr('disabled', true);}

// Every time a key is pressed, this code runs and checks the contents of the answer and question text boxes. If both are full then the submit button is enabled 
  $('#question_text, #question_answers_attributes_0_text').keyup(function(){
    if($('#question_text').val() && $('#question_answers_attributes_0_text').val() !=  "") 
         $('#submit_question').attr('disabled', false);    
    else
         $('#submit_question').attr('disabled', true);   
  });

});
