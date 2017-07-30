#cloud-config
write_files:
  - path: /etc/kontena-server.env
    permissions: 0600
    owner: root
    content: |
      KONTENA_VERSION=latest
      KONTENA_VAULT_KEY=<your vault_key>
      KONTENA_VAULT_IV=<your vault_iv>
      KONTENA_INITIAL_ADMIN_CODE=<initial_admin_code>
      SSL_CERT="/etc/kontena-server.pem"

  - path: /etc/kontena-server.pem
    permissions: 0600
    owner: root
    content: |
      -----BEGIN CERTIFICATE-----
      MIICrjCCAZYCCQDqVkvFjub07zANBgkqhkiG9w0BAQUFADAZMRcwFQYDVQQDEw5r
      b250ZW5hLW1hc3RlcjAeFw0xNzA3MzAxNTMxMzVaFw0xODA3MzAxNTMxMzVaMBkx
      FzAVBgNVBAMTDmtvbnRlbmEtbWFzdGVyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
      MIIBCgKCAQEAwyl3Fn9oJ/DzLrDT6EGfiAvMBtKVqrUm7cu/Dp1CiMlJrmnhbGYk
      Be/NyiBWjABCZZeoxGZC8JM7OqCbZjrz2h4hgjCmNajccCB9vOeWKWKXZEbZYFTp
      QX7Pglxpp8Z9kal3GwB5lXOtGGfkYa3yYPy7OxRtDobhMC2Q8dwxrSsdUrMB/5Yn
      voE6QakiXPBH+Fqaw/9beHDk4YH3G5JnLksl7i6x3ctxjSaqEiJ2Uz2IzD+EykDP
      ppUegwxAPnkJglsLIz+efQ+lRlmTHcs77jLucUrjVW6OmSyIgSWitanT/4NYOHb9
      ZBG1QyppqFBKtHkdDuvKOqjbZ3Ib/JWqmQIDAQABMA0GCSqGSIb3DQEBBQUAA4IB
      AQB5NWfGzQwDlUWILquN9MI9S6RzZMc5BV8n3N4246in//KsoWId+IsjCwlPWsSF
      bEE5vDb84+FwpDYFLdORwH6XLgglv+S+CzfJMAeJ6XSNbp463yTnz65Yh22UfCpD
      qC9c/jJRXhuHTRf9XIMCUD8fiXbbsf+LieeZNm44X0s+QNPVKDTh2xJaIZ/FPgxR
      UknfyS8HnExILFgiXI2PY8dVPt8ZUmgDSg07R/rfd6f9veWJHL3Mv0wJyYGLVARA
      4gXAPDBObGNNUqedT2Ldf+Pezsx02Af1roZwjLngj/CRdqr8S/RqFnxxpgiSFEkW
      hmFZsnLBCa1MdEqP6hZR39hK
      -----END CERTIFICATE-----
      -----BEGIN RSA PRIVATE KEY-----
      MIIEpAIBAAKCAQEAwyl3Fn9oJ/DzLrDT6EGfiAvMBtKVqrUm7cu/Dp1CiMlJrmnh
      bGYkBe/NyiBWjABCZZeoxGZC8JM7OqCbZjrz2h4hgjCmNajccCB9vOeWKWKXZEbZ
      YFTpQX7Pglxpp8Z9kal3GwB5lXOtGGfkYa3yYPy7OxRtDobhMC2Q8dwxrSsdUrMB
      /5YnvoE6QakiXPBH+Fqaw/9beHDk4YH3G5JnLksl7i6x3ctxjSaqEiJ2Uz2IzD+E
      ykDPppUegwxAPnkJglsLIz+efQ+lRlmTHcs77jLucUrjVW6OmSyIgSWitanT/4NY
      OHb9ZBG1QyppqFBKtHkdDuvKOqjbZ3Ib/JWqmQIDAQABAoIBAGbdgS5zgwOiZZsT
      iu3dQOflR+nEryxmBRnLjW13iC0u404x8qY/A/e5GN/TwapTLKv9ju/N8rR49fwF
      0ULGCefKf+DuIX0g/ud+yKd77VLs61zoVwUGXFewLlHIwcuzvFW9W9D4pB0Y9oBp
      qh+uHpXuQAV4066XezP4oHBKnkhmB/3krARicM6xn/ss8uZFGMbTmPSm/GrFohRL
      8FubWGe6P+tFmhnag+/bTyN7HK+PSDza9fiS8GaEKv3lQ+Gm0RB7GhnqKOXxzUlR
      pVJ9zp4WhBdNZBIBV8qp1FWhXJmV3q0dz/t6672PuHtKWMenEstPEFOcVfryhTsU
      zA+TB40CgYEA78j6J+LE6DtC7sUozg2kuwD8+1qLkrbc7SS7pUgJKkR8JnGE71Fm
      Mr42GgCNdvfwIKI4KMMfLN1vwnOiy8kJIdRYeSFtq6waEKWZCVvps2n6pN6f3wzo
      /jET99TZODqhlAY23LLYX4+EhOZ7FPepfWwihA7153/4+j0+6u+2+n8CgYEA0Fv/
      lXD7NyjPetRhz2BGHE+5lKYzfELVc/CT62x67Vcd5Cp8SlZ31XUdrIOMHijPpJAw
      SsGSaPnkQdT/AROg16AL39Ky3jDFiHNf7idjpBJRg2cYSjnSkudzRsRA1pI5r+VJ
      CR9t5uwC8VxQy38jsIwN2nx/kjxW9d3q9HwBXucCgYEAkyYIrdVx9Pn5F0ISynCA
      +OmgVje4k254oWb7aHCOf0vLzGO5qouPZfBojwhrx+hbigtC33Dufr/dR71i2CAk
      5IfFS4CCJunUjQaypZWsExgkYmzkOyNXEDbaBCqwqtsAMTCnFkUCl5IhRtWSDsn1
      Tyy++b+clFZqWlafd9lnts0CgYBo3wVDWHx5BOd5MVCRqilfspj7wrODRbheBKbP
      BejRcNmwr9mjKOZj3/Cxlfx+aZgpghFsbwWcJLrIj8ZR6mk4XmvbmhdBUlb6GOgd
      3GGAgV/ZvZgyM+xS2H/jDIB9/1dduxAJsXIFmqDYjthztGhoQfXvFF65Yfl7Atlx
      eMDP3QKBgQCk9FvAfmEd85iEA24T81s+I5+kDq3dJfZcmJHzalHTUnj5nyy6Op64
      b89BkoAkTA6hReCWwaiYqg2/S6XgLgl2E5CFWTjVMGq9zrq+uwJ/emJSRgn4BYBw
      fojediMTHV1tCi5q1376vs9OBEnKSxO3feazAdqCceIkjAFK7PqrKg==
      -----END RSA PRIVATE KEY-----
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
  units:
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