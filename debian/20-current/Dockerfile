# vim:set ft=dockerfile:
FROM debian:bookworm-slim

LABEL maintainer="Cedric Jadot <cjadot@thelis.be>"

ENV ASTERISK_VERSION 20-current
ENV OPUS_CODEC       asterisk-20.0/x86-64/codec_opus-20.0_current-x86_64

COPY build-asterisk.sh /
RUN /build-asterisk.sh

EXPOSE 5060/udp 5060/tcp
VOLUME /var/lib/asterisk /var/spool/asterisk /var/log/asterisk

# Set timezone
RUN apt-get update && \
    apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/Europe/Brussels /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata
    
RUN mkdir -p /var/lib/asterisk/moh
COPY moh /var/lib/asterisk/moh
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/asterisk", "-vvvdddf", "-T", "-W", "-U", "asterisk", "-p"]
