FROM golang:alpine

COPY kapp /

EXPOSE 8877

CMD /kapp
