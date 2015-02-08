function initialize() {
  var startLatlng = new google.maps.LatLng(40.7048872,-74.0123737);
  var mapOptions = {
    zoom: 3,
    center: startLatlng
  };
  window.map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
}

$(document).ready(function(){
  initialize();
  $.ajax({
    type: "GET",
    url: "/graduates"
  }).done(function(response) {
    var infoBoxes = []

    response.forEach(function(graduate) {
      var latitude_longitude = new google.maps.LatLng((parseFloat(graduate.latitude)), (parseFloat(graduate.longitude)))

      var marker = new google.maps.Marker({
        position: latitude_longitude,
        map: window.map
      });

      var contentString = "<p>" + graduate.name + "</p><p>" + graduate.current_location + "</p><p>" + graduate.current_employer + "</p>" + "<a href=" + graduate.linkedin_url + ">LinkedIn</a></p>"

      var infoWindow = new google.maps.InfoWindow({
          content: contentString
      });

      infoBoxes.push(infoWindow)

      google.maps.event.addListener(marker, 'click', function() {
        infoBoxes.forEach(function(infoBox) {
          infoBox.close()
        })
        infoWindow.open(window.map, marker);
      });
    })
  })
})