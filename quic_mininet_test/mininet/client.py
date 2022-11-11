import subprocess
import threading
import time

def download_function(file_name):

    make_host = ["./Quic/quic_client",  "--disable_certificate_verification", "--host=10.0.0.2", "--port=6121" , "https://www.example.org/"]
    proc = subprocess.Popen(make_host,stdout=subprocess.PIPE)
    output = proc.stdout.read()

    f = open(file_name,"a")
    f.write(output)
    f.close()

threads = []
for i in range(10):
    file_name = "output" + str(i) + ".txt"
    x = threading.Thread(target=download_function,args=(file_name,))
    threads.append(x)
    x.start()


for index, thread in enumerate(threads):
    st = time.time()
    thread.join()
    en = time.time()
    print("Required Time: ", en - st)
