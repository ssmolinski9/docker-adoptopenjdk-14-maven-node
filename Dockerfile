FROM ubuntu:16.04

MAINTAINER Sebastian Smolinski "sebastian.smolinski6@gmail.com"

ENV MAVEN_VERSION 3.6.3

RUN echo deb http://archive.ubuntu.com/ubuntu precise universe > /etc/apt/sources.list.d/universe.list
RUN apt-get update && apt-get install -y wget git curl zip monit openssh-server git iptables ca-certificates daemon net-tools libfontconfig-dev

#Install AdoptOpenJDK 14
#--------------------
RUN echo "# Installing AdoptOpenJDK 14" && \
    	wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add - && \
	add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
	apt-get install -y software-properties-common && \
	apt-get install adoptopenjdk-14-hotspot
	
# Maven related
# -------------
ENV MAVEN_ROOT /var/lib/maven
ENV MAVEN_HOME $MAVEN_ROOT/apache-maven-$MAVEN_VERSION
ENV MAVEN_OPTS -Xms256m -Xmx512m

RUN echo "# Installing Maven " && echo ${MAVEN_VERSION} && \
    wget --no-verbose -O /tmp/apache-maven-$MAVEN_VERSION.tar.gz \
    http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    mkdir -p $MAVEN_ROOT && \
    tar xzf /tmp/apache-maven-$MAVEN_VERSION.tar.gz -C $MAVEN_ROOT && \
    ln -s $MAVEN_HOME/bin/mvn /usr/local/bin && \
    rm -f /tmp/apache-maven-$MAVEN_VERSION.tar.gz

VOLUME /var/lib/maven

# Node related
# ------------

RUN echo "# Installing Nodejs" && \
    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
    apt-get install nodejs build-essential -y && \
    npm set strict-ssl false && \
    npm install -g npm@latest && \
    npm install -g bower grunt grunt-cli && \
    npm cache clear -f && \
    npm install -g n && \
    n stable
