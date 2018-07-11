#!/bin/bash

MODULES=""
for x in $(find /opt/drupal/web/modules/custom/ -name "*.info.yml" -exec basename {} .info.yml \;); do
    MODULES="$MODULES $x";
done

/opt/drupal/vendor/bin/drush -r /opt/drupal en -y $MODULES
