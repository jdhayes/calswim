// CalSWIM main Javascript file

$('#map_canvas').gmap().bind('init', function() { 	
	$.getJSON( 'http://jquery-ui-map.googlecode.com/svn/trunk/demos/json/demo.json', function(data) { 
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