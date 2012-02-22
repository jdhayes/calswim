// CalSWIM main Javascript file

$(document).ready(function() {
	function get_map_locs(lat, lng, radius){
		$('#map_canvas').gmap('clear', 'markers');
		$('#map_canvas').gmap('set', 'bounds', null);
		
		$.getJSON( '?get_map_locs='+lat+","+lng+"&radius="+radius, function(data) { 
			$.each( data.markers, function(i, marker) {
				alert(new google.maps.LatLng(marker.latitude,marker.longitude));
				$('#map_canvas').gmap({ 'center': new google.maps.LatLng(marker.latitude,marker.longitude), 'callback': function() {
					$('#map_canvas').gmap('addMarker', { 'bounds':true, 'position': new google.maps.LatLng(marker.latitude,marker.longitude), 'animation': google.maps.Animation.DROP }, function(map, marker){
		                $('#map_canvas').gmap('addInfoWindow', { 'position':marker.getPosition(), 'content': marker.content }, function(iw) {
		                        $(marker).click(function() {
		                                iw.open(map, marker);
		                                map.panTo(marker.getPosition());
		                        });
		                });
					});
				}});
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
			}else {
		    	alert("Geocode was not successful for the following reason: " + status);
		    }
		});
	});
});