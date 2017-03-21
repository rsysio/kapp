FROM golang:alpine

COPY run /go/

EXPOSE 8877

CMD /go/run
