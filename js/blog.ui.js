jQuery(document).ready(function($) {
    $("time.timeago").timeago();
    // google web fonts
    WebFontConfig = {google: { families: [ 'Exo:500:latin', 'Inconsolata::latin' ] }};
    var wf = document.createElement('script');
    wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
      '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
    wf.type = 'text/javascript';
    wf.async = 'true';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(wf, s);
});
