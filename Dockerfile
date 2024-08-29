FROM quay.io/nebari/nebari-jupyterlab:2024.3.2

# Switch to root to install packages and make system changes
USER root

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

WORKDIR /opt
RUN wget https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.15.5.tar.gz \
    && tar -xzf petsc-3.15.5.tar.gz \
    && cd petsc-3.15.5 \
    && ./configure --with-cc=gcc --with-cxx=g++ --with-fc=gfortran --download-fblaslapack --with-mpi=0 --with-debugging=0 --with-shared-libraries=0 --with-x=0 PETSC_ARCH=linux-gnu-opt \
    && make PETSC_DIR=/opt/petsc-3.15.5 PETSC_ARCH=linux-gnu-opt all \
    && rm /opt/petsc-3.15.5.tar.gz \
    && make PETSC_DIR=/opt/petsc-3.15.5 PETSC_ARCH=linux-gnu-opt check

# Clone and build CrunchFlow
WORKDIR /opt
RUN git clone https://bitbucket.org/crunchflow/crunchtope-dev.git \
    && cd crunchtope-dev \
    && mkdir -p /opt/crunch \
    && mv source /opt/crunch/

# Add CrunchFlow to PATH
ENV PATH=$PATH:/opt/crunch/source

# Build CrunchFlow
WORKDIR /opt/crunch/source
RUN make

# Create jovyan user and set permissions
RUN useradd -m -s /bin/bash -N jovyan \
    && chown -R jovyan:jovyan /opt/crunch /opt/petsc-3.15.5 \
    && chmod -R 755 /opt/crunch /opt/petsc-3.15.5

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set working directory
WORKDIR /home/jovyan/work

# Switch to jovyan user
USER jovyan