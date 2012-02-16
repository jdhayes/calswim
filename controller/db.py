"""
    DB interface script powered by WSGI
"""
import cgi;
import urllib;
import MySQLdb;
import json

def GetMapLocs(CalSwimView):
    """
        This is a simple script to query the database.
        We need this so that ajax can pull data
    """    
    #select_query="SELECT City,State,Latitude,Longitude FROM calswim__cities"   
    select_query = "SELECT City,State,Latitude,Longitude, ( 3959 * acos( cos( radians("+ CalSwimView.lat +") ) * cos( radians( Latitude ) ) * cos( radians( Longitude ) - radians("+ CalSwimView.lng +") ) + sin( radians("+ CalSwimView.lat +") ) * sin( radians( Latitude ) ) ) ) AS distance FROM calswim__cities HAVING distance < "+ CalSwimView.radius

    # Connect to an existing database
    connParams = {}
    connParams["UID"] = "calswim"
    connParams["PWD"] = "calswim2012"
    connParams["HOST"] = "localhost"
    connParams["PORT"] = 3306
    connParams["DSN"] = "wikijoo"        

    # Open database connection
    db = MySQLdb.connect(connParams["HOST"],connParams["UID"],connParams["PWD"],connParams["DSN"],connParams["PORT"])        
    # prepare a cursor object using cursor() method
    cursor = db.cursor()        
    # execute SQL query using execute() method.
    cursor.execute(select_query)        
    # Fetch a single row using fetchone() method.
    markers = []
    while(1):
        row=cursor.fetchone()
        if row == None:
            break
        markers.append( {"title":row[0]+", "+row[1], "content":row[0]+", "+row[1], "latitude":str(row[2]), "longitude":str(row[3])} )                
        
    # disconnect from server
    db.close()

    # Return search values as json
    return json.dumps({"markers": markers})
