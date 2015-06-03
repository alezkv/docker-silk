FROM debian:wheezy

MAINTAINER Alexey Zhukov <alex@izhukov.ru>

ENV SILK_VERSION 3.10.1
ENV SILK_MD5 e8a32f45383b7120ce695b141ef44cbe
ENV LIBFIXBUF_VERSION 1.6.2
ENV LIBFIXBUF_MD5 ecf4e026a0fb0f4c9b03c4200896b06e

RUN apt-get update && apt-get install -y libgnutls-dev libadns1-dev libglib2.0-dev liblzo2-2 liblzo2-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN buildDeps='curl gcc make' \
	&& set -x \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
	&& curl -SL "http://tools.netsa.cert.org/releases/libfixbuf-{$LIBFIXBUF_VERSION}.tar.gz" -o libfixbuf.tar.gz \
	&& echo "${LIBFIXBUF_MD5}  libfixbuf.tar.gz" | md5sum -c \
	&& mkdir -p /usr/src/libfixbuf \
	&& tar -xzf libfixbuf.tar.gz -C /usr/src/libfixbuf --strip-components=1 \
	&& rm libfixbuf.tar.gz \
	&& (cd /usr/src/libfixbuf && /usr/src/libfixbuf/configure) \
	&& make -C /usr/src/libfixbuf install \
	&& rm -rf /usr/src/libfixbuf \
	&& curl -SL "http://tools.netsa.cert.org/releases/silk-{$SILK_VERSION}.tar.gz" -o silk.tar.gz \
	&& echo "${SILK_MD5}  silk.tar.gz" | md5sum -c \
	&& mkdir -p /usr/src/silk \
	&& tar -xzf silk.tar.gz -C /usr/src/silk --strip-components=1 \
	&& rm silk.tar.gz \
	&& (cd /usr/src/silk && /usr/src/silk/configure) \
	&& make -C /usr/src/silk install \
	&& rm -rf /usr/src/silk \
	&& cp -r /usr/local/share/silk/etc/init.d/ /usr/local/etc/ \
	&& apt-get purge -y --auto-remove $buildDeps
