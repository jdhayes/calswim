// CalSWIM main Javascript file

$(document).ready(function() {	
	$('#map_canvas').gmap().bind('init', function() { 	
		$.getJSON( '?get_map_locs=a', function(data) { 
			$.each( data.markers, function(i, marker) {										
				$('#map_canvas').gmap('addMarker', { 
					'position': new google.maps.LatLng(marker.latitude, marker.longitude), 
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