import subprocess
make_host = ["./quic/Quic/quic_server", "--quic_response_cache_dir=www.example.org", "--certificate_file=quic/certs/leaf_cert.pem",
 "--key_file=quic/certs/leaf_cert.pkcs8"]
subprocess.call(make_host)
