# /bin/sh
docker-compose down
docker-compose build
docker-compose run registry rake db:setup:all
docker-compose run registry rake db:migrate
docker-compose run registry rake db:fixtures:load
