import subprocess
make_host = ["./Quic/quic_server", "--quic_response_cache_dir=www.example.org", "--certificate_file=out/leaf_cert.pem", "--key_file=out/leaf_cert.pkcs8"]
subprocess.call(make_host)
