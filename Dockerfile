FROM rockylinux:8.6 AS base
RUN yum install -y  \
    libgomp \
    libXpm \
    libXdamage \
    freetype \
    mesa-libGLU \
    libtiff \
    mesa-libGLw \
    libpng15 \
    nss \
    libXcomposite \
    libXtst \
    alsa-lib-devel \
    libxkbcommon \
    pciutils-libs \
    xcb-util-wm \
    xcb-util-image \
    xcb-util-keysyms \
    xcb-util-renderutil \
    libxkbcommon-x11 && \
    yum clean all


FROM base AS maya-install
ADD https://efulfillment.autodesk.com/NetSWDLD/2024/MAYA/537B71D7-A391-3E25-93C3-9967181B3F34/ESD/Autodesk_Maya_2024_Linux_64bit.tgz maya.tgz
RUN mkdir "maya_install" && \
    tar -xvf maya.tgz -C /maya_install && \
    rpm -ivh /maya_install/Packages/Maya*.rpm

FROM base AS maya-base
COPY --from=maya-install usr/autodesk/modules usr/autodesk/modules
COPY --from=maya-install usr/autodesk/mayausd usr/autodesk/mayausd
COPY --from=maya-install usr/autodesk/maya2024/bin usr/autodesk/maya2024/bin
COPY --from=maya-install usr/autodesk/maya2024/libexec usr/autodesk/maya2024/libexec
COPY --from=maya-install usr/autodesk/maya2024/modules usr/autodesk/maya2024/modules
COPY --from=maya-install usr/autodesk/maya2024/resources usr/autodesk/maya2024/resources
COPY --from=maya-install usr/autodesk/maya2024/lib usr/autodesk/maya2024/lib
COPY --from=maya-install usr/autodesk/maya2024/modules usr/autodesk/maya2024/modules
COPY --from=maya-install usr/autodesk/maya2024/plugins usr/autodesk/maya2024/plugins
COPY --from=maya-install usr/autodesk/maya2024/scripts usr/autodesk/maya2024/scripts

ENV MAYA_LOCATION=/usr/autodesk/maya2024/
ENV PATH=$MAYA_LOCATION/bin:$PATH
# Workaround for "Segmentation fault (core dumped)"
# See https://forums.autodesk.com/t5/maya-general/render-crash-on-linux/m-p/5608552/highlight/true
ENV MAYA_DISABLE_CIP=1
ENV DISPLAY :99
RUN mkdir /var/tmp/runtime-root && \
    chmod 0700 /var/tmp/runtime-root
ENV XDG_RUNTIME_DIR=/var/tmp/runtime-root
# avoid error when exiting maya after loading pymel
ENV MAYA_NO_STANDALONE_ATEXIT=1
