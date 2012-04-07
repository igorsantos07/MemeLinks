$(document).ready(function() {
  $('a.meme').fancybox({
   'titlePosition': 'inside',
   'transitionIn': 'elastic',
   'transitionOut': 'elastic',
   'overlayShow': true,
   'opacity': true,
   'titleFormat': function(title) { return '<h3>'+title+'</h3>'; }
  })
})