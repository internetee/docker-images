# Docker configuration for internet.ee projects

This repository provides a semi-automated way of setting up local development
environment for the following projects:

  * [Registry](https://github.com/internetee/registry)
  * [Rest WHOIS](https://github.com/internetee/rest-whois)
  * [WHOIS](https://github.com/internetee/whois)
  * [Auction Center](https://github.com/internetee/auction_center)
  * [EPP Proxy](https://github.com/internetee/epp_proxy)

## Design

The setup includes one nginx server acting as reverse proxy, 1 REST WHOIS
server, 1 registry instance serving EPP requests and 1 registry server serving
all portals interface. Ruby projects are running Puma servers.

Postgres instance persists its data in a dedicated volume, which is NOT deleted
with `docker-compose down`.

All services run on *.test domain, and are available via HTTPS. Use a tool like
[dnsmasq](https://www.stevenrombauts.be/2018/01/use-dnsmasq-instead-of-etc-hosts/) to redirect *.test domains to 127.0.0.1.

The following vhosts work on Chrome, Firefox and Safari:
  * registry.test
  * rest-whois.test
  * auction.test
  * registrar.test

Additionally, whois works on port 43 on localhost, and EPP is exposed on 700 port.

## Pre-requirements

To get started, you need:

  * Docker
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

### Build docker images

In the project root, run the following command:

```bash
$ docker-compose build
```

__NB!__ Containers need to be rebuilt every time there is an update to the
gemfile.

### Fire up docker-compose project

Since multiple configuration files are already using container-based paths, we need to boot up our project beforehand to address these paths.

In the project root, run the following command:

```bash
$ docker-compose up -d
```

This command will start all containers defined in docker-compose configuration file. You will see some errors from docker logs, but don't worry, they're expected.

### Connect to active registry container

Since openssl.cnf is based on paths used in container itself, we need to generate certificates inside container environment.

In the project root, run the following command:

```bash
$ docker ps
```

Mark down any `CONTAINER ID` which is running `registry` image.
```
$ docker ps
CONTAINER ID        IMAGE
2b13fa1fe93c        auction_center
**d4077e3a2e1c** << THIS ONE        registry
b0934102c7a6        auction_center
**48e8e38d2059** << OR THIS ONE       registry
9b6e13696d01        epp_proxy
7efc7918ecf0        internetee/httpd_epp:2.2
54a6e24954d6        postgres:9.4

```

Now, let's connect to registry container via:

```bash
$ docker exec -ti <CONTAINER ID> /bin/bash
```
or
```bash
$ docker-compose run registry bash
```

Great, we're inside container now.

### Setup root CA

You will be asked to supply a password and certain certificate details, such as
common name. Remember the password, as you'll be required to supply it at
various points in time for generation of other certificates. The root CA, and
all the certificates are valid for 1 year only.

Now, while connected to `registry` container, run this:

  ```bash
  $ cd /opt/ca
  $ ./prepare_root_ca.sh
  ```

By docker-compose, our main host `shared/ca` is mirrored to container env's `/opt/ca` path. These directories are shared.

Now, on different terminal tab, on main host, add the newly generated certificates from `shared/ca/ca.crt.pem` certificate to
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

As in previous step, run following commands inside container environment. You will be asked for your root CA password multiple times.

  ```bash
  $ cd /opt/ca
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

We've generated our required certificates now. Feel free to close container connection.

Let's shut down our composed project now via `docker-compose down` for now.

### Configure registry `config/application.yml`

Put the following values in Registry project's `config/application.yml` file:

```yaml
app_name: '.EE Registry'

openssl_config_path: '/opt/ca/openssl.cnf'
crl_dir:     '/opt/ca/crl'
crl_path:     '/opt/ca/crl/crl.pem'
ca_cert_path: '/opt/ca/certs/ca.crt.pem'
ca_key_path:  '/opt/ca/private/ca.key.pem'
ca_key_password: # your password

webclient_ips: '127.0.0.1'
webclient_cert_common_name: 'localhost'
epp_port: '700'
cert_path: '/opt/ca/certs/webclient.crt.pem'
key_path: '/opt/ca/private/webclient.key.pem'
epp_hostname: 'epp_proxy'
repp_url: 'http://epp:3000/repp/v1/'

action_mailer_default_host: 'registry.test'
action_mailer_default_from: 'no-reply@example.com'

secret_key_base: 'please-change-it-you-can-generate-it-with-rake-secret'
devise_secret: 'please-change-it-you-can-generate-it-with-rake-secret'
time_zone: 'Tallinn'
```

Rename config/environments/development.rb.sample to development.rb

change this line from false to true

```rb
config.action_mailer.raise_delivery_errors = true
```

and comment this line

```rb
config.file_watcher = ActiveSupport::EventedFileUpdateChecker
```


### Configure REST-Whois
Rename application-example.yml to application.yml

In application.yml added
```yaml
recaptcha_site_key: 6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI
recaptcha_secret_key: 6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe
```

Rename database-example.yml to database.yml

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

### Configure Auction Center
Rename customization.yml.sample to customization.yml

Rename database.yml.sample to database.yml

### Configure epp-proxy sys.config

```yaml
%% Path to root CA that should check the client certificates.
{cacertfile_path, "/opt/ca/certs/ca.crt.pem"},

```
### /etc/hosts

Added to /etc/hosts

```127.0.0.1       auction.test
127.0.0.1       rest-whois.test
127.0.0.1       whois.test
127.0.0.1       registry.test
127.0.0.1       epp.test
127.0.0.1       registrar.test
127.0.0.1       registrant.test
```

### Build docker images again

In the project root, run the following commands:

```bash
$ docker-compose build
```

### Setup databases

Assuming you're going to set up registry as development, rename `config/database_development.yml.sample` to `config/database.yml`

Modify `default` block to look like as follow:

```
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("APP_DB_MAX_THREADS") { 5 } %>
  host: <%= ENV.fetch("APP_DBHOST") { "localhost" } %>
  username: <%= ENV.fetch("APP_DBUSER") { "postgres" } %>
  password:

```
Done? Great. Let's initialize our databases.

```bash
$ docker-compose run registry bundle exec rake db:setup:all
$ docker-compose run rest-whois bundle exec rake db:setup
$ docker-compose run auction_center bundle exec rake db:setup
```

If an error with repp_logs and epp_logs occurs when running tests in the registry, try running the following command:
```
docker-compose run registry bundle exec rake db:schema:load:all
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
