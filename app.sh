#!/bin/bash

bundle install
npm install
gem install foreman

bin/rails db:migrate
bin/dev -p 8080
