# Docker configuration for internet.ee projects

This repository provides a semi-automated way of setting up local development
environment for the following projects:

  * [Registry](https://github.com/internetee/registry)
  * [Rest WHOIS](https://github.com/internetee/rest-whois)

Planned additions:

  *  [WHOIS](https://github.com/internetee/whois)
  *  [EPP Webclient](https://github.com/internetee/epp)

## Design

The setup includes one Apache server acting as reverse proxy, 1 REST WHOIS server, 1 registry instance serving EPP requests and 1 registry server serving all portals interface. Ruby projects are running Puma servers.

Postgres instance persists its files on the host disk, inside the `pg` folder. The folder is ignored by git.

All services run on localhost. Registry is running over HTTPS. 

The following vhosts work on Chrome:
  * admin.localhost
  * rest-whois.localhost

## Pre-requirements

To get started, you need:

  * Docker
  * OpenSSL command line
  * Internet.ee projects in specific folders, relative to this folder:
    ```
    .
    +-- docker (You are here)
    +-- registry (clone of https://github.com/internetee/registry)
    +-- rest_whois (clone of https://github.com/internetee/rest-whois)
    ```


## Setup

Setup of the project consists of four steps steps. The projects should work with out of the box configuration for both `config/application-example.yml` and `config/database-example.yml`.

### Setup root CA

You will be asked to supply a password and certain certificate details, such as common name. Remember the password, as you'll be required to supply it at various points in time for generation of other certificates. The root CA, and all the certificates are valid for 1 year only.

  ```bash
  $ cd shared/ca
  $ ./prepare_root_ca.sh
  ```

Add the newly generated certificates from `shared/ca/ca.crt.pem` certificate to your trusted chains, and enable trust for SSL communication. If you are using a MacOS computer, just drop the certificate file to login keychain in Keychain Access.

__NB!__ Trusting a self generated certificate is generally a security risk, so make sure that you're the only person with the access to this root ca and do not commit it to any kind of source code repository.

If you already have a certificate like that from a different project, you can just drop the files to the required locations:

  * key to `shared/ca/private/ca.key.pem`
  * certificate to `shared/ca/certs/ca.cert.pem`

Then, move on to generating certificates reqired by application.

### Setup application certificates

You will be asked for your root CA password multiple times.

  ```bash
  $ cd shared/ca
  $ ./generate_certificates.sh
  ```

### Build docker images

In the project root, run the following commands:

```bash
$ docker-compose build
```

__NB!__ Containers need to be rebuilt every time there is an update to the gemfile.

### Setup databases

```bash
$ docker-compose run registry rake db:setup:all
$ docker-compose run rest_whois rake db:setup:all
```

## Useful commands

Below you will find a list of useful and frequently used docker commands:

  * `docker-compose exec -it $container_name_number /bin/bash` Opens bash in a running container, so you can run `rake test`, `rake db:migrate` or other commands on the codebase.
  * `docker image prune` Removes dangling images to save you some SSD space.
  * `docker attach $container_name_number` Attaches to a running container, useful if you have pry breakpoint somewhere in your code. To deatach without stopping the container, press `CTRL+P, CTRL+Q`. 



