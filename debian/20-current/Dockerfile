# vim:set ft=dockerfile:
FROM debian:bookworm-slim

LABEL maintainer="Andrius Kairiukstis <k@andrius.mobi>"

ENV ASTERISK_VERSION 20-current
ENV OPUS_CODEC       asterisk-20.0/x86-64/codec_opus-20.0_current-x86_64

COPY build-asterisk.sh /
RUN /build-asterisk.sh

EXPOSE 5060/udp 5060/tcp
VOLUME /var/lib/asterisk /var/spool/asterisk /var/log/asterisk

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/asterisk", "-vvvdddf", "-T", "-W", "-U", "asterisk", "-p"]
