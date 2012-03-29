// CalSWIM main Javascript file

// Define Global Vars
var map;
var map_items=[];
var infowindow = new google.maps.InfoWindow();

// Extend Google Maps API v3
google.maps.Polygon.prototype.getBounds = function() {
    var bounds = new google.maps.LatLngBounds();
    var paths = this.getPaths();
    var path;        
    for (var i = 0; i < paths.getLength(); i++) {
        path = paths.getAt(i);
        for (var ii = 0; ii < path.getLength(); ii++) {
            bounds.extend(path.getAt(ii));
        }
    }
    return bounds;
}

// Main function that populates table and map with data
function initTableMap(json_data) {    
	// Define table data and map data
    var json_table_data = json_data.table_data;
    var geoObjects = json_data.coordinates; 
    
	// No search results found
    if (geoObjects.length <= 0){
    	// DB response            		
		$("#upload_message").html("<p>No locations found.</p>");
		$("#upload_message").dialog('open')
    }else{    	      
        // Define geo data
        var geoData = new google.visualization.DataTable(json_table_data);    
        // Filter geo data
        var tableGeoView = new google.visualization.DataView(geoData);    
        //tableGeoView.setColumns([0,1,2]);
        // Draw Table
        var tableOptions = {height:"30%"}
        var table = new google.visualization.Table(document.getElementById('table_canvas'), tableOptions);
        table.draw(tableGeoView, {showRowNumber: false});
        
        // Add points and polygons to map                    
    	$(geoObjects).each(function(index, coords){      	
        	var coords = coords.split(",");        	
        	// Check if polygon or marker point
            if (coords.length > 1){                    
                // Parse coordinates and build polygons            	
                var path = [];                
                for (var i = 0; i < coords.length; i++) {     	
                	var coord = coords[i].split(" ");                    
                    path.push(new google.maps.LatLng(coord[0], coord[1]));
                }
                // Define polygon options
                var polyOptions = {
                		clickable: true,
                		strokeColor: "#FF0000",
                		strokeOpacity: 0.8,
                		strokeWeight: 2,
                		fillColor: "#FF0000",
                		fillOpacity: 0.35,
                		path: new google.maps.MVCArray(path),
                		type:"polygon"
                }
                // Draw Polygon                 	
            	var polygon = new google.maps.Polygon(polyOptions);
                map_items.push(polygon);
            	polygon.setMap(map);
            	// Set Google Map event handler
            	google.maps.event.addListener(polygon,"click",function(event){
            		// Close previously opened infowindow
            		infowindow.close();
            		
            		// Highlight item
            		// Open infowindow
            		var content = json_table_data.rows[index]['c'][1]['v'];
            		infowindow.setContent(content);
            		if (event) {
            			point = event.latLng;
            		}
            		infowindow.setPosition(point);
            		infowindow.open(map); 
            		// Set selection in table
            	});
            	map.fitBounds(polygon.getBounds());
            }else{
                // Set point as Google Marker
            	var coord = coords[0].split(" ");
            	var marker = new google.maps.Marker({
            	    position: new google.maps.LatLng(coord[0], coord[1]),
            	    map: map,
            	    title: 'Click to zoom',
            	    bounds: true,
            	    type:"marker"
            	  });
            	map_items.push(marker);
            	var content = json_table_data.rows[index]['c'][1]['v'];
            	google.maps.event.addListener(marker, 'click', function() {
            	    // Highlight item
            	    // Set contents then open infowindow
            		infowindow.setContent(content);
            	    infowindow.open(map,marker);
            	    // Set selection in table
            	    //table.setSelection()
            	});                    
            }
        });                
        
        // Set a 'select' event listener for the table.        
        google.visualization.events.addListener(table, 'select', function() {       
        	var selected_items = table.getSelection()
        	$(selected_items).each(function(key,value){
        		if (map_items[value.row].type == "polygon"){
        			map.fitBounds(map_items[value.row].getBounds());
        		}
        		else{
        			var bounds = new google.maps.LatLngBounds();
        			bounds.extend(map_items[value.row].getPosition());
        			map.fitBounds(bounds);
        		}
        	});
        });
        // Set 'click' event on map to close infowindow
        google.maps.event.addListener(map, 'click', function() {
        	infowindow.close();
        }); 
    }
}

function clearMap(){
	for(var i = 0; i < map_items.length; i++) {
		map_items[i].setMap(null);
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
    var geocoder = new google.maps.Geocoder();        
    geocoder.geocode( { 'address': 'U.S.A.'}, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          var myOptions = {
        	  zoom: 4,
	          center: results[0].geometry.location,
	          mapTypeId: google.maps.MapTypeId.ROADMAP
          }
          map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
        }
      });
    
    // Method access database and pulls records according to search parameters
    function get_map_locs(latlng, radius, keywords){
        // Clear previously set markers and polygons
    	clearMap();
        
        // Get json results from DB        
        $.getJSON("?get_map_locs="+latlng +"&radius="+radius +"&keywords="+keywords, function(json_data) {                                
            initTableMap(json_data);            
        });
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