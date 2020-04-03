# https://github.com/docker-library/kibana/blob/master/7/Dockerfile
FROM kibana:7.6.2

ENTRYPOINT ["/usr/local/bin/dumb-init" "--"]
CMD ["/usr/local/bin/kibana-docker"]
