===========
QUICK START
===========

1- Montez l'image docker::
    cd jessie && docker build -t performist/odoodev:jessie . 
    docker-compose up -d

2 - Exécuter le script shell::
    chmod u+x run_odoo.sh
    ./run_odoo.sh

3- Sur un navigateur, allez sur le port 8069 pour accéder à Odoo::
    http://localhost:8069
