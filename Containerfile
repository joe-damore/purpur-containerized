ARG ALPINE_LINUX_VERSION=3.22
ARG PURPUR_MC_VERSION=1.21.8

###############
# Build Image #
###############
FROM alpine:${ALPINE_LINUX_VERSION} as purpur-build
ARG PURPUR_MC_VERSION

# Create purpur directory and set working directory
RUN mkdir /purpur
WORKDIR /purpur

# Upgrade packages, install dependencies, download purpur
RUN apk upgrade --update && \
    apk add --no-cache openssl wget && \
    apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community openjdk21-jre && \
    wget "https://api.purpurmc.org/v2/purpur/${PURPUR_MC_VERSION}/latest/download" -O "/purpur/purpur-mc-v${PURPUR_MC_VERSION}.jar"

#############
# App Image #
#############
FROM alpine:${ALPINE_LINUX_VERSION} as purpur
ARG ALPINE_LINUX_VERSION
ARG PURPUR_MC_VERSION

ENV MEMORY_MIN=1G
ENV MEMORY_MAX=4G

# Set working dir, create purpur dirs
WORKDIR /
RUN mkdir /purpur && \
    mkdir /purpur_data

# Copy Purpur binary
COPY --from=purpur-build /purpur/purpur-mc-v${PURPUR_MC_VERSION}.jar /purpur/purpur.jar
COPY ./start-purpur.sh /purpur/start-purpur.sh

RUN apk upgrade --update && \
    apk add --no-cache bash curl dumb-init && \
    apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community openjdk21-jre && \
    chmod +x /purpur/start-purpur.sh

EXPOSE 25565

VOLUME /purpur_data

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/purpur/start-purpur.sh"]
