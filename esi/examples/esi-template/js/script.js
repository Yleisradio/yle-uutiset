$(function () {
  var yleApp = {
    formatNr: function (x, addComma) {
      x = x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '&nbsp;');
      x = x.replace('.', ',');
      if (addComma === true && x.indexOf(',') === -1) {
        x = x + ',0';
      }
      return (x == '') ? 0 : x;
    },
    roundNr: function (x, d) {
      return parseFloat(x.toFixed(d));
    },
    setPath: function () {
      if (location.href.match('http://yle.fi/plus/yle')) {
        yleApp.path = 'http://yle.fi/plus/yle/2015/' + yleApp.projectName + '/';
      }
      else if (location.href.match('http://yle.fi')) {
        yleApp.path = 'http://yle.fi/plus/2015/' + yleApp.projectName + '/';
      }
      else {
        yleApp.path = '2015/' + yleApp.projectName + '/';
      }
    },
    getScale: function () {
      var width = $('#esi-vis').width();
      if (width >= 578) {
        $('#esi-vis').addClass('wide');
        return true;
      }
      if (width < 578) {
        $('#esi-vis').removeClass('wide');
        return false;
      }
    },
    initMediaUrls: function () {
      $.each($('.handle_img', '#esi-vis'), function (i, el) {
        $(this).attr('src', yleApp.path + 'img/' + $(this).attr('data-src'));
      });
    },
    init: function () {
      yleApp.projectName = '';
      yleApp.setPath();
      yleApp.getScale();
      $(window).resize(function () {
        yleApp.getScale();
      });
      yleApp.initMediaUrls();
    }
  }
  yleApp.init();
});