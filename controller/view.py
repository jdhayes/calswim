import os;
from datetime import date;
import urllib;
import re, string;

class WebView:
    """
        Simple web view class that should generate all dynamically viewed content
    """
    def __init__(self, base_dir, errors):        
        self.base_dir = base_dir
      
        # Define TPL path and set inital web CONTENT
        self.TPL_DIR = base_dir + '/tpl/'                
        self.year = date.today().year
        
        # Initialize error var
        self.errors = errors
    
    def set_content(self, template):
        FILE = open(self.TPL_DIR + template + '.tpl')
        self.content = FILE.read()
    
    def set_search(self, latlng, radius, keywords):        
        """
            Assign params to class instance
        """
        if latlng == "Everywhere":
            self.lat = None
            self.lng = None
        else:
            self.lat, self.lng = latlng.split(",")
            self.radius = radius;
        
        # Parse out non alpha numeric characters
        if keywords == "Everything":
            self.keywords = []
        else:
            pattern = re.compile('[\W_]+')
            self.keywords = pattern.sub(' ', keywords).split()    
        