FROM docker.io/alpine:3.14.2 AS downloader

ARG GHIDRA_URL=https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.1.2_build/ghidra_10.1.2_PUBLIC_20220125.zip
ARG GHIDRA_SHA256=ac96fbdde7f754e0eb9ed51db020e77208cdb12cf58c08657a2ab87cb2694940

RUN apk add --no-cache wget unzip && \
    wget -q -O /ghidra.zip ${GHIDRA_URL} && \
    echo "${GHIDRA_SHA256}  /ghidra.zip" | sha256sum -c -s && \
    unzip /ghidra.zip -d / && \
    mv /ghidra_* /ghidra


FROM docker.io/openjdk:11-slim

COPY --from=downloader /ghidra /ghidra

WORKDIR /ghidra
VOLUME /ghidra/repositories

EXPOSE 13100-13102

ENTRYPOINT [ "/ghidra/server/ghidraSvr" ]
CMD [ "console" ]
