/*****************************/
/* CalSWIM Upload Javascript */
/*****************************/

google.setOnLoadCallback(function(){                
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
        	    form.submit();
        	}
        }
    });
    
    // Init form button
    $(".submit").button();
});