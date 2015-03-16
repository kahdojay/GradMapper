var markersArray = [];
var infoBoxes = [];

var initializeMap = function() {
  var startLatlng = new google.maps.LatLng(40.7048872,-74.0123737);
  var mapOptions = {
    zoom: 3,
    minZoom: 3,
    center: startLatlng
  };
  window.map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
}

var populateGraduates = function(graduates) {
  $('.carousel').slick('unslick');
  $("#grad-container").empty();

  graduates.forEach(function(graduate) {
    var latitude_longitude = new google.maps.LatLng((parseFloat(graduate.lat)), (parseFloat(graduate.long)))
    var marker = new google.maps.Marker({
      position: latitude_longitude,
      map: window.map
    })
    var contentString = "<div class='grad-panel'><img class='grad-pic' src=" + graduate.img_url + "><div class='grad-content'><p class='grad-name'>" + graduate.name + "</p><p class='grad-cohort_name'>" + graduate.cohort_name + "</p><p class='grad-company'>" + graduate.company + "</p>" + "<a href=" + graduate.linked_in + ">LinkedIn </a></div></div>"
    var infoWindow = new google.maps.InfoWindow({
        content: contentString,
        maxWidth: 140
    })
    $(".carousel").append(contentString);
    markersArray.push(marker);
    infoBoxes.push(infoWindow);
    google.maps.event.addListener(marker, 'mouseover', function() {
      infoBoxes.forEach(function(infoBox) {
        infoBox.close();
      })
      infoWindow.open(window.map, marker);
    });
  })
  $(".buttons-container").append('<p id="up">&#9650</p><p id="down">&#9660</p>')
  initializeSlick();
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

var initializeAutoComplete = function() {
  var fruits = ['Apple', 'Banana', 'Orange'];
  var url = '/graduates?q={input}'
  var widget = new AutoComplete('search_bar', url);
}

var initializeSlick = function() {
  $('.carousel').slick({
    vertical: true,
    infinite: true,
    dots: false,
    prevArrow:"#up",
    nextArrow:"#down",
    infinite: true,
    speed: 300,
    slidesToShow: 4,
    slidesToScroll: 3,
  });

  $('.carousel').find('.grad-panel')
}

$(document).ready(function(){
  initializeMap();
  populateMarkers();
  initializeSlick();
  initializeAutoComplete();
})