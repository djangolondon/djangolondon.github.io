FROM ubuntu:latest
RUN apt-get update

RUN apt-get install -y nodejs
RUN apt-get install -y ruby ruby-dev ruby-redcarpet
RUN apt-get install -y zlib1g-dev liblzma-dev
RUN apt-get install -y build-essential patch
RUN apt-get install -y git-core

RUN gem install bundler
RUN mkdir -p /app
WORKDIR /app

ADD Gemfile /app/Gemfile
RUN bundle install

ADD . /app/

EXPOSE 4000
EXPOSE 35729

# CMD ["bundle", "exec", "jekyll", "serve", "--watch"]
CMD ["guard", "-i"]
