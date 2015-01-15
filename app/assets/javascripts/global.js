$(function(){
  $('.close-alert').click(function(){
    $('.alert').slideUp();
  });
  $(':checkbox').checkbox();
  $("select").selectpicker({style: 'btn-hg btn-primary', menuStyle: 'dropdown-inverse'});
});