// CalSWIM main Javascript file

$(document).ready(function() {
	/* ***************** */
	/* Initialize Layout */
	/* ***************** */
	
	/* Custom Toggle buttons */
	/*
        toggleButtons = '<div class="btnToggler"></div>' + '<div class="btnReset"></div>' + '<div class="btnExpand"></div>'
	*/
	
	$('body').layout({ 
		 center__paneSelector:   "#content" 
	    ,north__paneSelector:    "#header"
	    ,north__closable:        false
	    ,north__resizeable:      false
        ,north__size:            50                     	
        ,north__maxSize:		 50
        ,south__paneSelector:    "#footer"
        ,south__closable:        false
	    ,south__resizeable:      false
        ,south__size:            25                       	
        ,south__maxSize:         25
        //,south__togglerLength_closed: 105
		//,south__togglerLength_open:   105
        //,south__togglerContent_closed: toggleButtons
		//,south__togglerContent_open:   toggleButtons
	});	
	$('#content').layout({ applyDefaultStyles: true });
	$("#address").Watermark("Everywhere");
	$("#keywords").Watermark("Everything");
	
	/* ********************* */
	/* Initialize Google Map */
	/* ********************* */
	function get_map_locs(latlng, radius, keywords){
		// Clear previously set markers
		$('#map_canvas').gmap('clear', 'markers');		
		
		// Init json data
		var first_latlng;
		
		// Get results
		$.getJSON("?get_map_locs="+latlng +"&radius="+radius +"&keywords="+keywords, function(data) {
			
			// Return first latlng so that the map will have somewhere to focus
			first_latlng = data.markers[0].latitude+","+data.markers[0].longitude;
			
			$.each( data.markers, function(i, marker) {
				$('#map_canvas').gmap('addMarker', { 
					'position': marker.latitude+","+marker.longitude, 
					'bounds': true 
				}).click(function() {					
					$('#map_canvas').gmap('openInfoWindow', { 'content': "<span class='marker_content'>"+marker.content+"</span>" }, this);
				});						
			});
		});		
		var first_latlng = new google.maps.LatLng(first_latlng);
		return first_latlng;
	}
	var geocoder = new google.maps.Geocoder();
	
	$('#map_canvas').gmap().bind('init', function() { 	
		geocoder.geocode( {'address': 'U.S.A' }, function(results, status) {
			$('#map_canvas').gmap('get', 'map').panTo(results[0].geometry.location);
		});
	});
	
	$('#search_button').click(function() {
		var latlng;
		if ( $('#address').val()=="Everywhere" ){
			latlng = get_map_locs("Everywhere", 0, $("#keywords").val());			
	    }
		else{
		    geocoder.geocode( {'address': $('#address').val() }, function(results, status) {
		    	if (status == google.maps.GeocoderStatus.OK) {
					var lat = results[0].geometry.location.lat();
					var lng = results[0].geometry.location.lng();						
					get_map_locs(lat+","+lng, $("#radius").val(), $("#keywords").val());					
				}else {
			    	alert("Geocode was not successful for the following reason: " + status);
			    }
		    	latlng = results[0].geometry.location
		    });
		}
		// Center map on resuts
		$('#map_canvas').gmap('get', 'map').panTo(latlng);
		$('#map_canvas').gmap('refresh');
		$('#map_canvas').gmap('resize');
	});
});