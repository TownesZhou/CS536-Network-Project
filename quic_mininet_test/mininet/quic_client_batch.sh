#! /bin/bash

# This script is used to run multiple quic clients in the background in parallel
# It takes 1 arguments:
# 1. The number of clients to run in parallel

# Example usage:
# ./quic_client_batch.sh 10

# Check if the number of clients to run is provided
if [ -z "$1" ]
then
    echo "Please provide the number of clients to run in parallel"
    exit 1
fi

# Run the clients in the background
for i in $(seq 1 $1)
do
    # Use a & at the end to run the client in the background
    ./Quic/quic_client --host=10.0.0.2 --port=6121 https://www.example.org/image.jpeg --disable_certificate_verification > quic_client_out_$i.txt &
done

# Wait for all the clients to finish, then print a message and exit
wait
echo "All clients finished"
exit 0
