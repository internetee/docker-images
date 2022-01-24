#!/usr/bin/env bash
docker push internetee/ruby:3.0.3
docker push internetee/ruby:3.0.3-buster
docker push internetee/ruby:3.0.3.$(date +'%Y.%m.%d')
