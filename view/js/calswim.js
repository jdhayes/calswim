// CalSWIM main Javascript file

// Set Auto Zoom and Center
// map: an instance of GMap2
// latlng: an array of instances of GLatLng
var glatlngs = new Arrary();
var latlngbounds = new GLatLngBounds( );

function auto_zoom_center() {
	for ( var i = 0; i < glatlngs.length; i++ )
	{
	  latlngbounds.extend( glatlngs[ i ] );
	}
	map.setCenter( latlngbounds.getCenter( ), map.getBoundsZoomLevel( latlngbounds ) );
}

$(document).ready(function() {	
	$('#map_canvas').gmap().bind('init', function() { 	
		$.getJSON( '?get_map_locs=a', function(data) { 
			$.each( data.markers, function(i, marker) {				
				var glatlng = new google.maps.LatLng(marker.latitude, marker.longitude);
				glatlngs.push(glatlng);
				
				$('#map_canvas').gmap('addMarker', { 
					'position': glatlng), 
					'bounds': true 
				}).click(function() {
					$('#map_canvas').gmap('openInfoWindow', { 'content': marker.content }, this);
				});
			});
		});
	});
	
	$('#search_button').click(function() {
		var geocoder = new google.maps.Geocoder();
		geocoder.geocode( {'address': $('#search').val() }, function(results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				var lat = results[0].geometry.location.lat();
				var lng = results[0].geometry.location.lng();
				var markers = $('#map_canvas').gmap('get', 'markers');
				find_closest_marker( lat, lng, markers );
				$('#map_canvas').gmap('get', 'map').panTo(results[0].geometry.location);
			}			              	
		});
	});
});