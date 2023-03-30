FROM rockylinux:8.5 AS base
RUN yum install -y  \
    libSM  \
    libICE  \
    nss
    #missing libprcre16
RUN yum install -y \
    mesa-libGLU \
    mesa-libGLw \
    gamin \
    e2fsprogs-libs \
    libmng \
    speech-dispatcher \
    cups \
    libpng15
    # audiofile-devel
RUN yum install -y \
    libXcomposite \
    libXScrnSaver \
    xcb-util \
    xcb-util-wm \
    xcb-util-image \
    xcb-util-keysyms \
    xcb-util-renderutil \
    libxkbcommon \
    libxkbcommon-x11 \
    libX11
    # missing cups
RUN yum install -y \
    xorg-x11-fonts-ISO8859-1-75dpi \
    xorg-x11-fonts-ISO8859-1-100dpi \
    liberation-sans-fonts \
    liberation-serif-fonts
RUN yum clean all


FROM base AS mayabase
COPY Autodesk_Maya_2024_Linux_64bit.tgz maya.tgz
RUN mkdir "maya_install" && \
    tar -xvf maya.tgz -C /maya_install && \
    rm maya.tgz && \
    rpm -ivh /maya_install/Packages/Maya*.rpm && \
    rm -r maya_install
RUN mkdir "mortenstestfolder"

FROM rockylinux:8.5 AS maya
COPY --from=mayabase usr/autodesk usr/autodesk
ENV MAYA_LOCATION=/usr/autodesk/maya2023/
ENV PATH=$MAYA_LOCATION/bin:$PATH
# Workaround for "Segmentation fault (core dumped)"
# See https://forums.autodesk.com/t5/maya-general/render-crash-on-linux/m-p/5608552/highlight/true
ENV MAYA_DISABLE_CIP=1
ENV DISPLAY :99