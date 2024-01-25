Asterisk PBX Docker image
=========================

> REFACTOR! I started massive refactor, considering comments received in the issues and private emails. Thank you all for the feedback! Once ready, This readme will be updated, right away please look to the existing docker tags on hub

The smallest Docker image with Asterisk PBX https://hub.docker.com/r/andrius/asterisk/

This image is based on Alpine Linux image, which is only a 5MB image, and contains
[Asterisk PBX](http://www.asterisk.org/get-started/features).

Total size of this image for `latest` tag (based on Alpine linux) is:

[![](https://images.microbadger.com/badges/image/andrius/asterisk.svg)](https://microbadger.com/images/andrius/asterisk "Get your own image badge on microbadger.com")

And for `debian-stretch-slim-15-current`
[![](https://images.microbadger.com/badges/image/andrius/asterisk:debian-stretch-slim-15-current.svg)](https://microbadger.com/images/andrius/asterisk:debian-stretch-slim-15-current "Get your own image badge on microbadger.com").

# Build Thello Debian image

In debian/XX-current folder



```bash
docker login registry.thelis.be:5001 thelis <password>

docker build -t registry.thelis.be:5001/thelis/asterisk:20-5 .
docker push registry.thelis.be:5001/thelis/asterisk:20-5
```

# Custom UID/GID

By default, Asterisk will run as default user (asterisk) with UID and GID assigned by alpine linux, but it's possible to specify then through environment variables:

- `ASTERISK_UID`
- `ASTERISK_GID` (note, GID is not supported in debian releases)

Default asterisk user will be re-created with new UID and GID

In given example, ID's of current host user will be used to start, that will fix permissions issues on logs volume:

```bash
docker run -ti --rm \
  -e ASTERISK_UID=`id -u` \
  -e ASTERISK_GID=`id -g` \
  -v ${PWD}/logs:/var/log/asterisk \
  andrius/asterisk
```

# Alternative user

It is possible to specifty other than asterisk user to start through environment variable `ASTERISK_USER`:

```bash
docker run -ti --rm -e ASTERISK_USER=root andrius/asterisk
```

# Versions

## Based on Alpine linux:

- `docker pull andrius/asterisk:11.6.1` for Asterisk 11.x (stable release), Alpine 2.6
- `docker pull andrius/asterisk:11` for Asterisk 11.x (stable release), Alpine 2.7
- `docker pull andrius/asterisk:14` for Asterisk 14.x, Alpine 3.6
- `docker pull andrius/asterisk:15.2.2` for Asterisk 15.2.2, Alpine 3.7
- `docker pull andrius/asterisk:15` for Asterisk 15.x, Alpine 3.8
- `docker pull andrius/asterisk:latest` for Asterisk 15.x, Alpine latest
- `docker pull andrius/asterisk:edge` for latest Asterisk 15.x, based on Alpine edge

### What's missing

Only base Asterisk packages installed. If you want to add sounds, it's recommended to mount them as volume or data container, however you may install additional packages with `apk` command:

- asterisk-alsa - ALSA channel;
- asterisk-cdr-mysql - MySQL CDR;
- asterisk-chan-dongle - chan\_dongle, to manage calls and SMS through Huawei USB dongle;
- asterisk-curl - curl integration with Asterisk;
- asterisk-dahdi - DAHDI channel (ISDN BRI/PRI, FXO and FXS cards integration);
- asterisk-fax - support faxing
- asterisk-mobile - Use Bluetooth mobile phones as FXO devices;
- asterisk-odbc - ODBC support;
- asterisk-pgsql - PostgreSQL support;
- asterisk-sounds-en - sounds
- asterisk-sounds-moh - music on hold;
- asterisk-speex - Speex codec;
- asterisk-srtp - SRTP encryption;
- asterisk-tds - MS SQL support.

### Database support

By default, Asterisk PBX store CDR's to the CSV file, but also support databases. Refer Asterisk PBX documentation for ODBC support.

For Postgre SQL include following lines to your Dockerfile:

```bash
RUN apk add --update less psqlodbc asterisk-odbc asterisk-pgsql \
&&  rm -rf /var/cache/apk/*
```

And For MySQL:

For MySQL, `mysql-connector-odbc` should be downloaded from the official site and compiled

## Based on Debian linux:

Debian Jessie:

- `docker pull andrius/asterisk:debian-11.25.3`
- `docker pull andrius/asterisk:debian-12.8.2`

Debian Stretch:

- `docker pull andrius/asterisk:debian-13-current`
- `docker pull andrius/asterisk:debian-14-current`
- `docker pull andrius/asterisk:debian-15-current`
