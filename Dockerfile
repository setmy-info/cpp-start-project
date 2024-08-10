FROM setmyinfo/setmy-info-rocky:latest as RPM_BUILD_IMAGE

RUN mkdir -p /var/opt/setmy-info/build && \
    chown -R microservice:microservice /var/opt/setmy-info/build && \
    dnf install -y cpp gcc g++ boost-test boost-devel boost-program-options valgrind libjpeg-devel libtiff libtiff-devel libtiff gtk4 gtk4-devel eog make dos2unix yum-utils rpmdevtools rpm-build gzip bzip2 xz zip rpm tree rpmlint file

WORKDIR /opt
ADD https://github.com/Kitware/CMake/releases/download/v3.30.2/cmake-3.30.2-linux-x86_64.tar.gz /opt
RUN tar xvzf cmake-3.30.2-linux-x86_64.tar.gz && ln -s /opt/cmake-3.30.2-linux-x86_64 /opt/cmake && ls -la

WORKDIR /var/opt/setmy-info/build

COPY ./src/ ./src/
COPY CMakeLists.txt ./
COPY configure ./
RUN dos2unix **/* && dos2unix ./configure && dos2unix ./src/main/sh/build/packages-build.sh &&  chmod ugoa+x ./src/main/sh/build/packages-build.sh

RUN ./src/main/sh/build/packages-build.sh

FROM debian:latest as DEBBUILD_IMAGE

RUN mkdir -p /var/opt/setmy-info/build && \
    chown -R microservice:microservice /var/opt/setmy-info/build && \
    dnf install -y cpp gcc g++ boost-test boost-devel boost-program-options valgrind libjpeg-devel libtiff libtiff-devel libtiff gtk4 gtk4-devel eog make dos2unix yum-utils rpmdevtools rpm-build gzip bzip2 xz zip rpm tree rpmlint file

WORKDIR /opt
ADD https://github.com/Kitware/CMake/releases/download/v3.30.2/cmake-3.30.2-linux-x86_64.tar.gz /opt
RUN tar xvzf cmake-3.30.2-linux-x86_64.tar.gz && ln -s /opt/cmake-3.30.2-linux-x86_64 /opt/cmake && ls -la

WORKDIR /var/opt/setmy-info/build

COPY ./src/ ./src/
COPY CMakeLists.txt ./
COPY configure ./
RUN dos2unix **/* && dos2unix ./configure && dos2unix ./src/main/sh/build/packages-build.sh &&  chmod ugoa+x ./src/main/sh/build/packages-build.sh

RUN ./src/main/sh/build/packages-build.sh
