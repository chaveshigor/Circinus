FROM ruby:3.0.2
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client && apt install -y npm && npm install -g yarn
WORKDIR /myapp
COPY package.json /myapp/package.json
RUN yarn
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install


EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]