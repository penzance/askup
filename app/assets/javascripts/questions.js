function validateEditQuestionInput() {
  // disables/enables submit button depending on if there is text in the question and answer boxes
  var isValid = $('#question_text').val().trim() && $('#question_answers_attributes_0_text').val().trim();
  $('.submit-question').attr('disabled', !isValid);
}

function initQuestionFilter() {
  $("#mine-radio").click(function(){
    $('.my-question').removeClass('hidden');
    $('.other-question').addClass('hidden');
  });

  $('#other-radio').click(function(){
    $('.my-question').addClass('hidden');
    $('.other-question').removeClass('hidden');
  });
}

function initQuestionDisplayModal($modal, $question_link) {
  // Creates the initial view of the modal.

  // The submit answer button is shown as well as an empty text input box.
  $('.submit-answer').show();

  // The answer is initially hidden and so is the response + alert divs.
  $('.answer-text').val('');
  $('.response, .answers, .feedback-alert').hide();

  initAnswerButton();
  initUserFeedback();

  // Setting up the response buttons to have the correct q_id to send to the analytics.log and to also trigger the right feedback form
  $('#respond-yes, #respond-no').data('feedback-qid', $question_link.data('qid'));

  // Populates the modal with the data received when the modal was clicked
  $modal.find('.modal-title').text($question_link.data('question'));
  $modal.find('.first-answer').text($question_link.data('answer'));
}

function initSocialModal($modal, $social_link) {
  var title = $social_link.data('website');
  var text_question = $social_link.data('question');
  var url_link = $social_link.data('url');
  var hyperlink = $social_link.data('hyperlink');
  var hyperlinktext = $social_link.data('hyperlinktext');

  // Populates the modal with the data received when the modal was clicked
  $modal.find('.modal-title').text(title); // sets the title
  $modal.find('.modal-body-social input').val(text_question + " ➡" + "Follow the link to find out the answer: " + url_link); // creates the text that includes the question and url for user to copy to clipboard
  $modal.find('.hyperlink').attr("href", hyperlink); // updates the href to the appropriate social platform the second attribute allows the social site to be opened on a new page
  $modal.find('.hyperlink').text(hyperlinktext); // creates the text that the hyperlink will show up as
}

function initEditQuestion() {
  // initialize the submit button
  validateEditQuestionInput();

  // check for valid input each time the user presses a key in the #question_text form field
  $('#question_text, #question_answers_attributes_0_text').keyup(validateEditQuestionInput);
}
