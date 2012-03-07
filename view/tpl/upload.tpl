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
        <script type="text/javascript" src="js/upload.js"></script>
        <script type="text/javascript">
            google.load('visualization', '1', {'packages': ['table', 'map', 'corechart']});
            google.setOnLoadCallback(function(){
                alert('Fill out the form');
            });               
        </script>
    </head>
    <body>
        <form>
            <h2>Source Information</h2>         
            <div>     
                <label>Organization/Person responsible</label>
                <input id="label" name="label" />
            </div>
            <div>
                <label>Source URL</label>
                <input id="source" name="source" />
            </div>
            
            <h2>Meta Data</h2>
            <div>
                <label>Label</label>
                <input id="label" name="label" />
            </div>            
            <div>
                <label>Description</label>
                <textarea></textarea>
            </div>
            <div>
                <label>Keywords</label>
                <textarea></textarea>
            </div>
            
            <h2>Location</h2>
            <div>                
                <label>Latitude</label>
                <input id="lat" name="lat" />
            
                <label>Longitude</label>
                <input id="lng" name="lng" />
                
                OR
                <label>Shape file</label>
                <input type="file" id="shp_file" name="shp_file" />
            </div>
            
            <h2>Other</h2>
            <div>
                <label>Additional Information (optional)</label>
                <textarea></textarea>
            </div>
            
            <button type="submit" id="Submit" name="Submit">Submit</button>
        </form>
    </body>
</html>