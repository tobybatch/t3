#!/bin/bash 

# If drupal is not set up
if [ ! -e /opt/drupal/installation_complete ]; then
    cp /opt/drupal/web/sites/default/{default.settings.php,settings.php}
    vendor/bin/drush \
        --no-ansi --pipe -q si -y \
        --db-url=mysqli://lamp:lamp@db/lamp \
        --account-pass=planetcrownceilingemerald
    vendor/bin/drush config-set "system.site" uuid "${SYSTEM_SITE_UUID}"
    echo "\$settings['trusted_host_patterns'] = [ '^localhost$', '^127.0.0.1$', '^0.0.0.0$', '.*', '^goodlife.localhost$', ];" >> web/sites/default/settings.php

    vendor/bin/drush pmu -y search
    /tmp/turn-on-all.sh
    vendor/bin/drush -y cset tabsapi.connection url ${T3_API_URL}
    vendor/bin/drush -y cset tabsapi.connection username ${T3_API_USERNAME}
    vendor/bin/drush -y cset tabsapi.connection password ${T3_API_PASSWORD}
    vendor/bin/drush -y cset tabsapi.connection key ${T3_API_KEY}
    vendor/bin/drush -y cset tabsapi.connection secret ${T3_API_SECRET}
    vendor/bin/drush -y updatedb
    vendor/bin/drupal toccimport:import:domain good_life_lake_district_cottages_localhost
    vendor/bin/drush -y config-set system.theme default wykedorset
    vendor/bin/drupal site:mode dev

    touch /opt/drupal/installation_complete
fi

if [ ! -z "${T3_MODULE_BRANCH}" ]; then
    git -C /opt/drupal/web/modules/custom/tabs2apidrupal8modules checkout ${T3_MODULE_BRANCH}
fi

if [ ! -z "${T3_THEME_BRANCH}" ]; then
    git -C /opt/drupal/web/themes/custom/template3themes/ checkout ${T3_THEME_BRANCH}
fi

echo drush -r /opt/drupal rs 0.0.0.0:${T3_PORT}
drush -r /opt/drupal rs 0.0.0.0:${T3_PORT}
