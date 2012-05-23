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
from pesto.session import session_middleware
from pesto.session.memorysessionmanager import MemorySessionManager
base_dir = os.path.dirname(__file__)

def wsgi_app(environ, start_response):
    
    """
        ==========================================================        
        * Logic for determining web view content is located here *
        ==========================================================
    """
    
    # Retrieve GET variables and store them as a dictionary    
    form = cgi.FieldStorage(fp=environ['wsgi.input'], environ=environ)
       
    # Initialize web classes    
    CalSwimView = WebView(base_dir, environ['wsgi.errors'])    
    CalSwimDB = WebDB(base_dir, environ['wsgi.errors']);
    #print >> CalSwimView.errors, "Print Error Message In Apache Logs"
    
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
    elif 'import_data' in form:
        """
            Handle AJAX call for data import into DB
        """        
        CalSwimDB.import_data(form)
        CalSwimView.content = CalSwimDB.return_message
    elif 'get_data_details' in form:
        """
           Return AJAX call results for data details
        """
        dataID = form.getvalue('get_data_details')
        
        if 'format' in form:
            format = form.getvalue('format')
        else:
            format = 'json'        
        CalSwimView.content = CalSwimDB.get_data_details(dataID, format)
        
        if format != 'json':
            # Define headers and return content
            start_response('200 OK', [('content-type', 'application/CSV'),('Content-Disposition','attachment; filename=ecodata'+dataID+'.csv')])
            return CalSwimView.content
    elif 'login' in form:
        # Set user name in session to mark successful login
#        if 'username' in form:
#            passwd = form.getvalue('password')
#            if passwd=='EcoAdminPass2012':
#                session = environ['pesto.session']
#                session['user'] = 'admin'
#            else:
#                session['user'] = "guest"
#        
#        # Get user if it exists, and verify if it is admin
#        user = session.get('user')
#        if 'admin' == user:
#            # Get all records
#            items = CalSwimDB.get_items(session.session_id)
#            # Place all records in html frontend
#            CalSwimView.set_content('admin')
#            CalSwimView.content = CalSwimView.content % {'Items' : items}
#        else:            
#            CalSwimView.set_content('index')
#            CalSwimView.content = CalSwimView.content % {'uploadResult' : "Your user name or password was incorrect."}            
        CalSwimView.content = environ['pesto.session']
    else:        
        CalSwimView.set_content('index')
        CalSwimView.content = CalSwimView.content % {'uploadResult' : ""}
    
    # Define headers and return content
    start_response('200 OK', [('content-type', 'text/html')])
    return CalSwimView.content

manager = MemorySessionManager()
application = session_middleware(manager)(wsgi_app)
