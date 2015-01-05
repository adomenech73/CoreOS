FROM adomenech73/base
MAINTAINER Albert Domenech <adomenech@gmail.com>


# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# install elasticsearch
RUN add-apt-repository -y ppa:webupd8team/java && \
  apt-get update -q && \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  oracle-java7-installer && \
  rm -rf /var/lib/apt/lists/*
  
  CMD ["/usr/bin/supervisord"]
