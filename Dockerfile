FROM justcontainers/base-alpine
LABEL maintainer="bas.van.wetten@gmail.com"

# Expose ports

# Start command for container

ADD docker/run.sh /run.sh
RUN chmod +x /run.sh
CMD ["/run.sh"]
