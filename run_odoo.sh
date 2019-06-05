#!/bin/bash
docker-compose up -d

docker-compose exec odoo bash -c "
cd /home/performist/project && 
git clone https://github.com/cameroun/performist.git
"

docker-compose exec odoo bash -c "
dropdb -h pg performist &&
createdb -h pg performist
"

docker-compose exec odoo bash -c "
cd /home/performist/project/performist && 
rm -rf sandbox &&
virtualenv sandbox &&
sandbox/bin/python bootstrap.py -c buildout.cfg
"

docker-compose exec odoo bash -c "
cd /home/performist/project/performist && 
bin/buildout -c buildout.cfg
"
docker-compose exec odoo bash -c "
cd /home/performist/project/performist && 
bin/start_odoo -d performist --db-filter=performist --without-demo=ALL -i performist_hr --db-host=pg 
"
