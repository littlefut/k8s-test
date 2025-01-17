FROM golang:1.16 as base

ENV SRC_DIR=/go/src/k8s-test

WORKDIR $SRC_DIR
COPY go.mod .
COPY Makefile .

RUN make deps

COPY . .
RUN make build-release

FROM scratch

ENV SRC_DIR=/go/src/k8s-test

WORKDIR $SRC_DIR
COPY --from=base ${SRC_DIR}/bin/server ${SRC_DIR}
COPY --from=base ${SRC_DIR}/public ${SRC_DIR}/public
ENTRYPOINT [ "./server" ]