FROM adomenech73/base
MAINTAINER Albert Domenech <adomenech@gmail.com>

RUN apt-get update && apt-get -y install \
  nginx \
  php5-fpm \
  php5-mysql \
  php-apc pwgen \
  #python-setuptools \
  curl \
  git \
  unzip \
  php5-curl \
  php5-gd \
  php5-intl \
  php-pear \
  php5-imagick \
  php5-imap \
  php5-mcrypt \
  php5-memcache \
  php5-ming \
  php5-ps \
  php5-pspell \
  php5-recode \
  php5-sqlite \
  php5-tidy \
  php5-xmlrpc \
  php5-xsl && \
  rm -rf /var/lib/apt/lists/* && \
  sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf && \
  sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf && \
  echo "daemon off;" >> /etc/nginx/nginx.conf && \
  # php-fpm config
  sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini && \
  sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini && \
  sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini && \
  sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf && \
  sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf && \
  find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

  # nginx site conf
  ADD ./nginx/sites-available /etc/nginx/sites-available/default
  # Supervisor Config
  ADD ./supervisor/nginx.conf /etc/supervisor/conf.d/nginx.conf
  ADD ./supervisor/php5.conf /etc/supervisor/conf.d/php5.conf
  # Install Wordpress
  ADD http://wordpress.org/latest.tar.gz /usr/share/nginx/latest.tar.gz

  RUN cd /usr/share/nginx/ && tar xvf latest.tar.gz && rm latest.tar.gz && \
    mv /usr/share/nginx/html/5* /usr/share/nginx/wordpress && \
    rm -rf /usr/share/nginx/www && \
    mv /usr/share/nginx/wordpress /usr/share/nginx/www && \
    # Wordpress Initialization and Startup Script
    #RUN sed -i -e "s/\/\* That's all, stop editing\! Happy blogging\. \*\//define('WP_ALLOW_MULTISITE', true);/" /usr/share/nginx/www/wp-config.php
    chown -R www-data:www-data /usr/share/nginx/www


  # Wordpress configuraion
  #ADD ./configure.sh /configure.sh
  #RUN chmod 755 /configure.sh
  #RUN /configure.sh

  CMD exec supervisord -n
  # private expose
  EXPOSE 80
