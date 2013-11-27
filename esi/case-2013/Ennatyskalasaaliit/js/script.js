var ylePath = 'case-2013/Ennatyskalasaaliit/';
//var ylePath = 'http://yle.fi/embed/2013/11_ennatyskalasaaliit/';

var yleApp = {
  formatNr: function (x) {
    x = x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
    x = x.replace('.', ',');
    return (x == '') ? 0 : x;
  },
  roundNr: function (x, d) {
    return parseFloat(x.toFixed(d));
  },
  getScale: function () {
    var width = $('#esi-vis').width();
    if (width >= 580) {
      $('#esi-vis').addClass('wide');
      return true;
    }
    if (width < 580) {
      $('#esi-vis').removeClass('wide');
      return false;
    }
  },
  initTable: function () {
    // @See https://code.google.com/p/jquerycsvtotable/
    $('.table_container', '#esi-vis').CSVToTable(ylePath + 'data/data.csv', { 
      loadingImage:ylePath + 'img/ajax-loader.gif', 
      loadingText:'',
      tbodyClass:'list',
      startLine:0,
    }).bind('loadComplete', function() {
      // Leave empty if all enabled.
      var sortDisabled = [1];
      // Set default sort, 0 is first column.
      var defaultSort = 0;
      // Get columns count.
      var columnCount = $('.table_container thead th', '#esi-vis').length;

      // Include search.
      $('.table_container', '#esi-vis').prepend('<div class="search_container"><label><strong>Etsi taulukosta:</strong> <input class="search" /></label></div>');

      // Set required class attributes for table header.
      $.each($('.table_container thead th', '#esi-vis'), function(idx, el) {
        $(this).addClass('column-' + (idx % columnCount));
        // Enable sorting for this column if not disabled.
        if (sortDisabled.indexOf(idx % columnCount) === -1) {
          var sort = '';
          if ((idx % columnCount) === defaultSort) {
            sort = 'asc';
          }
          $(this).html('<span class="sort ' + sort + ' " data-sort="column-' + (idx % columnCount) + '">' + $(this).html() + '</span>')
        }
      });

      // Set required class attributes for table body.
      $.each($('.table_container tbody td', '#esi-vis'), function(idx, el) {
        $(this).addClass('column-' + (idx % columnCount));
      });

      // Set up List.js.
      var valueNames = [];
      for (ii = 0; ii < columnCount; ii++) valueNames.push('column-' + ii);
      var esi_options = {
        valueNames: valueNames
      };
      new List('esi-table', esi_options);
    });
  },
  init: function () {
    yleApp.getScale();
    $(window).resize(function () {
      yleApp.getScale();
    });
    yleApp.initTable();
  }
}

$(document).ready(function() {
  yleApp.init();
});