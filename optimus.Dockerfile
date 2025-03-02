# last modified: 2025.03.02

FROM ubuntu:22.04

ENV PYTHON_VERSION 3.11.11

RUN apt-get update
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN (apt-get install -y --no-install-recommends \
        ca-certificates \
        build-essential \
        software-properties-common \
        curl \
        cmake \
        lcov \
        valgrind \
        gettext-base \
        jq \
        wget \
        git \
        gnupg \
        hdf5-tools \
        libhdf5-serial-dev \
        gfortran \
        libopenblas-dev \
        liblapack-dev \
        libboost-all-dev \
        libzmq3-dev \
        libssl-dev \
        libmetis-dev \
        pkg-config \
        zlib1g-dev \
        openssh-client \
        openjdk-11-jdk \
        g++ unzip zip \
        openjdk-11-jre-headless)


# Install Python
WORKDIR /tmp/
RUN (wget -P /tmp https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz)
RUN tar -zxvf Python-$PYTHON_VERSION.tgz
WORKDIR /tmp/Python-$PYTHON_VERSION
RUN apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y


RUN apt-get install -y --no-install-recommends libbz2-dev libncurses5-dev libgdbm-dev libgdbm-compat-dev liblzma-dev libsqlite3-dev libssl-dev openssl tk-dev uuid-dev libreadline-dev
RUN apt-get install -y --no-install-recommends libffi-dev
RUN ./configure --prefix=/usr/local/python3 && \
        make && \
        make install
RUN update-alternatives --install /usr/bin/python python /usr/local/python3/bin/python3 1
RUN update-alternatives --install /usr/bin/pip pip /usr/local/python3/bin/pip3 1
RUN update-alternatives --config python
RUN update-alternatives --config pip
RUN pip install --upgrade pip
RUN (pip install grpcio numpy && touch /root/WORKSPACE)

# 更换默认pip源
RUN mkdir /root/.pip
RUN echo "[global]" >> /root/.pip/pip.conf
RUN echo "index-url=http://mirrors.aliyun.com/pypi/simple/" >> /root/.pip/pip.conf
RUN echo "trusted-host=mirrors.aliyun.com" >> /root/.pip/pip.conf


# Install bazel
# ENV BAZEL_VERSION 8.1.1
# RUN (wget -P /tmp https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh)
# RUN (chmod +x /tmp/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh)
# RUN bash /tmp/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh

RUN (git clone https://github.com/xianyi/OpenBLAS.git)
RUN (cd OpenBLAS && make FC=gfortran && make PREFIX=/usr/local install)

# GoogleTest v1.16.0
RUN git clone -q https://github.com/google/googletest.git /tmp/googletest
RUN cd /tmp/googletest \
       && git checkout v1.16.0 \
       && mkdir -p /tmp/googletest/build \
       && cd /tmp/googletest/build \
       && cmake .. && make && make install \
       && rm -rf /tmp/googletest


# Google benchmark v1.9.1
RUN git clone -q https://github.com/google/benchmark.git /tmp/benchmark
RUN cd /tmp/benchmark \
       && git checkout v1.9.1 \
       && mkdir -p /tmp/benchmark/build \
       && cd /tmp/benchmark/build \
       && cmake -DCMAKE_BUILD_TYPE=Release -DBENCHMARK_ENABLE_GTEST_TESTS=ON \
          -DBENCHMARK_DOWNLOAD_DEPENDENCIES=OFF -DCMAKE_INSTALL_PREFIX=/usr/local .. \
       && make install \
       && rm -rf /tmp/benchmark

# clean
RUN rm -rf /tmp/* && \
        rm -rf /var/lib/apt/lists/* && \
        rm -rf /root/.cache/pip

WORKDIR /root

RUN update-alternatives --install /usr/bin/python3 python3 /usr/local/python3/bin/python3 1
RUN update-alternatives --install /usr/bin/pip3 pip3 /usr/local/python3/bin/pip3 1
RUN update-alternatives --config python3
RUN update-alternatives --config pip3

# https://github.com/pypa/pip/issues/4924
RUN mv /usr/bin/lsb_release /usr/bin/lsb_release.bak

CMD ["bin/bash"]