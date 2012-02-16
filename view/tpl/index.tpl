<!DOCTYPE html>
<html>
  <head>      
    <link rel="stylesheet" type="text/css" href="css/index.css" />
    <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDYIRhex5ycocL6uuYWa5ZVf1yxwV-4eDk&sensor=false"></script>
    <script type="text/javascript" src="js/jquery/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.ui.map.full.min.js"></script>
    <script type="text/javascript" src="js/calswim.js"></script>
  </head>
  <body>    
    <div id="header" class="dark"><h1>Welcome to CalSWIM!</h1></div>    
    
    <div id="map_canvas_wrapper" class="dark rounded">
        <div id="map_canvas"></div>
    </div>
    
    <div id="search_canvas" class="dark rounded">        
        <label>Address</label>
        <input id="search"/>        
        
        <label>Search Radius (Miles)</label>
        <select id="radius">
            <option value="5">5</option>
            <option value="10">10</option>
            <option value="25">25</option>
            <option value="50">50</option>
            <option value="100">100</option>
        </select>
        
        <button id="search_button">Search</button>
    </div>
    
    <div id="footer" class="dark">CalSWIM &copy; ICS @ UCI</div>
  </body>
</html>