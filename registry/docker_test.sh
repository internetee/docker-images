# /bin/sh
docker-compose down
docker-compose build

# Setup test database
docker-compose run registry rake db:setup:all test
# Finally run tests to check if everything is in order
docker-compose run registry rspec
