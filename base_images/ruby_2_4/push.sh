#!/usr/bin/env bash
docker push internetee/ruby:2.4 
docker push internetee/ruby:2.4-buster 
docker push internetee/ruby:2.4.$(date +'%Y.%m.%d')
