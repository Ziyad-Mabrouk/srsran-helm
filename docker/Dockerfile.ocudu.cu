ARG OS_VERSION=24.04
ARG ROHC_VERSION=2.3.1
ARG OCUDU_VERSION=release_26_04

FROM ubuntu:${OS_VERSION} AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    build-essential \
    cmake \
    pkg-config \
    autoconf \
    automake \
    autotools-dev \
    libtool \
    libpcap-dev \
    libcmocka-dev \
    libfftw3-dev \
    libmbedtls-dev \
    libsctp-dev \
    libyaml-cpp-dev \
    libgtest-dev \
    && rm -rf /var/lib/apt/lists/*

ARG ROHC_VERSION

RUN curl -fsSL \
    "https://rohc-lib.org/download/rohc-${ROHC_VERSION%.*}.x/${ROHC_VERSION}/rohc-${ROHC_VERSION}.tar.xz" \
    -o /tmp/rohc.tar.xz \
    && tar -xf /tmp/rohc.tar.xz -C /tmp \
    && cd "/tmp/rohc-${ROHC_VERSION}" \
    && ./autogen.sh \
    && ./configure --prefix=/opt/rohc \
    && make -j"$(nproc)" \
    && make install \
    && rm -rf /tmp/rohc-* \
    && ldconfig

ARG OCUDU_VERSION

RUN git clone --depth 1 --branch "${OCUDU_VERSION}" \
    https://gitlab.com/ocudu/ocudu.git /src

WORKDIR /src

ENV ROHC_DIR=/opt/rohc

RUN cmake -S . -B build \
    -DBUILD_TESTING=OFF \
    -DENABLE_UHD=Off \
    -DENABLE_DPDK=Off \
    -DCMAKE_INSTALL_PREFIX=/opt/ocudu \
    && cmake --build build --target ocu -- -j"$(nproc)" \
    && mkdir -p /opt/ocudu/bin \
    && cp build/apps/cu/ocu /opt/ocudu/bin/ocu

FROM ubuntu:${OS_VERSION}

ENV DEBIAN_FRONTEND=noninteractive
ENV LD_LIBRARY_PATH=/opt/rohc/lib:/opt/rohc/lib64

RUN apt-get update && apt-get install -y --no-install-recommends \
    libfftw3-dev \
    libmbedtls-dev \
    libsctp-dev \
    libyaml-cpp-dev \
    libgtest-dev \
    libcap2-bin \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/rohc /opt/rohc
COPY --from=builder /opt/ocudu/bin/ocu /usr/local/bin/ocu

RUN printf '%s\n' \
    /opt/rohc/lib \
    /opt/rohc/lib64 \
    > /etc/ld.so.conf.d/ocudu.conf \
    && ldconfig \
    && setcap cap_sys_nice,cap_ipc_lock+ep /usr/local/bin/ocu

ENTRYPOINT ["/usr/local/bin/ocu"]