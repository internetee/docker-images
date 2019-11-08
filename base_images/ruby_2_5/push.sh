#!/bin/env bash
docker push internetee/ruby:2.5
docker push internetee/ruby:2.5-buster
docker push internetee/ruby:2.5.$(date +'%Y.%m.%d')
docker push internetee/ruby
