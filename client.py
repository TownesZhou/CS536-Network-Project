import subprocess
import threading
import time

def download_function(file_name):

    make_host = ["google-chrome", 
"--no-sandbox",
"--headless",
"--disable-gpu",
"--user-data-dir=/tmp/chrome-profile",
"--no-proxy-server",
"--enable-quic",
"--origin-to-force-quic-on=www.example.org:443",
"--host-resolver-rules='MAP www.example.org:443 10.0.0.1:6121'",
"--ignore-certificate-errors-spki-list=$(cat quic/certs/fingerprints.txt) https://www.example.org/test.txt"
]
    proc = subprocess.Popen(make_host,stdout=subprocess.PIPE)
    output = proc.stdout.read()


total_time = 0
iteration = 1

for cnt in range(iteration):
    st = time.time()
    file_name = "index.html"
    download_function(file_name)
    en = time.time()
    total_time += ((en-st)*1000)

avg_time = total_time/iteration
print("Total Time: ", total_time)
print("Avg Time: ", avg_time)
