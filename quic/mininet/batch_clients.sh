#! /bin/bash

# This script is used to run multiple QUIC clients and multiple HTTP clients in the background in parallel
# Make sure there are already both QUIC and/or HTTP servers running on the server hosts.
# It takes 2 arguments:
# 1. The number of QUIC clients to run in parallel
# 2. The number of HTTP clients to run in parallel

# Example usage:
# ./quic_client_batch.sh 3 1    # 3 QUIC clients and 1 HTTP client

# Check if the number of QUIC clients to run is provided
if [ -z "$1" ]
then
    echo "Please provide the number of QUIC clients to run in parallel"
    exit 1
fi

if [ -z "$2" ]
then
    echo "Please provide the number of HTTP clients to run in parallel"
    exit 1
fi

# Run the QUIC clients in the background
for i in $(seq 1 $1)
do
    # Use a & at the end to run the client in the background
    echo "Running QUIC client $i"
    ./Quic/quic_client --host=10.0.0.2 --port=6121 https://www.example.org/image.jpeg --disable_certificate_verification > quic_client_out_$i.txt &
done

# Run the HTTP clients in the background
for i in $(seq 1 $2)
do
    # Use a & at the end to run the client in the background
    echo "Running HTTP client $i"
    wget http://10.0.0.2:80/www.example.org/image.jpeg &
done

# Wait for all the clients to finish, then print a message and exit
wait
echo "All clients finished"
exit 0
