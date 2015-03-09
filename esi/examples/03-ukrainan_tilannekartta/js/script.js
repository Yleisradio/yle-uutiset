var yleApp;
var yleDefaultZoom;
var yleDefaultZoomCrimea;
var yleTooltip = $('.tooltip', '#esi-vis');
$(function () {
  var yleMap;
  var yleKmls = [];
  var ylePolygons = [];
  var yleMarkerClustersKiova = [];
  //var ylePath = 'http://yle.fi/embed/2014/03_ukrainan_tilannekartta/';
  var ylePath = 'case-2014/03-Ukrainan Tilannekartta/';
  yleApp = {
    formatNr: function (x) {
      if (x === 0) {
        return 'Ei tiedossa';
      }
      return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
    },
    emptyHandler: function (x) {
      if (x == '') {
        return '';
      }
      return x;
    },
    getScale: function () {
      var width = $('#esi-vis').width();
      // Wide.
      if (width >= 560) {
        yleDefaultZoom = 6;
        yleDefaultZoomCrimea = 8;
        $('#esi-vis').addClass('wide');
      }
      // Narrow.
      if (width < 560) {
        yleDefaultZoom = 5;
        yleDefaultZoomCrimea = 7;
        $('#esi-vis').removeClass('wide');
      }
    },
    initMap: function () {
      var myOptions = {
        /*maxZoom:15,*/
        center:new google.maps.LatLng(48.5, 31),
        mapTypeControl:true,
        mapTypeId:google.maps.MapTypeId.ROADMAP,
        minZoom:3,
        overviewMapControl:true,
        panControl:true,
        scaleControl:true,
        streetViewControl:false,
        zoom:yleDefaultZoom,
        zoomControl:true
      };
      yleMap = new google.maps.Map($('.map', '#esi-vis')[0], myOptions);
      // Initialize JSONP request
      var url = 'https://www.googleapis.com/fusiontables/v1/query?sql=' + encodeURIComponent('SELECT * FROM 1VtI4JZ3a7Qt82u_G5i-6O4BvISJQ3Y4fhi_murg') + '&callback=yleApp.drawMap&key=AIzaSyAuT-8Tfcakov9HcvUpMoM97tAfq-9KFdM';   
      $('<script src="' + url + '"></script>').appendTo($('body'));
      // Init map event handlers.
      yleApp.initMapEventHandlers();
    },
    drawMap: function (data) {
      $.each(data['rows'], function (index, row) {
        if (row[data_desc['disabled'].id] !== 'true') {
          var newCoordinates = [];
          if (row[data_desc['location'].id]['geometries']) {
            var geometries = row[data_desc['location'].id]['geometries'];
            $.each(geometries, function (idx, geometry) {
              newCoordinates.push(yleApp.constructNewCoordinates(geometry, 'MultiPolygon'));
            });
            var kml = new google.maps.Polygon({
              paths:newCoordinates,
              fillColor:row[data_desc['type'].id],
              fillOpacity:0.6,
              strokeColor:'#666',
              strokeOpacity:0.8,
              strokeWeight:1
            });
            ylePolygons.push(kml);
          }
          else if (row[data_desc['location'].id]['geometry'].type === 'Polygon') {
            var geometries = row[data_desc['location'].id]['geometry'].coordinates;
            $.each(geometries, function (idx, geometry) {
              newCoordinates.push(yleApp.constructNewCoordinates(geometry, 'Polygon'));
            });
            var kml = new google.maps.Polygon({
              paths:newCoordinates,
              fillColor:row[data_desc['type'].id],
              fillOpacity:0.6,
              strokeColor:'#666',
              strokeOpacity:0.8,
              strokeWeight:1
            });
            ylePolygons.push(kml);
            // Init layer event handlers.
            google.maps.event.addListener(kml, 'click', function (event) {
              yleTooltip.hide();
            });
          }
          else if (row[data_desc['location'].id]['geometry'].type === 'Point') {
            newCoordinates = yleApp.constructNewCoordinates(row[data_desc['location'].id]['geometry'], 'Point');
            var kml = new google.maps.Marker({
              position:newCoordinates,
              //icon:ylePath + 'img/explosion.png',
              optimized:false
            });
            yleApp.initMarkerEventHandlers(kml);
          }
          else if (row[data_desc['location'].id]['geometry'].type === 'LineString') {
            var geometries = row[data_desc['location'].id]['geometry'].coordinates;
            newCoordinates = yleApp.constructNewCoordinates(geometries, 'LineString');
            var kml = new google.maps.Polyline({
              path:newCoordinates,
              // geodesic:true,
              strokeColor:'#ff0000',
              strokeOpacity:0.6,
              strokeWeight:6
            });
          }

          yleTooltip.fixPos = function (e) {
            var MouseEvent;
            $.each(e, function (index, element) {
              if (element) {
                if (element.pageX) {
                  MouseEvent = element;
                }
              }
            });
            if (MouseEvent && $('#esi-vis').hasClass('wide')) {
              var x = MouseEvent.pageX + 10;
              var y = MouseEvent.pageY + 10;
              if (x > 650) {
                x = x - 220;
              }
              this.offset({left: x, top: y});
            }
            else {
              var position = $('.map', '#esi-vis').offset();
              this.offset({left: position.left + 10, top: position.top + 10});
            }
          };

          kml.data = row;
          yleKmls.push(kml);

          if (row[data_desc['address'].id] == 'Kiova') {
            yleMarkerClustersKiova.push(kml);
          }
          else {
            kml.setMap(yleMap);
          }
        }
      });
      // Create marker cluster.
      var mcOptions = {gridSize: 10, maxZoom: 14};
      var markerClusterCyria = new MarkerClusterer(yleMap, yleMarkerClustersKiova, mcOptions);
      yleApp.createLegend();
      $('.loading', '#esi-vis').hide();
    },
    initMarkerEventHandlers: function (marker) {
      // Marker mouseover event handler.
      google.maps.event.addListener(marker, 'mouseover', function (event) {
        yleApp.tooltipContent(marker, event);
      });

      // Marker mouseout event handler.
      google.maps.event.addListener(marker, 'mouseout', function (event) {
        yleTooltip.hide();
      });

      // Marker click event handler.
      google.maps.event.addListener(marker, 'click', function (event) {
        yleApp.tooltipContent(marker, event);
      });
    },
    initMapEventHandlers: function () {
      // Map click event handler.
      google.maps.event.addListener(yleMap, 'click', function (event) {
        yleTooltip.hide();
      });

      // Map zoom changed event handler.
      google.maps.event.addListener(yleMap, 'zoom_changed', function () {
        if (yleMap.getZoom() > 11) {
          yleMap.setMapTypeId(google.maps.MapTypeId.HYBRID);
          $.each(ylePolygons, function (idx, polygon) {
            polygon.setVisible(false);
          });
        }
        else {
          yleMap.setMapTypeId(google.maps.MapTypeId.ROADMAP);
          $.each(ylePolygons, function (idx, polygon) {
            polygon.setVisible(true);
          });
        }
      });
    },
    tooltipContent: function (marker, event) {
      var html = '';
      if (!$('#esi-vis').hasClass('wide')) {
        html += '<div class="close"><a href="javascript: yleTooltip.hide();"><img src="' + ylePath + 'img/close.png"></a></div>';
      }
      html += '<h3>' + marker.data[data_desc['title'].id] + '</h3>';
      html += '<div><strong></strong>' + yleApp.emptyHandler(marker.data[data_desc['description'].id]) + '</div>';
      yleTooltip.html(html);
      yleTooltip.show();
      yleTooltip.fixPos(event);
    },
    createLegend: function () {
      var legend = $('<div class="legend"></div>');
      legend.append('<div class="small">Saat lisätietoja osoittamalla kohteita</div>');
      legend.index = 1;
      yleMap.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(legend[0]);
    },
    constructNewCoordinates: function (kmls, type) {
      if (type === 'Point') {
        return new google.maps.LatLng(kmls.coordinates[1], kmls.coordinates[0]);
      }
      else if (type === 'MultiPolygon') {
        var newCoordinates = [];
        $.each(kmls.coordinates[0], function(idx, kml) {
          newCoordinates.push(new google.maps.LatLng(kml[1], kml[0]));
        });
        return newCoordinates;
      }
      else if (type === 'Polygon' || type === 'LineString') {
        var newCoordinates = [];
        $.each(kmls, function(idx, kml) {
          newCoordinates.push(new google.maps.LatLng(kml[1], kml[0]));
        });
        return newCoordinates;
      }
    },
    setCenter: function (lat, lng, zoom) {
      yleMap.panTo(new google.maps.LatLng(lat, lng));
      yleMap.setZoom(zoom);
    },
    init: function () {
      yleApp.getScale();
      $(window).resize(function () {
        yleApp.getScale();
      });
      yleApp.initMap();
    }
  }
  if ($('html').hasClass('ie6') || $('html').hasClass('ie7') || $('html').hasClass('ie8')) {
    $('#esi-vis').html('Kartta ei toimi Internet Explorer -selaimen vanhemmilla versioilla (vanhempi kuin versio 9). Kokeile päivittää selaimesi tai vaihda se esimerkiksi <a href="http://www.google.com/intl/fi/chrome/browser/" target="_blank">Chrome</a>, <a href="http://www.mozilla.org/fi/firefox/new/" target="_blank">Firefox</a>, <a href="http://www.opera.com/fi" target="_blank">Opera</a> tai <a href="http://www.apple.com/fi/safari/" target="_blank">Safari</a> -selaimeen.')
  }
  else {
    yleApp.init();
  }
});
