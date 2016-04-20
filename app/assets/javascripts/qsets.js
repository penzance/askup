var quizQuestions = [];
var quizAllIndex = 0;

function initQsets() {
  $('#qsets').on('change', function(event) {
    var $selectedOption = $(this.options[this.selectedIndex]);
    window.open($selectedOption.data('qset-url'), '_self');
  });

  $('.modal').on('shown.bs.modal', function (event) {
    $(this).find('input:text:visible:first').focus().select();
  });

  $('#modal-new-qset').on('show.bs.modal', function (event) {
    $(this).find('input[name="name"]').val('');
  });

  $('#modal-edit-qset').on('show.bs.modal', function (event) {
    $('#delete_confirmation_form_container').hide();
  });

  // todo: do we need this anymore? can it be a trashcan icon at the main page, and simplify editing?
  $('#edit-qset-delete').on('click', function (event) {
    $('#delete_confirmation_form_container').show();
  });

  $('form').on('submit', function (event) {
    $('.modal :button').prop('disabled', true);
  });

  $('.quiz-all').on('click', function (event) {
    $('#question_display_Modal').modal('show');
  });
}

// function initQuestionDisplayModal($modal, $question_link) {
//   // Creates the initial view of the modal.

//   // The submit answer button is shown as well as an empty text input box.
//   $('.submit-answer').show();

//   // The answer is initially hidden and so is the response + alert divs.
//   $('.answer-text').val('');
//   $('.response, .answers, .feedback-alert').hide();

//   initAnswerButton();
//   initUserFeedback();

//   // Setting up the response buttons to have the correct q_id to send to the analytics.log and to also trigger the right feedback form
//   $('#respond-yes, #respond-no, #respond-maybe').data('feedback-qid', $question_link.data('qid'));

//   // Populates the modal with the data received when the modal was clicked
//   $modal.find('.modal-title').text($question_link.data('question'));
//   $modal.find('.first-answer').text($question_link.data('answer'));
// }

function initQuestionDisplayModalForQuizAll() {
  // Creates the initial view of the modal.
  var $modal = $('#question_display_Modal');

  // The submit answer button is shown as well as an empty text input box.
  $('.submit-answer').show();

  // The answer is initially hidden and so is the response + alert divs.
  $('.answer-text').val('');
  $('.response, .answers').hide();

  initAnswerButton();
  initUserFeedback();

  $modal.find('.modal-title').text(quizQuestions.questions[quizAllIndex].text);
  $modal.find('.first-answer').text(quizQuestions.answers[quizAllIndex][0].text);

}

function initDataForQuizAll() {
  $('.feedback-alert').hide();
  var qset_id = $('#qset-show-container').data('qset-id');
  questionJSON(qset_id);
}


function initQuestionFilter() {
  var noQuestionsMessage = {
    'all': 'There are no questions.',
    'mine': 'You have not created any questions.',
    'other': 'No other users have created any questions.'
  };
  var qsetId = $('#qset-show-container').data('qset-id');

  // recalls preferred filter option
  filterBy(Cookies.get('all_mine_other_filter'));

  // changes to filter 1. show filtered set of questions, and 2. are tracked in a user cookie
  $('.filter-choice').click(function(){
    var filterType = $(this).find('input')[0].getAttribute('name');  // radio button 'name' value
    filterBy(filterType);
    Cookies.set('all_mine_other_filter', filterType, { expires: 1000 });
  });

  function anyQuestions(filterType) {
    // expecting filterType == 'all', 'mine', or 'other'
    switch (filterType) {
      case 'mine':
        return ($('.my-question').length > 0);
      case 'other':
        return ($('.other-question').length > 0);
      default:  // 'all' or invalid filterType
        return ($('.my-question, .other-question').length > 0);
    }
  }

  function filterBy(filterType) {
    // expecting filterType == 'all', 'mine', or 'other'
    var anyQuestionsToDisplay = anyQuestions(filterType);
    if (!anyQuestionsToDisplay) showNoQuestionNotification(noQuestionsMessage[filterType]);
    $('#quizAllButtonID').attr('disabled', !anyQuestionsToDisplay);
    $('.no-questions').toggleClass('hidden', anyQuestionsToDisplay);
    $('.my-question').toggleClass('hidden', filterType == 'other' || !anyQuestionsToDisplay);
    $('.other-question').toggleClass('hidden', filterType == 'mine' || !anyQuestionsToDisplay);
  }

  function showNoQuestionNotification(msg) {
    var noQuestionsNotification = msg + ' <a href="/questions/new?qset=' + qsetId + '">Create one now!</a>';
    $('.no-questions > p').html(noQuestionsNotification);
  }
}

function questionJSON(qsetid) {
  $.getJSON("/qsets/" + qsetid + "/qset_json?", {filter: Cookies.get('all_mine_other_filter')}, function(data) {
    quizQuestions = data;
    initQuestionDisplayModalForQuizAll();
    // Setting up the response buttons to have the correct q_id to send to the analytics.log and to also trigger the right feedback form
    // $('#respond-yes, #respond-no, #respond-maybe').data('feedback-qid', $question_link.data('qid'));

  });
}
