# My T3 Dockers

## PRETYY MUCH UNTESTED ##

Build base image

    docker build --rm -t neonkvm:5000/t3_base_drupal -f Dockerfile.base .

Build t3-skunk

    docker build --rm -t neonkvm:5000/t3 .

Run t3 skunk

    docker run -ti -p $T3_PORT:$T3_PORT --name t3-skunk --rm \
        -e T3_PORT=$T3_PORT \
        -e T3_API_USERNAME=$T3_API_USERNAME \
        -e T3_API_PASSWORD=$T3_API_PASSWORD \
        -e T3_API_KEY=$T3_API_KEY \
        -e T3_API_SECRET=$T3_API_SECRET \
        -e T3_API_URL=$T3_API_URL \
        -v $HOME/workspace/tocc/Tabs2ApiDrupal8Modules:/opt/drupal/web/modules/custom/tabs2apidrupal8modules \
        neonkvm:5000/t3

Reset admin passwd

    docker exec -ti t3-skunk vendor/bin/drush upwd admin password=XXXXX # Won't persist

Turn off caching

    docker exec -ti t3-skunk vendor/bin/drupal site:mode dev
