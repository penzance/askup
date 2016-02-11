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
  $('#respond-yes, #respond-no, #respond-maybe').data('feedback-qid', $question_link.data('qid'));

  // Populates the modal with the data received when the modal was clicked
  $modal.find('.modal-title').text($question_link.data('question'));
  $modal.find('.first-answer').text($question_link.data('answer'));
}

function initQuestionFilter() {
  var qsetId = $('#qset-show-container').data('qset-id');

  // recalls preferred filter option
  var filter = Cookies.get('all_mine_other_filter');
  if (filter == 'mine') { showMine() }
  else if (filter == 'other') { showOther() }
  else showAll();

  // changes to filter 1. show filtered set of questions, and 2. are tracked in a user cookie
  $('.all-radio').click(function(){
    Cookies.set('all_mine_other_filter', 'all', { expires: 1000 });
    showAll();
  });

  $('.mine-radio').click(function(){
    Cookies.set('all_mine_other_filter', 'mine', { expires: 1000 });
    showMine();
  });

  $('.other-radio').click(function(){
    Cookies.set('all_mine_other_filter', 'other', { expires: 1000 });
    showOther();
  });

  function showAll() {
    var questions = ($('.my-question, .other-question').length > 0);
    $('.my-question, .other-question').toggleClass('hidden', !questions);
    $('.no-questions').toggleClass('hidden', questions);
    showNoQuestionNotification('There are no questions.');
  }

  function showMine() {
    var questions = ($('.my-question').length > 0);
    $('.my-question').toggleClass('hidden', !questions);
    $('.no-questions').toggleClass('hidden', questions);
    $('.other-question').addClass('hidden');
    showNoQuestionNotification('You have not created any questions.');
  }

  function showOther() {
    var questions = ($('.other-question').length > 0);
    $('.other-question').toggleClass('hidden', !questions);
    $('.no-questions').toggleClass('hidden', questions);
    $('.my-question').addClass('hidden');
    showNoQuestionNotification('No other users have created any questions.');
  }

  function showNoQuestionNotification(msg) {
    var noQuestionsNotification = msg + ' <a href="/questions/new?qset=' + qsetId + '">Create one now!</a>';
    $('.no-questions > p').html(noQuestionsNotification);
  }
}
