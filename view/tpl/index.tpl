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
    <script type="text/javascript" src="js/calswim.js"></script>
    <script type="text/javascript">
        google.load('visualization', '1', {'packages': ['table', 'map', 'corechart']});
        google.setOnLoadCallback(initialize);
        
        function initialize() {
            // The URL here is the URL of the spreadsheet.
            // This is where the data is.
            var query = new google.visualization.Query(
                'https://spreadsheets.google.com/pub?key=AIzaSyDYIRhex5ycocL6uuYWa5ZVf1yxwV-4eDk');
            query.send(draw);
          }

          function draw(response) {
            if (response.isError()) {
              alert('Error in query');
            }

            var ticketsData = response.getDataTable();
            var chart = new google.visualization.ColumnChart(
                document.getElementById('chart_div'));
            chart.draw(ticketsData, {'isStacked': true, 'legend': 'bottom',
                'vAxis': {'title': 'Number of tickets'}});

            var geoData = new google.visualization.DataTable();
            geoData.addColumn('string', 'City');
            geoData.addColumn('string', 'Name');
            geoData.addColumn('boolean', 'Food');
            geoData.addRows(3);
            geoData.setCell(0, 0, 'London');
            geoData.setCell(1, 0, 'Paris');
            geoData.setCell(2, 0, 'Moscow');
            geoData.setCell(0, 1, 'Cinematics London');
            geoData.setCell(1, 1, 'Cinematics Paris');
            geoData.setCell(2, 1, 'Cinematics Moscow');
            geoData.setCell(0, 2, true);
            geoData.setCell(1, 2, true);
            geoData.setCell(2, 2, false);

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
        <div id="map_canvas_wrapper" class="dark rounded ui-layout-center">
            <div id="map_canvas"></div>
            <div id="table_canvas"></div>
        </div>
        
        <div id="search_canvas" class="rounded ui-layout-north">        
            <label>Address</label>
            <input id="search"/>
            <button id="search_button">Search</button>    
        </div>
        
        <div class="rounded ui-layout-west">
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