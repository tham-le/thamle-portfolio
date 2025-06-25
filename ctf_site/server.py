#!/usr/bin/env python3
"""
Enhanced HTTP Server for CTF Site
- Redirects directory requests without trailing slashes to main page
- Serves index.html for directory requests
- More secure error handling
"""

import http.server
import socketserver
import os
import sys
from urllib.parse import urlparse

PORT = 8000

class CTFHandler(http.server.SimpleHTTPRequestHandler):
    """Custom handler for CTF site"""
    
    def do_GET(self):
        # Parse the URL
        parsed_url = urlparse(self.path)
        path = parsed_url.path
        
        # Check if path exists
        file_path = self.translate_path(path)
        
        # If it's a directory without a trailing slash, redirect to home
        if os.path.isdir(file_path) and not path.endswith('/'):
            self.send_response(302)
            self.send_header('Location', '/')
            self.end_headers()
            return
            
        # If it's a directory with a trailing slash but no index.html, go to home
        if os.path.isdir(file_path) and path != '/':
            index_path = os.path.join(file_path, 'index.html')
            if not os.path.exists(index_path):
                self.send_response(302)
                self.send_header('Location', '/')
                self.end_headers()
                return
                
        # For all other requests, use the default handler
        return http.server.SimpleHTTPRequestHandler.do_GET(self)

def run_server():
    """Run the server with the custom handler"""
    with socketserver.TCPServer(("", PORT), CTFHandler) as httpd:
        print(f"Serving at http://127.0.0.1:{PORT}")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped.")
            httpd.server_close()
            sys.exit(0)

if __name__ == "__main__":
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    run_server()
