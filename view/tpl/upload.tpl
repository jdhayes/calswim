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
        <script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js"></script>
        <script type="text/javascript" src="js/upload.js"></script>
        <script type="text/javascript">
            google.load('visualization', '1', {'packages': ['table', 'map', 'corechart']});
            google.setOnLoadCallback(function(){                
                $("#upload_form").validate({
                    submitHandler: function(form) {
                    	// Assess which values were entered
                    	if ( $('#lat').val() && $('#lng').val() ){
                            var latlng = true;
                    	}
                    	if ( $('#shp_file').val() ){
                    		var shpFile = true;
                    	}
                    	
                    	// Append error message according to values entered
                    	if (latlng && shpFile){
                    		$('#location').append('<label class="error">Please fill out coordinates OR upload shape file, not both.</label>');
                    	}
                    	else if (!latlng && !shpFile){
                    		$('#location').append('<label class="error">Please fill out coordinates OR upload shape file.</label>');
                    	}
                    	else{
                    	    form.submit();
                    	}
                    }
                });
            });
        </script>
        <style>
            #form_wrapper{
                margin: auto;
                width: 950px;
                padding: 15px;
                border-radius: 8px 8px 8px 8px;
            }
            label.error { 
                float: none;
                color: red;
                padding-left: .5em;
                vertical-align: top;
            }   
            input.submit{
                float: right;
            }
            .indent{
                margin-left: 25px;
            }
        </style>
    </head>
    <body>
        <div id="form_wrapper">
            <form id="upload_form" method="post" action="">
                <fieldset>
                    <legend>Please fill out and submit the following form to registar your data location[s]</legend>               
                    <h2>Source Information</h2>
                    <div class="indent">
                        <div>     
                            <label>Organization/Person responsible</label>
                            <input id="label" name="label" class="required" />
                        </div>
                        <div>
                            <label>Source URL</label>
                            <input id="source" name="source" class="required" />
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
                            <textarea class="required" class="required"></textarea>
                        </div>
                        <div>
                            <label>Keywords</label>
                            <textarea class="required" class="required"></textarea>
                        </div>
                    </div>
                    
                    <h2>Location</h2>
                    <div id="location" class="indent">
                        <div>                
                            <label>Latitude</label>
                            <input id="lat" name="lat" />
                        
                            <label>Longitude</label>
                            <input id="lng" name="lng" />
                        </div>
                        <h3>OR</h3>
                        <div>
                            <label>Shape file</label>
                            <input type="file" id="shp_file" name="shp_file" />
                        </div>
                    </div>
                    
                    <h2>Other</h2>
                    <div class="indent">
                        <label>Additional Information (optional)</label><br />
                        <textarea></textarea>
                    </div>
                    
                    <input class="submit" type="submit" value="Submit"/>
                </fieldset>
            </form>
        </div>
    </body>
</html>