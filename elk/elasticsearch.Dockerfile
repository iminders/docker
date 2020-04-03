# https://github.com/docker-library/elasticsearch/blob/master/7/Dockerfile
FROM docker.elastic.co/elasticsearch/elasticsearch:7.6.2@sha256:59342c577e2b7082b819654d119f42514ddf47f0699c8b54dc1f0150250ce7aa

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["eswrapper"]
