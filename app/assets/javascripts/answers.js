function sendFeedback(feedbackUrl, isCorrect) {
  $.ajax({
    url: feedbackUrl,
    type: "POST",
    data: { correct: isCorrect }
  });
}

function handleUserFeedback(feedbackActive, feedbackString, feedbackQid) {
  if (feedbackActive) { sendFeedback('/questions/' + feedbackQid + '/feedback', feedbackString);}
  if (feedbackString == 'yes') {
    $('.feedback-alert').removeClass('alert-danger alert-maybe').addClass('alert-success');
    $('.feedback-alert-text').text('Got it!');
  }
  if (feedbackString == 'no'){
    $('.feedback-alert').removeClass('alert-success alert-maybe').addClass('alert-danger');
    $('.feedback-alert-text').text("Missed it!");
  } 
  if (feedbackString == 'maybe'){
    $('.feedback-alert').removeClass('alert-danger alert-success').addClass('alert-maybe');
    $('.feedback-alert-text').text("Sort-of");
  }
  $('.feedback-alert').slideDown();
  $('.response').hide("slow");
}

// disables/enables submit button depending on if there is text in the answer box
function validateAnswer() {
  $('.submit-answer').attr('disabled', !$('.answer-text').val().trim());
}

function initUserFeedback() {
  $('.feedback-button').unbind().click(function(ev) {
    ev.preventDefault(); // prevents bootstrap from automatically adding a hidden attribute
    var $button = $(ev.target).closest('.feedback-button');
    var feedbackActive = $button.data('feedback-active');
    var feedbackString = $button.data('feedback-string');
    var feedbackQid = $button.data('feedback-qid');
    handleUserFeedback(feedbackActive, feedbackString, feedbackQid);
  });
}

function initAnswerButton() {
  // Function is called as soon as page is loaded so that submit button can be disabled initially
  validateAnswer();

  // validates input each time the user presses a key in the #answer_text form field
  $('.answer-text').keyup(validateAnswer);

  // When a user submits an answer, the real answer and response form fade in.
  $(".submit-answer").click(function (ev) {
    // prevents bootstrap from automatically adding a hidden attribute; we are explicitly hiding and showing using jquery instead
    ev.preventDefault();
    $(".answers, .response").fadeIn();
    $(".submit-answer").hide("slow");
  });
}
