FROM adomenech73/basejava
MAINTAINER Albert Domenech <adomenech@gmail.com>

ENV ES_PKG_NAME elasticsearch-1.4.2

RUN cd / && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.deb && \
  dpkg -i $ES_PKG_NAME.deb && \
  rm $ES_PKG_NAME.deb && \
  chown -R elasticsearch:elasticsearch /var/lib/elasticsearch && \
  mkdir -p /tmp/elasticsearch && \
  chown elasticsearch:elasticsearch /tmp/elasticsearch

# Configure elasticsearch
ADD ./elasticsearch/elasticsearch-start /usr/local/bin/elasticsearch-start
RUN chmod 755 /usr/local/bin/elasticsearch-start

# Define mountable directories.
VOLUME ["/data/elasticsearch"]
# Define working directory.
WORKDIR /data

# Configure supervisord
ADD ./supervisor/elasticsearch.conf /etc/supervisor/conf.d/elasticsearch.conf

# start supervisor
CMD ["/usr/bin/supervisord"]

# Expose ports.
# - 9200: HTTP
# - 9300: transport
EXPOSE 9200
EXPOSE 9300
