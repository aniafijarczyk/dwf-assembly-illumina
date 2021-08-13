FROM ubuntu
# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;
    
# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# Install wget
RUN  apt-get update && \
     apt-get install -y wget && \
     rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget https://sourceforge.net/projects/bbmap/files/BBMap_38.91.tar.gz && tar -zxvf BBMap_38.91.tar.gz && rm -rf BBMap_38.91.tar.gz
WORKDIR /data
ENTRYPOINT ["../tmp/bbmap/bbmerge.sh"]
