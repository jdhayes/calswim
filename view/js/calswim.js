// CalSWIM main Javascript file
$(document).ready(function() {
	$('#map_canvas').gmap().bind('init', function() { 	
		$.getJSON( 'get_locs.py?', function(data) { 
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
});