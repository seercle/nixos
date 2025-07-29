#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <username> <password>"
  echo "Example: $0 myuser mysecretpassword"
  exit 1
fi

USER="$1"
PASSWORD="$2"

echo "Creating auth file for user: ${USER}"
echo "${USER}:$(openssl passwd -stdin -apr1 <<< "${PASSWORD}")" >> auth

echo "Auth file 'auth' created successfully!"
echo "Content of 'auth' file:"
cat auth
