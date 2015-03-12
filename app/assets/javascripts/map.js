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

// var initializeSoulmate = function() {
//   var render = function(term, data, type) {
//     return term;
//   }
//   var select = function(term, data, type) {
//     $("#search").text(term);
//     $("#search").val(term);
//     $("ul#soulmate").hide();
//     clearMarkers();
//     populateMarkers($(event.target).text())
//   }
//   var checkForEmptySearch = function() {
//     if ($("#search").val() === "") { populateMarkers() }
//   }

//   $("#search").soulmate({
//     url: "/autocomplete/search",
//     types: ["cohorts"],
//     renderCallback: render,
//     selectCallback: select,
//     minQueryLength: 2,
//     maxResults: 5
//   })
//   $(window).keydown(function(event){
//     if(event.keyCode == 13) {
//       event.preventDefault();
//       return false;
//     }
//   });
//   $(window).keyup(function(event){ checkForEmptySearch() });
// }

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
  $("#grad-container").empty();

  var indexCounter = 0

  graduates.forEach(function(graduate) {
    indexCounter = indexCounter + 1

    var latitude_longitude = new google.maps.LatLng((parseFloat(graduate.lat)), (parseFloat(graduate.long)))
    var marker = new google.maps.Marker({
      position: latitude_longitude,
      map: window.map
    })
    marker.indx = indexCounter

    var contentString = "<div class='grad-panel' data-index=" + marker.indx + "><img class='grad-pic' src=" + graduate.img_url + "><div class='grad-content'><p class='grad-name'>" + graduate.name + "</p><p class='grad-cohort_name'>" + graduate.cohort_name + "</p><p class='grad-company'>" + graduate.company + "</p>" + "<a href=" + graduate.linked_in + ">LinkedIn </a></div></div>"
    var infoWindow = new google.maps.InfoWindow({
        content: contentString,
        maxWidth: 140
    })

      $(".carousel").append("<div class='grad-panel' data-index=" + marker.indx + "><img class='grad-pic' src=" + graduate.img_url + "><div class='grad-content'><p class='grad-name'>" + graduate.name + "</p><p class='grad-cohort_name'>" + graduate.cohort_name + "</p><p class='grad-company'>" + graduate.company + "</p>" + "<a href=" + graduate.linked_in + ">LinkedIn </a></div></div>");


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

var slideToMarkerId = function(index) {
  $(".carousel").slick('slickGoTo', index);
  console.log("went to " + index)
}

var clearMarkers = function() {
  for (var i=0; i < markersArray.length; i++) {
    markersArray[i].setMap(null);
  }
  markersArray.length = 0;
}

$(document).ready(function(){
  initializeMap();
  initializeSlick();
  populateMarkers();
  var fruits = ['Apple', 'Banana', 'Orange'];
  var widget = new AutoComplete('search_bar', fruits);
})