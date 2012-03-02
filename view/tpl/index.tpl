<!DOCTYPE html>
<html>
  <head>      
    <link rel="stylesheet" type="text/css" href="css/index.css" />
    <script type="text/javascript" src="http://www.google.com/jsapi"></script>    
    <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDYIRhex5ycocL6uuYWa5ZVf1yxwV-4eDk&sensor=false"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.ui.map.full.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.layout.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.watermark.js"></script>
    <script type="text/javascript" src="js/calswim.js"></script>
    <script type="text/javascript">
        google.load('visualization', '1', {'packages': ['table', 'map', 'corechart']});
        google.setOnLoadCallback(initialize);               
    </script>
  </head>
  <body>    
    <div id="header" class="dark"><h1>Welcome to CalSWIM!</h1></div>    
    
    <div id="content">
        <div id="map_canvas_wrapper" class="rounded ui-layout-center">
            <div id="map_canvas"></div>
            <div id="table_canvas"></div>
        </div>
        
        <div id="search_canvas" class="rounded ui-layout-north">
            <h2>Search</h2>      
            <label>Address</label>
            <input id="address"/>
            <button id="search_button">Search</button>    
        </div>
        
        <div class="rounded ui-layout-west">
            <h2>Filters</h2>
            
            <label>Search Radius (Miles)</label>
            <select id="radius">
                <option value="5">5</option>
                <option value="10">10</option>
                <option value="25">25</option>
                <option value="50">50</option>
                <option value="100">100</option>
            </select>
            <br />
            <label>Keywords</label>
            <textarea id="keywords" style="width: 100%"></textarea>               
        </div>
    </div>
    
    <div id="footer" class="dark">CalSWIM &copy; ICS @ UCI</div>
  </body>
</html>