FROM setmyinfo/setmy-info-rocky

RUN mkdir -p /var/opt/setmy-info/build
RUN chown -R microservice:microservice /var/opt/setmy-info/build
RUN dnf install -y cpp gcc g++ boost-test boost-devel boost-program-options valgrind libjpeg-devel libtiff libtiff-devel libtiff gtk4 gtk4-devel eog make dos2unix yum-utils rpmdevtools rpm-build

WORKDIR /opt
ADD https://github.com/Kitware/CMake/releases/download/v3.30.2/cmake-3.30.2-linux-x86_64.tar.gz /opt
RUN tar xvzf cmake-3.30.2-linux-x86_64.tar.gz && ln -s /opt/cmake-3.30.2-linux-x86_64 /opt/cmake && ls -la

WORKDIR /var/opt/setmy-info/build

COPY ./src/ ./src/
COPY ./CMakeLists.txt ./
COPY ./configure ./
ENV PROJECT_VERSION="1.0.0"
ENV PATH=/opt/cmake/bin:$PATH
RUN cmake --version && make --version && g++ --version
RUN pwd
RUN ls -la
RUN dos2unix **/*
RUN dos2unix ./configure
RUN ./configure release && make clean && make all test package && sudo rpm -e cpp-start-project && sudo rpm -i cpp-start-project-${PROJECT_VERSION}.x86_64.rpm
