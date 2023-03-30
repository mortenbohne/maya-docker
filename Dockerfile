FROM rockylinux:8.5 as base

RUN yum install -y \
    libXp \
    libXmu \
    libXpm \
    libXi \
    libtiff \
    libXinerama


ENV DISPLAY :99

FROM base as mayabase
COPY Autodesk_Maya_2024_Linux_64bit.tgz maya.tgz
RUN mkdir "maya_install" && \
    tar -xvf maya.tgz -C /maya_install && \
    rm maya.tgz && \
    rpm -Uvh /maya_install/Packages/Maya*.rpm && \
    rm -r maya_install

