// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("hyperspace-1dca531e62dc.json")}"
  project     = "hyperspace-171711"
  region      = "eu-west1"
}

resource "google_compute_instance" "coreos" {
  name = "${format("coreos-%d", count.index)}"
  image = "cos-stable-59-9460-64-0"
  private_networking = true
  zone = "europe-west1-b"
  machine_type = "n1-standard-1"


user_data = << EOF
#cloud-config

write_files:
  - path: /etc/kontena-server.env
    permissions: 0600
    owner: root
    content: |
      KONTENA_VERSION=latest
      KONTENA_VAULT_KEY=31m2lqP54cbS6HsI2OV0bF2ZEgbPxNrkpq7laDqmApUzJd2mC0MZcSozKYoH51PY
      KONTENA_VAULT_IV=KGzwfRB908S8DhFhozln0pYTFQfg47GCSpUDRl9UQxy8l9Pd2jgdvmZQYSb5eyuw
      KONTENA_INITIAL_ADMIN_CODE=Demo600
      SSL_CERT="/etc/kontena-server.pem"

  - path: /etc/kontena-server.pem
    permissions: 0600
    owner: root
    content: |
            -----BEGIN CERTIFICATE-----
      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
      RhieE8jm5SNL
      -----END CERTIFICATE-----
      -----BEGIN PRIVATE KEY-----
      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
      6/z9oJLGoJA3gi+c6o64t9ezEFPxBQ==
      -----END PRIVATE KEY-----

  - path: /opt/bin/kontena-haproxy.sh
    permissions: 0755
    owner: root
    content: |
      #!/bin/sh
      if [ -n "$SSL_CERT" ]; then
        SSL_CERT=$(awk 1 ORS='\\n' $SSL_CERT)
      else
        SSL_CERT="**None**"
      fi
      /usr/bin/docker run --name=kontena-server-haproxy \
        --link kontena-server-api:kontena-server-api \
        -e SSL_CERT="$SSL_CERT" -e BACKEND_PORT=9292 \
        -p 80:80 -p 443:443 kontena/haproxy:latest
coreos:
  etcd:
    # Get a new discovery URL from https://discovery.etcd.io/new
    discovery: https://discovery.etcd.io/569eeb972592289939e3d9e0716d0d52
    addr: $private_ipv4:4001
    peer-addr: $private_ipv4:7001
  units:
    - name: etcd.service
      command: start
    - name: fleet.service
      command: start
    - name: kontena-server-mongo.service
      command: start
      enable: true
      content: |
        [Unit]
        Description=kontena-server-mongo
        After=network-online.target
        After=docker.service
        Description=Kontena Server MongoDB
        Documentation=http://www.mongodb.org/
        Requires=network-online.target
        Requires=docker.service

        [Service]
        Restart=always
        RestartSec=5
        ExecStartPre=/usr/bin/docker pull mongo:3.0
        ExecStartPre=-/usr/bin/docker create --name=kontena-server-mongo-data mongo:3.0
        ExecStartPre=-/usr/bin/docker stop kontena-server-mongo
        ExecStartPre=-/usr/bin/docker rm kontena-server-mongo
        ExecStart=/usr/bin/docker run --name=kontena-server-mongo \
            --volumes-from=kontena-server-mongo-data \
            mongo:3.0 mongod --smallfiles
        ExecStop=/usr/bin/docker stop kontena-server-mongo

    - name: kontena-server-api.service
      command: start
      enable: true
      content: |
        [Unit]
        Description=kontena-server-api
        After=network-online.target
        After=docker.service
        Description=Kontena Agent
        Documentation=http://www.kontena.io/
        Requires=network-online.target
        Requires=docker.service

        [Service]
        Restart=always
        RestartSec=5
        EnvironmentFile=/etc/kontena-server.env
        ExecStartPre=-/usr/bin/docker stop kontena-server-api
        ExecStartPre=-/usr/bin/docker rm kontena-server-api
        ExecStartPre=/usr/bin/docker pull kontena/server:${KONTENA_VERSION}
        ExecStart=/usr/bin/docker run --name kontena-server-api \
            --link kontena-server-mongo:mongodb \
            -e MONGODB_URI=mongodb://mongodb:27017/kontena_server \
            -e VAULT_KEY=${KONTENA_VAULT_KEY} -e VAULT_IV=${KONTENA_VAULT_IV} \
            -e INITIAL_ADMIN_CODE=${KONTENA_INITIAL_ADMIN_CODE} \
            kontena/server:${KONTENA_VERSION}
        ExecStop=/usr/bin/docker stop kontena-server-api

    - name: kontena-server-haproxy.service
      command: start
      enable: true
      content: |
        [Unit]
        Description=kontena-server-haproxy
        After=network-online.target
        After=docker.service
        Description=Kontena Server HAProxy
        Documentation=http://www.kontena.io/
        Requires=network-online.target
        Requires=docker.service

        [Service]
        Restart=always
        RestartSec=5
        EnvironmentFile=/etc/kontena-server.env
        ExecStartPre=-/usr/bin/docker stop kontena-server-haproxy
        ExecStartPre=-/usr/bin/docker rm kontena-server-haproxy
        ExecStartPre=/usr/bin/docker pull kontena/haproxy:latest
        ExecStart=/opt/bin/kontena-haproxy.sh
        ExecStop=/usr/bin/docker stop kontena-server-haproxy
  EOF
}



output "address_coreos" {
  value = "${google_compute_instance.coreos-%d.ipv4_address}"
}
