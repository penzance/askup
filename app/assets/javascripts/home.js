$(function() {
  $('#home-scroll-down').click(function (event) {
    var idTo = $(this).attr('href');
    var position = $(idTo).offset().top;
    $('body').animate({ scrollTop: position }, 'slow');
    return false;
  });
});



