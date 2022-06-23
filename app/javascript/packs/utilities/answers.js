$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerID = $(this).data('answerId');
    $('form#edit-answer-' + answerID).show();
  })
});
