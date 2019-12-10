FROM ruby:2.5.1

# 必要なパッケージをインストール
RUN apt-get update -qq && \
  apt-get install -y build-essential \
  libpq-dev \
  nodejs \
  libappindicator1 \
  fonts-liberation \
  libappindicator3-1 \
  libasound2 \
  libnspr4 \
  libnss3 \
  libxss1 \
  xdg-utils \
  apt-utils \
  lsb-release \
  unzip

# Timezone
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'Asia/Tokyo' > /etc/timezone && dpkg-reconfigure tzdata
ENV TZ JST-9

# Setup
RUN apt-get update -y && apt-get install -y locales && \
    sed -i 's/#.*ja_JP\.UTF/ja_JP\.UTF/' /etc/locale.gen && \
    locale-gen && update-locale LANG=ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LC_CTYPE ja_JP.UTF-8

# chrome をインストール
RUN curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install

# chrome driver をインストール
RUN curl -O https://chromedriver.storage.googleapis.com/78.0.3904.105/chromedriver_mac64.zip
RUN unzip chromedriver_mac64.zip

# Japanese font
RUN mkdir /noto
ADD https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip /noto
WORKDIR /noto
RUN unzip NotoSansCJKjp-hinted.zip && \
    mkdir -p /usr/share/fonts/noto && \
    cp *.otf /usr/share/fonts/noto && \
    chmod 644 -R /usr/share/fonts/noto/ && \
    /usr/bin/fc-cache -fv
WORKDIR /
RUN rm -rf /noto

# 作業ディレクトリの作成、設定
RUN mkdir /app_name

# 作業ディレクトリ名をAPP_ROOTに割り当てて、以下$APP_ROOTで参照
ENV APP_ROOT /app_name
WORKDIR $APP_ROOT

# ホスト側（ローカル）のGemfileを追加する
ADD ./Gemfile $APP_ROOT/Gemfile
ADD ./Gemfile.lock $APP_ROOT/Gemfile.lock

# Gemfileのbundle install
RUN bundle install
ADD . $APP_ROOT

COPY . /app_name
RUN ["apt-get", "install", "-y", "vim"]
