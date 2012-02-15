"""
    ========================================================
    * CalSWIM index (root controller) powered by WSGI *
    ========================================================
"""
import os;
import cgi;
import urllib;
from view import WebView;
from db import GetMapLocs;

def application(environ, start_response):
    """
        ==========================================================        
        * Logic for determining web view content is located here *
        ==========================================================
    """
    
    # Retrieve GET variables and store them as a dictionary
    form = cgi.FieldStorage(fp=environ['wsgi.input'], environ=environ)
       
    # Initialize web class    
    CalSwimView = WebView(os.path.dirname(__file__))
    # Set name for search node
    CalSwimView.set_search(form.getvalue('search'))
    
    """
        ================================================
        * Main switch to determine controller/template *
        ================================================
    """
    if 'get_map_locs' in form:
        """
            Return AJAX call results for Google Map Pins
        """        
        CalSwimView.content = GetMapLocs()
    else:        
        CalSwimView.set_content('index')
        #CalSwimView.content = CalSwimView.content % {'results' : '','search' : ''}
    
    # Define headers and return content
    start_response('200 OK', [('content-type', 'text/html')])
    return CalSwimView.content
