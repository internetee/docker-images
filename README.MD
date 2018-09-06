# Docker configuration for internet.ee projects

This repository provides a semi-automated way of setting up local development
environment for the following projects:

  * [Registry](https://github.com/internetee/registry)
  * [Rest WHOIS](https://github.com/internetee/rest-whois)
  * [WHOIS](https://github.com/internetee/whois)
  * [Auction Center](https://github.com/internetee/auction_center)

Planned additions:

  *  [EPP Webclient](https://github.com/internetee/epp)

## Design

The setup includes one Apache server acting as reverse proxy, 1 REST WHOIS
server, 1 registry instance serving EPP requests and 1 registry server serving
all portals interface. Ruby projects are running Puma servers.

Postgres instance persists its data in a dedicated volume, which is NOT deleted
with `docker-compose down`.

All services run on localhost. Registry is running over HTTPS.

The following vhosts work on Chrome:
  * admin.localhost
  * rest-whois.localhost
  * auction.localhost

To allow access from Firefox, you should:

1. Visit `about:config` in Firefox.
2. Find `network.dns.localDomains` key
3. Enter `admin.localhost,rest-whois.localhost,auction.localhost` as values.

   If you have any other domains subdomains that should work on localhost, add
   them as well, just make sure to use comma as a separator.

Additionally, whois works on port 43 on localhost.

## Pre-requirements

To get started, you need:

  * Docker
  * OpenSSL command line
  * Internet.ee projects in specific folders, relative to this folder:
    ```
    .
    +-- docker-images (You are here)
    +-- registry (clone of https://github.com/internetee/registry)
    +-- rest-whois (clone of https://github.com/internetee/rest-whois)
    ```


## Setup

Setup of the project consists of four steps steps. The projects should work with
out of the box configuration for both `config/application-example.yml` and
`config/database-example.yml`. Small changes that are described below are
needed for certificates and setup of EPP/REST API.

### Setup root CA

You will be asked to supply a password and certain certificate details, such as
common name. Remember the password, as you'll be required to supply it at
various points in time for generation of other certificates. The root CA, and
all the certificates are valid for 1 year only.

  ```bash
  $ cd shared/ca
  $ ./prepare_root_ca.sh
  ```

Add the newly generated certificates from `shared/ca/ca.crt.pem` certificate to
your trusted chains, and enable trust for SSL communication. If you are using a
MacOS computer, just drop the certificate file to login keychain in Keychain
Access.

__NB!__ Trusting a self generated certificate is generally a security risk, so
make sure that you're the only person with the access to this root ca and do not
commit it to any kind of source code repository.

If you already have a certificate like that from a different project, you can
just drop the files to the required locations:

  * key to `shared/ca/private/ca.key.pem`
  * certificate to `shared/ca/certs/ca.cert.pem`

Then, move on to generating certificates reqired by application.

### Setup application certificates

You will be asked for your root CA password multiple times.

  ```bash
  $ cd shared/ca
  $ ./generate_certificates.sh
  ```

When asked, set common name to `localhost` in the CSR:

```bash
Country Name (2 letter code) [EE]:
State or Province Name (full name) [Harjumaa]:
Locality Name (eg, city) [Tallinn]:
Organization Name (eg, company) [Eesti Interneti Sihtasutus]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:localhost
Email Address [hello@internet.ee]:
```

Sign the CSR and commit the certificate:

```
Certificate Details:
        Serial Number: 4096 (0x1000)
        Validity
            Not Before: Jun 14 12:44:30 2018 GMT
            Not After : Jun 14 12:44:30 2019 GMT
        Subject:
            countryName               = EE
            stateOrProvinceName       = Harjumaa
            organizationName          = Eesti Interneti Sihtasutus
            commonName                = localhost
            emailAddress              = hello@internet.ee
        X509v3 extensions:
            X509v3 Basic Constraints:
                CA:FALSE
            X509v3 Key Usage:
                Digital Signature, Non Repudiation, Key Encipherment
            Netscape Comment:
                OpenSSL Generated Certificate
            X509v3 Subject Key Identifier:
                37:8F:5C:6B:42:41:7F:66:0C:50:88:61:AA:AE:F6:51:EF:29:3C:3C
            X509v3 Authority Key Identifier:
                keyid:49:2D:98:38:1F:27:8E:B1:D6:6C:F0:A5:2E:8D:14:15:59:8E:3A:42

Certificate is to be certified until Jun 14 12:44:30 2019 GMT (365 days)
Sign the certificate? [y/n]:
1 out of 1 certificate requests certified, commit? [y/n]y
```

### Configure registry `config/application.yml`

Put the following values in Registry project's `config/application.yml` file:

```yaml
openssl_config_path: '/opt/ca/openssl.cnf'
crl_dir:     '/opt/ca/crl'
crl_path:     '/opt/ca/crl/crl.pem'
ca_cert_path: '/opt/ca/certs/ca.crt.pem'
ca_key_path:  '/opt/ca/private/ca.key.pem'
ca_key_password: # your password


webclient_cert_common_name: 'localhost'
epp_port: '700'
cert_path: '/opt/ca/certs/webclient.crt.pem'
key_path: '/opt/ca/private/webclient.key.pem'
epp_hostname: 'httpd'
repp_url: 'http://repp:3000/repp/v1/'
```

### Configure whois database

Whois database does not work well with environment variables, so you can instead
hard code a working docker setup in `config/database.yml`:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5
  host: db
  username: postgres
  password:
```

### Build docker images

In the project root, run the following commands:

```bash
$ docker-compose build
```

__NB!__ Containers need to be rebuilt every time there is an update to the
gemfile.

### Setup databases

```bash
$ docker-compose run registry rake db:setup:all
$ docker-compose run rest-whois rake db:setup
$ docker-compose run auction rake db:setup
```

__NB!__ On first run, the commands above might fail due to the database
container not being yet ready.

### Connecting to database server

If you need to connect to postgres container, it is exposed to localhost on port
5433, with default username being `postgres` and no password.

```bash
$ psql -p 5433 -U postgres -h localhost
```


## Useful commands

Below you will find a list of useful and frequently used docker commands:

  * `docker exec -it $container_name_number /bin/bash` Opens bash in a running
  container, so you can run `rake test`, `rake db:migrate` or other commands on
  the codebase.
  * `docker image prune` Removes dangling images to save you some SSD space.
  * `docker attach $container_name_number` Attaches to a running container,
  useful if you have pry breakpoint somewhere in your code. To deatach
  without stopping the container, press `CTRL+P, CTRL+Q`.
  * `docker volume rm docker-images_pg` Removes the postgres docker image.
