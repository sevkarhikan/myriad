#!/bin/bash

# Function to generate random port number between 3500 and 5500
generate_random_port() {
    echo $(( ( RANDOM % 2001 ) + 3500 ))
}

# Assign arguments to variables
new_name=$1
new_port=$2
devcontainer_dir="./.devcontainer"

# Check if container name is not provided
if [ -z "$new_name" ]; then
    echo "Container name is required."
    exit 1
fi

# Check if port number is provided. If not, generate a random port.
if [ -z "$new_port" ]; then
    new_port=$(generate_random_port)
    echo "No port number provided. Using random port: $new_port"
fi

# Update devcontainer.json
# Replace port number and container name
sed -i "s/\"-p=[0-9]*:[0-9]*\"/\"-p=${new_port}:${new_port}\"/; s/\"--name\", \"[^\"]*\"/\"--name\", \"${new_name}\"/" "${devcontainer_dir}/devcontainer.json"

# Update forwardPorts in devcontainer.json
sed -i "s/\"forwardPorts\": \[[0-9]*\]/\"forwardPorts\": [${new_port}]/" "${devcontainer_dir}/devcontainer.json"

# Update Dockerfile
# Replace EXPOSE line with new port number
sed -i "s/EXPOSE [0-9]*/EXPOSE ${new_port}/" "${devcontainer_dir}/Dockerfile"

# Update startup.sh
# Replace sshd command with new port number
sed -i "s/sshd -p [0-9]*/sshd -p ${new_port}/" "${devcontainer_dir}/startup.sh"

echo "Updated configuration with container name ${new_name} and port ${new_port}."
