"""
    =============================================================
    * CalSWIM Get Google Map locations method - powered by WSGI *
    =============================================================
"""
import os;
import cgi;
import urllib;
from view import WebView;
from db import SearchVals;

def application(environ, start_response):
    locs = """{"markers":[ { "latitude":57.7973333, "longitude":12.0502107, "title":"Angered", "content":"Representing :)" }, { "latitude":57.6969943, "longitude":11.9865, "title":"Gothenburg", "content":"Swedens second largest city" } ]}"""
    start_response('200 OK', [('content-type', 'text/html')])
    return locs