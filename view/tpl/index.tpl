<!DOCTYPE html>
<html>
  <head>
    <title>EcoDataPortal</title>
    <meta charset="utf-8" />
    <style type="text/css" title="CalSWIMStyle">  
        @import "css/index.css";
        @import "css/humanity/jquery-ui-1.8.22.custom.css";
        @import "css/jquery.colorbox.css";
    </style>
    <script type="text/javascript" src="http://www.google.com/jsapi"></script>    
    <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false"></script>   
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.22/jquery-ui.min.js"></script>       
    <script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.layout.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.colorbox.min.js"></script>    
    <script type="text/javascript" src="js/jquery/jquery.watermark.js"></script>
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
            <a id="about_link" class="tab" href="#about">About</a>
            <a id="tools_link" class="tab" href="#tools">Tools</a>            
            <a id="contact_link" class="tab" href="#contact">Contact</a>
            <a id="search_link" class="tab" href="#search">Search</a>
            <a id="login_link" class="tab" style="float:right;" href="#login">Login</a>
        </div>
    </div>
    
    <div id="content">                
        <div id="search" class="ui-widget ui-widget-content ui-corner-all ui-layout-north">            
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
            
            <button id="search_button" class="button">Find</button>            
        </div>
        
        <div id="map_canvas_wrapper" class="rounded ui-layout-center">
            <div id="map_canvas"></div>            
        </div>
        
        <div id="data_details_wrapper" class="ui-layout-west ui-widget ui-widget-content ui-corner-all">
            <a href="#" class="download_details">Save as CSV/Excel</a>                     
            <div id="data_details" class=""></div>                       
        </div>
        
        <div id="table_canvas" class="ui-layout-south ui-widget ui-widget-content ui-corner-all"></div>                
    </div>
    
    <!-- <div id="footer">                
        Center for Environmental Biology, School of Biological Science @ UCI | Mondego Group, Donald Bren School of Information and Computer Science @ UCI | Institute for Genomics and Bioinformatics @ UCI
    </div> -->
        
    <div id="form_hidden_wrapper">
        <div id="about"  class="colorbox_content">
            <h1>About</h1>
            <p>
                The Ecological Data Portal is a web portal that maps and links available
                information on ecological datasets collected in Orange County. It is being
                developed through collaborations between the following:
            </p>
            <ul id="logos">
                <li><a href="http://www.uciceb.com/" target="_blank"><img src="/images/ceb_logo.png" alt="Center for Environmental Biology" title="Center for Environmental Biology" /></a></li>
                <li class="list-spacing"><a href="http://mondego.ics.uci.edu/" target="_blank"><img src="/images/mg_logo.png" alt="Mondego Group" title="Mondego Group" /></a></li>
                <li><a href="http://www.igb.uci.edu/" target="_blank"><img src="/images/igb_logo.png" alt="Institute for Genomics and Bioinformatics" title="Institute for Genomics and Bioinformatics" /></a></li>
            </ul>
            <p>...and numerous other agencies and NGOs.</p>
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
            <p>
                <span class="subheader">Sarah Kimball</span><br/>
                Center for Environmental Biology<br/>
                3110 Biological Sciences III<br/>
                University of California, Irvine<br/>
                Irvine, CA 92697<br/>
                (949)824-7151<br/>
                <a href="mailto:skimball@uci.edu">skimball@uci.edu</a>
            </p>
            <p>
                <span class="subheader">Cristina Videira Lopes</span><br/>
                Associate Professor<br/>
                Department of Informatics<br/>
                Donald Bren School of Information and Computer Sciences<br/>
                University of California, Irvine<br/>
                Irvine, CA 92697<br/>
                (949)824-1525<br/>
                <a href="mailto:lopes@ics.uci.edu">lopes@ics.uci.edu</a> 
            </p>
        </div>                
        <div id="login" class="colorbox_content">
            <h2>Administrative Use Only</h2>
            <form id="login_form" method="post" action="?login=admin">
                <label>User Name</label><input name="username" type="text" /> <br />
                <label>Password</label><input name="password" type="password" /><br />
                <button id="login_button" name="login_button">Login</button>
            </form>
        </div>
    </div>       
  </body>
</html>