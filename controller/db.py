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
        # Just a few MySQL notes:
        #    Default MySQL operation executes an "OR" search among terms
        #    To make sure all terms are in a given result, "AND" search among terms, then just add prefix "+" before each term
        #    To exclude results with a given term, just add prefix "-" before the term
        keyword_query = "*, ".join(CalSwimView.keywords) +"*"        
        query_build.insert(1,"""                          
                                 WHERE
                                 MATCH (description)
                                 AGAINST ('%(KeywordQuery)s' IN BOOLEAN MODE)
                              """ % {"KeywordQuery":keyword_query})
    select_query = "\n".join(query_build)    
    print >> CalSwimView.errors, select_query

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
    rows = []
    locs = []
    table_data = []
    while(1):
        row=cursor.fetchone()
        if row == None:
            break
        rows.append( {"c":[{"v":row[0]}, {"v":row[1]}]} )
        locs.append( {"latitude":str(row[2]), "longitude":str(row[3])} )          
        
    # disconnect from server
    db.close()

    # Return search values as json    
    cols = [{"id":'source', "label":'Source', "type":'string'}, {id:'description', "label":'Description', "type":'string'}, {"id":'url', "label":'URL', "type":'string'}]    
    table_data["cols"] = cols
    table_data["rows"] = rows
    json_data["table_data"] = table_data
    json_data["locs"] = locs
    return json.dumps(json_data)
