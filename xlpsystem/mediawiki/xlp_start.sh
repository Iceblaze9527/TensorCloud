#!/bin/sh
# Define env
export MW_INSTALL_PATH=/var/www/html

# Add open-id plugin
# https://www.mediawiki.org/wiki/Extension:OpenID
php $MW_INSTALL_PATH/maintenance/update.php --quick


# Elasticsearch
# Delete $wgSearchType if exists
sed -i --follow-symlinks "/\$wgSearchType = 'CirrusSearch';/d" $MW_INSTALL_PATH/LocalSettings.php

# Add $wgDisableSearchUpdate to LocalSettings.php
sed -i --follow-symlinks '$ a \$wgDisableSearchUpdate = true;' $MW_INSTALL_PATH/LocalSettings.php

# Generate Elasticsearch index
php $MW_INSTALL_PATH/extensions/CirrusSearch/maintenance/updateSearchIndexConfig.php

# Inject $wgServer
if [ -z "$SERVER_URL" ] 
then 
  SERVER_URL="http:\/\/hotbackup.toyhouse.cc:801"
fi
sed -i --follow-symlinks "s/SERVER_URL/${SERVER_URL}/g" $MW_INSTALL_PATH/LocalSettings.php

# Remove $wgDisableSearchUpdate from LocalSettings.php
sed -i --follow-symlinks '/\$wgDisableSearchUpdate = true;/d' $MW_INSTALL_PATH/LocalSettings.php

php $MW_INSTALL_PATH/extensions/CirrusSearch/maintenance/forceSearchIndex.php --skipLinks --indexOnSkip
php $MW_INSTALL_PATH/extensions/CirrusSearch/maintenance/forceSearchIndex.php --skipParse

# Add $wgSearchType to LocalSettings.php
sed -i --follow-symlinks "$ a \$wgSearchType = 'CirrusSearch';" $MW_INSTALL_PATH/LocalSettings.php

# Start
apachectl -e info -D FOREGROUND
