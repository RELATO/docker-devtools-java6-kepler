FROM relato/openjdk6

MAINTAINER RELATO <consultoria@relato.com.br>

ENV STD_DOWNLOAD_URL http://eclipse.c3sl.ufpr.br/technology/epp/downloads/release/kepler/SR2/eclipse-standard-kepler-SR2-linux-gtk-x86_64.tar.gz
ENV JEE_DOWNLOAD_URL http://eclipse.c3sl.ufpr.br/technology/epp/downloads/release/kepler/SR2/eclipse-jee-kepler-SR2-linux-gtk-x86_64.tar.gz
ENV INSTALLATION_DIR /usr/local

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
 && apt-get install -y software-properties-common curl locales \
 \
 && apt-get install -y libgtk2.0-0 libxtst6 \
 \
 && curl "$JEE_DOWNLOAD_URL" | tar vxz -C $INSTALLATION_DIR \
 && adduser --disabled-password --quiet --gecos '' eclipse \
 && chown -R root:eclipse $INSTALLATION_DIR/eclipse \
 && chmod -R 775 $INSTALLATION_DIR/eclipse 

# Set locales
RUN locale-gen pt_BR.UTF-8
RUN locale-gen pt_BR
ENV LANG pt_BR.ISO-8859-1
ENV LANGUAGE pt_BR:pt:en
ENV LC_CTYPE pt_BR.ISO-8859-1
 
RUN DEBIAN_FRONTEND=noninteractive curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -  \
  && sudo apt-get install nodejs  \
  && npm install -g @angular/cli@1.1.3  \
  && npm install -g yarn  \
  && ng set --global packageManager=yarn  \
  && yarn global add yo grunt-cli gulp-cli  \
  && npm install -g node-gyp \
  && npm install -g npm  \
  && npm cache clear\
  && node-gyp configure || echo "" \
  && npm install -g generator-jhipster

RUN DEBIAN_FRONTEND=noninteractive apt-get --purge autoremove -y software-properties-common curl \
 && apt-get clean

RUN wget --quiet --no-cookies http://www-us.apache.org/dist/ant/binaries/apache-ant-1.9.9-bin.tar.gz \
  -O /tmp/ant.tgz && \
  tar xzvf /tmp/ant.tgz -C /opt && \
  mv /opt/apache-ant-1.9.9 /opt/ant && \
  rm /tmp/ant.tgz && \
  wget --quiet --no-cookies http://www-us.apache.org/dist/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz \
  -O /tmp/maven.tgz && \
  tar xzvf /tmp/maven.tgz -C /opt && \
  mv /opt/apache-maven-3.0.5 /opt/maven && \
  rm /tmp/maven.tgz 

ADD locale /etc/default/locale
#ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
RUN ln -s /usr/lib/jvm/java-6-openjdk-amd64 /opt/java 
ENV JAVA_HOME /opt/java
ENV ANT_HOME /opt/ant
ENV M2_HOME /opt/maven
ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$JAVA_HOME/bin:$ANT_HOME/bin:$M2_HOME/bin:$CATALINA_HOME/bin

VOLUME "/data"

USER root
ENTRYPOINT $INSTALLATION_DIR/eclipse/eclipse
