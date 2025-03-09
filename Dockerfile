# Use latest stable channel SDK.
# FROM dart:stable AS build
FROM dart:3.7.0 AS build

# Resolve app dependencies.
WORKDIR /app

COPY pubspec.* ./

# copy all pubspec files
COPY packages/env_vars_wrapper/pubspec.* ./packages/env_vars_wrapper/
COPY packages/database_wrapper/pubspec.* ./packages/database_wrapper/
COPY packages/events_scraper/pubspec.* ./packages/events_scraper/

# RUN dart pub get
RUN dart pub get --directory packages/env_vars_wrapper
RUN dart pub get --directory packages/database_wrapper
RUN dart pub get --directory packages/events_scraper
RUN dart pub get

# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY . .

RUN mkdir -p build

RUN dart compile exe bin/server.dart -o build/server
RUN dart compile exe packages/events_scraper/bin/events_scraper.dart -o build/scraper

# Build minimal serving image from AOT-compiled `/server`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
# FROM scratch
FROM alpine:latest

COPY --from=build /runtime/ /
COPY --from=build /app/build/server /app/build/
COPY --from=build /app/build/scraper /app/build/

# Install necessary utilities
RUN apk add --no-cache bash
RUN apk add --no-cache chromium

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
# https://github.com/puppeteer/puppeteer/issues/11028
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# it would be good to write this to some logs
# RUN mkdir -p /var/log
# RUN echo "* * * * * /app/build/scraper >> /var/log/scraper.log 2>&1" > /etc/crontabs/root
RUN echo '*  *  *  *  *   /app/build/scraper' >/etc/crontabs/root

# TODO create a user and run as that user

# Start server.
EXPOSE 8080
CMD ["sh", "-c", "crond && /app/build/server"]
