// CalSWIM main Javascript file

function initTableMap(json_data) {    
    // No search results found
    if (json_data == null){
        alert('empty');
    }else{
    	// Define table data and map data
        var json_table_data = json_data.table_data;
        var geoObjects = json_data.coordinates;
        
        // Define geo data
        var geoData = new google.visualization.DataTable(json_table_data);    
        // Filter geo data
        var tableGeoView = new google.visualization.DataView(geoData);    
        //tableGeoView.setColumns([0,1,2]);        
        // Draw Table
        var table = new google.visualization.Table(document.getElementById('table_canvas'));
        table.draw(tableGeoView, {showRowNumber: false});
        
        // Add points and polygons to map                    
    	$(geoObjects).each(function(index, coords){      	
        	var coords = coords.split(",");        	
        	
            if (coords.length > 1){                      
                // Parse coordinates and build polygons            	
                var path = [];                
                for (var i = 0; i < coords.length; i++) {     	
                	var coord = coords[i].split(" ");                    
                    path.push(new google.maps.LatLng(coord[0], coord[1]));
                }
                // Define polygon options
                var polyOptions = {
                		'clickable': true,
                		'strokeColor': "#FF0000",
                		'strokeOpacity': 0.8,
                		'strokeWeight': 2,
                		'fillColor': "#FF0000",
                		'fillOpacity': 0.35,
                		'path': new google.maps.MVCArray(path)                		
                }
                // Draw Polygon                 	
            	var polygon = new google.maps.Polygon(polyOptions);
            	polygon.setMap(map);                	
            	google.maps.event.addListener(polygon,"click",function(){ alert("You clicked a polygon")});
            }else{
                // Set point as Google Marker
            	var coord = coords[0].split(" ");
            	var marker = new google.maps.Marker({
            	    position: new google.maps.LatLng(coord[0], coord[1]),
            	    map: map,
            	    title: 'Click to zoom',
            	    bounds: true
            	  });
            	var content = json_table_data.rows[index]['c'][1]['v'];
            	google.maps.event.addListener(marker, 'click', function() {
            		alert(content);
            	});                    
            }
        });                
        
        // Set a 'select' event listener for the table.
        // When the table is selected,
        // we set the selection on the map.
        google.visualization.events.addListener(table, 'select', function() {
              alert("Clicked table row");
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
        ,north__maxSize:         50
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
    // Init Google Map
    var map;
    var geocoder = new google.maps.Geocoder();        
    geocoder.geocode( {'address': 'U.S.A' }, function(results, status) {
//    	var mapOptions = {
//    		center: results[0].geometry.location
//    	}
    	map = new google.maps.Map(document.getElementById("map_canvas"));
    });
    
    // Method access database and pulls records according to search parameters
    function get_map_locs(latlng, radius, keywords){
        // Clear previously set markers
//        $('#map_canvas').gmap('clear', 'overlays');
//        $('#map_canvas').gmap('clear', 'markers');
//        $('#map_canvas').gmap('clear', 'services');
        
        // Get json results from DB        
        $.getJSON("?get_map_locs="+latlng +"&radius="+radius +"&keywords="+keywords, function(json_data) {                                
            initTableMap(json_data);            
        });
        
        // Refresh map, and resize
//        $('#map_canvas').gmap('refresh');
    }    
    
    
    // Set click event on search button
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
                // Center map on results
//                $('#map_canvas').gmap('get', 'map').panTo(results[0].geometry.location);
            });
        }        
    });
}