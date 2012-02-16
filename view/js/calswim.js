// CalSWIM main Javascript file

$(document).ready(function() {
	function get_map_locs(lat=0, lng=0, radius=0){
		$('#map_canvas').gmap('clear', 'markers');
		
		$.getJSON( '?get_map_locs='+lat+","+lng, function(data) { 
			$.each( data.markers, function(i, marker) {										
				$('#map_canvas').gmap('addMarker', { 
					'position': new google.maps.LatLng(marker.latitude, marker.longitude), 
					'bounds': true 
				}).click(function() {
					$('#map_canvas').gmap('openInfoWindow', { 'content': marker.content }, this);
				});
			});
		});
	}
	
	$('#map_canvas').gmap().bind('init', function() { 	
		get_map_locs();
	});
	
	$('#search_button').click(function() {
		var geocoder = new google.maps.Geocoder();
		geocoder.geocode( {'address': $('#search').val() }, function(results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				var lat = results[0].geometry.location.lat();
				var lng = results[0].geometry.location.lng();						
				get_map_locs(lat, lng, 5000);
				$('#map_canvas').gmap('get', 'map').panTo(results[0].geometry.location);
			}
		});
	});
});