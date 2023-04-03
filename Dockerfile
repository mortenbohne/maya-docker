FROM rockylinux:8.5 AS base
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
    libxkbcommon && \
    yum clean all


FROM base AS maya-install
ADD https://efulfillment.autodesk.com/NetSWDLD/2023/MAYA/EC4CAAD2-186E-37F3-911B-DDEBDF7486CF/SFX//Autodesk_Maya_2023_3_Update_Linux_64bit.tgz maya.tgz
RUN mkdir "maya_install" && \
    tar -xvf maya.tgz -C /maya_install && \
    rpm -ivh /maya_install/Packages/Maya*.rpm

FROM base AS maya-base
COPY --from=maya-install usr/autodesk/maya2023/bin usr/autodesk/maya2023/bin
COPY --from=maya-install usr/autodesk/maya2023/libexec usr/autodesk/maya2023/libexec
COPY --from=maya-install usr/autodesk/maya2023/modules usr/autodesk/maya2023/modules
COPY --from=maya-install usr/autodesk/maya2023/resources usr/autodesk/maya2023/resources
COPY --from=maya-install usr/autodesk/maya2023/lib usr/autodesk/maya2023/lib
COPY --from=maya-install usr/autodesk/maya2023/modules usr/autodesk/maya2023/modules
COPY --from=maya-install usr/autodesk/maya2023/plugins usr/autodesk/maya2023/plugins
COPY --from=maya-install usr/autodesk/maya2023/scripts usr/autodesk/maya2023/scripts
ENV MAYA_LOCATION=/usr/autodesk/maya2023/
ENV PATH=$MAYA_LOCATION/bin:$PATH
# Workaround for "Segmentation fault (core dumped)"
# See https://forums.autodesk.com/t5/maya-general/render-crash-on-linux/m-p/5608552/highlight/true
ENV MAYA_DISABLE_CIP=1
ENV DISPLAY :99
RUN mkdir /var/tmp/runtime-root && \
    chmod 0700 /var/tmp/runtime-root
ENV XDG_RUNTIME_DIR=/var/tmp/runtime-root

FROM maya-base as maya
COPY requirements.txt requirements.txt
RUN mayapy -m pip install -r requirements.txt