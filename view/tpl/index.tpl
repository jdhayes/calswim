<!DOCTYPE html>
<html>
  <head>
    <title>EcoDataPortal</title>
    <meta charset="utf-8" />
    <style type="text/css" title="CalSWIMStyle">  
        @import "css/humanity/jquery-ui-1.8.22.custom.css";
    </style>
    <script type="text/javascript" src="js/jquery/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/jquery/jquery-ui-1.8.22.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function(){
        	$("#search_button").button({       
                icons: {
                    secondary: "ui-icon-search"
                }
            });
        });
    </script>    
  </head>
  <body>
    <button id="search_button" class="button">Find</button>       
  </body>
</html>