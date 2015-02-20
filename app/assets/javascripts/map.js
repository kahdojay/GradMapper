var markersArray = [];
var infoBoxes = [];

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
    $("#search").text(term);
    $("#search").val(term);
    $("ul#soulmate").hide();
    clearMarkers();
    populateMarkers($(event.target).text())
  }
  var checkForEmptySearch = function() {
    if ($("#search").val() === "") { populateMarkers() }
  }

  $("#search").soulmate({
    url: "/autocomplete/search",
    types: ["cohorts"],
    renderCallback: render,
    selectCallback: select,
    minQueryLength: 2,
    maxResults: 5
  })
  $(window).keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });
  $(window).keyup(function(event){ checkForEmptySearch() });
}

var initializeSlick = function() {
  $('.carousel').slick({
    infinite: true,
    dots: false,
    infinite: true,
    speed: 300,
    slidesToShow: 10,
    slidesToScroll: 5
  });
}


var populateMarkers = function(cohortName) {
  $.ajax({
    type: "GET",
    url: "/graduates",
    data: {cohort: cohortName}
  }).done(function(response) {
    populateGraduates(response)
  })
}

var populateGraduates = function(graduates) {
  $('.carousel').slick('unslick');
  $("#grad-bar").empty();

  graduates.forEach(function(graduate) {
    var latitude_longitude = new google.maps.LatLng((parseFloat(graduate.lat)), (parseFloat(graduate.long)))
    var marker = new google.maps.Marker({
      position: latitude_longitude,
      map: window.map
    })

    var contentString = "<p>" + graduate.name + "</p><p>" + graduate.location + "</p><p>" + graduate.company + "</p>" + "<a href=" + graduate.linked_in + ">LinkedIn</a></p>"
    var infoWindow = new google.maps.InfoWindow({
        content: contentString
    })

    if (graduate.img_url) {
      $("#grad-bar").append("<div class='panel'><img class='grad-pic'src=" + graduate.img_url + "><br><div class='grad-content'>" + graduate.name + "<br>" + graduate.company + "</div></div>");
    }

    markersArray.push(marker);
    infoBoxes.push(infoWindow);
    google.maps.event.addListener(marker, 'click', function() {
      infoBoxes.forEach(function(infoBox) {
        infoBox.close();
      })
      infoWindow.open(window.map, marker);
    });
  })
  initializeSlick();
}

var clearMarkers = function() {
  for (var i=0; i < markersArray.length; i++) {
    markersArray[i].setMap(null);
  }
  markersArray.length = 0;
}

$(document).ready(function(){
  initializeMap();
  initializeSoulmate();
  populateMarkers();
  initializeSlick();
})