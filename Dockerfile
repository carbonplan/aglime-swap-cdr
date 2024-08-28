
FROM quay.io/nebari/nebari-jupyterlab:2024.3.2


RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    gfortran \
    gcc \
    g++ \
    python3 \
    python3-pip \
    git \
    make \
    xz-utils \


SHELL ["/bin/bash", "-c"]


# Install PETSc
ENV PETSC_VERSION=3.15.5
ENV PETSC_DIR=/opt/petsc-${PETSC_VERSION}
ENV PETSC_ARCH=linux-gnu-opt

RUN mkdir -p /opt/crunch \
    && cd /opt/crunch \
    && wget https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-${PETSC_VERSION}.tar.gz \
    && tar -xzf petsc-${PETSC_VERSION}.tar.gz \
    && cd petsc-${PETSC_VERSION} \
    && ./configure --with-cc=gcc --with-cxx=g++ --with-fc=gfortran --download-fblaslapack --with-mpi=0 --with-debugging=0 --with-shared-libraries=0 --with-x=0 PETSC_ARCH=${PETSC_ARCH} \
    && make PETSC_DIR=${PETSC_DIR} PETSC_ARCH=${PETSC_ARCH} all

# Clone and build CrunchFlow
RUN cd /opt/crunch \
    && git clone https://bitbucket.org/crunchflow/crunchtope-dev.git \
    && cd crunchtope-dev/source \
    && make

# Add CrunchFlow to PATH
ENV PATH=$PATH:/opt/crunch/crunchtope-dev/source
