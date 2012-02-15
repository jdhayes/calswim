// CalSWIM main Javascript file

// Calculate nearest markers
function rad(x) {return x*Math.PI/180;}
function find_closest_marker( lat, lng, markers ) {
    var R = 6371;
    var distances = [];
    var closest = -1;    
    for( i=0; i<markers.length; i++ ) {
        var mlat = markers[i].position.lat();
        alert(mlat);
        var mlng = markers[i].position.lng();
        var dLat  = rad(mlat - lat);
        var dLong = rad(mlng - lng);
        var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
            Math.cos(rad(lat)) * Math.cos(rad(lat)) * Math.sin(dLong/2) * Math.sin(dLong/2);
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        var d = R * c;
        distances[i] = d;
        if ( closest == -1 || d < distances[closest] ) {
            closest = i;
        }
    }

    alert(markers[closest].title);
}
	
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
		geocoder.geocode( {'address': $('#search').val() }, function(results, status) { if (status == google.maps.GeocoderStatus.OK) {
				var lat = results[0].geometry.location.lat();
				var lng = results[0].geometry.location.lng();
				var markers = $('#map_canvas').gmap('get', 'markers');
				find_closest_marker( lat, lng, markers );
				$('#map_canvas').gmap('get', 'map').panTo(results[0].geometry.location);
			}			              	
		});
	});
});