FROM docker.io/alpine:3.19.0 AS downloader

ARG GHIDRA_URL=https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.1_build/ghidra_11.1_PUBLIC_20240607.zip
ARG GHIDRA_SHA256=293f60e04fa480315d2c467f4b2b4b10b3b6b5c8a8416bf7167fe082406e3be8

RUN apk add --no-cache wget unzip && \
    wget -q -O /ghidra.zip ${GHIDRA_URL} && \
    echo "${GHIDRA_SHA256}  /ghidra.zip" | sha256sum -c -s && \
    unzip /ghidra.zip -d / && \
    mv /ghidra_* /ghidra


FROM docker.io/eclipse-temurin:17-jre-jammy

COPY --from=downloader /ghidra /ghidra

WORKDIR /ghidra
VOLUME /ghidra/repositories

EXPOSE 13100-13102

ENTRYPOINT [ "/ghidra/server/ghidraSvr" ]
CMD [ "console" ]
