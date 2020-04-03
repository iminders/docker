# https://hub.docker.com/layers/elastic/filebeat/7.6.2/images/sha256-24211654fbe1ce3866583d7ae385feffbfaa77d4598d189fdec46111133811a9?context=explore

FROM elastic/filebeat:7.6.2

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
CMD ["-e"]
