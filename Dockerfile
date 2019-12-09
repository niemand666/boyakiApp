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

# chrome をインストール
RUN curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install

# chrome driver をインストール
RUN curl -O https://chromedriver.storage.googleapis.com/78.0.3904.105/chromedriver_mac64.zip
RUN unzip chromedriver_mac64.zip

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
