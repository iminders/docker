# last modified: 2023.10.23

FROM ubuntu:20.04

# 2023.10.23
# ENV BAZEL_VERSION 5.2.0
# 2024.03.24
ENV BAZEL_VERSION 7.1.1
ENV PYTHON_VERSION 3.8.0

RUN apt-get update

RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN (apt-get install -y --no-install-recommends \
        ca-certificates \
        build-essential \
        software-properties-common \
        curl \
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


# Install bazel
RUN (wget -P /tmp https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh)
RUN (chmod +x /tmp/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh)
RUN bash /tmp/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh

RUN (git clone https://github.com/xianyi/OpenBLAS.git)
RUN (cd OpenBLAS && make FC=gfortran && make PREFIX=/usr/local install)

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