import BaseHTTPServer, SimpleHTTPServer
import os
import ssl

if __name__ == '__main__':  
    # os.system("openssl req -nodes -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -subj '/CN=mylocalhost'")
    # openssl req -out ca.req -key ca.key -new -nodes -subj '/CN=mylocalhost'
    # openssl req -out server.req -key server.key -new -nodes -subj '/CN=mylocalhost'
    # openssl req -out client.req -key client.key -new -nodes -subj '/CN=mylocalhost'

    httpd = BaseHTTPServer.HTTPServer(('', 8000),
            SimpleHTTPServer.SimpleHTTPRequestHandler)

    httpd.socket = ssl.wrap_socket (httpd.socket,
            keyfile="./server.key",
            certfile='./server.crt', server_side=True)

    httpd.serve_forever()