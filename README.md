# Run QUIC server and client within mininet

Download the QUIC binaries from [here](https://drive.google.com/file/d/1aLskldTWSjkwHhLZJ-VHQ5FJjE0ZtQO2/view?usp=share_link) and the certificate files from [here](https://drive.google.com/file/d/1KUiLFjDsEG8iBZt1cIi0Kmuz3d_aXKTq/view?usp=share_link). **Extract the two compressed files into the `/quic_mininet_test/mininet/` directory.** For the rest of this guide, we will assume all the commands are run in this directory `/quic_mininet_test/mininet/`.

The QUIC binaries will be extracted to `Quic` and the certificate files will be extracted to `out`.

## Start `mn-stratum` docker image and set up Mininet

Open a new terminal window and cd into the same directory of `/quic_mininet_test/mininet/`. Run the following command:

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

## Run Quic client and server within Mininet hosts

Open up the fifth terminal window, and run the following terminal to enter **host 2**:

```bash
make host-h2
```

Then, run the following command to run the QUIC server:

```bash
./Quic/quic_server --quic_response_cache_dir=www.example.org --certificate_file=out/leaf_cert.pem --key_file=out/leaf_cert.pkcs8
```

Finally, open up the sixth terminal window, and run the following to enter **host 1**:

```bash
make host-h1
```

Then, run the following command to run the QUIC client to try to access the `index.html` file:

```bash
./Quic/quic_client --host=10.0.0.2 --port=6121 https://www.example.org/ --disable_certificate_verification > quic_client_out.txt
```

If successful, you should see the `quic_client_out.txt` in the current directory.

Finally, try to download the `image.jpeg` file:

```bash
./Quic/quic_client --host=10.0.0.2 --port=6121 https://www.example.org/image.jpeg --disable_certificate_verification > quic_client_out.txt
```

If succssful, you should see a `quic_client_out.txt` file with size `9.8M`.  

### Run multiple QUIC client processes parallelly

I made a simple bash script that initiate a given number of QUIC client processes parallelly in the backgroud. Simply run the following command in the client host terminal window:

```bash
bash ./batch_clients.sh <number of TOY QUIC clients> <number of WGET HTTP clients>
```
where `<number of TOY QUIC clients>` and `<number of WGET HTTP clients>` is an integer indicating the number of processes you want to initiate for the toy quic client (NOT the Chrome client) and the WGET HTTP client (provided a HTTP server has been started), respectively.

# Use Google Chrome as Client

Run chrome inside the client host to connet to the QUIC server (the QUIC server must have alreay been started in the server host `host-h2`):
```bash
google-chrome --no-sandbox --headless --disable-gpu --user-data-dir=/tmp/chrome-profile --no-proxy-server --enable-quic --origin-to-force-quic-on=www.example.org:443 --host-resolver-rules='MAP www.example.org:443 10.0.0.2:6121' --ignore-certificate-errors-spki-list=$(cat fingerprints.txt) https://www.example.org/image.jpeg
```

