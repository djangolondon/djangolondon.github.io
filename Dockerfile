FROM ubuntu:latest
RUN apt-get update

RUN apt-get install -y nodejs 
RUN apt-get install -y ruby ruby-dev ruby-redcarpet
RUN apt-get install -y zlib1g-dev liblzma-dev
RUN apt-get install -y build-essential patch
RUN apt-get install -y git-core

RUN gem install bundler
RUN mkdir -p /app

ADD . /app/
WORKDIR /app

RUN bundle install

EXPOSE 4000

CMD ["bundle", "exec", "jekyll", "serve"]