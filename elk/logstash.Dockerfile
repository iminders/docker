# https://hub.docker.com/layers/elastic/logstash/7.6.2/images/sha256-baed5f5bf04299994ea41881afb4d4985cb0f33427a2aef39223c75975bab60e?context=explore
FROM elastic/logstash:7.6.2

EXPOSE 5044 9600

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
