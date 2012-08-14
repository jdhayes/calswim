<!DOCTYPE html>
<html>
<head>
    <title>EcoDataPortal: Admin Area</title>
    <meta charset="utf-8" />
    <script type="text/javascript" src="http://www.google.com/jsapi"></script>    
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.watermark.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.colorbox.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.form.js"></script>
    <script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js"></script>
    <script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.3/jquery.dataTables.min.js"></script> 
    <script type="text/javascript" src="js/upload.js"></script>
    <style type="text/css" title="CalSWIMStyle">          
        @import "css/index.css";
        @import "css/jquery.colorbox.css";
        @import "css/sunny/jquery-ui-1.8.19.custom.css";
        @import "http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.3/css/jquery.dataTables.css";        
        textarea{
            width: 100%%;
            height: 200px;
        }
        #logout {
            float: right;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function(){
        	// Initialize buttons
        	$(".button").button();
        	// Initialize table
        	$(".data_table").dataTable({
        		"bJQueryUI": true
        	});
        });
    </script>
</head>
<body>    
    <h1>Admin Area</h1>    
    <div id="content">        
        <div id="items">
            <form action='' method='post'><a id='upload' href='#form_wrapper'>Add</a> | <input type='submit' name='delete' value='Delete'/> <a id="logout" href="?login=false">Logout</a>
                <table class="data_table">
                    %(Items)s
                </table>
            </form>
        </div>
    </div>
    
    <div id="upload_message"></div>
    <div id="form_hidden_wrapper">
        <div id="form_wrapper" class="colorbox_content">
            <form id="upload_form" method="post" action="" enctype="multipart/form-data">              
                <h3>Please fill out and submit the following form to register your data location[s]</h3>                
                <h2>Source Information</h2>
                <div class="indent ui-widget ui-widget-content ui-corner-all">
                    <div class="input_wrapper"> 
                        <label><span class="red">*</span> Organization Name</label>
                        <input id="organization" name="organization" class="required full" />                        
                    </div>                    
                    <div class="input_wrapper">     
                        <label><span class="red">*</span> Contact Name</label>
                        <input id="contact" name="contact" class="required full" />
                    </div>
                    <div class="input_wrapper"> 
                        <label><span class="red">*</span> Contact Email</label>
                        <input id="email" name="email" class="required email full" />
                    </div>
                    <div class="input_wrapper"> 
                        <label>Contact Phone</label>
                        <input id="phone" name="phone" class="digits full" />
                    </div>
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Data Link</label> <span>(local <input id="data_check" name="data_check" type="checkbox" /> )</span>
                        <input id="source" name="source" class="required url full" />
                        <input id="data_file" name="data_file" type="file" class="full"/>
                    </div>
                </div>
                
                <h2>Project Information</h2>
                <div class="indent ui-widget ui-widget-content ui-corner-all">
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Project name</label>
                        <textarea id="label" name="label" class="required full"></textarea>
                    </div>
                    <div class="input_wrapper">
                        <label>Short Project name (optional)</label>
                        <textarea id="shortLabel" name="labelShort" class="full"></textarea>
                    </div>            
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Project description</label>
                        <textarea id="description" name="description" class="required full"></textarea>
                    </div>
                    <div class="input_wrapper">
                        <label>Project timeline</label>
                        <div>
                            <label><span class="red">*</span> Start:</label><input id="timelineStart" name="timelineStart" class="required half" />
                            <br />
                            <label>Finish:</label><input id="timelineFinish" name="timelineFinish" class="half" />
                        </div>
                    </div>
                    <div class="input_wrapper">
                        <label>Project funder</label>
                        <textarea id="funder" name="funder" class="full"></textarea>
                    </div>
                </div>
                
                <h2>Meta Data</h2>
                <div class="indent ui-widget ui-widget-content ui-corner-all">
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Habitat or target species</label>
                        <textarea id="target" name="target" class="required full"></textarea>
                    </div>                    
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Site location description</label>
                        <textarea id="locdescription" name="locdescription" class="required full"></textarea>
                    </div>
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Number of Sites</label>
                        <input id="numsites" name="numsites" class="required digits full" />
                    </div>
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Data collector</label>
                        <textarea id="collector" name="collector" class="required full"></textarea>
                    </div>                    
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Data type</label>
                        <textarea id="datatype" name="datatype" class="required full"></textarea>
                    </div>
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Data format</label>
                        <textarea id="dataformat" name="dataformat" class="required full"></textarea>
                    </div>
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Data sharing policies</label>
                        <textarea id="policies" name="policies" class="required full"></textarea>
                    </div>                    
                </div>
                
                <h2>Location</h2>
                <div id="location" class="indent ui-widget ui-widget-content ui-corner-all">                    
                    <div class="input_wrapper">                
                        <label>Latitude</label>
                        <input id="lat" name="lat" class="number" />
                        <br />
                        <label>Longitude</label>
                        <input id="lng" name="lng" class="number" />
                    </div>
                    <h3>OR</h3>
                    <div class="input_wrapper">
                        <label for="shp_file">Shape file</label>
                        <input type="file" id="shp_file" name="shp_file" />
                    </div>
                </div>
                
                <h2>Other</h2>
                <div class="indent ui-widget ui-widget-content ui-corner-all">
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Searchable keywords</label>
                        <textarea id="keyword" name="keyword" class="required full"></textarea>
                    </div>
                    <div class="input_wrapper">
                        <label>Additional Information (optional)</label><br />
                        <textarea id="other" name="other" class="full"></textarea>
                    </div>
                </div>
                
                <input type="hidden" name="import_data" id="import_data" value="import_data"/>
                <button type="submit" id="upload_button" class="button">Submit</button>                
            </form>
        </div>
    </div>
</body>
</html>