FROM adomenech73/base
MAINTAINER Albert Domenech <adomenech@gmail.com>

# Install MySQL.
RUN apt-get update && \
  apt-get install -y \
  mysql-server && \
  rm -rf /var/lib/apt/lists/*

ADD mysql/my.cnf /etc/mysql/my.cnf

RUN \
  sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf && \
  sed -i 's/^\(log_error\s.*\)/# \1/' /etc/mysql/my.cnf && \
  echo "mysqld_safe &" > /tmp/config && \
  echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config && \
  echo "mysqladmin create wordpress || exit 1"  >> /tmp/config && \
  echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" IDENTIFIED BY \"changeme\" WITH GRANT OPTION;'" >> /tmp/config && \
  bash /tmp/config && \
  rm -f /tmp/config

# Define mountable directories.
VOLUME ["/etc/mysql", "/var/lib/mysql"]

# Define working directory.
WORKDIR /data

# copy supervisor conf
ADD supervisor/mysql.conf /etc/supervisor/conf.d/mysql.conf
# start supervisor
CMD ["/usr/bin/supervisord"]

# Expose ports.
EXPOSE 3306
