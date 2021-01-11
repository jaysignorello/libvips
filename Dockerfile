FROM debian:buster-slim as base

LABEL maintainer "hello@jaysignorello.com"

RUN apt-get update -qq && apt-get install -y build-essential wget \
  libde265-dev libheif1 libheif-dev libexif-dev libopenslide-dev libgsf-1-dev libopenjp2-7-dev \
  libexpat1-dev libjbig-dev  zlib1g-dev libtiff5-dev libpng16-16 libpng-dev libjbig2dec0 \
  libwebp6 libwebp-dev libgomp1 libwebpmux3 pkg-config libbz2-dev libxml2-dev ghostscript

ARG VIPS_VERSION=8.10.5
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

RUN wget ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
  && tar xf vips-${VIPS_VERSION}.tar.gz \
  && cd vips-${VIPS_VERSION} \
  && ./configure \
  && make V=0 \
  && make install \
  && cd ../ \
  && rm -fr vips* \
  && ldconfig

# Clean up
RUN apt-get remove -y automake curl wget build-essential && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD [ "/bin/bash" ]
