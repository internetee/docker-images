# Internet.ee base images

These are the Dockerfiles for base images used at Estonian Internet foundation
for Apache with EPP and Ruby 2.3

## Updating images

This uses `internetee/ruby` image.

To update the images and push them to dockerhub:
  ```bash
  $ docker build . -t internetee/ruby:2.3.YYYY.MM.DD -t internetee/ruby:2.3 -t internetee/ruby:latest
  $ docker push internetee/ruby
  ```
Where YYYY.MM.DD and 2.3 is the current Ruby version.

__NB!__ Use only latest tag only if both the runtime and release are both latest. Do not tag Ruby 1.9 with latest.
