function getURLParameter(name) {
  return decodeURI(
    (RegExp(name + '=' + '(.+?)(&|$)').exec(location.search)||[,null])[1]
  );
}
var lang;
var l;

$(document).ready(function() {
  // Define languages.
  lang = {
    en: {
      
    },
    fi: {
      
    },
    se: {
      
    }
  }

  // Get current lang.
  l = getURLParameter('l');
  // Test whether language is given.
  if (l == 'null') {
    l = 'fi';
  }

  // Set up language strings to html ids.
  //$('#').html(lang[l].)

});