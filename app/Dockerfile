FROM golang:1.9-alpine

RUN adduser -s /bin/sh -D -H runner && \
    apk update && apk add git 
WORKDIR /home/root/hyperspace
ADD . .
RUN go get github.com/gorilla/websocket && \
    go get github.com/lucasb-eyer/go-colorful && \
    cd server && \
    go build && \
    chown -R runner:runner ./server
EXPOSE 9393

USER runner:runner
ENTRYPOINT ./server/server -port 9393 echo $$!