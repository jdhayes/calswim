<!DOCTYPE html>
<html>
  <head>      
    <link rel="stylesheet" type="text/css" href="css/index.css" />
    <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDYIRhex5ycocL6uuYWa5ZVf1yxwV-4eDk&sensor=false"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.ui.map.full.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.layout.min.js"></script>
    <script type="text/javascript" src="js/calswim.js"></script>
  </head>
  <body>    
    <div id="header" class="dark"><h1>Welcome to CalSWIM!</h1></div>    
    
    <div id="map_canvas_wrapper" class="dark rounded ui-layout-center">
        <div id="map_canvas"></div>
    </div>
    
    <div id="search_canvas" class="dark rounded ui-layout-north">        
        <label>Address</label>
        <input id="search"/>
        <button id="search_button">Search</button>    
    </div>
    
    <div class="ui-layout-west">
        <label>Search Radius (Miles)</label>
        <select id="radius">
            <option value="5">5</option>
            <option value="10">10</option>
            <option value="25">25</option>
            <option value="50">50</option>
            <option value="100">100</option>
        </select>               
    </div>
    
    <div id="footer" class="dark ui-layout-south">CalSWIM &copy; ICS @ UCI</div>
  </body>
</html>