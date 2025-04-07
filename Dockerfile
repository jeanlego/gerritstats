FROM ubuntu:22.04

# Install OpenJDK-8
RUN apt-get update && apt-get install -y \
	openjdk-8-jdk \
	openjdk-11-jdk \
    	ant \
    	ca-certificates-java \
	ca-certificates \
	unzip \
	wget \
	git \
	curl
	
ENV GRADLE_VERSION=6.3
ENV GRADLE_HOME=/opt/gradle/latest
ENV PATH=${GRADLE_HOME}/bin:${PATH}
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp \
	&& unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip \
	&& ln -s /opt/gradle/gradle-${GRADLE_VERSION} ${GRADLE_HOME}
	
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

ENV NVM_DIR=/opt/nvm
RUN mkdir -p "${NVM_DIR}"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash \
	&& . ${NVM_DIR}/nvm.sh \
	&& nvm install 6.17.1 \
	&& nvm alias default 6.17.1 nvm use 6.17.1 \
	&& npm install -g http-server

RUN mkdir -p /opt/gerritstats
WORKDIR /opt/gerritstats
ADD * /opt/gerritstats/
ADD .* /opt/gerritstats/

RUN . ${NVM_DIR}/nvm.sh \
	&& gradle wrapper \
	&& ./gradlew assemble

ENTRYPOINT [ "/opt/gerritstats/launch.sh" ]

