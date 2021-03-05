ARG secret=defaultValue
FROM golang:1.13.5-alpine
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64
WORKDIR $GOPATH/src/gocalc
COPY ./gocalc/main.go .
RUN apk add git
RUN go get . && go build

FROM alpine:3.10.3
ARG secret
WORKDIR /app
COPY --from=0 /go/bin/gocalc /app
RUN echo ${secret} > secretfile && cat secretfile
ENTRYPOINT ./gocalc