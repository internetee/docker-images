#!/usr/bin/env bash
docker push internetee/ruby:3.0
docker push internetee/ruby:3.0-buster
docker push internetee/ruby:3.0.$(date +'%Y.%m.%d')
