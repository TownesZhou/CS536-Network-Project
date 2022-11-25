import os
import time
import csv
# import urllib2
# import ssl

if __name__ == '__main__':  
    if os.path.exists("./files"):
        os.system("rm -rf ./files")
    os.system("mkdir ./files")

    with open("result.csv","w") as csvfile: 
        writer = csv.writer(csvfile)
        writer.writerow(["each file","file number","time"])

    size = ["5KB", "10KB", "100KB", "200KB", "500KB", "1MB", "10MB"]
    file_number = {"5KB":[1, 200], "10KB":[1, 100], "100KB":[1, 10], "200KB":[1, 5], "500KB":[1, 2], "1MB":[1], "10MB":[1]}
    time = 0

    for total_size in size:
        for number in file_number[total_size]:          
            start = time.time()
            for i in range(number):
                os.system("wget --no-check-certificate -P ./files https://10.0.0.1:8000/files/test_%s_%d_%d.txt" % (total_size, number, i))
            end = time.time()
            time = (end - start) * 1000
            print("size:", total_size, " number:", file_number, " download time:", time)
            with open("result.csv","a") as csvfile: 
                writer = csv.writer(csvfile)
                writer.writerow([total_size, number, time])

#     if os.path.exists("./test.txt"):
#         os.remove("./test.txt")

#     CA_FILE = "../ca/ca.crt"
#     KEY_FILE = "./client.key"
#     CERT_FILE = "./client.crt"

#     context = ssl.SSLContext(ssl.PROTOCOL_TLS)
#     context.check_hostname = False
#     context.load_cert_chain(certfile=CERT_FILE, keyfile=KEY_FILE)
#     context.load_verify_locations(CA_FILE)
#     context.verify_mode = ssl.CERT_REQUIRED

#     try:
#         start = time.time()
#         request = urllib2.Request('https://10.0.0.1:8000/test.txt')
#         res = urllib2.urlopen(request, context=context)
#         end = time.time()
#         print("download time:", end - start)
#     except Exception as ex:
#         print("Found Error in auth phase:%s" % str(ex))
