"""
    DB interface script powered by WSGI
"""
import cgi;
import urllib;
import MySQLdb;
import json

def GetMapLocs():
    """
        This is a simple script to query the database.
        We need this so that ajax can pull data
    """    
#    select_query="SELECT KEGG,BIOCHEMICAL,HMDB_ID FROM LiverMetabolites;"      
#
#    # Connect to an existing database
#    connParams = {}
#    connParams["UID"] = "genomics"
#    connParams["PWD"] = "genomics"
#    connParams["HOST"] = "db-igb.ics.uci.edu"
#    connParams["PORT"] = 5000
#    connParams["DSN"] = "SassoneData"        
#
#    # Open database connection
#    db = MySQLdb.connect(connParams["HOST"],connParams["UID"],connParams["PWD"],connParams["DSN"],connParams["PORT"])        
#    # prepare a cursor object using cursor() method
#    cursor = db.cursor()        
#    # execute SQL query using execute() method.
#    cursor.execute(select_query)        
#    # Fetch a single row using fetchone() method.
#    data = set()
#    while(1):
#        row=cursor.fetchone()
#        if row == None:
#            break
#        for i in range(len(row)):
#            data.add(str(row[i]))                
#        
#    # disconnect from server
#    db.close()
#
#    # Return search values    
#    data = list(data)
#    data.sort()
#    return json.dumps(data)
    return """
        {"markers":[ 
            { "latitude":57.7973333, "longitude":12.0502107, "title":"Angered", "content":"Representing :)" },
            { "latitude":57.6969943, "longitude":11.9865, "title":"Gothenburg", "content":"Swedens second largest city" },
            
            { "latitude":33.901303, "longitude":-117.520888, "title":"Rock Vista Park", "content":"2401 Moonridge Cir"},
            { "latitude":33.90141, "longitude":-117.531102, "title":"Parkview Park", "content":"1995 Las Colinas Cir"},
                        
            { "latitude":33.64568, "longitude":-117.842533, "title":"Aldrich Park", "content":"University of California, Irvine, CA 92879"},
            { "latitude":33.644371, "longitude":-117.841861, "title":"Information Computer Science Building", "content":"University of California, Irvine, CA 92879"}            
        ]}"""
