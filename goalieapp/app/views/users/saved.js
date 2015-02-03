$('.goalCompleted').each(function(idx, elem) {

  $(elem).on('change', function() {
    $(this.form).submit();
    id = $(elem).attr('id');
    var status = $('#' + String(id) + '-status');
    console.log(id);
    console.log(status);
    status.show();
    status.html("updated completion status");
    status.fadeOut("slow");
  });
});

$('.goalPub').each(function(idx, elem) {
  $(elem).on('change', function() {
    $(this.form).submit();
    id = $(elem).attr('id');
    var status = $('#' + String(id) + '-status');
    console.log(status);
    var status = $('#' + String(id) + '-status');
    status.show();
    status.html("updated public status");
    status.fadeOut("slow");
  });
});
