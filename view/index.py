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
from pesto.session.filesessionmanager import FileSessionManager
from pesto.response import Response
base_dir = os.path.dirname(__file__)

def wsgi_app(environ, start_response):
    
    """
        ==========================================================        
        * Logic for determining web view content is located here *
        ==========================================================
    """
    
    # Retrieve GET variables and store them as a dictionary
    session = environ['pesto.session']  
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
        
        if format == 'cvs':
            # Define headers and return content
            return Response(
                status = '200 OK',
                content_type = 'application/CSV',
                content_disposition = 'attachment; filename=ecodata'+dataID+'.csv',
                content = CalSwimView.content
            )
    elif 'login' in form:
        
        # Set user name in session to mark successful login
        if 'username' in form:
            passwd = form.getvalue('password')
            if passwd=='EcoAdminPass2012':                
                session['user'] = 'admin'
            else:
                session['user'] = "guest"
        
        user = session.get('user')
        # Get user if it exists, and verify if it is admin        
        if 'admin' == user:
            if 'edit' in form:
                """
                    Handler for a single item edit
                """
                gd_id = form.getvalue('edit')                
                if 'organization' in form:                    
                    CalSwimView.content = CalSwimDB.set_data_details(gd_id, form)
                else:
                    CalSwimView.set_content('admin')
                    items = CalSwimDB.get_data_details(gd_id, 'html')
                    CalSwimView.content = CalSwimView.content % {'Items' : items}
            elif 'import_data' in form:
                """
                    Handle AJAX call for data import into DB
                """        
                CalSwimDB.import_data(form)
                CalSwimView.content = CalSwimDB.return_message
            elif 'delete' in form:
                """
                    Handler for deleting items
                """                
                # Delete items from a list of ids
                CalSwimDB.delete_items(form.getlist('deletes'))                
                # Get all records
                items = CalSwimDB.get_items()
                # Place all records in html frontend
                CalSwimView.set_content('admin')
                CalSwimView.content = CalSwimView.content % {'Items' : items}
#                CalSwimView.content = str(form.getlist('deletes'))
            else:
                # Get all records
                items = CalSwimDB.get_items()
                # Place all records in html frontend
                CalSwimView.set_content('admin')
                CalSwimView.content = CalSwimView.content % {'Items' : items}
        else:            
            CalSwimView.set_content('index')
            CalSwimView.content = CalSwimView.content % {'uploadResult' : "Incorrect name or password."}            
    else:        
        CalSwimView.set_content('index')
        CalSwimView.content = CalSwimView.content % {'uploadResult' : ""}
        
    return CalSwimView.content

application = session_middleware(
    FileSessionManager(base_dir+"/tmp"),
    cookie_path='/',
    cookie_domain='ecodataportal.ics.uci.edu',
)(wsgi_app)
