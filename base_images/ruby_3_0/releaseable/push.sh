#!/usr/bin/env bash
docker push internetee/ruby_base:3.0
docker push internetee/ruby_base:latest
docker push internetee/ruby_base:3.0-base.$(date +'%Y.%m.%d')
