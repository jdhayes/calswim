"""
    DB interface script powered by WSGI
"""
# Script level 
import os
import sys
import getopt
import csv
# Web level
import cgi;
import urllib;
import MySQLdb;
import json;
import string;

class WebDB:
    def __init__(self):
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
        self.cursor = db.cursor()                
        
    def import_data(self, form):
        """
            Simple function to inhale form data and insert it into the Database
        """
        try:
            #columns = "contact, source, label, description, keyword, shp_file, other, latitude, longitude"
            columns = " urllink, source_name, description, site_name, latitude, longitude"
            
            # Gather submitted for values
            values = []
            #values.push( form.getvalue('contact') )
            #values.push( form.getvalue('email') )
            values.push( form.getvalue('source') )
            values.push( form.getvalue('label') )
            values.push( form.getvalue('description') )
            #values.push( form.getvalue('keyword') )
            #values.push( form.getvalue('shp_file') )
            values.push( form.getvalue('other') )
            values = "'"+ "','".join(values)  +"',"+ form.getvalue('lat') +","+ form.getvalue('lng')
            
            # Build query
            insert_query = "INSERT INTO calswim.coordinate (%(columns)s) VALUES(%(values)s);"
            insert_query = insert_query % {"columns":columns, "values":values}
            self.cursor.execute(insert_query)
            
            # Return JavaScript boolean to view 
            self.success = 'true';
        except:
            e = sys.exc_info()[1]
            self.success = e;
    
    def process(self, file_name):
        csv_reader = csv.reader(open(file_name, 'rb'), delimiter=' ', quotechar='|')
        for row in csv_reader:
            columns = "source_name,site_name,description,urllink,latitude,longitude"
            lat = convert_coordinates(row.pop(2))
            lng = convert_coordinates(row.pop(2))
    
            values = "'"+ "','".join(row) +"',"+ lat +","+ lng
            insert_query = "INSERT INTO calswim.coordinate (%(columns)s) VALUES(%(values)s);"
            insert_query = insert_query % {"columns":columns, "values":values}
            self.cursor.execute(insert_query)
            #print mysql_insert_row
    
    def convert_coordinates(self, deg_min_sec):
        deg, min, sec  = deg_min_sec.split()
        return str(float(deg) + (float(min)/60) + (float(sec)/3600));            
    
    def get_map_locs(self, CalSwimView):
        """
            This is a simple script to query the database.
            We need this so that ajax can pull data
        """
        # Initialize query list
        query_build = []
        
        if (CalSwimView.lat and CalSwimView.lng):
            # Search query has a specified location
            query_build.append("""
                                   SELECT source_name,description,urllink,latitude,longitude,( 3959 * acos( cos( radians(%(Latitude)s) ) * cos( radians( latitude ) ) * cos( radians( longitude ) - radians(%(Longitude)s) ) + sin( radians(%(Latitude)s) ) * sin( radians( latitude ) ) ) ) AS distance
                                   FROM coordinate
                                """ % {"Latitude":CalSwimView.lat, "Longitude":CalSwimView.lng})
            query_build.append("HAVING distance < %(Radius)s" % {"Radius":CalSwimView.radius})
        else:
            # Search query does not have a specidied location
            query_build.append("""
                                 SELECT source_name,description,urllink,latitude,longitude
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
        
        # execute SQL query using execute() method.
        self.cursor.execute(select_query)        
        # Fetch a single row using fetchone() method.
        rows = []    
        table_data = {}    
        while(1):
            row=self.cursor.fetchone()
            if row == None:
                break
            rows.append( {"c":[{"v":str(row[3])+","+str(row[4])}, {"v":row[0]}, {"v":row[1]}, {"v":row[2]}]} )          
            
        # disconnect from server
        db.close()
    
        # Return search values as json    
        cols = [{"id":'latlng', "label":'Coordinates', "type":'string'},{"id":'source', "label":'Source', "type":'string'}, {"id":'description', "label":'Description', "type":'string'}, {"id":'url', "label":'URL', "type":'string'}]    
        table_data["cols"] = cols
        table_data["rows"] = rows
        # Assign table data to json table data container
        json_data = {}
        json_data["table_data"] = table_data
        return json.dumps(json_data)

if __name__ == "__main__":
    # parse command line options
    try:
        opts, args = getopt.getopt(sys.argv[1:], "h", ["help"])
    except getopt.error, msg:
        print msg
        print "for help use --help"
        sys.exit(2)
    # process options
    for o, a in opts:
        if o in ("-h", "--help"):
            #print __doc__
            print "Usage::\n\tpython db.py csv_file.csv"
            sys.exit(0)
    # process arguments
    CalSwimDB = WebDB()
    for arg in args:
        CalSwimDB.process(arg)      
