#cloud-config
write_files:
  - path: /etc/kontena-agent.env
    permissions: 0600
    owner: root
    content: |
      KONTENA_URI=${kontena_uri}
      KONTENA_TOKEN=${kontena_worker_token}
      KONTENA_PEER_INTERFACE=${kontena_peer_interface}
      KONTENA_VERSION=${kontena_version}
  - path: /etc/systemd/system/docker.service.d/50-kontena.conf
    content: |
        [Service]
        Environment='DOCKER_OPTS=--insecure-registry="10.81.0.0/16" --bip="172.17.43.1/16"'
  - path: /etc/sysctl.d/99-inotify.conf
    owner: root
    permissions: 0644
    content: |
      fs.inotify.max_user_instances = 8192
coreos:
  units:
    - name: 50-docker.network
      mask: true
    - name: 50-docker-veth.network
      mask: true
    - name: zz-default.network
      content: |
        # default should not match virtual Docker/weave bridge/veth network interfaces
        [Match]
        Name=${kontena_peer_interface}

        [Network]
        DHCP=yes
        DNS=172.17.43.1
        DNS=8.8.8.8
        DNS=8.8.4.4
        
        Domains=kontena.local

        [DHCP]
        UseMTU=true
        UseDNS=false

    - name: kontena-agent.service
      command: start
      enable: true
      content: |
        [Unit]
        Description=kontena-agent
        After=network-online.target
        After=docker.service
        Description=Kontena Agent
        Documentation=http://www.kontena.io/
        Requires=network-online.target
        Requires=docker.service

        [Service]
        Restart=always
        RestartSec=5
        EnvironmentFile=/etc/kontena-agent.env
        ExecStartPre=-/usr/bin/docker stop kontena-agent
        ExecStartPre=-/usr/bin/docker rm kontena-agent
        ExecStartPre=/usr/bin/docker pull kontena/agent:${kontena_version}
        ExecStart=/usr/bin/docker run --name kontena-agent \
            -e KONTENA_URI=${kontena_uri} \
            -e KONTENA_TOKEN=${kontena_worker_token} \
            -e KONTENA_PEER_INTERFACE=${kontena_peer_interface} \
            -v=/var/run/docker.sock:/var/run/docker.sock \
            -v=/etc/kontena-agent.env:/etc/kontena.env \
            --net=host \
            kontena/agent:${kontena_version}
