# vim:set ft=dockerfile:
FROM debian:bookworm-slim

LABEL maintainer="Cedric Jadot <cjadot@thelis.be>"

ENV ASTERISK_VERSION 20-current
ENV OPUS_CODEC       asterisk-20.0/x86-64/codec_opus-20.0_current-x86_64

COPY build-asterisk.sh /
RUN /build-asterisk.sh

EXPOSE 5060/udp 5060/tcp 5070/tcp
VOLUME /var/lib/asterisk /var/spool/asterisk /var/log/asterisk /etc/openvpn /var/log/openvpn

# Add OpenVPN
RUN apt-get update && \
    apt-get install -yq openvpn

# Set timezone
RUN apt-get update && \
    apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/Europe/Brussels /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata
    
RUN mkdir -p /var/lib/asterisk/moh
RUN mkdir -p /var/lib/asterisk/sounds/tts-sounds
COPY moh /var/lib/asterisk/moh
COPY beep.gsm /var/lib/asterisk/sounds

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/asterisk", "-vvvdddf", "-T", "-W", "-U", "asterisk", "-p"]
