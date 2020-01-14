# ruby2.5.1のalpineを指定
FROM ruby:2.5.1-alpine

ENV CHROME_PACKAGES="chromium-chromedriver zlib-dev chromium xvfb wait4ports xorg-server dbus ttf-freefont mesa-dri-swrast udev" \
    BUILD_PACKAGES="build-base curl-dev" \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

# apk --update --no-cache add でインストールするパッケージを指定
RUN apk --update --no-cache add tzdata libxml2-dev curl-dev make gcc libc-dev g++ mariadb-dev linux-headers nodejs && \
    mkdir /app_name

WORKDIR /app_name

ADD Gemfile /app_name/Gemfile
ADD Gemfile.lock /app_name/Gemfile.lock

ENV BUNDLER_VERSION 1.17.0
# && \で改行していくことにより、より軽量になるらしい
RUN gem install bundler && \
    apk upgrade && \
# Warningがでたのでここでupdateを一度入れる
    apk update && \
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    apk add --no-cache ${CHROME_PACKAGES} && \
    apk add --virtual build-packages --no-cache ${BUILD_PACKAGES} && \
    bundle install && \
    apk add --no-cache curl fontconfig && \
    curl -O https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip && \
    mkdir -p /usr/share/fonts/NotoSansCJKjp && \
    unzip NotoSansCJKjp-hinted.zip -d /usr/share/fonts/NotoSansCJKjp/ && \
    rm NotoSansCJKjp-hinted.zip && \
    fc-cache -fv && \
# 上で指定したパッケージの中で開発環境を構築したら不要になるファイルをapk delで削除する
    apk del libxml2-dev curl-dev make gcc libc-dev g++ linux-headers build-packages

ADD . /app_name
# 容量が大きく不要であるcacheファイルは構築後削除する
RUN rm -rf /usr/local/bundle/cache/* /app_name/vendor/bundle/cache/*
