#!/usr/bin/env bash
docker push internetee/ruby:3.3.1-node-18
docker push internetee/ruby:3.3.1-bullseye-node-18
docker push internetee/ruby:3.3.1.$(date +'%Y.%m.%d')-node-18
