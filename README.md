# Hyperspace

A real-time multiplayer space shooter being run on a scaling and auto healing Kontena cluster. A project that you can read more about on my blog [here](https://blog.mecloud.online).

The actual 80's style game is a fork from Ken Pratts repo: https://github.com/kenpratt/hyperspace

## Tools used

 * Docker
 * Kontena
 * Terraform
 * GitLab
 * ...

 ### Easiest way to generate self-signed cert for HTTPS

 ```
 openssl genrsa -out private.key 2048 && openssl req -x509 -new -nodes -key private.key -out private.crt -days 3650 -subj '/CN=demo'
 ```
 