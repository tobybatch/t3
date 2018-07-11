FROM neonkvm:5000/t3_base_drupal:latest

LABEL maintainer tobias@neontribe.co.uk

HEALTHCHECK --interval=15s --timeout=1s --retries=10 CMD [ -e /opt/drupal/started ] || exit 1
ENV T3_API_URL=http://localhost
ENV T3_API_USERNAME=foo
ENV T3_API_PASSWORD=password
ENV T3_API_KEY=somekey
ENV T3_API_SECRET=somesecret

COPY startup.sh /usr/local/bin/startup.sh

ENTRYPOINT []
ENV T3_PORT=8989

CMD ["/usr/local/bin/startup.sh"]

# Build base image
# docker build --rm -t neonkvm:5000/t3_base_drupal -f Dockerfile.base .

# Build t3-skunk
# docker build --rm -t neonkvm:5000/t3 .

# Run t3 skunk
# docker run -ti -p $T3_PORT:$T3_PORT --name t3-skunk --rm -e T3_PORT=$T3_PORT -e T3_API_USERNAME=$T3_API_USERNAME -e T3_API_PASSWORD=$T3_API_PASSWORD -e T3_API_KEY=$T3_API_KEY -e T3_API_SECRET=$T3_API_SECRET -e T3_API_URL=$T3_API_URL -v $HOME/workspace/tocc/Tabs2ApiDrupal8Modules:/opt/drupal/web/modules/custom/tabs2apidrupal8modules neonkvm:5000/t3

# Reset admin passwd
# docker exec -ti t3-skunk vendor/bin/drush upwd admin password=XXXXX # Won't persist

# Turn off caching
# docker exec -ti t3-skunk vendor/bin/drupal site:mode dev
