# Change the `lasertime_mysql` to whatever your container gets called

docker-compose up --no-start
docker start lasertime_mysql
docker exec -i lasertime_mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"' < mysql_init/*
