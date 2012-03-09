"""
    ========================================================
    * CalSWIM index (root controller) powered by WSGI *
    ========================================================
"""
import os;
import cgi;
import urllib;
from view import WebView;
from db import WebDB;

def application(environ, start_response):
    """
        ==========================================================        
        * Logic for determining web view content is located here *
        ==========================================================
    """
    
    # Retrieve GET variables and store them as a dictionary
    form = cgi.FieldStorage(fp=environ['wsgi.input'], environ=environ)
       
    # Initialize web classes
    CalSwimView = WebView(os.path.dirname(__file__), environ['wsgi.errors'])        
    CalSwimDB = WebDB();
    
    """
        ================================================
        * Main switch to determine controller/template *
        ================================================
    """
    if 'get_map_locs' in form:
        """
            Return AJAX call results for Google Map Pins
        """
        CalSwimView.set_search(form.getvalue('get_map_locs'),form.getvalue('radius'),form.getvalue('keywords'))
        CalSwimView.content = CalSwimDB.get_map_locs(CalSwimView)
    elif 'upload' in form:            
        CalSwimView.set_content('upload')
        CalSwimView.content = CalSwimView.content % {'uploadResult' : ""}
    elif 'submit' in form:
        CalSwimDB.import_data(form)
        CalSwimView.set_content('upload')
        CalSwimView.content = CalSwimView.content % {'uploadResult' : CalSwimDB.success}
    else:        
        CalSwimView.set_content('index')
        #CalSwimView.content = CalSwimView.content % {'results' : '','search' : ''}
    
    # Define headers and return content
    start_response('200 OK', [('content-type', 'text/html')])
    return CalSwimView.content
