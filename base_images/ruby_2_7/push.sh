#!/usr/bin/env bash
docker push internetee/ruby:2.7
docker push internetee/ruby:2.7-buster
docker push internetee/ruby:2.7.$(date +'%Y.%m.%d')
