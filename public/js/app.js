$(document).ready(function() {
  // generate id for header
  $('#toc').toc();

  // apply scrollspy
  $('body').scrollspy({
    target: '.bs-docs-sidebar',
    offset: 40
  });
  $("#sidebar").affix({
    offset: { top: 60 }
  });
});
