<!DOCTYPE html>
<html>
<head>
    <title>EcoDataPortal: Admin Area</title>
    <meta charset="utf-8" />
    <style type="text/css" title="CalSWIMStyle">          
        @import "css/index.css";
        @import "css/jquery.colorbox.css";
        @import "css/sunny/jquery-ui-1.8.22.custom.css";
        @import "css/jqueryui.dataTables.css";
        #logout {
            float: right;
        }
        #items {
            margin: 10px;
        }
        #topnav {
            margin-bottom: 10px;
        }
        textarea{
            width: 100%%;
            height: 100px;
        }
        .float-right{
            float: right;
        }
        .margin-bottom{
            margin-bottom: 10px;
        }
    </style>
    <script type="text/javascript" src="http://www.google.com/jsapi"></script>    
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.22/jquery-ui.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.watermark.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.colorbox.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery.form.js"></script>
    <script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js"></script>
    <script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.3/jquery.dataTables.min.js"></script> 
    <script type="text/javascript" src="js/upload.js"></script>
    <script type="text/javascript">
        $(document).ready(function(){
        // Initialize buttons
        $(".button").button();
        // Initialize table
        var all_data_table = $("#all_data_table").dataTable({
        "bJQueryUI": true,
        "sAjaxSource": "/?login=admin&get_items=all",
        "fnServerData": function ( sSource, aoData, fnCallback ) {
            /* Define JSON retrieval function and add extra data to table */
            $.ajax( {
            "dataType": 'json',
            "type": "GET",
            "url": sSource,
            "success": function(data){
                if(typeof data.aaData === 'object'){
                /* Pre Process data, we need to add a column for the details button */
                $.each(data.aaData, function(key, val) {
                    var gd_id = val[0];
                    var editButton = '<button class="edit" name="'+ gd_id +'">Edit</button>';
                    val.unshift(editButton);
                    var deleteBox = '<input type="checkbox" name="deletes" value="'+gd_id+'" />';
                    val.push(deleteBox);
                });
    
                /* Pass data back to table for display */
                fnCallback(data);
                // Initialize buttons
                $(".edit").button();
                // When edit button is clicked populate fields in edit form using json result of AJAX call
                $(".edit").click(function(){
                    var id = $(this).attr('name');
                    $.post("?format=plain_json&get_data_details="+id, function(json_data){
                    $.each(json_data, function(jindex, tuple){
                        index = tuple[0].toLowerCase().replace(/ /g,'_').replace(/-/g,'');
                        value = tuple[1];
                        if (index == "location"){
                        value = value.replace(/\)/g,'');
                        var val_parts = value.split("(");
                        if (val_parts[0] == "POINT"){
                            val_parts = val_parts[1].split(" ");
                            $("#lat").val(val_parts[0]);
                            $("#lng").val(val_parts[1]);
                        }else{ $("#location").hide(); }
                        }else{
                        $('#'+index).val(value);
                        }
                    });
                    $("#import_data").val("update_data");
                    $("#edit").val(id);
                    $.colorbox({inline:true,maxHeight:"100%%",width:"500px",href:"#form_wrapper"});
                    }, "json");
                    return false;
                });
                }else{
                alert("ERROR: Server response is invalid.");
                }
            }
            } );
        }
        });
        });
    </script>
</head>
<body>    
    <h1>Admin Area</h1>
    <div id="loading"></div>
    <div id="content">        
        <div id="items">
            <form action='' method='post'>
                <div id="topnav">
                    <button id='upload' class="button">Add</button> | <input class="button" type='submit' name='delete' value='Delete'/> <a class="button" id="logout" href="?login=false">Logout</a>
                </div>
                <div class="demo_jui">
                    <div role="grid" class="dataTables_wrapper" id="example_wrapper">
                        <table id="all_data_table" class="data_table display">
                            <thead>
                <tr>
                    <th></th> <th>ID</th> <th>Organization</th> <th>Project Name</th> <th>Short Project Name</th> <th>Project Description</th> <th>Data Type</th> <th>Data Target</th> <th>Delete</th>
                </tr>
                </thead>
                <tbody></tbody>
                        </table>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
    <div id="upload_message"></div>
    <div id="form_hidden_wrapper">
        <div id="form_wrapper" class="colorbox_content">
            <form id="upload_form" method="post" action="" enctype="multipart/form-data">              
                <h3>Please complete and save the following form</h3>
                <h2>Source Information</h2>
                <div class="indent ui-widget ui-widget-content ui-corner-all">
                    <div class="input_wrapper"> 
                        <label><span class="red">*</span> Organization name</label>
                        <input id="organization" name="organization" class="required full" type="text"/>                        
                    </div>                    
                    <div class="input_wrapper">     
                        <label><span class="red">*</span> Contact name</label>
                        <input id="contact" name="contact" class="required full" type="text"/>
                    </div>
                    <div class="input_wrapper"> 
                        <label><span class="red">*</span> Contact email</label>
                        <input id="email" name="email" class="required email full" type="text"/>
                    </div>
                    <div class="input_wrapper"> 
                        <label>Contact phone</label>
                        <input id="phone" name="phone" class="digits full" type="text"/>
                    </div>
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Data link</label> <span>(local <input id="data_check" name="data_check" type="checkbox" /> )</span>
                        <input id="data_url" name="data_url" class="required url full" type="text"/>
                        <input id="data_file" name="data_file" type="file" class="full"/>
                    </div>
                </div>
                
                <h2>Project Information</h2>
                <div class="indent ui-widget ui-widget-content ui-corner-all">
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Project name</label>
                        <textarea id="project_name" name="project_name" class="required full"></textarea>
                    </div>
                    <div class="input_wrapper">
                        <label>Short Project name (optional)</label>
                        <textarea id="project_name_short" name="project_name_short" class="full"></textarea>
                    </div>            
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Project description</label>
                        <textarea id="project_description" name="project_description" class="required full"></textarea>
                    </div>
                    <div class="input_wrapper">
                        <label>Project timeline</label>
                        <div>
                            <label><span class="red">*</span> Start:</label><input id="timeline_start" name="timeline_start" class="required half" type="text"/>
                            <br />
                            <label>Finish:</label><input id="timeline_finish" name="timeline_finish" class="half" type="text"/>
                        </div>
                    </div>
                    <div class="input_wrapper">
                        <label>Project funder</label>
                        <textarea id="project_funder" name="project_funder" class="full"></textarea>
                    </div>
            <div class="input_wrapper">
            <label>Project report/publication Link</label> <span>(local <input id="report_check" name="report_check" type="checkbox" /> )</span>
                        <input id="report_url" name="report_url" class="url full" type="text"/>
            <input id="report_file" name="report_file" type="file" class="full"/>
            </div>
                </div>
                
                <h2>Meta Data</h2>
                <div class="indent ui-widget ui-widget-content ui-corner-all">
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Habitat or target species</label>
                        <textarea id="data_target" name="data_target" class="required full"></textarea>
                    </div>                    
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Site location description</label>
                        <textarea id="location_description" name="location_description" class="required full"></textarea>
                    </div>
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Number of sites</label>
                        <input id="site_count" name="site_count" class="required digits full" type="text"/>
                    </div>
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Data collector</label>
                        <textarea id="data_collector" name="data_collector" class="required full"></textarea>
                    </div>                    
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Data type</label>
                        <textarea id="data_type" name="data_type" class="required full"></textarea>
                    </div>
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Data format</label>
                        <textarea id="data_format" name="data_format" class="required full"></textarea>
                    </div>
                    <div class="input_wrapper">
                        <label><span class="red">*</span> Data sharing policies</label>
                        <textarea id="data_policies" name="data_policies" class="required full"></textarea>
                    </div>                    
                </div>
                
                <h2>Location</h2>
                <div id="location" class="indent ui-widget ui-widget-content ui-corner-all">                    
                    <div class="input_wrapper">                
                        <label>Latitude</label>
                        <input id="lat" name="lat" class="number" type="text"/>
                        <br />
                        <label>Longitude</label>
                        <input id="lng" name="lng" class="number" type="text"/>
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
                        <label>Additional information (optional)</label><br />
                        <textarea id="other" name="other" class="full"></textarea>
                    </div>
                </div>
                
                <input type="hidden" name="import_data" id="import_data" value="import_data"/>
        <input type="hidden" name="edit" id="edit" value=""/>
                <button type="submit" id="upload_button" class="button">Save</button>                
            </form>
        </div>
    </div>
</body>
</html>