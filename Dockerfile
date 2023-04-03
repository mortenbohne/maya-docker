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
    libxkbcommon

RUN yum clean all


FROM base AS mayabase
COPY Autodesk_Maya_2023_ML_Linux_64bit.tgz maya.tgz
RUN mkdir "maya_install" && \
    tar -xvf maya.tgz -C /maya_install && \
    rm maya.tgz && \
    rpm -ivh /maya_install/Packages/Maya*.rpm && \
    rm -r maya_install

FROM base AS maya
COPY --from=mayabase usr/autodesk usr/autodesk
ENV MAYA_LOCATION=/usr/autodesk/maya2023/
ENV PATH=$MAYA_LOCATION/bin:$PATH
# Workaround for "Segmentation fault (core dumped)"
# See https://forums.autodesk.com/t5/maya-general/render-crash-on-linux/m-p/5608552/highlight/true
ENV MAYA_DISABLE_CIP=1
ENV DISPLAY :99
RUN mkdir /var/tmp/runtime-root && \
    chmod 0700 /var/tmp/runtime-root
ENV XDG_RUNTIME_DIR=/var/tmp/runtime-root
