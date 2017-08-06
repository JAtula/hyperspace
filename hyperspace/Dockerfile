FROM golang:1.7-alpine
RUN apk update && apk add git 
WORKDIR /home/root/hyperspace
ADD .
RUN ln -s etc/hyperspace.service /etc/systemd/system/ \
    hyperspace ALL=(ALL) NOPASSWD: /home/hyperspace/hyperspace/bin/start \
    hyperspace ALL=(ALL) NOPASSWD: /home/hyperspace/hyperspace/bin/stop \
    hyperspace ALL=(ALL) NOPASSWD: /home/hyperspace/hyperspace/bin/restart \
    go get github.com/gorilla/websocket \
    go get github.com/lucasb-eyer/go-colorful
CMD ["systemctl","start","hyperspace"]