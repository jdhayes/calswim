"""
    DB interface script powered by WSGI
"""
import cgi;
import urllib;
import MySQLdb;
import json;
import string;

def GetMapLocs(CalSwimView):
    """
        This is a simple script to query the database.
        We need this so that ajax can pull data
    """
    # Initialize query list
    query_build = []
    
    if (CalSwimView.lat and CalSwimView.lng):
        # Search query has a specified location
        query_build.append("""
                               SELECT description,urllink,latitude,longitude,( 3959 * acos( cos( radians(%(Latitude)s) ) * cos( radians( latitude ) ) * cos( radians( longitude ) - radians(%(Longitude)s) ) + sin( radians(%(Latitude)s) ) * sin( radians( latitude ) ) ) ) AS distance
                               FROM coordinate
                            """ % {"Latitude":CalSwimView.lat, "Longitude":CalSwimView.lng})
        query_build.append("HAVING distance < %(Radius)s" % {"Radius":CalSwimView.radius})
    else:
        # Search query does not have a specidied location
        query_build.append("""
                             SELECT description,urllink,latitude,longitude
                             FROM coordinate
                          """)
    # Search query has at least 1 keyword
    if len(CalSwimView.keywords) > 0:
        keyword_query = "+"+ "* +".join(CalSwimView.keywords) +"*"
        #select_query = "SELECT description,urllink,latitude,longitude, ( 3959 * acos( cos( radians("+ CalSwimView.lat +") ) * cos( radians( latitude ) ) * cos( radians( longitude ) - radians("+ CalSwimView.lng +") ) + sin( radians("+ CalSwimView.lat +") ) * sin( radians( latitude ) ) ) ) AS distance FROM coordinate HAVING distance < "+ CalSwimView.radius
        query_build.insert(1,"""                          
                                 WHERE
                                 MATCH (description)
                                 AGAINST ('%(KeywordQuery)s' IN BOOLEAN MODE)
                              """ % {"KeywordQuery":keyword_query})
        select_query = "\n".join(query_build)    
    print >> environ['wsgi.errors'], select_query

    # Connect to an existing database
    connParams = {}
    connParams["UID"] = "calswim"
    connParams["PWD"] = "calswim2012"
    connParams["HOST"] = "localhost"
    connParams["PORT"] = 3306
    connParams["DSN"] = "calswim"        

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
        markers.append( {"content":row[0]+"<br /><a target='_blank' href='"+row[1]+"'>Source</a>", "latitude":str(row[2]), "longitude":str(row[3])} )                
        
    # disconnect from server
    db.close()

    # Return search values as json
    return json.dumps({"markers": markers})
