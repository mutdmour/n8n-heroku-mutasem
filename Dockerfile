FROM node:lts-alpine

# pass N8N_VERSION Argument while building or use default
ARG N8N_VERSION=0.98.0

# Update everything and install needed dependencies
RUN apk add --update graphicsmagick tzdata

# Set a custom user to not have n8n run as root
USER root

# Install n8n and the also temporary all the packages
# it needs to build it correctly.
# RUN apk --update add --virtual build-dependencies python build-base && \
# 	npm_config_user=root npm install -g n8n@${N8N_VERSION} && \
# 	apk del build-dependencies

RUN apk --update add --virtual build-dependencies python build-base && \
	apk --update add git && \
	apk del build-dependencies

RUN git clone https://github.com/n8n-io/n8n && \
	cd n8n && \
	npm_config_user=root npm run build && \
	alias n8n="./packages/cli/bin/n8n"

# Specifying work directory
WORKDIR /data

# copy start script to container
COPY ./start.sh /

# make the script executable
RUN chmod +x /start.sh

# define execution entrypoint
CMD ["/start.sh"]
