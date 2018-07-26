FROM t3_base_drupal

LABEL maintainer tobias@neontribe.co.uk

HEALTHCHECK --interval=15s --timeout=1s --retries=10 CMD [ -e /opt/drupal/started ] || exit 1

ARG T3_API_URL=https://toccl.test.api.tabs-software.co.uk/v2/
ARG T3_API_USERNAME=t.batch
ARG T3_API_PASSWORD=password
ARG T3_API_KEY=15_468yq9yhyq04ks8o0w4kkckcwsg804ckwg8g8cs8wgs4s0scg0
ARG T3_API_SECRET=1crapwsm6lc0so4kow044oo8cg08s04ogwsowkosk0cc44kogg
ARG T3_PORT=8980
ARG T3_MODULE_BRANCH=develop
ARG T3_THEME_BRANCH=master

WORKDIR /opt/drupal/web/modules/custom/tabs2apidrupal8modules
RUN git checkout ${T3_MODULE_BRANCH}
WORKDIR /opt/drupal/web/themes/custom/template3themes/
RUN git checkout ${T3_THEME_BRANCH}
RUN npm install && gulp

WORKDIR /opt/drupal
RUN vendor/bin/drush pmu -y search
COPY turn-on-all.sh /tmp/turn-on-all.sh
RUN /tmp/turn-on-all.sh
RUN vendor/bin/drush -y cset tabsapi.connection url ${T3_API_URL}
RUN vendor/bin/drush -y cset tabsapi.connection username ${T3_API_USERNAME}
RUN vendor/bin/drush -y cset tabsapi.connection password ${T3_API_PASSWORD}
RUN vendor/bin/drush -y cset tabsapi.connection key ${T3_API_KEY}
RUN vendor/bin/drush -y cset tabsapi.connection secret ${T3_API_SECRET}
RUN vendor/bin/drush -y updatedb
RUN vendor/bin/drupal toccimport:import:domain good_life_lake_district_cottages_localhost
RUN vendor/bin/drush -y config-set system.theme default wykedorset
RUN vendor/bin/drupal site:mode dev

COPY startup.sh /usr/local/bin/startup.sh

RUN drush cr
ENTRYPOINT []
CMD ["/usr/local/bin/startup.sh"]

# Build base image
# docker build --rm -t neonkvm:5000/t3_base_drupal --no-cache -f Dockerfile.base .

# Build t3-skunk
# docker build --rm -t neonkvm:5000/t3 .

# Run t3 skunk
# docker run -ti -p $T3_PORT:$T3_PORT -e T3_PORT=$T3_PORT -e T3_MODULES_ON="devel kint" -v $HOME/workspace/tocc/Tabs2ApiDrupal8Modules:/opt/drupal/web/modules/custom/tabs2apidrupal8modules neonkvm:5000/t3

# Reset admin passwd
# docker exec -ti t3-skunk vendor/bin/drush upwd admin password=XXXXX # Won't persist

# http://good-life-lake-district-cottages.template3.originalcottages.co.uk:8980/
