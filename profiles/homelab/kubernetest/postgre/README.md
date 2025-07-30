Write the init script in postgre-secret-init-script.sql

Encode this file into base64 with sops -d ./[filename] | base64

Paste the output in the field INPUT_SCRIPT of the yaml secret file
