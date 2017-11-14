#!/usr/bin/env bash
# Provision Drupal Stable

DOMAIN=`get_primary_host "${VVV_SITE_NAME}".dev`
DOMAINS=`get_hosts "${DOMAIN}"`
SITE_TITLE=`get_config_value 'site_title' "${DOMAIN}"`
DB_NAME=`get_config_value 'db_name' "${VVV_SITE_NAME}"`
DB_NAME=${DB_NAME//[\\\/\.\<\>\:\"\'\|\?\!\*-]/}
LIVE_URL=`get_config_value 'live_url' "null"`

# Make a database, if we don't already have one
echo -e "\nCreating database '${DB_NAME}' (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME}"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO drupal@localhost IDENTIFIED BY 'drupal';"
echo -e "\n DB operations done.\n\n"

# Nginx Logs
mkdir -p ${VVV_PATH_TO_SITE}/log
touch ${VVV_PATH_TO_SITE}/log/error.log
touch ${VVV_PATH_TO_SITE}/log/access.log

if [[ ! -f "${VVV_PATH_TO_SITE}/public_html/index.php" ]]; then
  echo "Downloading Drupal..."
  cd "${VVV_PATH_TO_SITE}/public_html/"
  wget https://ftp.drupal.org/files/projects/drupal-8.4.2.tar.gz
 # tar -x -f drupal-8.4.2.tar.gz -v -z --strip-components=1
fi

cp -f "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf.tmpl" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
sed -i "s#{{DOMAINS_HERE}}#${DOMAINS}#" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"

# Proxy images from live site
if [[ "${LIVE_URL}" != http* ]]; then
	LIVE_URL=''
else
	LIVE_URL="\n\n    # Directives to send expires headers and turn off 404 error logging.\n    location ~* .(js|css|png|jpg|jpeg|gif|ico)$ {\n         expires 24h;\n         log_not_found off;\n         try_files \$uri \$uri\/ @production;\n    }\n\n    location @production {\n        resolver 8.8.8.8;\n        proxy_pass $LIVE_URL\/\$uri;\n    }\n"
fi
sed -i "s,nginx-wp-common.conf;,nginx-wp-common.conf;${LIVE_URL},g" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
