#!/bin/bash

bundle install
npm install

bin/rails db:migrate
bin/dev -p 8080
