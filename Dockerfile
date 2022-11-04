FROM docker.io/alpine:3.15.5 AS downloader

ARG GHIDRA_URL=https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.2_build/ghidra_10.2_PUBLIC_20221101.zip
ARG GHIDRA_SHA256=a5163f50bd6ce725c4c8638f7505b64bb603ea6bfe3f7d9ed4e403236716f787

RUN apk add --no-cache wget unzip && \
    wget -q -O /ghidra.zip ${GHIDRA_URL} && \
    echo "${GHIDRA_SHA256}  /ghidra.zip" | sha256sum -c -s && \
    unzip /ghidra.zip -d / && \
    mv /ghidra_* /ghidra


FROM docker.io/openjdk:17-slim

COPY --from=downloader /ghidra /ghidra

WORKDIR /ghidra
VOLUME /ghidra/repositories

EXPOSE 13100-13102

ENTRYPOINT [ "/ghidra/server/ghidraSvr" ]
CMD [ "console" ]
