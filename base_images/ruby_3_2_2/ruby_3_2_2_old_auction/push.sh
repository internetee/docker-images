#!/usr/bin/env bash
docker push internetee/ruby:3.2.2-node-18
docker push internetee/ruby:3.2.2-bullseye-node-18
docker push internetee/ruby:3.2.2.$(date +'%Y.%m.%d')-node-18
