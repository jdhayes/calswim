"""
    DB interface script powered by WSGI
"""
# Script level 
import os, sys, getopt, csv, re, string, types, shutil;
pattern = re.compile('[\W_]+')
# Web level
import cgi, urllib, MySQLdb, json;
# ESRI Geographic data parser 
import shapefile
# File handling
import fnmatch
from StringIO import StringIO
from tempfile import mkdtemp, mkstemp
from zipfile import ZipFile

class WebDB:
    def __init__(self, base_dir, errors, hostname):
        # Setup base dir for reference later
        self.base_dir = base_dir
        self.hostname = hostname
        self.user = {}
        
        # Connect to an existing database
        connParams = {}
        connParams["UID"] = "calswim"
        connParams["PWD"] = "calswim2012"
        connParams["HOST"] = "localhost"
        connParams["PORT"] = 3307
        connParams["DSN"] = "calswim"
        connParams["UNIX_SOCKET"] = '/tmp/mysql.sock'
    
        # Open database connection
        self.db = MySQLdb.connect(connParams["HOST"],connParams["UID"],connParams["PWD"],connParams["DSN"],connParams["PORT"],unix_socket=connParams["UNIX_SOCKET"])        
        # prepare a cursor object using cursor() method
        self.cursor = self.db.cursor()  
        # Set return message to blank
        self.return_message = ""
        # Initialize error var
        self.errors = errors
    
    def validate_user(self,username,password):
        select_query="SELECT u_id FROM `User` WHERE name='%(NAME)s' AND password='%(PASS)s' LIMIT 1" % {'NAME':username,'PASS':password}       
        self.cursor.execute(select_query)
        row = self.cursor.fetchone()
        if row != None and len(row) > 0:
            select_query="SELECT g_id FROM GroupMap WHERE u_id=%(UID)s" % {'UID':row[0]}
            self.cursor.execute(select_query)
            group_rows = self.cursor.fetchall()
            groups = []
            for group_row in group_rows:
                groups.append(group_row[0])
            self.user['g_id'] = groups
            self.user['u_id'] = row[0]
            return True
        else:
            return False
    
    def delete_items(self, delete_ids, g_id='0'):
        delete_query="DELETE FROM GeoData WHERE g_id IN (%s) AND gd_id IN (" % g_id
        for id in delete_ids:
            delete_query += id+","
        delete_query = delete_query.rstrip(',') + ")"
        self.cursor.execute(delete_query)
                
    def get_items(self, type="json",g_id='0'):
        # Get all records from DB
        select_query="SELECT gd_id, organization, project_name, project_name_short, project_description, data_type, data_target FROM GeoData WHERE g_id IN (%s) ORDER BY gd_id DESC" % g_id
        self.cursor.execute(select_query)
        
        if type=="html":
            # Compile all records into an HTML string        
            html_rows = "" 
            while(1):
                row=self.cursor.fetchone()
                if row == None:
                    break            
                html_row = '<td><button class="button edit" name="'+str(row[0])+'">Edit</button></td>'
                for html_item in row:
                    html_row += "<td>"+str(html_item)+"</td>"
                html_rows += "<tr>"+html_row+"<td><input type='checkbox' name='deletes' value='"+str(row[0])+"'/></td></tr>"
            columns = ["<th>ID", "Organization", "Project Name", "Short Name", "Project Description","Data Type","Data Target","Delete</th>"]
            return "<thead><tr><th></th>"+ "</th><th>".join(columns) +"</tr></thead><tbody>"+ html_rows +"</tbody>"
        if type=="json":
            rows=self.cursor.fetchall()
            #for label,value in enumerate(rows):
            #     data_details[label] = value
            json_data = {"aaData":rows}
            return json.dumps(json_data)
        else:
            return json.dumps({'message':'ERROR:: Incorrect format specified.'})
    
    def html_filter(self, string):
        """
            Just apply <a> tags to E-Mails and URLs
        """
        words = string.split()
        for word in words:
            if re.search('^http:\/\/.*$', word):
                word = '<a href="%(url)s">%(url)s</a>' % {'url':word}
            if re.search('^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$', word.upper()):
                word = '<a href="mailto:%(email)s">%(email)s</a>' % {'email':word}                    
        return ' '.join(words)
    
    def set_poly_geo(self,shp_file):        
        # Open shp_file with parser
        sf = shapefile.Reader(shp_file)
        # Get all shapes
        shapes = sf.shapes()
        # Iterate over shapes
        polygons=[]
        count = 0
        errors = []
        warnings = []
        for shape in shapes:
            count = count+1
            # Make sure the first and last set of coordinate are the same, closed polygon
            if shape.points[0] == shape.points[-1]:
                polygons.append(shape.points)
            else:
                warnings.append("WARNING:: Shape number %d is not an enclosed polygon. First and last coordinates should be the same. This was automatically corrected." % count)
                shape.points.append([shape.points[0][0],shape.points[0][1]])
                polygons.append(shape.points)
        
        if count == 0:
            errors.append("ERROR:: No valid shapes found.")
        
        count = 0;
        for poly in polygons:
            count = count+1
            if len(poly) < 1:
                errors.append("ERROR:: Shape number %d has no valid points." % count)
        return polygons,errors,warnings
     
    def find_shapefile(self, temp_dir):
        matches = []
        for root, dirnames, filenames in os.walk(temp_dir):
            for filename in fnmatch.filter(filenames, '*.shp'):
                matches.append(os.path.join(root, filename))
        return matches

    def import_data(self, form, g_id='0'):
        """
            Inhale and preprocess form data and insert it into the Database
        """
        error_msg = ""
        
        try:
            # Set insert order
            columns = "g_id, organization, contact, email, phone, data_url, \
            project_name_short, project_name, project_description, timeline_start, timeline_finish, project_funder, report_url,\
            data_target, location_description, site_count, data_collector, data_type, data_format, data_policies, \
            keyword, other, location, shp_file"
            
            # Gather submitted for values
            values = []
            # Set Group ID for entry, use only first id pulled from DB
            values.append( '%s' % g_id.split(',')[0] )
            # Source data
            values.append( '"%s"' % form.getvalue('organization') )
            values.append( '"%s"' % form.getvalue('contact') )
            values.append( '"%s"' % form.getvalue('email') )
            if form.getvalue('phone'):
                values.append( form.getvalue('phone') )
            else:
                values.append('NULL')
            values.append( '"%s"' % form.getvalue('data_url') )
            # Project data
            if len(form.getvalue('project_name_short')) > 0:
                values.append( '"%s"' % form.getvalue('project_name_short') )
            else:
                values.append( '"%s"' % form.getvalue('project_name') )
            values.append( '"%s"' % form.getvalue('project_name') )
            values.append( '"%s"' % form.getvalue('project_description') )        
            values.append( "STR_TO_DATE('"+ form.getvalue('timeline_start') +"', '%m/%d/%Y')" )
            values.append( "STR_TO_DATE('"+ form.getvalue('timeline_finish') +"', '%m/%d/%Y')" )
            values.append( '"%s"' % form.getvalue('project_funder') )
            values.append( '"%s"' % form.getvalue('report_url') )
            # Meta data
            values.append( '"%s"' % form.getvalue('data_target') )
            values.append( '"%s"' % form.getvalue('location_description') )
            values.append( form.getvalue('site_count') )
            values.append( '"%s"' % form.getvalue('data_collector') )
            values.append( '"%s"' % form.getvalue('data_type') )
            values.append( '"%s"' % form.getvalue('data_format') )
            values.append( '"%s"' % form.getvalue('data_policies') )
            # Other Data
            values.append( '"%s"' % " ".join(pattern.sub(' ', form.getvalue('keyword')).split()) )
            values.append( '"%s"' % form.getvalue('other') )
            # Shape file data            
            shp_file_handle = form['shp_file'].file
            shp_file_contents = form.getvalue('shp_file')
            shp_file_name = form['shp_file'].filename
            # Latitude/Longitude data
            lat = form.getvalue('lat')
            lng = form.getvalue('lng')
            
            # Build MySQL Geometry syntax
            locations = []
            json_data = ""
            temp_dir = mkdtemp(dir=self.base_dir+"/tmp/")
            if shp_file_name:
                if shp_file_name.split('.')[-1] == "zip":
                    # Extract all files from compressed shapefile
                    zip_sf = ZipFile(shp_file_handle, 'r')
                    zip_sf.extractall(path=temp_dir)
                    zip_sf.close()
                    # Pass only the first shp file found
                    path_to_shapefile = self.find_shapefile(temp_dir)[0]
                        
                    #json_data = {'message':'DEBUG::Temp Dir:'+temp_dir}
                    #self.return_message = json.dumps(json_data);
                    #return
                else:
                    path_to_shapefile = temp_dir+'/'+shp_file_name
                    temp_file = open( path_to_shapefile, 'wb')
                    temp_file.write(shp_file_contents)
                    temp_file.close()
                
                # Set POLYGON GEOMETRY from shp file
                polygons,errors,warnings = self.set_poly_geo(path_to_shapefile)                                    
                
                # Regardless of errors process polygons
                for polygon in polygons:
                    # Re-map polygon coordinates with spaces between lat and lng
                    for idx, val in enumerate(polygon):
                        # Reverse values so that latitude is first, then longitude
                        val.reverse()
                        polygon[idx] = " ".join( map( str, val) )
                    locations.append("GeomFromText('POLYGON((%s))')" % (",".join(polygon)))
                
                # Send errors, if any
                errors_warnings = errors + warnings
                html_errors = "<br>".join(errors_warnings)
                json_data = {'message':html_errors}
                self.return_message = json.dumps(json_data);
                
                # If there are errors, warnings are OK, then return without inserting
                if len(errors) > 0:                    
                    return
            elif lat and lng:
                # Set MySQL NULL value for shp contents
                shp_file_contents = "NULL"
                # Set POINT GEOMETRY from latitude and longitude
                locations.append("GeomFromText('POINT("+lat+" "+lng+")')")            
            else:
                json_data = {'message':'ERROR:: No Shape File nor Coordinates were found.'}
                self.return_message = json.dumps(json_data);
                return
            
            # For each location insert details into DB
            count = 0
            if len(locations) < 1:
                json_data = {'message':'ERROR:: Coordinates were not found.'}
                self.return_message = json.dumps(json_data);
                return
                        
            for location in locations:
                if not location:
                    json_data = {'message':'ERROR:: Empty location.'}                    
                    self.return_message = json.dumps(json_data);
                    return
            
                # Init reusable list to append location and shapefile
                locs_shps = []
                count = count+1
                
                # Build MySQL insert query
                locs_shps.append(location)
                locs_shps.append( '"%s"' % self.db.escape_string(shp_file_contents) )
                
                insert_query = "INSERT INTO calswim.GeoData ("+columns+") VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s);"
                insert_values = tuple(values+locs_shps)
                insert_query_with_values = insert_query % insert_values                
                self.cursor.execute(insert_query_with_values)
                if json_data == "":
                    json_data = {'message':'Data successfully saved'}                    
            
            # Commit queries
            self.db.commit()
            
            select_query = "SELECT LAST_INSERT_ID() as id"
            self.cursor.execute(select_query)
            row = self.cursor.fetchone()
            
            # Process uploaded files
            update_query = None
            data_url = self.import_file(form['data_file'],row[0])
            report_url = self.import_file(form['report_file'],row[0])
            if data_url and report_url:
                update_query = """UPDATE calswim.GeoData SET data_url="%(DATA_URL)s", report_url="%(REPORT_URL)s" WHERE gd_id=%(ID)s""" % {'DATA_URL': data_url, 'REPORT_URL':report_url, 'ID':row[0]}
            elif data_url and report_url==None:
                update_query = """UPDATE calswim.GeoData SET data_url="%(DATA_URL)s" WHERE gd_id=%(ID)s""" % {'DATA_URL': data_url, 'ID':row[0]}
            elif report_url and data_url==None:
                update_query = """UPDATE calswim.GeoData SET report_url="%(REPORT_URL)s" WHERE gd_id=%(ID)s""" % {'REPORT_URL':report_url, 'ID':row[0]}
            if update_query:
                self.cursor.execute(update_query)
            
            # Return JavaScript boolean to view         
            self.return_message = json.dumps(json_data)
        except:
            e = sys.exc_info()[1]
            #json_data = {'message': error_msg+" "+str(e)}
            json_data = {'message': "ERROR:: Please try again."} 
            self.return_message = json.dumps(json_data)
            print >> self.errors, "ERROR:: "+error_msg+" "+str(e)
        
        # Delete temp files
        try:
            if os.path.isdir(temp_dir):
                shutil.rmtree(temp_dir) # delete directory
        except:
            e = sys.exc_info()[1]
            print >> self.errors,"ERROR:: "+error_msg+" "+str(e)
        # Close DB connections        
        self.cursor.close()
    
    def import_file(self, filehandler, gd_id):
        if filehandler.filename:
            # Get filename
            data_file_name = os.path.basename(filehandler.filename)                
            # Build save path
            download_dir = self.base_dir +"/downloads/"+ str(gd_id) +"/"                
            # Make sure directory exists
            if not os.path.exists(download_dir):
                os.makedirs(download_dir)
            # Save contents to new file
            data_save_file = open(download_dir+data_file_name, "w")
            data_save_file.write(filehandler.file.read())
            data_save_file.close
            # Return local URL
            return "http://"+self.hostname+"/downloads/"+ str(gd_id) +"/"+data_file_name
        else:
            return None
    
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
    
    def set_data_details(self, gd_id, form, g_id='0'):        
        try:
            # Iterate over columns and create SQL query with form values
            update_query = "UPDATE GeoData SET "
            columns = ["organization","contact","email","phone","data_url","project_name_short","project_name","project_description","timeline_start","timeline_finish","project_funder","report_url","data_target","location_description","site_count","data_collector","data_type","data_format","data_policies","location","keyword","other"]
            for column in columns:
                if column == "location":
                    try:
                        lat_float = float(form.getvalue('lat'))
                        lng_float = float(form.getvalue('lng'))
                        latlng = "POINT("+ str(lat_float) +" "+ str(lng_float) +")"
                        update_query += column+"=GeomFromText('"+latlng+"'),"
                    except:
                        e = sys.exc_info()[1]
                        print >> self.errors, "ERROR:: "+ str(e)
                elif form.getvalue(column) == None or form.getvalue(column) == "":
                    update_query += column+"=NULL,"
                elif column == "phone" or column == "site_count":
                    update_query += column+"="+form.getvalue(column)+","
                elif column == "timeline_start" or column == "timeline_finish":
                    update_query += column+"=STR_TO_DATE('"+ form.getvalue(column) +"', '%m/%d/%Y'),"
                else:
                    update_query += column+'="'+form.getvalue(column)+'",'
            
            update_query = update_query.rstrip(',') + " WHERE gd_id="+gd_id+" AND g_id="+g_id.split(',')[0]
            self.cursor.execute(update_query)
            # Close DB connections        
            self.cursor.close()
            json_data = {'message':"Data successfully saved"}
            return_message = json.dumps(json_data);
            return return_message
        except:
            e = sys.exc_info()[1]
            print >> self.errors, "ERROR:: "+ str(e)
            return "ERROR::<br/>"+ str(e) +"<br/><br/>STATMENT::<br/>"+ update_query
        
    def get_data_details(self, gd_id, format='json'):
        # Select all details from table according to gd_id
        if format == "csv":
            # This is the CSV format, used for front end users to download details 
            select_query = """
            SELECT organization, contact,
            email,
            concat(left(phone,3),'-',mid(phone,4,3),'-',right(phone,4)) as phone, 
            data_url,        
            project_name, project_description,
            DATE_FORMAT( timeline_start, '%M %e, %Y') as timeline_start,
            DATE_FORMAT( timeline_finish, '%M %e, %Y') as timeline_finish,
            project_funder, report_url, data_target, location_description, site_count, data_collector,
            data_type, data_format, data_policies, keyword, other
            FROM GeoData WHERE gd_id=""" + gd_id
            # Create a list of column names                
            labels = ["Organization","Contact","E-Mail","Phone","Data URL","Project Name","Project Description","Start Date","Finish Date","Project Funder","Report URL","Data Target","Location Description","Site Count","Data Collector","Data Type","Data Format","Data Policies","Keywords","Other"]            
        elif format == "html":
            # This is the HTML format, used for editing details        
            select_query = """
            SELECT organization, contact,email,phone, data_url, project_name, project_name_short, project_description,
            timeline_start, timeline_finish, project_funder, report_url, data_target, location_description,
            site_count, data_collector, data_type, data_format, data_policies, AsText(location) as location, keyword, other
            FROM GeoData WHERE gd_id=""" + gd_id
            # Create a list of column names                
            labels = ["organization","contact","email","phone","data_url","project_name","project_name_short","project_description","timeline_start","timeline_finish","project_funder","report_url","data_target","location_description","site_count","data_collector","data_type","data_format","data_policies","location","keyword","other"]
        elif format == "plain_json":
            select_query = """
            SELECT organization, contact,
            email,phone,data_url,
            project_name, project_name_short, project_description,
            DATE_FORMAT( timeline_start, '%m/%d/%Y') as timeline_start,
            DATE_FORMAT( timeline_finish, '%m/%d/%Y') as timeline_finish,
            project_funder, report_url, data_target, location_description, site_count, data_collector,
            data_type, data_format, data_policies,
            AsText(location) as location,
            keyword, other
            FROM GeoData WHERE gd_id=""" + gd_id            
            # Create a list of column names
            labels = ["organization","contact","email","phone","data_url","project_name","project_name_short","project_description","timeline_start","timeline_finish","project_funder","report_url","data_target","location_description","site_count","data_collector","data_type","data_format","data_policies","location","keyword","other"]
        else:
            select_query = """
            SELECT organization, contact,
            concat('<a href="mailto:',email,'">',email,'</a>') as email,
            concat(left(phone,3),'-',mid(phone,4,3),'-',right(phone,4)) as phone, 
            concat('<a href="',data_url,'" target="_blank">',data_url,'</a>') as data_url,
            project_name, project_name_short, project_description,
            DATE_FORMAT( timeline_start, '%M %e, %Y') as timeline_start,
            DATE_FORMAT( timeline_finish, '%M %e, %Y') as timeline_finish,
            project_funder,
            concat('<a href="',report_url,'" target="_blank">',report_url,'</a>') as report_url,
            data_target, location_description, site_count, data_collector,
            data_type, data_format, data_policies, keyword, other
            FROM GeoData WHERE gd_id=""" + gd_id
            # Create a list of column names
            labels = ["Organization","Contact","E-Mail","Phone","Data URL","Project Name","Project Name Short","Project Description","Start Date","Finish Date","Project Funder", "Report URL", "Data Target","Location Description","Site Count","Data Collector","Data Type","Data Format","Data Policies","Keywords","Other"]
            
        self.cursor.execute(select_query)
        row = self.cursor.fetchone()            
        
        # Return results
        if format == 'csv':
            buffer = StringIO()
            csv_model = csv.writer(buffer)            
            csv_model.writerow(labels)
            csv_model.writerow(row)
            return buffer.getvalue()
        elif format == 'html':            
            html_row = ""
            for index, item in enumerate(row):
                if labels[index] == "project_name_short":
                    project_name_short = item
                if item:
                    html_item = str(item)                
                else:
                    html_item = ""
                html_row += "<tr><td class='label' width='150px'>"+(labels[index].capitalize()).replace("_"," ")+"</td><td><textarea name='"+labels[index]+"'>"+html_item+"</textarea></td></tr>"            
            return "<h2>("+gd_id+") "+project_name_short+"</h2><input class='button float-right margin-bottom' type='submit' name='submit' value='update'/><thead><tr><th>Label</th><th>Data</th></tr></thead><tbody>"+ html_row +"</tbody>"
        else:        
            html_row = []
            for item in row:
                if item == None:
                    item = ""
                if isinstance(item, str):
                    if format == "json":
                        html_row.append("<br />".join(item.split("\n")))
                    else:
                        html_row.append(item)
                else:
                    html_row.append(str(item))
                            
            data_details = dict()
            for index,label in enumerate(labels):
                 data_details[index] = (label,html_row[index])            
            # Return raw json
            return json.dumps(data_details, sort_keys=True)
    
    def get_map_locs(self, CalSwimView):
        """
            This is a simple script to query the database.
            We need this so that ajax can pull data
        """
        # Initialize query list
        query_build = []
        
        if (CalSwimView.lat and CalSwimView.lng):            
            # Search query has a specified location thus check against intersection of points and polygons in database
            self.cursor.execute("SET @center = GeomFromText('POINT(%s %s)');",(float(CalSwimView.lat), float(CalSwimView.lng)))
            self.cursor.execute("SET @radius = %s;",(CalSwimView.radius))
            self.cursor.execute("""
                                   SET @bbox = CONCAT('POLYGON((',
                                       X(@center) - @radius, ' ', Y(@center) - @radius, ',',
                                       X(@center) + @radius, ' ', Y(@center) - @radius, ',',
                                       X(@center) + @radius, ' ', Y(@center) + @radius, ',',
                                       X(@center) - @radius, ' ', Y(@center) + @radius, ',',
                                       X(@center) - @radius, ' ', Y(@center) - @radius, '))'
                                   );
                               """)
            query_build.append("""
                                  SELECT gd_id, organization, project_name_short, project_name, project_description, data_type, data_target, AsText(location)
                                  FROM GeoData
                                  WHERE Intersects( location, GeomFromText(@bbox) )
                                  AND
                                      CASE geometrytype(location)
                                          WHEN 'POINT' THEN
                                              SQRT(POW( ABS( X(location) - X(@center)), 2) + POW( ABS(Y(location) - Y(@center)), 2 )) < @radius
                                          ELSE
                                              TRUE
                                      END
                               """)
            # Search query has at least 1 keyword
            if len(CalSwimView.keywords) > 0:
                # Just a few MySQL notes:
                #    Default MySQL operation executes an "OR" search among terms
                #    To make sure all terms are in a given result, "AND" search among terms, then just add prefix "+" before each term
                #    To exclude results with a given term, just add prefix "-" before the term
                keyword_query = "*, ".join(CalSwimView.keywords) +"*"        
                query_build.append("""                          
                                         AND
                                         MATCH (organization, contact, project_name, project_description, project_funder, data_target, location_description, data_collector, data_type, keyword, other)
                                         AGAINST ('%(KeywordQuery)s' IN BOOLEAN MODE)
                                      """ % {"KeywordQuery":keyword_query})
        else:
            # Search query does not have a specified location
            query_build.append("""
                                 SELECT gd_id, organization, project_name_short, project_name, project_description, data_type, data_target, AsText(location)
                                 FROM GeoData
                              """)
            # Search query has at least 1 keyword
            if len(CalSwimView.keywords) > 0:
                # Just a few MySQL notes:
                #    Default MySQL operation executes an "OR" search among terms
                #    To make sure all terms are in a given result, "AND" search among terms, then just add prefix "+" before each term
                #    To exclude results with a given term, just add prefix "-" before the term
                keyword_query = "*, ".join(CalSwimView.keywords) +"*"        
                query_build.append("""                          
                                         WHERE
                                         MATCH (organization, contact, project_name, project_description, project_funder, data_target, location_description, data_collector, data_type, keyword, other)
                                         AGAINST ('%(KeywordQuery)s' IN BOOLEAN MODE)
                                      """ % {"KeywordQuery":keyword_query})
        select_query = "\n".join(query_build)
        #print >> CalSwimView.errors, select_query
        
        # execute SQL query using execute() method.
        self.cursor.execute(select_query)

        # Fetch a single row using fetchone() method.
        rows = []    
        table_data = {}
        coordinates = []
        while(1):
            row=self.cursor.fetchone()
            if row == None:
                break            
            coordinates.append( str(row[7]).replace('POINT(','').replace('POLYGON((','').replace(')','') )
            rows.append( {"c":[{"v":row[0]}, {"v":row[1]}, {"v":row[2]}, {"v":row[3]}, {"v":row[4]}, {"v":row[5]}, {"v":row[6]}]} )
    
        # Return search values as json
        cols = [{"id":'gd_id', "label":'gd_id', "type":'string'},
                {"id":'organization', "label":'Organization', "type":'string'},
                {"id":'project_short', "label":'Project Short', "type":'string'},
                {"id":'project', "label":'Project', "type":'string'},
                {"id":'description', "label":'Description', "type":'string'},                
                {"id":'target', "label":'Target', "type":'string'}]
        table_data["cols"] = cols
        table_data["rows"] = rows
        # Assign table data to json table data container
        json_data = {}
        json_data["table_data"] = table_data
        json_data["coordinates"] = coordinates
        
        # Close DB connections        
        self.cursor.close()
        
        # Return results
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
