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
from hashlib import md5
base_dir = os.path.dirname(__file__)

def wsgi_app(environ, start_response):    
    """
        ==========================================================        
        * Logic for determining web view content is located here *
        ==========================================================
    """
    # Activate session storage
    session = environ['pesto.session']  
    # Retrieve GET variables and store them as a dictionary
    form = cgi.FieldStorage(fp=environ['wsgi.input'], environ=environ)

    # Initialize web classes    
    CalSwimView = WebView(base_dir, environ['wsgi.errors'])    
    CalSwimDB = WebDB(base_dir, environ['wsgi.errors'], environ.get('HTTP_HOST'));
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
        
        if format == 'csv':
            # Return CVS content
            start_response('200 OK', [('content-type', 'application/CSV'),('Content-Disposition','attachment; filename=ecodata'+dataID+'.csv')])
            return CalSwimView.content
        if format == 'json':
            start_response('200 OK', [('content-type', 'application/json')])
            return CalSwimView.content
    elif 'login' in form:
        # Logout from admin area
        if 'false' == form.getvalue('login'):
            session['user'] = ""
            session['g_id'] = ""
            session['u_id'] = ""
              
        # Set user name in session to mark successful login
        if 'username' in form:
            username = form.getvalue('username')
            passwd = md5(form.getvalue('password')).hexdigest()
            valid_user = CalSwimDB.validate_user(username,passwd)
            
            if valid_user:
                session['user'] = username
                session['u_id'] = CalSwimDB.user['u_id']
                session['g_id'] = ', '.join(map(str, CalSwimDB.user['g_id']))
            else:
                session['user'] = ""
        
        user = session.get('user')
        u_id = session.get('u_id')
        g_id = session.get('g_id')
        
        # If user has account allow access to upload area
        if user and u_id:
            if 'get_items' in form:
                # Get all records and return json list
                #items = CalSwimDB.get_items()
                CalSwimView.content = CalSwimDB.get_items('json',g_id)
            elif form.getvalue('import_data') == "update_data":
                """
                    Handler for a single item edit
                """
                gd_id = form.getvalue('edit')                
                CalSwimView.content = CalSwimDB.set_data_details(gd_id, form, g_id)
            elif form.getvalue('import_data') == "import_data":
                """
                    Handle AJAX call for data import into DB
                """        
                CalSwimDB.import_data(form,g_id)
                CalSwimView.content = CalSwimDB.return_message
            elif 'delete' in form:
                """
                    Handler for deleting items
                """                
                # Delete items from a list of ids
                CalSwimDB.delete_items(form.getlist('deletes'),g_id)
                # Set template type
                CalSwimView.set_content('admin')
                # Set content
                CalSwimView.content = CalSwimView.content
            else:
                # Set template type
                CalSwimView.set_content('admin')
                # Set content
                CalSwimView.content = CalSwimView.content
        else:            
            CalSwimView.set_content('index')
            CalSwimView.content = CalSwimView.content % {'uploadResult' : "Incorrect name or password."}            
    else:        
        CalSwimView.set_content('index')
        CalSwimView.content = CalSwimView.content % {'uploadResult' : ""}
    
    # Return finalized content
    start_response('200 OK', [('content-type', 'text/html')]) 
    return CalSwimView.content

# Pass wsgi app to session handler
application = session_middleware(
    FileSessionManager(base_dir+"/tmp"),
    cookie_path='/'    
)(wsgi_app)
