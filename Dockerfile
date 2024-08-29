# FROM quay.io/nebari/nebari-jupyterlab:2024.3.2
# Trying to build off a sort minimal jupyter image. This gives us the ability to run notebooks.
# Is this something the average crunchtope user would want?

# FROM quay.io/jupyter/minimal-notebook
# this fails on the coiled deployment b/c distribued is missing:

FROM quay.io/jupyter/scipy-notebook


USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    gfortran \
    gcc \
    g++ \
    # git \ # should be covered by base
    make \
    # python3 \ # should be covered by base
    # python3-pip \ # should be covered by base
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
    && rm /opt/petsc-3.15.5.tar.gz \
    && make PETSC_DIR=/opt/petsc-3.15.5 PETSC_ARCH=linux-gnu-opt check

# Clone and build CrunchFlow
WORKDIR /opt
RUN git clone https://bitbucket.org/crunchflow/crunchtope-dev.git \
    && mkdir -p /opt/crunch \
    && mv crunchtope-dev/source /opt/crunch/ \
    && cd /opt/crunch/source \
    && make

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up permissions for the default Jupyter user
RUN mkdir -p /home/jovyan/work && \
    chown -R 1000:100 /home/jovyan && \
    chmod -R 775 /home/jovyan

# Set working directory
WORKDIR /home/jovyan/work

# Ensure the PATH is updated for all users
ENV PATH=$PATH:/opt/crunch/source

# Switch back to the default Jupyter user
USER 1000
