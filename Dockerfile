
FROM quay.io/nebari/nebari-jupyterlab:2024.3.2


# FROM pangeo/pangeo-notebook:latest 

# USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
#     curl \ 
    wget \ 
#     htop 

# ENV JAVA_HOME=/usr/bin/java
# ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/bin/java
# ENV=/usr/lib/jvm/java-17-openjdk-amd64

# ENV PYSPARK_PYTHON=/srv/conda/envs/notebook/bin/python
# ENV SPARK_HOME=${SPARK_HOME:-"/opt/spark"}
# RUN mkdir -p ${SPARK_HOME}
# WORKDIR ${SPARK_HOME}



# USER root

# RUN curl https://dlcdn.apache.org/spark/spark-3.5.1/spark-3.5.1-bin-hadoop3.tgz --output spark-3.5.1-bin-hadoop3.tgz \
# && tar xvzf spark-3.5.1-bin-hadoop3.tgz --strip-components 1  \
# && rm -rf spark-3.5.1-bin-hadoop3.tgz



# ENV PYSPARK_DRIVER_PYTHON=/srv/conda/envs/notebook/lib/python3.11/site-packages/pyspark



# build locally for m1
# docker build -t pyspark_test . --platform linux/arm64 --no-cache

# startup new container: docker run -it --name pyspark5 pyspark_test:latest /bin/bash
# docker stop < name> : ex > docker stop pyspark:latest