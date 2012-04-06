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
    <script type="text/javascript" src="js/jquery/jquery.layout.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.watermark.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.colorbox.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.form.js"></script>
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
            <div id="table_canvas_wrapper">
                <div id="table_canvas"></div>
            </div>
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
    
    <div id="upload_message"></div>
    <div id="form_hidden_wrapper">
        <div id="form_wrapper">
            <form id="upload_form" method="post" action="" enctype="multipart/form-data">              
                <h3>Please fill out and submit the following form to register your data location[s]</h3>                
                <h2>Source Information</h2>
                <div class="indent">
                    <div> 
                        <label>Organization Name</label>
                        <input id="contact" name="contact" class="required" />
                    </div>
                    <div>     
                        <label>Contact Name</label>
                        <input id="contact" name="contact" class="required" />
                    </div>
                    <div> 
                        <label>Contact Email</label>
                        <input id="email" name="email" class="required" />
                    </div>
                    <div> 
                        <label>Contact Phone</label>
                        <input id="phone" name="phone" class="required" />
                    </div>
                    <div>
                        <label>Data Link</label>
                        <input id="source" name="source" class="required url" />
                    </div>
                </div>
                
                <h2>Project Information</h2>
                <div class="indent">
                    <div>
                        <label>Project name</label>
                        <textarea id="label" name="label" class="required upload"></textarea>
                    </div>            
                    <div>
                        <label>Project description</label>
                        <textarea id="description" name="description" class="required upload"></textarea>
                    </div>
                    <div>
                        <label>Project timeline</label><br />
                        <input id="timelineStart" name="timelineStart" class="required" />
                        <input id="timelineFinish" name="timelineFinish" class="required" />
                    </div>
                    <div>
                        <label>Project funder</label>
                        <textarea id="funder" name="funder" class="required upload"></textarea>
                    </div>
                </div>
                
                <h2>Meta Data</h2>
                <div class="indent">
                    <div>
                        <label>Habitat or target species</label>
                        <textarea id="target" name="target" class="required upload"></textarea>
                    </div>                    
                    <div>
                        <label>Site location description</label>
                        <textarea id="location" name="location" class="required upload"></textarea>
                    </div>
                    <div>
                        <label>Number of Sites</label>
                        <textarea id="numsites" name="numsites" class="required upload"></textarea>
                    </div>
                    <div>
                        <label>Data collector</label>
                        <textarea id="collector" name="collector" class="required upload"></textarea>
                    </div>                    
                    <div>
                        <label>Data type</label>
                        <textarea id="datatype" name="datatype" class="required upload"></textarea>
                    </div>
                    <div>
                        <label>Data format</label>
                        <textarea id="dataformat" name="dataformat" class="required upload"></textarea>
                    </div>
                    <div>
                        <label>Data sharing policies</label>
                        <textarea id="policies" name="policies" class="required upload"></textarea>
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
                    <div>
                        <label>Searchable keywords</label>
                        <textarea id="keyword" name="keyword" class="required upload"></textarea>
                    </div>
                    <div>
                        <label>Additional Information (optional)</label><br />
                        <textarea id="other" name="other" class="upload"></textarea>
                    </div>
                </div>
                
                <input type="hidden" name="import_data" id="import_data" value="import_data"/>
                <button id="upload_button" class="button">Submit</button>                
            </form>
        </div>
    </div>
    
    <div id="footer" class="dark">CalSWIM &copy; ICS @ UCI</div>
  </body>
</html>