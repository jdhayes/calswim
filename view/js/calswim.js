// CalSWIM main Javascript file

$(document).ready(function() {
	/* ***************** */
	/* Initialize Layout */
	/* ***************** */
	$('body').layout({ 
		center__paneSelector:   "#content", 
	    north__paneSelector:    "#header",
	    east__paneSelector:     ".outer-east", 
        north__size:             125,                       	
        north__maxSize:			200        
	});
	$('content').layout({ applyDefaultStyles: true });
	
	/* ********************* */
	/* Initialize Google Map */
	/* ********************* */
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
	var geocoder = new google.maps.Geocoder();
	
	$('#map_canvas').gmap().bind('init', function() { 	
		geocoder.geocode( {'address': 'U.S.A' }, function(results, status) {
			$('#map_canvas').gmap('get', 'map').panTo(results[0].geometry.location);
		});
	});
	
	$('#search_button').click(function() {		
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