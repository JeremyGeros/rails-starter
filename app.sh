#!/bin/bash

bunlde install
npm install

bin/rails db:create
bin/rails db:migrate
bin/dev -p 8080
