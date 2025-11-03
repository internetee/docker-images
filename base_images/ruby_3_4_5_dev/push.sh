#!/usr/bin/env bash
docker push internetee/ruby:3.4.5-node-18-dev
docker push internetee/ruby:3.4.5-bookworm-node-18-dev
docker push internetee/ruby:3.4.5.$(date +'%Y.%m.%d')-node-18-dev
