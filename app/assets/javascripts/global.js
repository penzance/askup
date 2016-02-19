$(function(){
  $('.close-alert').click(function(){
    $('.alert').slideUp();
  });
});

// To use bootstrap tooltips you need to initialize them first, for performance
// reasons. (cf http://getbootstrap.com/javascript/#tooltips)
function initTooltips() {
  $('[data-toggle="tooltip"]').tooltip();
}