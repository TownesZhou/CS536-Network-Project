# Compare QUIC with HTTP

## Setup QUIC Server and Client in Mininet

### Download QUIC binaries and Google Chrome

Download the QUIC binaries from [here](https://drive.google.com/file/d/1aLskldTWSjkwHhLZJ-VHQ5FJjE0ZtQO2/view?usp=share_link) **Extract the compressed file into the `quic/` directory.** 

The QUIC binaries should be extracted to `quic/Quic` directory. There is another directory `quic/certs` which contains the example certificates, which we will later use to set up the QUIC server.

Download Google Chrome:

```bash
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
```

You should see a `google-chrome-stable_current_amd64.deb` file appear under the root directory.

### Start `mn-stratum` docker image and set up Mininet

Open a new terminal window at the root directory of this repo. Run the following command:

```bash
make mininet

# When you want to set a bandwidth limit, use mininet-bandwidth target instead.
# ex: 10 Mbps limit
make mininet-bandwidth bw=10
```

Open up another terminal window in the same directory. Run the following command to install necessary dependencies and install the server's certificate file:

```bash
make mininet-prereqs
```

When it asks for password with something like this `Enter Password or Pin for "NSS Certificate DB"`, just hit enter multiple times to enter empty passwords. In the final line of output you will see something like `unix:path=/var/run/dbus/system_bus_socket,guid=ed0e8d608caf8959c5962a6a637d36c8` and the terminal will be stuck there. This is the `dbus-daemon` process running, which is necessary for Google Chrome. **DO NOT press `ctrl + C` to terminate this process.** 

Open up a third terminal window and run the following command to start the controller:

```bash
make controller
```

Open up a fourth terminal window and run the following command:

```bash
make cli
```

This will start the ONOS cli. Enter `rocks` when it asks for password. Once it starts, run the following command within the ONOS cli:

```bash
app activate fwd
```

Open up the fifth terminal window and run the following command to set up the switch:

```bash
make netcfg
```

### Run Quic server and test with toy client

The QUIC binaries are shipped with a QUIC server and a QUIC toy client program. We will use the QUIC server program to setup the server and first use the toy client program to check that this setup is correct. Later, we will use **Google Chrome** as the client instead.

Open up the fifth terminal window, and run the following terminal to enter **host 1**:

```bash
make host-h1
```

Then, run the following command to run the QUIC server:

```bash
./quic/Quic/quic_server --quic_response_cache_dir=www.example.org --certificate_file=quic/certs/leaf_cert.pem --key_file=quic/certs/leaf_cert.pkcs8
```

Finally, open up the sixth terminal window, and run the following to enter **host 2**:

```bash
make host-h2
```

Then, run the following command to run the QUIC toy client to try to access the `index.html` file:

```bash
./quic/Quic/quic_client --host=10.0.0.1 --port=6121 https://www.example.org/ --disable_certificate_verification > quic_client_out.txt
```

If successful, you should see the `quic_client_out.txt` in the current directory.

Finally, try to download the 500KB text file `test_500KB.txt`:

```bash
./quic/Quic/quic_client --host=10.0.0.1 --port=6121 https://www.example.org/test.txt --disable_certificate_verification > quic_client_out.txt
```

If succssful, you should see a `quic_client_out.txt` file with size `504K`.  

<!-- ### Run multiple QUIC client processes parallelly

I made a simple bash script that initiate a given number of QUIC client processes parallelly in the backgroud. Simply run the following command in the client host terminal window:

```bash
bash ./batch_clients.sh <number of TOY QUIC clients> <number of WGET HTTP clients>
```
where `<number of TOY QUIC clients>` and `<number of WGET HTTP clients>` is an integer indicating the number of processes you want to initiate for the toy quic client (NOT the Chrome client) and the WGET HTTP client (provided a HTTP server has been started), respectively. -->

### Use Google Chrome as Client

We will now use Google Chrome instead of the toy QUIC client as the client process. 

Generate a SPKI fingerprint from the QUIC server's public key:

```bash
openssl x509 -pubkey < "quic/certs/leaf_cert.pem" | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64 > "quic/certs/fingerprints.txt"
```
This should generate a `fingerprints.txt` file under the `quic/certs` directory.

Run chrome inside the client host `host-h2` to connet to the QUIC server (the QUIC server must have alreay been started in the server host `host-h1`):

```bash
google-chrome --no-sandbox --headless --disable-gpu --user-data-dir=/tmp/chrome-profile --no-proxy-server --enable-quic --origin-to-force-quic-on=www.example.org:443 --host-resolver-rules='MAP www.example.org:443 10.0.0.1:6121' --ignore-certificate-errors-spki-list=$(cat quic/certs/fingerprints.txt) https://www.example.org/test.txt
```


## Setup HTTPS server in mininet

Generate certificates for the HTTP server. Go to `https/` directory and run the `ssl.sh` file:

```bash
cd https
bash ssl.sh
```

Generate a SPKI fingerprint from the QUIC server's public key:
```bash
cd h1
openssl x509 -pubkey < "server.crt" | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64 > "fingerprints.txt"
```

Go into the server host `host-h1`, run the HTTP server **under the `https/h1` directory**
```bash
python server.py
```

Go into the client host `host-h2`, run Google chrome **under the root directory** to download a file from the HTTP server:

```bash
google-chrome --no-sandbox --headless --disable-gpu --user-data-dir=/tmp/chrome-profile --no-proxy-server --ignore-certificate-errors-spki-list=$(cat https/h1/fingerprints.txt) --disk-cache-dir=/dev/null  https://10.0.0.1:8000/files/test_500KB_1_0.txt
```

This will download the file `test_500KB_1_0.txt`. There are many other test files of varying sizes under the directory `https/h1/files`. Simply change the url to the corresponding file to download those other files.
