/*****************************/
/* CalSWIM Upload Javascript */
/*****************************/

google.setOnLoadCallback(function(){                        
    /* Init message div */
    $("#upload_message").dialog({ autoOpen: false });
    
    /* Init upload form overlay */
	$("#upload").colorbox({inline:true,maxHeight:"100%"});
	
    // Init form button
    $(".submit").button();
    
    // Use jQuery Form Plugin
	// http://malsup.com/jquery/form/
	var options = {		
        iframe:		'true',
        dataType:	'json',
        success:	function(data, statusText, xhr, $form){
        	// Close colorbox after form submission
        	alert('Sucess');
        	$("#upload").colorbox.close();
    		
    		// DB response            		
    		$("#upload_message").html("<p>"+data.message+"</p>");
    		$("#upload_message").dialog('open')
        }  // post-submit callback

        // Other available options:
        //target:		'#output',   // target element(s) to be updated with server response
        //beforeSubmit:  showRequest,  // pre-submit callback
        //url:       url         // override for form's 'action' attribute
        //type:      type        // 'get' or 'post', override for form's 'method' attribute
        //dataType:  null        // 'xml', 'script', or 'json' (expected server response type)
        //clearForm: true        // clear all form fields after successful submit
        //resetForm: true        // reset the form after successful submit

        // $.ajax options can be used here too, for example:
        //timeout:   3000
    };
    // Bind form submission handler to form
    $('#upload_form').ajaxForm(options);
    
    $("#upload_form").validate({
    	rules: {
    		shp_file: {
    	        required: false,
    	        accept: "shp|txt"
    	    }
    	},
        submitHandler: function(form) {
        	// Assess which values were entered
        	if ( $('#lat').val() && $('#lng').val() ){
                var latlng = true;
        	}else{ var latlng = false; }
        	if ( $('#shp_file').val() ){
        		var shpFile = true;
        	}else{ var shpFile = false; }
        	
        	// Append error message according to values entered
        	if (latlng==true && shpFile==true){
        		$('#location').append('<label class="error">Please fill out coordinates OR upload shape file, not both.</label>');
        	}
        	else if (latlng==false && shpFile==false){
        		$('#location').append('<label class="error">Please fill out coordinates OR upload shape file.</label>');
        	}
        	else{
        		// Submit for via AJAX        		
        		$("#upload_form").ajaxSubmit(options);
        	}
        }
    });
});