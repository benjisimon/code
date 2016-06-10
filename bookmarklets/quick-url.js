/*
 * This is a javascript file used for generating a bookmarklet to a short but sweet URL.
 */
(function() {
  function c() {
    var dict = ['A','B','C','D','E','F','G','H','J','K','L','M','N',
                'P','Q','R','S','T','U','W','X','Y','Z',
                2,3,4,5,6,7,8,9];
    return dict[Math.floor(Math.random() * dict.length)];
  }
  window.open('http://u.ideas2executables.com/admin.py?hash=True&main=True&action=EDIT&' +
              'url='+encodeURIComponent(location.href) + '&' +
              'path=' + c() + c() + c(), '_blank');
}())
    
