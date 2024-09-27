# Internet.ee base images

These are the Dockerfiles for base images used at Estonian Internet foundation
for Apache with EPP and Ruby. There are 3 sets of Ruby images: one for Ruby 2.4,
which is mainly used for registry, one for Ruby 2.5 used by REST WHOIS
and auction center, and one for Ruby 2.6 (not in use as of 2019-03-19)

## Updating images

This uses `internetee/ruby` image.

To update the images and push them to dockerhub:
  ```bash
  $ docker build --no-cache . -t internetee/ruby:2.3.YYYY.MM.DD -t internetee/ruby:2.3 -t internetee/ruby:latest
  $ docker push internetee/ruby
  ```
Where YYYY.MM.DD and 2.3 is the current Ruby version.

__NB!__ Use only latest tag only if both the runtime and release are both latest. Do not tag Ruby 1.9 with latest.
