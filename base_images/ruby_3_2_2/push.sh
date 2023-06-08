#!/usr/bin/env bash
docker push internetee/ruby:3.2.2
docker push internetee/ruby:3.2.2-bullseye
docker push internetee/ruby:3.2.2.$(date +'%Y.%m.%d')
