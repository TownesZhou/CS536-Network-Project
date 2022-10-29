# QUIC toy server and client setup guide

## Download required files
Download the QUIC binaries from [here](https://drive.google.com/file/d/1aLskldTWSjkwHhLZJ-VHQ5FJjE0ZtQO2/view?usp=share_link) and the certificate files from [here](https://drive.google.com/file/d/1KUiLFjDsEG8iBZt1cIi0Kmuz3d_aXKTq/view?usp=share_link). Extract the two compressed files into the same directory of this README file. For the rest of this guide, we will assume all the commands are run in this directory.

```shell
$ tar -xvf quic.tar.gz
$ tar -xvf certs.tar.gz
```

The QUIC binaries will be extracted to `Quic` and the certificate files will be extracted to `out`.

## Install certificates

Get the tools for installing certificates:

```shell
$ sudo apt install libnss3-tools
```

List all certificates already installed:

```shell
$ certutil -d sql:$HOME/.pki/nssdb -L
```

The output should be empty because we haven't installed any certificates yet.

> If you run into the following error: `certutil: function failed: security library: bad database.`, then initialize the database by running the following:
>
> ```shell
> $ mkdir -p $HOME/.pki/nssdb
> $ certutil -d $HOME/.pki/nssdb -N --empty-password
> ```
>
> Then try to run the above command again to list already installed certificates.
> 
> See also: https://serverfault.com/a/438669

Now, install the root CA certificate that is used for issuing SSL server certificates:

```shell
$ certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n quic_cert -i out/2048-sha256-root.pem
```

Now, list all certificates again:

```shell
$ certutil -d sql:$HOME/.pki/nssdb -L
```

You should see something like this:

```shell
Certificate Nickname                        Trust Attributes
                                            SSL,S/MIME,JAR/XPI

quic_cert                                   C,,
```
indicating that the root CA certificate has been successfully installed.


## Run the QUIC server

Now, open a new terminal window and run the QUIC server:

```shell
$ ./Quic/quic_server --quic_response_cache_dir=www.example.org --certificate_file=out/leaf_cert.pem --key_file=out/leaf_cert.pkcs8
```

## Run the QUIC client and request data

Open a second new terminal window and try to request the HTML index file from the server:

```shell
$ ./Quic/quic_client --host=127.0.0.1 --port=6121 https://www.example.org/ --allow_unknown_root_cert > quic_client_out.txt
```

If successful, you should see a `quic_client_out.txt` file in the current directory with the contents of the requested file.

Now, let's try to request to 10MB image file:

```shell
$ ./Quic/quic_client --host=127.0.0.1 --port=6121 https://www.example.org/image.jpeg --allow_unknown_root_cert > quic_client_out.txt
```

and run the following command to verify the size of the downloaded file:

```shell
$ du -sh quic_client_out.txt
```

If successful, you should see:

```shell
9.8M    quic_client_out.txt
```
indicating that all the data of the image file have been downloaded.

# References

* [Playing with QUIC](https://www.chromium.org/quic/playing-with-quic/)
* [Linux Cert Management](https://chromium.googlesource.com/chromium/src/+/HEAD/docs/linux/cert_management.md)
