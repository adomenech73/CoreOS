#!/bin/bash
if [ ! -f /usr/share/nginx/www/wp-config.php ]; then
  sleep 10s
  # Here we generate random passwords (thank you pwgen!). The first two are for mysql users, the last batch for random keys in wp-config.php
  WORDPRESS_DB="wordpress"
  #MYSQL_PASSWORD=`pwgen -c -n -1 12`
  MYSQL_PASSWORD="changeme"
  WORDPRESS_PASSWORD=`pwgen -c -n -1 12`
  #WORDPRESS_PASSWORD=``
  #This is so the passwords show up in logs.
  #echo mysql root password: $MYSQL_PASSWORD
  echo wordpress password: $WORDPRESS_PASSWORD
  #echo $MYSQL_PASSWORD > /mysql-root-pw.txt
  echo $WORDPRESS_PASSWORD > /wordpress-db-pw.txt

  sed -e "s/database_name_here/$WORDPRESS_DB/
  s/username_here/root/
  s/password_here/changeme/
  s/'localhost'/getenv('DBHOST')/
  /'AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'SECURE_AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'LOGGED_IN_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'NONCE_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'SECURE_AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'LOGGED_IN_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'NONCE_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/" /usr/share/nginx/www/wp-config-sample.php > /usr/share/nginx/www/wp-config.php

  # Download nginx helper plugin
  curl -O `curl -i -s https://wordpress.org/plugins/nginx-helper/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
  unzip -o nginx-helper.*.zip -d /usr/share/nginx/www/wp-content/plugins
  chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/nginx-helper

  # Activate nginx plugin and set up pretty permalink structure once logged in
  cat << ENDL >> /usr/share/nginx/www/wp-config.php
  \$plugins = get_option( 'active_plugins' );
  if ( count( \$plugins ) === 0 ) {
    require_once(ABSPATH .'/wp-admin/includes/plugin.php');
    \$wp_rewrite->set_permalink_structure( '/%postname%/' );
    \$pluginsToActivate = array( 'nginx-helper/nginx-helper.php' );
    foreach ( \$pluginsToActivate as \$plugin ) {
      if ( !in_array( \$plugin, \$plugins ) ) {
        activate_plugin( '/usr/share/nginx/www/wp-content/plugins/' . \$plugin );
      }
    }
  }
ENDL

echo "define('WP_ALLOW_MULTISITE', true);" >> /usr/share/nginx/www/wp-config.php
echo "DBHOST=\$COREOS_PRIVATE_IPV4" >> /etc/environment
chown www-data:www-data /usr/share/nginx/www/wp-config.php

fi
