#!/bin/env bash
docker push internetee/ruby:2.6
docker push internetee/ruby:2.6-buster
docker push internetee/ruby:2.6.$(date +'%Y.%m.%d')
