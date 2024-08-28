
FROM quay.io/nebari/nebari-jupyterlab:2024.3.2

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    gfortran \
    gcc \
    g++ \
    git \
    make \
    python3 \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PETSC_DIR=/opt/petsc-3.15.5
ENV PETSC_ARCH=linux-gnu-opt
ENV PATH=$PATH:/opt/crunch/source

WORKDIR /opt
RUN wget https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.15.5.tar.gz \
    && tar -xzf petsc-3.15.5.tar.gz \
    && cd petsc-3.15.5 \
    && ./configure --with-cc=gcc --with-cxx=g++ --with-fc=gfortran --download-fblaslapack --with-mpi=0 --with-debugging=0 --with-shared-libraries=0 --with-x=0 PETSC_ARCH=linux-gnu-opt \
    && make PETSC_DIR=/opt/petsc-3.15.5 PETSC_ARCH=linux-gnu-opt all \
    && rm /opt/petsc-3.15.5.tar.gz

WORKDIR /opt
RUN git clone https://github.com/CISteefel/CrunchTope.git \
    && mv crunchtope-dev/source crunch \
    && cd crunch \
    && make

WORKDIR /
