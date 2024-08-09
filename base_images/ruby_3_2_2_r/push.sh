#!/usr/bin/env bash
docker push internetee/ruby:3.2.2-refactor
docker push internetee/ruby:3.2.2-bullseye-refactor
docker push internetee/ruby:3.2.2.$(date +'%Y.%m.%d')-refactor
