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