FROM ubuntu:trusty
MAINTAINER Ascensio System SIA <support@onlyoffice.com>

ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive QT_SELECT=qt56

RUN apt-get -y update && \
    apt-get install --force-yes -yq apt-transport-https locales software-properties-common curl && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    locale-gen en_US.UTF-8 && \
    apt-get -y update && \
    apt-get install --force-yes -yq \
        wget \
        build-essential \
        sed \
        dpkg-dev \
        debhelper \
        createrepo \
        libxml2-dev \
        libcurl4-gnutls-dev \
        libglib2.0-dev \
        libgdk-pixbuf2.0-dev \
        libgtkglext1-dev \
        libatk1.0-dev \
        libcairo2-dev \
        libxss-dev \
        libgconf2-dev \
        default-jre \
        qtchooser \
        "^libxcb.*" \
        libx11-xcb-dev \
        libglu1-mesa-dev \
        libxrender-dev \
        libcups2-dev \
        nodejs \
        p7zip-full \
        git \
        subversion \
        python-pip && \
    wget http://download.qt.io/official_releases/qt/5.6/5.6.1/single/qt-everywhere-opensource-src-5.6.1.tar.gz && \
    tar -xvzf qt-everywhere-opensource-src-5.6.1.tar.gz && \
    rm qt-everywhere-opensource-src-5.6.1.tar.gz && \
    cd qt-everywhere-opensource-src-5.6.1 && \
    ./configure -opensource -confirm-license -release -static -accessibility \
      -qt-zlib -qt-libpng -qt-libjpeg -qt-xcb -qt-pcre -qt-freetype -no-glib \
      -no-cups -no-sql-sqlite -no-qml-debug -no-egl -no-sm -nomake examples \
      -nomake tests -skip qtenginio -skip qtlocation -skip qtmultimedia \
      -skip qtserialport -skip qtsensors -skip qtwebsockets \
      -skip qtxmlpatterns -skip qt3d && \
    make -j $(grep -c ^processor /proc/cpuinfo) && \
    make install && \
    mkdir -p /etc/xdg/qtchooser && \
    printf "/usr/local/Qt-5.6.0/bin\n/usr/local/Qt-5.6.0/lib" > /etc/xdg/qtchooser/qt56.conf && \
    npm install -g npm && \
    npm install -g grunt-cli && \
    npm cache clean && \
    pip install awscli && \
    rm -rf /var/lib/apt/lists/*

ADD build.sh /app/onlyoffice/build.sh

VOLUME /var/lib/onlyoffice

CMD bash -C '/app/onlyoffice/build.sh'
