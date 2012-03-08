// CalSWIM main Javascript file

function initTableMap(json_table_data) {
	if (json_table_data == null){
		// Init Google Map
		var geocoder = new google.maps.Geocoder();
		$('#map_canvas').gmap().bind('init', function() { 	
			geocoder.geocode( {'address': 'U.S.A' }, function(results, status) {
				$('#map_canvas').gmap('get', 'map').panTo(results[0].geometry.location);
			});
		});
	}
	else{
	    var geoData = new google.visualization.DataTable(json_table_data);    
		
		var tableGeoView = new google.visualization.DataView(geoData);	
		tableGeoView.setColumns([1,2,3]);
		var mapGeoView = new google.visualization.DataView(geoData);	
		mapGeoView.setColumns([0,2]);
		
		var table = new google.visualization.Table(document.getElementById('table_canvas'));
		table.draw(tableGeoView, {showRowNumber: false});
			
	    var map = new google.visualization.Map(document.getElementById('map_canvas'));
	    map.draw(mapGeoView, {showTip: true});
	
	    // Set a 'select' event listener for the table.
	    // When the table is selected,
	    // we set the selection on the map.
	    google.visualization.events.addListener(table, 'select',
	        function() {
	          map.setSelection(table.getSelection());
	        });
	
	    // Set a 'select' event listener for the map.
	    // When the map is selected,
	    // we set the selection on the table.
	    google.visualization.events.addListener(map, 'select',
	        function() {
	          table.setSelection(map.getSelection());
	    });
	}
}

function initialize() {    
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
	$(".button").button();
	
	// Method access database and pulls records according to search parameters
	function get_map_locs(latlng, radius, keywords){
		// Clear previously set markers
		$('#map_canvas').gmap('clear', 'overlays');
		$('#map_canvas').gmap('clear', 'markers');
		$('#map_canvas').gmap('clear', 'services');
		
		// Get json results from DB		
		$.getJSON("?get_map_locs="+latlng +"&radius="+radius +"&keywords="+keywords, function(json_data) {								
			initTableMap(json_data.table_data);			
		});
		
		// Refresh map, and resize
		$('#map_canvas').gmap('refresh');
	}	
	
	// Init Google Data Table
	initTableMap(null);
	
	// Set click even on search button
	$('#search_button').click(function() {
		var latlng;
		// Do DB search with no coordinates
		if ( $('#address').val()=="Everywhere" ){
			get_map_locs("Everywhere", 0, $("#keywords").val());	
	    }		
		// Get coordinates for address and do DB search
		else{
			var geocoder = new google.maps.Geocoder();
		    geocoder.geocode( {'address': $('#address').val() }, function(results, status) {
		    	if (status == google.maps.GeocoderStatus.OK) {
					var lat = results[0].geometry.location.lat();
					var lng = results[0].geometry.location.lng();						
					get_map_locs(lat+","+lng, $("#radius").val(), $("#keywords").val());					
				}else {
			    	alert("Geocode was not successful for the following reason: " + status);
			    }		    	
				// Center map on resuts
				$('#map_canvas').gmap('get', 'map').panTo(results[0].geometry.location);
		    });
		}		
	});
}