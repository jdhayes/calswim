// CalSWIM main Javascript file

$(document).ready(function() {
	function get_map_locs(lat, lng, radius){
		$('#map_canvas').gmap('clear', 'markers');
		
		$.getJSON( '?get_map_locs='+lat+","+lng+"&radius="+radius, function(data) { 
			$.each( data.markers, function(i, marker) {										
				$('#map_canvas').gmap('addMarker', { 
					'position': marker.latitude+","+marker.longitude, 
					'bounds': true 
				}).click(function() {					
					$('#map_canvas').gmap('openInfoWindow', { 'content': "<span class='marker_content'>"+marker.content+"</span>" }, this);
				});
			});
		});
	}
	
	$('#map_canvas').gmap().bind('init', function() { 	
		get_map_locs(0,0,0);
	});
	
	$('#search_button').click(function() {
		var geocoder = new google.maps.Geocoder();
		geocoder.geocode( {'address': $('#search').val() }, function(results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				var lat = results[0].geometry.location.lat();
				var lng = results[0].geometry.location.lng();						
				get_map_locs(lat, lng, $("#radius").val() );
				$('#map_canvas').gmap('get', 'map').panTo(results[0].geometry.location);
				$('#map_canvas').gmap('refresh');
			}else {
		    	alert("Geocode was not successful for the following reason: " + status);
		    }
		});
	});
});