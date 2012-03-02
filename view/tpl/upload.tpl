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
        <label>Source</label>
        <input id="lat" name="lat" />
        
        <label>Contact</label>
        <input id="lat" name="lat" />
        
        <label>Latitude</label>
        <input id="lat" name="lat" />
        
        <label>Longitude</label>
        <input id="lng" name="lng" />
        
        <label>Description</label>
        <textarea></textarea>
        
        <label>Keywords</label>
        <textarea></textarea>
        
        <label>Other Additional Information (optional)</label>
        <textarea></textarea>
        </form>
    </body>
</html>