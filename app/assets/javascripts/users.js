function initUser() {
  initTooltips();
  initVote();
  $('.my-question, .other-question').removeClass('hidden');




  $('.modal').on('shown.bs.modal', function (event) {
    $(this).find('input:text:visible:first').focus().select();
  });
}