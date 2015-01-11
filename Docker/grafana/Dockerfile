FROM adomenech73/base
MAINTAINER Albert Domenech <adomenech@gmail.com>

ENV GF_PKG_NAME grafana-1.9.1

# install nginx
RUN apt-get update && apt-get install -y nginx && \
  rm -rf /var/lib/apt/lists/* && \
  # install grafana
  mkdir /opt/grafana && \
  cd /opt/grafana && \
  wget http://grafanarel.s3.amazonaws.com/$GF_PKG_NAME.tar.gz && \
  tar xzvf $GF_PKG_NAME.tar.gz --strip-components=1 && \
  rm $GF_PKG_NAME.tar.gz && \
  cd /

# Configure grafana
ADD ./grafana/config.js /opt/grafana/config.js

# Configure nginx
ADD ./nginx/nginx.conf /etc/nginx/nginx.conf

# Configure supervisord
ADD ./supervisor/nginx.conf /etc/supervisor/conf.d/nginx.conf
# start supervisor
CMD ["/usr/bin/supervisord"]

# expose nginx
EXPOSE 8081
