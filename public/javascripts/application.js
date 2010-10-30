$('document').ready(function() {
  $('button')
    .click(function() {
      $(this).removeClass('pressed');
    })
    .mousedown(function() {
      $(this).addClass('pressed');
    })
    .mouseout(function() {
      $(this).removeClass('pressed');
    });
});
