import os;
import MySQLdb;
from datetime import date;
import urllib;

class WebView:
    """
        Simple web view class that should generate all dynamically viewed content
    """
    def __init__(self, base_dir):        
        self.base_dir = base_dir
      
        # Define TPL path and set inital web CONTENT
        self.TPL_DIR = base_dir + '/tpl/'                
        self.year = date.today().year        
    
    def set_content(self, template):
        FILE = open(self.TPL_DIR + template + '.tpl')
        self.content = FILE.read()
    
    def set_search(self, search):        
        self.search = search