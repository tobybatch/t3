#!/bin/bash -x

# If we have a dump then install it.
if [ -e /tmp/dump.sql ]; then
    drush sqlc < /tmp/dump.sql
fi

# If we have a files bundle then install it.
if [ -e /tmp/files.tgz ]; then
    tar zxvf /tmp/files.tgz
fi

# If we have a config bundle then install it.
if [ -e /tmp/config.tgz ]; then
    tar zxvf /tmp/config.tgz
    vendor/bin/drush cim -y
fi

if [ ! -z "${T3_MODULES_OFF}" ]; then
    echo -e "\nTurn off modules ${T3_MODULES_OFF}"
    vendor/bin/drush --no-ansi --pipe pmu -y ${T3_MODULES_OFF}
fi
if [ ! -z "${T3_MODULES_ON}" ]; then
    echo -e "\nTurning on modules ${T3_MODULES_ON}"
    vendor/bin/drush --no-ansi --pipe en -y ${T3_MODULES_ON}
fi

touch /opt/drupal/started

echo drush -r /opt/drupal rs 0.0.0.0:${T3_PORT}
drush -r /opt/drupal rs 0.0.0.0:${T3_PORT}
