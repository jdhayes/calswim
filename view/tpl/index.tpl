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
    <script type="text/javascript" src="js/jquery.watermark.js"></script>
    <script type="text/javascript" src="js/calswim.js"></script>
    <script type="text/javascript">
        google.load('visualization', '1', {'packages': ['table', 'map', 'corechart']});
        google.setOnLoadCallback(initialize);
        
        function initialize() {
           drawTable();
          }

          function drawTable(response) {
            var geoData = new google.visualization.DataTable();
            geoData.addColumn('string', 'Source');
            geoData.addColumn('string', 'Description');
            geoData.addColumn('string', 'URL');
            geoData.addRows(3);
            geoData.setCell(0, 0, 'Southern California Transect, Desert');
            geoData.setCell(1, 0, 'Southern California Transect, Pinyon/Juniper');
            geoData.setCell(2, 0, 'Southern California Transect, Desert Chaparral');
            geoData.setCell(0, 1, 'Data collected from desert region.');
            geoData.setCell(1, 1, 'Data collected from .Pinyon/Juniper region.');
            geoData.setCell(2, 1, 'Data collected from desert Chaparral region.');
            geoData.setCell(0, 2, "http:\/\/www.ess.uci.edu\/~california\/");
            geoData.setCell(1, 2, "http:\/\/www.ess.uci.edu\/~california\/");
            geoData.setCell(2, 2, "http:\/\/www.ess.uci.edu\/~california\/");

            var geoView = new google.visualization.DataView(geoData);
            geoView.setColumns([0, 1]);

            var table = new google.visualization.Table(document.getElementById('table_canvas'));
            table.draw(geoData, {showRowNumber: false});

            /*
                var map = new google.visualization.Map(document.getElementById('map_canvas'));
                map.draw(geoView, {showTip: true});
    
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
            */
          }
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
            <label>Keywords</label>
            <textarea id="keywords" style="width: 100%"></textarea>
            <label>Search Radius (Miles)</label>
            <select id="radius">
                <option value="5">5</option>
                <option value="10">10</option>
                <option value="25">25</option>
                <option value="50">50</option>
                <option value="100">100</option>
            </select>               
        </div>
    </div>
    
    <div id="footer" class="dark">CalSWIM &copy; ICS @ UCI</div>
  </body>
</html>