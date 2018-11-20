#!/bin/sh

# make /xlp_dev
mkdir /xlp_data

# add toyhouse logo
mv /tmp/xlp_dev /

# add links
rm -rf /var/www/html/extensions
ln -s /xlp_dev/extensions /var/www/html/extensions

rm -rf /var/www/html/skins
ln -s /xlp_dev/skins /var/www/html/skins

# add toyhouse.png(logo)
ln -s /xlp_dev/toyhouse.png /var/www/html/resources/assets/toyhouse.png

# add data links
rm -rf /var/www/html/LocalSettings.php
ln -s /xlp_data/LocalSettings.php /var/www/html/LocalSettings.php