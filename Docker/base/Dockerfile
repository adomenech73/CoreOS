# adomenech Base image is a ubuntu
#
# VERSION               0.0.1
FROM      ubuntu
MAINTAINER Albert Domenech <adomenech@gmail.com>


# Set locale
RUN locale-gen --no-purge es_ES.UTF-8
ENV LC_ALL es_ES.UTF-8

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl
# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  software-properties-common \
  python-software-properties \
  supervisor \
  python-pip \
  wget && \
  rm -rf /var/lib/apt/lists/*

RUN echo "supervisor-stdout" > base_reqs.txt && \
 pip install -r base_reqs.txt && \
 rm -rf ~/.pip/cache && \
 rm -rf build

RUN mkdir -p /var/log/supervisor

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
