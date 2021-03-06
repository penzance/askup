function validateEditQuestionInput() {
  // disables/enables submit button if user chooses a qset and there is text in question and answer boxes
  var isValid = $('#question_text').val().trim() && $('#question_answers_attributes_0_text').val().trim() && $('#qset-id-input').val().trim();
  $('.submit-question').attr('disabled', !isValid);
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

  selectQsetForNewQuestion();

  // track qset_id after selecting qset from modal (uses js-cookie plugin)
  $('#qset-id-input').change(function() {
    Cookies.set('new_question_qset_id', this.value, { expires: 1000 });
  });

}

// Closes modal, displays qset name next to Choose Qset button, and populates hidden qset-id input
function selectQsetForNewQuestion() {
  $('.qset-selectable').click(function() {
    $('.qset-display').text($(this).find('.qset-name-modal').data("qset-name"));
    $('.qset-display').removeClass("no-qset-chosen");
    $('#qset-id-input').val($(this).find('.qset-name-modal').data("qset-id")).trigger("change");
    $('#modal-launch').modal('hide');

    validateEditQuestionInput();

  });
}
