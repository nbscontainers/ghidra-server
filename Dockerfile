FROM docker.io/alpine:3.17.2 AS downloader

ARG GHIDRA_URL=https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.4_build/ghidra_10.4_PUBLIC_20230928.zip
ARG GHIDRA_SHA256=6911d674798f145f8ea723fdd3eb67a8fae8c7be92e117bca081e6ef66acac19

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
