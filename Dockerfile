FROM debian:latest AS deb_build_image

#docker build --no-cache --progress=plain -f Dockerfile .

RUN apt-get -y update && apt-get -y upgrade && mkdir -p /var/opt/setmy.info/build && \
    apt-get -y install cpp gcc g++ libboost-test-dev libboost-dev libboost-program-options-dev valgrind libjpeg-dev libtiff-dev make dos2unix gzip bzip2 xz-utils zip


WORKDIR /opt
ADD https://github.com/Kitware/CMake/releases/download/v4.4.5/cmake-4.4.5-linux-x86_64.tar.gz /opt
RUN tar xvzf cmake-4.4.5-linux-x86_64.tar.gz && ln -s /opt/cmake-4.4.5-linux-x86_64 /opt/cmake && ls -la

WORKDIR /var/opt/setmy.info/build

COPY ./src/ ./src/
COPY CMakeLists.txt ./
COPY configure ./
COPY changelog ./
RUN dos2unix **/* && dos2unix ./configure ./src/main/sh/build/*.sh && chmod ugoa+x ./configure ./src/main/sh/build/*.sh

RUN ./src/main/sh/build/packages-build.sh

RUN apt install -y ./cpp-start-project-1.0.0.x86_64.deb
RUN ./src/main/sh/build/check-files.sh
RUN ls -la /opt/setmy.info

FROM setmyinfo/setmy-info-rocky:latest AS rpm_build_image

RUN dnf install -y epel-release && \
    dnf --enablerepo=epel group && \
    dnf config-manager --set-enabled crb && \
    dnf config-manager --set-enabled plus && \
    dnf config-manager --set-enabled rt && \
    dnf update -y && \
    mkdir -p /var/opt/setmy.info/build && \
    dnf install -y cpp gcc g++ boost-test boost-devel boost-program-options valgrind libjpeg-devel libtiff libtiff-devel libtiff gtk4 gtk4-devel eog make dos2unix yum-utils rpmdevtools rpm-build rpm rpmlint

WORKDIR /opt
ADD https://github.com/Kitware/CMake/releases/download/v4.4.5/cmake-4.4.5-linux-x86_64.tar.gz /opt
RUN tar xvzf cmake-4.4.5-linux-x86_64.tar.gz && ln -s /opt/cmake-4.4.5-linux-x86_64 /opt/cmake && ls -la

WORKDIR /var/opt/setmy.info/build

COPY ./src/ ./src/
COPY CMakeLists.txt ./
COPY configure ./
COPY changelog ./
RUN dos2unix **/* && dos2unix ./configure ./src/main/sh/build/*.sh && chmod ugoa+x ./configure ./src/main/sh/build/*.sh
COPY --from=deb_build_image /var/opt/setmy.info/build/cpp-start-project-1.0.0.x86_64.deb /var/opt/setmy.info/build/cpp-start-project-1.0.0.x86_64.deb

RUN ./src/main/sh/build/packages-build.sh
RUN ls -la
RUN rpm -e cpp-start-project || true
RUN rpm -i ./cpp-start-project-1.0.0.x86_64.rpm
RUN ./src/main/sh/build/check-files.sh
RUN ls -la /opt/setmy.info
