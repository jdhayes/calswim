// CalSWIM main Javascript file

// Define Global Vars
var map;
var table;
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
    
    // Define geo data
    var geoData = new google.visualization.DataTable(json_table_data);    
    // Filter geo data
    var tableGeoView = new google.visualization.DataView(geoData);
    // Filter viewable columns
    tableGeoView.setColumns([1,3,4,5]);
    // Draw Table    
    var tableOptions = {width:'100%',height: '100%',page:'disable', showRowNumber:false, cssClassNames:{headerRow:'ui-widget-header'}};    
    table.draw(tableGeoView, tableOptions);    
    // Open the Table canvas pane
    layout = $("#content").layout();
    layout.open('south');
    // Close the Data Details pane   
    layout.close('west');
    
	// No search results found
    if (geoObjects.length <= 0){
    	// Clear previously populated table data
    	clearTable(geoData);    	
    	
    	// DB response            		
		$("#upload_message").html("<p>No locations found.</p>");
		$("#upload_message").dialog('open')
    }else{
    	// Initialize bounds object
    	var bounds = new google.maps.LatLngBounds();
    	
        // Add points and polygons to map                    
    	$(geoObjects).each(function(index, coords){      	
        	// Place all coordinates into an array
    		var coords = coords.split(",");
        	// Define content for InfoWindow
        	var content = json_table_data.rows[index]['c'][2]['v'];
        	// Define database ID for data details ajax call
        	var data_id = json_table_data.rows[index]['c'][0]['v'];
        	// Check if polygon or marker point
            if (coords.length > 1){
            	
                // Parse coordinates and build polygons            	
                var path = [];                
                for (var i = 0; i < coords.length; i++) {     	
                	var coord = coords[i].split(" ");
                	var poly_cord = new google.maps.LatLng(coord[0], coord[1]);
                    path.push(poly_cord);
                    bounds.extend(poly_cord);
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
                		type:"polygon",
                		title: content,                		
                	    gdID: data_id
                }
                // Draw Polygon                 	
            	var polygon = new google.maps.Polygon(polyOptions);
                map_items.push(polygon);
            	polygon.setMap(map);
            	// Set Google Map event handler
            	google.maps.event.addListener(polygon,"click",function(event){
            		// Close previously opened infowindow
            		infowindow.close();
            		// Clear previsouly highlighted polygon
            		clearSelected();
            		
            		// Highlight item
            		polygon.setOptions({fillColor: "#0000FF"});
            		// Open infowindow            		
            		infowindow.setContent(content);
            		if (event) {
            			point = event.latLng;
            		}
            		infowindow.setPosition(point);
            		infowindow.open(map); 
            		// Set selection in table
            		table.setSelection([{'row': index}])
            	    // Open data details pane
            	    get_data_details(data_id);
            	});            	
            }else{            	
                // Set point as Google Marker
            	var coord = coords[0].split(" ");
            	var marker_cord = new google.maps.LatLng(coord[0], coord[1]);
            	bounds.extend(marker_cord);
            	var marker = new google.maps.Marker({
            	    position: marker_cord,
            	    map: map,
            	    title: 'Click to zoom',
            	    bounds: true,
            	    type:"marker",
            	    title: content,
            	    gdID: data_id
            	  });
            	map_items.push(marker);            	            
                
            	google.maps.event.addListener(marker, 'click', function() {
            		// Clear previously highlighted marker
            		clearSelected();
            	    // Highlight item
            		marker.setIcon('/images/gmap-blue-dot.png');
            	    // Set contents then open infowindow
            		infowindow.setContent('<p>'+ content +'</p>');
            	    infowindow.open(map,marker);
            	    // Set selection in table
            	    table.setSelection([{'row': index}]);
            	    // Open data details pane
            	    get_data_details(data_id);            		
            	});
            }
        });            
    	// Fit map to previously set bounds
    	map.fitBounds(bounds);
    	
        // Set a 'select' event listener for the table.        
        google.visualization.events.addListener(table, 'select', function() {
        	var selected_items = table.getSelection()
        	$(selected_items).each(function(key,value){
        		// Clear the previously selected polygon or marker
        		clearSelected();
        		
        		// Highlight the current selection
        		if (map_items[value.row].type == "polygon"){
        			map_items[value.row].setOptions({fillColor: "#0000FF"});
        			map.fitBounds(map_items[value.row].getBounds());
        		}
        		else{
        			map_items[value.row].setIcon('/images/gmap-blue-dot.png');
        			var bounds = new google.maps.LatLngBounds();
        			bounds.extend(map_items[value.row].getPosition());
        			//map.fitBounds(bounds);
        			map.setCenter(bounds.getCenter());
        			map.setZoom(14);
        		}
        		
        		// Open data details pane
        	    get_data_details(map_items[value.row].gdID);
        	});
        });
        // Set 'click' event on map to close infowindow
        google.maps.event.addListener(map, 'click', function() {
        	infowindow.close();
        }); 
    }
    
    // Initialize resizable table container
    resizeOptions = {handles:"n", alsoResize:'#table_canvas div div:last'}
    $('#table_canvas').resizable(resizeOptions);       
}

// Clear all selections on the map
function clearSelected(){
	for(var i = 0; i < map_items.length; i++) {
		if (map_items[i].type == "polygon"){
			map_items[i].setOptions({fillColor: "#FF0000"});
		}
		else{
			map_items[i].setIcon('/images/gmap-red-dot.png');
		}
	}
}

// Delete all the markers on the map
function clearMap(){
	for(var i = 0; i < map_items.length; i++) {
		map_items[i].setMap(null);
	}
	map_items.length=0;
}

// Delete all rows in table
function clearTable(table){
	var totalRows = table.getNumberOfRows();
	table.removeRows(0,totalRows);
}

// Send ID via ajax call to DB for data details
function get_data_details(data_id) {
    $.getJSON("?get_data_details="+data_id, function(json_data) {                    	
    	var html_details = "";
    	$.each(json_data, function(jindex, tuple){
    		index = tuple[0];
    		value = tuple[1];
    		if (value && value!="None" && value!="" && value!=" "){
    			html_details += '<h3 class="ui-widget-header">'+ index +'</h3><p>'+ value +'</p>';
    		}
    	});
    	
    	// Initialize button    	
    	$(".download_details").attr("href", "/?format=csv&get_data_details="+data_id)
    	$("#data_details_wrapper .download_details").button({    	
    		icons: {
				secondary: "ui-icon-disk"
			}
    	});
    	// Initialize html details
    	$("#data_details").html(html_details);
    });
    
    // Open the data details pane
    west_layout = $("#content").layout();
    west_layout.open('west');
}

function initialize() {    
    /* ***************** */
    /* Initialize Layout */
    /* ***************** */
    
    /* Custom Toggle buttons */
    /*
        toggleButtons = '<div class="btnToggler"></div>' + '<div class="btnReset"></div>' + '<div class="btnExpand"></div>'
    */
    
    /*
	$('body').layout({
    	 applyDefaultStyles:    true
        ,center__paneSelector:   "#content" 
        ,north__paneSelector:    "#header"
        ,north__closable:        false
        ,north__resizeable:      false
        ,north__size:            75                         
        ,north__maxSize:         75
        ,south__paneSelector:    "#table_canvas"
        ,south__initClosed:      true
        ,south__size:            "30%"
        ,south__closable:        true
        ,south__resizeable:      true        
        //,south__togglerLength_closed: 105
        //,south__togglerLength_open:   105
        //,south__togglerContent_closed: toggleButtons
        //,south__togglerContent_open:   toggleButtons
    });
    */
    
    // Init Table
    var data = new google.visualization.DataTable();
    data.addColumn('string','Organization');
    data.addColumn('string','Project');
    data.addColumn('string','Description');    
    data.addColumn('string','Target');
    table = new google.visualization.Table(document.getElementById('table_canvas'));    
    table.draw(data, {width:'100%', height: '100%', showRowNumber: false, cssClassNames:{headerRow: 'ui-widget-header'}});    
    
    // Initialize center layout
    var layout_options = {
    	applyDefaultStyles:    true
    	//, north__paneSelector:  "#search"
    	//, north__initClosed: true
		//, west__paneSelector:   "#data_details_wrapper"
    	, west__initClosed:    true
    	, west__size:          300
    	//,south__paneSelector:    "#table_canvas"
        , south__initClosed:      true
        , south__size:            "30%"
        , south__closable:        true
        , south__resizeable:      true
    	//, south__togglerContent_open:  "<span style='font-size:5pt'>Close<span>"
    	//, south__togglerContent_close: "<span style='font-size:5pt'>Open<span>"
    	//, center__paneSelector: "#map_canvas_wrapper"    	
    	//, center__onresize:     function () {
    		// ReSize GTable Fixed Header to the duplicated header underneath
    	//	$('#table_canvas div div:first').height($('#table_canvas').height());
    	//, triggerEventsOnLoad:  true
    		
    	//	var new_width = $('table.google-visualization-table-table').width();
    	//	var new_height = $('td.google-visualization-table-th').outerHeight(true);    		
    	//	$('#table_canvas div div:last').width(new_width);
    	//	$('#table_canvas div div:last').height(new_height);    		    		
    	//}
    };
    myLayout = $('#content').layout(layout_options);
    $('#search_link').click(function(){
    	myLayout.toggle('north');
    });       
    
    /* Init colorbox overlays */
	$("#about_link").colorbox({inline:true,maxHeight:"100%",width:"500px"});	
	$("#tools_link").colorbox({inline:true,maxHeight:"100%",width:"500px"});
	$("#contact_link").colorbox({inline:true,maxHeight:"100%",width:"500px"});
	$("#login_link").colorbox({inline:true,maxHeight:"100%",width:"500px"});
    /* Init watermarks and buttons */
	$("#address").Watermark("Everywhere");
    $("#keywords").Watermark("Everything");        
    $("#login_button").button({    	
		icons: {
			secondary: "ui-icon-locked"
		}
	});
    $("#search_button").button({    	
		icons: {
			secondary: "ui-icon-search"
		}
	});
    
    // Init Google Map    
    var geocoder = new google.maps.Geocoder();
    // Center initialized map on OC
    geocoder.geocode( { 'address': 'Orange County, California'}, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          var myOptions = {
        	  zoom: 9,
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