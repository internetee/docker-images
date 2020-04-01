## Docker configuration for rest-whois MVP
This tutorial covers an absolute minimal setup to get rest-whois project up and running in local environment, without actual registry integration.

## Prerequisites
- Docker (https://www.docker.com/products/docker-desktop)
- Docker compose (https://docs.docker.com/compose/install/)
- Git

## Setup
When dependencies are met, proceed to clone `rest-whois` and `docker-images` git repos to the same path.
```
$ cd Documents/development/
$ git clone --single-branch --branch rest-whois-showcase https://github.com/internetee/docker-images.git
$ git clone --single-branch --branch master https://github.com/internetee/rest-whois.git
```

In `rest-whois` project, create new file `config/database.yml`
```
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("APP_DB_MAX_THREADS") { 5 } %>
  host: <%= ENV.fetch("APP_DBHOST") { "localhost" } %>
  username: <%= ENV.fetch("APP_DBUSER") { "postgres" } %>
  password:

development:
  <<: *default
  database: postgres
```

Again, in `rest-whois` project, rename `config/application-sample.yml` to `config/application.yml` and include test reCaptcha keys
```
recaptcha_site_key: 6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI
recaptcha_secret_key: 6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe
```

Also, delete `db/migrate` folder.

Now go to `docker-images` folder via terminal and launch

```
docker-compose up -d
```

Containers should boot. When done, do 
```
docker ps
```

...and find the name for database container. For me it was `whois_db_1` .

Now, when still in terminal, in docker-images folder, let's write a dump to our database. In command line:

```
cat whois_sample | docker exec -i <CONTAINER NAME> psql -Upostgres
```

This should seed your docker database with some little amount of data.

From now on, you should be able to reach `rest-whois` service from `http://localhost:3000` 

Rest-whois files can be found from rest-whois folder, obviously. They are linked automatically to container as well.