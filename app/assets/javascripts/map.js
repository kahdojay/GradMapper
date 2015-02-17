var initializeMap = function() {
  var startLatlng = new google.maps.LatLng(40.7048872,-74.0123737);
  var mapOptions = {
    zoom: 3,
    center: startLatlng
  };
  window.map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
}

var initializeSoulmate = function() {
  var render = function(term, data, type) {
    return term;
  }
  var select = function(term, data, type) {
    $("#search").val(term);
    $("ul#soulmate").hide();
    clearMarkers();
    populateMarkers($(event.target).text())
  }
  $("#search").soulmate({
    url: "/autocomplete/search",
    types: ["cohorts"],
    renderCallback: render,
    selectCallback: select,
    minQueryLength: 2,
    maxResults: 5
  })
}


var populateMarkers = function(cohortName) {
  $.ajax({
    type: "GET",
    url: "/graduates",
    data: {cohort: cohortName}
  }).done(function(response) {
    markersArray = [];
    var infoBoxes = []
    response.forEach(function(graduate) {
      var latitude_longitude = new google.maps.LatLng((parseFloat(graduate.lat)), (parseFloat(graduate.long)))
      var marker = new google.maps.Marker({
        position: latitude_longitude,
        map: window.map
      });
      var contentString = "<p>" + graduate.name + "</p><p>" + graduate.location + "</p><p>" + graduate.company + "</p>" + "<a href=" + graduate.linked_in + ">LinkedIn</a></p>"
      var infoWindow = new google.maps.InfoWindow({
          content: contentString
      });
      markersArray.push(marker)
      infoBoxes.push(infoWindow)
      google.maps.event.addListener(marker, 'click', function() {
        infoBoxes.forEach(function(infoBox) { infoBox.close() })
        infoWindow.open(window.map, marker);
      });
    })
  })
}

var clearMarkers = function() {
  for (var i =0; i < markersArray.length; i++) {
    markersArray[i].setMap(null);
  }
  markersArray.length = 0;
}

$(document).ready(function(){
  initializeMap();
  initializeSoulmate();
  populateMarkers();
})