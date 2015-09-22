function initQsets() {
  $('#qsets').on('change', function(event) {
    var $selectedOption = $(this.options[this.selectedIndex]);
    window.open($selectedOption.data('qset-url'), '_self');
  });

  $('#modal-new-qset').on('show.bs.modal', function (event) {
    $(this).find('input[name="name"]').val('');
  });

  $('#edit-qset').on('click', function (event) {
    $('#delete_confirmation_form_container').hide();
  });

  // todo: do we need this anymore? can it be a trashcan icon at the main page, and simplify editing?
  $('#edit-qset-delete').on('click', function (event) {
    $('#delete_confirmation_form_container').show();
  });
}