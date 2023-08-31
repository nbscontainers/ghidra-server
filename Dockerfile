FROM docker.io/alpine:3.17.2 AS downloader

ARG GHIDRA_URL=https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.3.3_build/ghidra_10.3.3_PUBLIC_20230829.zip
ARG GHIDRA_SHA256=63833361bea8ef5ada1bc28cd2aa2ae4ab43204d2672b595500372582152eebe

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
