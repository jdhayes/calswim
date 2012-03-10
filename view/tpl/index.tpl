<!DOCTYPE html>
<html>
  <head>
    <style type="text/css" title="CalSWIMStyle">  
        @import "css/index.css";
        @import "css/jquery.colorbox.css";
        @import "css/humanity/jquery-ui-1.8.18.custom.css";
    </style>   
    <script type="text/javascript" src="http://www.google.com/jsapi"></script>    
    <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDYIRhex5ycocL6uuYWa5ZVf1yxwV-4eDk&sensor=false"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"></script>
    <script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.ui.map.full.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.layout.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.watermark.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.colorbox.min.js"></script>
    <script type="text/javascript" src="js/calswim.js"></script>
    <script type="text/javascript" src="js/upload.js"></script>
    <script type="text/javascript">
        google.load('visualization', '1', {'packages': ['table', 'map', 'corechart']});
        google.setOnLoadCallback(initialize);               
    </script>
  </head>
  <body>
    <div id="header" class="dark">
        <h1>Welcome to CalSWIM!</h1>
        <a id="upload" class="button" href="#form_wrapper">Upload</a>
    </div>    
    
    <div id="content">
        <div id="map_canvas_wrapper" class="rounded ui-layout-center">
            <div id="map_canvas"></div>
            <div id="table_canvas"></div>
        </div>
        
        <div id="search_canvas" class="rounded ui-layout-north">
            <h2>Search</h2>      
            <label>Address</label>
            <input id="address"/>
            <span id="search_button" class="button">Search</span>    
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
            <textarea id="keywords"></textarea>               
        </div>
    </div>
    
    <div id="form_hidden_wrapper">
        <div id="form_wrapper">
            <form id="upload_form" method="post" action="">              
                <div id="uppload_message_wrapper"><p id="upload_message"></p></div>
                <h3>Please fill out and submit the following form to register your data location[s]</h3>                
                <h2>Source Information</h2>
                <div class="indent">
                    <div>     
                        <label>Organization/Person responsible</label>
                        <input id="contact" name="contact" class="required" />
                    </div>
                    <div>
                        <label>Source URL</label>
                        <input id="source" name="source" class="required url" />
                    </div>
                </div>
                
                <h2>Meta Data</h2>
                <div class="indent">
                    <div>
                        <label>Label</label>
                        <textarea id="label" name="label" class="required"></textarea>
                    </div>            
                    <div>
                        <label>Description</label>
                        <textarea id="description" name="description" class="required"></textarea>
                    </div>
                    <div>
                        <label>Keywords</label>
                        <textarea id="keyword" name="keyword" class="required"></textarea>
                    </div>
                </div>
                
                <h2>Location</h2>
                <div id="location" class="indent">
                    <div>                
                        <label>Latitude</label>
                        <input id="lat" name="lat" class="number" />
                        <br />
                        <label>Longitude</label>
                        <input id="lng" name="lng" class="number" />
                    </div>
                    <h3>OR</h3>
                    <div>
                        <label for="shp_file">Shape file</label>
                        <input type="file" id="shp_file" name="shp_file" />
                    </div>
                </div>
                
                <h2>Other</h2>
                <div class="indent">
                    <label>Additional Information (optional)</label><br />
                    <textarea id="other" name="other"></textarea>
                </div>
                                    
                <input id="submit" name="submit" type="submit" value="submit" class="button" />                
            </form>
        </div>
    </div>
    
    <div id="footer" class="dark">CalSWIM &copy; ICS @ UCI</div>
  </body>
</html>