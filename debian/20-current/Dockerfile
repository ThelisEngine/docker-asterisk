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
    apt-get install -yq tzdata cron && \
    ln -fs /usr/share/zoneinfo/Europe/Brussels /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata
    
RUN mkdir -p /var/lib/asterisk/moh
RUN mkdir -p /var/lib/asterisk/sounds/tts-sounds
COPY asterisk_logs.sh /usr/sbin/asterisk_logs
COPY asterisk_logs.cron /etc/cron.d/asterisk_logs
COPY default-moh.gsm /var/lib/asterisk/moh
COPY beep.gsm /var/lib/asterisk/sounds
RUN chmod 0644 /etc/cron.d/asterisk_logs
RUN chown -R asterisk:asterisk /var/lib/asterisk
RUN chown asterisk:asterisk /usr/sbin/asterisk_logs
RUN touch /var/log/cron.log

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/asterisk", "-vvvdddf", "-T", "-W", "-U", "asterisk", "-p"]
