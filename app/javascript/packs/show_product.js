import { Loader } from "@googlemaps/js-api-loader";

// Create the script tag, set the appropriate attributes

const loader = new Loader({
    apiKey: "AIzaSyCSUnN_KPnlZn8o2FXoWY4AdpLTMR-uN0Y",
    version: "weekly"
})

var map;

loader.load().then(()=>{
    map = new google.maps.Map(document.getElementById("map"), {
      center: { lat: 53, lng: -0.5 },
      zoom: 4,
      mapTypeId: 'terrain'
    });
    var p1 = new google.maps.LatLng(gon.lat1, gon.long1);
    var p2 = new google.maps.LatLng(gon.lat2, gon.long2);

    var markerP1 = new google.maps.Marker({
        position: p1,
        map: map
    });
    var markerP2 = new google.maps.Marker({
        position: p2,
        map: map
    });
    google.maps.event.addListener(map, 'projection_changed', function () {
      var p1 = map.getProjection().fromLatLngToPoint(markerP1.getPosition());
      var p2 = map.getProjection().fromLatLngToPoint(markerP2.getPosition());
      var e = new google.maps.Point(p1.x - p2.x, p1.y - p2.y);
      var m = new google.maps.Point(e.x / 2, e.y / 2);
      var o = new google.maps.Point(0, 7);
      var c = new google.maps.Point(m.x + o.x, m.y + o.y);
      var curveMarker2 = new google.maps.Marker({
          position: markerP1.getPosition(),
          icon: {
              path: "M 0 0 q " + c.x + " " + c.y + " " + e.x + " " + e.y,
              scale: 24,
              strokeWeight: 2,
              fillColor: '#009933',
              fillOpacity: 0,
              rotation: 180,
              anchor: new google.maps.Point(0, 0)
          }
      });
      curveMarker2.setMap(map);
      google.maps.event.addListener(map, 'zoom_changed', function () {
          var zoom = map.getZoom();
          var scale = 1 / (Math.pow(2, -zoom));
          var icon = {
              path: "M 0 0 q " + c.x + " " + c.y + " " + e.x + " " + e.y,
              scale: scale,
              strokeWeight: 2,
              fillColor: '#009933',
              fillOpacity: 0,
              rotation: 180,
              anchor: new google.maps.Point(0, 0)
          };
          curveMarker2.setIcon(icon);
      });
  });
})



/*Not my code */
var p1 = new google.maps.LatLng(23.634501, -102.552783);
var p2 = new google.maps.LatLng(17.987557, -92.929147);

var markerP1 = new google.maps.Marker({
    position: p1,
    map: map
});
var markerP2 = new google.maps.Marker({
    position: p2,
    map: map
});
google.maps.event.addListener(map, 'projection_changed', function () {
    var p1 = map.getProjection().fromLatLngToPoint(markerP1.getPosition());
    var p2 = map.getProjection().fromLatLngToPoint(markerP2.getPosition());
    var e = new google.maps.Point(p1.x - p2.x, p1.y - p2.y);
    var m = new google.maps.Point(e.x / 2, e.y / 2);
    var o = new google.maps.Point(0, 7);
    var c = new google.maps.Point(m.x + o.x, m.y + o.y);
    var curveMarker2 = new google.maps.Marker({
        position: markerP1.getPosition(),
        icon: {
            path: "M 0 0 q " + c.x + " " + c.y + " " + e.x + " " + e.y,
            scale: 24,
            strokeWeight: 2,
            fillColor: '#009933',
            fillOpacity: 0,
            rotation: 180,
            anchor: new google.maps.Point(0, 0)
        }
    });
    curveMarker2.setMap(map);
    google.maps.event.addListener(map, 'zoom_changed', function () {
        var zoom = map.getZoom();
        var scale = 1 / (Math.pow(2, -zoom));
        var icon = {
            path: "M 0 0 q " + c.x + " " + c.y + " " + e.x + " " + e.y,
            scale: scale,
            strokeWeight: 2,
            fillColor: '#009933',
            fillOpacity: 0,
            rotation: 180,
            anchor: new google.maps.Point(0, 0)
        };
        curveMarker2.setIcon(icon);
    });
});