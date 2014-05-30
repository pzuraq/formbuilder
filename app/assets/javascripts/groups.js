// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('page:change', function () {
  var editor_id;
  var moderator_id;
  $('#new_editor_id').bind('change', function() {
    var editor_id = $(this).val();
  });
  $('#new_moderator_id').bind('change', function() {
    var moderator_id = $(this).val();
  });
});
