$(document).ready(function(q){

    $("#mine-radio").click(function(){
      $('.my-question').removeClass('hidden');
      $('.other-question').addClass('hidden');
    });

    $('#other-radio').click(function(){
      $('.my-question').addClass('hidden');
      $('.other-question').removeClass('hidden');
    });

});