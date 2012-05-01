<!DOCTYPE html>
<html>
  <head>
    <style type="text/css" title="CalSWIMStyle">  
        @import "css/index.css";
        @import "css/jquery.colorbox.css";
        @import "css/sunny/jquery-ui-1.8.19.custom.css";
    </style>   
    <script type="text/javascript" src="http://www.google.com/jsapi"></script>    
    <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false"></script>
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
    <div id="header">
        <div id="header_image_wrapper"></div>
        <div id="title">
            <h1>ECOL<span style="color:#FF4500">O</span>GI<span style="color:#FF4500">C</span>AL DATA PORTAL</h1>
        </div>
        <div id="menu">
            <a id="home" class="tab" href="#home">Home</a>
            <a id="about_link" class="tab" href="#about">About The Data Portal</a>
            <a id="tools_link" class="tab" href="#tools">Educational Tools</a>
            <a id="upload" class="tab" href="#form_wrapper">Upload Your Data</a>
            <a id="contact_link" class="tab" href="#contact">Contact Us</a>
            <a id="search_link" class="tab" href="#search">Search</a>
        </div>
    </div>
    
    <div id="content">                
        <div id="search" class="rounded ui-layout-north ui-widget ui-widget-content ui-corner-all">            
            <label>Location</label>
            <input id="address"/>
            
            <div style="display: inline; padding:0px 50px 0px 50px">
                <label>Radius (Miles)</label>
                <select id="radius">
                    <option value="5">5</option>
                    <option value="10">10</option>
                    <option value="25">25</option>
                    <option value="50">50</option>
                    <option value="100">100</option>
                </select>
            </div>
            
            <label>Keywords</label>
            <input id="keywords" />
            
            <span id="search_button" class="button">Show</span>            
        </div>
        
        <div id="map_canvas_wrapper" class="rounded ui-layout-center">
            <div id="map_canvas"></div>            
            <div id="table_canvas"></div>            
        </div>
        
        <div id="data_details_wrapper" class="rounded ui-layout-west ui-widget ui-widget-content ui-corner-all">
            <h2>Data Details</h2>                     
            <div id="data_details" class=""></div>
            
            <div id="footer">
                <p>
                    Center for Environmental Biology<br />
                    School of Biological Science<br />
                    University of California, Irvine
                </p>        
            </div>
        </div>
    </div>
    
    <div id="upload_message"></div>
    <div id="form_hidden_wrapper">
        <div id="about"  class="colorbox_content">
            <h1>About</h1>
            <p>
                The Ecological Data Portal is a web portal that maps and links available
                information on ecological datasets collected in Orange County. It is being
                developed through collaborations between the following:
            </p>
            <ul id="logos">
                <li><img src="/images/ceb_logo.png" alt="Center for Environmental Biology" title="Center for Environmental Biology" /></li>
                <li class="list-spacing"><img src="/images/mg_logo.png" alt="Mondego Group" title="Mondego Group" /></li>
                <li><img src="/images/igb_logo.png" alt="Institute for Genomics and Bioinformatics" title="Institute for Genomics and Bioinformatics" /></li>
            </ul>
            <p> and numerous other agencies and NGOs.</p>
            <p>
                Over time, many agencies, consulting firms, and academic researchers have
                conducted ecological monitoring projects and experiments throughout Orange
                County.  There is currently a large volume of data held by different
                agencies on a variety of parameters, held in different forms without
                common metadata.  The data portal provides knowledge of these datasets,
                useful for improving the potential for future collaborations, addressing
                basic questions in local ecology, and for developing a baseline for future
                monitoring.
            </p>
        </div>
        <div id="tools"  class="colorbox_content">
            In the future, we hope to provide specific ecological data sets and lesson plans for instructional purposes.            
        </div>
        <div id="contact"  class="colorbox_content">
            <pre>
                Sarah Kimball
                Center for Environmental Biology
                3110 Biological Sciences III
                University of California, Irvine
                Irvine, CA 92697
                (949)824-7151
                <a href="mailto:skimball@uci.edu">skimball@uci.edu</a>
            </pre>
        </div>
        <div id="form_wrapper" class="colorbox_content">
            <form id="upload_form" method="post" action="" enctype="multipart/form-data">              
                <h3>Please fill out and submit the following form to register your data location[s]</h3>                
                <h2>Source Information</h2>
                <div class="indent ui-widget ui-widget-content ui-corner-all">
                    <div class="input_wrapper"> 
                        <label>Organization Name</label>
                        <input id="organization" name="organization" class="required full" />
                    </div>
                    <div class="input_wrapper">     
                        <label>Contact Name</label>
                        <input id="contact" name="contact" class="required full" />
                    </div>
                    <div class="input_wrapper"> 
                        <label>Contact Email</label>
                        <input id="email" name="email" class="required email full" />
                    </div>
                    <div class="input_wrapper"> 
                        <label>Contact Phone</label>
                        <input id="phone" name="phone" class="required digits full" />
                    </div>
                    <div class="input_wrapper">
                        <label>Data Link</label>
                        <input id="source" name="source" class="required url full" />
                    </div>
                </div>
                
                <h2>Project Information</h2>
                <div class="indent ui-widget ui-widget-content ui-corner-all">
                    <div class="input_wrapper">
                        <label>Project name</label>
                        <textarea id="label" name="label" class="required full"></textarea>
                    </div>            
                    <div class="input_wrapper">
                        <label>Project description</label>
                        <textarea id="description" name="description" class="required full"></textarea>
                    </div>
                    <div class="input_wrapper">
                        <label>Project timeline</label>
                        <div>
                            <label>Start:</label><input id="timelineStart" name="timelineStart" class="required half" />
                            <label>Finish:</label><input id="timelineFinish" name="timelineFinish" class="required half" />
                        </div>
                    </div>
                    <div class="input_wrapper">
                        <label>Project funder</label>
                        <textarea id="funder" name="funder" class="required full"></textarea>
                    </div>
                </div>
                
                <h2>Meta Data</h2>
                <div class="indent ui-widget ui-widget-content ui-corner-all">
                    <div class="input_wrapper">
                        <label>Habitat or target species</label>
                        <textarea id="target" name="target" class="required full"></textarea>
                    </div>                    
                    <div class="input_wrapper">
                        <label>Site location description</label>
                        <textarea id="location" name="location" class="required full"></textarea>
                    </div>
                    <div class="input_wrapper">
                        <label>Number of Sites</label>
                        <input id="numsites" name="numsites" class="required digits full" />
                    </div>
                    <div class="input_wrapper">
                        <label>Data collector</label>
                        <textarea id="collector" name="collector" class="required full"></textarea>
                    </div>                    
                    <div class="input_wrapper">
                        <label>Data type</label>
                        <textarea id="datatype" name="datatype" class="required full"></textarea>
                    </div>
                    <div class="input_wrapper">
                        <label>Data format</label>
                        <textarea id="dataformat" name="dataformat" class="required full"></textarea>
                    </div>
                    <div class="input_wrapper">
                        <label>Data sharing policies</label>
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
                        <label>Searchable keywords</label>
                        <textarea id="keyword" name="keyword" class="required full"></textarea>
                    </div>
                    <div class="input_wrapper">
                        <label>Additional Information (optional)</label><br />
                        <textarea id="other" name="other" class="full"></textarea>
                    </div>
                </div>
                
                <input type="hidden" name="import_data" id="import_data" value="import_data"/>
                <button id="upload_button" class="button">Submit</button>                
            </form>
        </div>
    </div>       
  </body>
</html>