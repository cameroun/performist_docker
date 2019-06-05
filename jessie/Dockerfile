# to build this image:
# docker build -t performist/odoodev:jessie .

FROM debian:jessie
LABEL company="CAMNETWORK"
      maintainer "CAMNETWORK <contact@cam-network.org>"

ENV DEBIAN_FRONTEND noninteractive

USER root

# locale
COPY file/locale.gen /etc/locale.gen
RUN apt-get update && apt-get install -y apt-utils debconf locales \
    && locale-gen \
    && localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
ENV LC_ALL=fr_FR.UTF-8
ENV LANG=fr_FR.UTF-8
# user (root password 'toor', performist user password 'ab'
RUN echo 'root:toor' | chpasswd \
    && mkdir /performist \
    && useradd -m performist \
    && echo 'performist:ab' | chpasswd \
    && apt-get update && apt-get install -y sudo \
    && adduser performist sudo

# user tree: ops: ops tools, project: the project
USER performist
RUN mkdir /home/performist/.pg_dumps \
    && mkdir /home/performist/.ssh \
    && mkdir /home/performist/bin \
    && bash -c "echo create_bashrc" \
    && echo 'export PATH=$PATH:/home/performist/bin' >> /home/performist/.bashrc \
    && mkdir /home/performist/ops \
    && mkdir /home/performist/project
USER root
RUN chown performist:performist /home/performist/.ssh \
    && chown performist:performist /home/performist/.pg_dumps \
    && chown performist:performist /home/performist/bin \
    && chown performist:performist /home/performist/ops \
    && chown performist:performist /home/performist/project

WORKDIR /tmp

# psql client 10
RUN apt-get update && apt-get install -y gnupg wget \
    && wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" >> /etc/apt/sources.list.d/pgdg.list \
    && apt-get update && apt-get install -y postgresql-client

# performist repos
COPY file/performist_packagers.asc /tmp/
RUN apt-key add /tmp/performist_packagers.asc && rm /tmp/performist_packagers.asc
COPY file/performist.list /performist/
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    && cat /performist/performist.list >> /etc/apt/sources.list
RUN apt-get update \
    && apt-get install -y --fix-missing --force-yes anybox-odoo-host \
    && apt-get install -y --force-yes openerp-server-system-build-deps

# wkhtmltox
RUN apt-get update \
    && apt-get install -y fontconfig libfontconfig1 libxrender1 libxext6 xfonts-75dpi \
    #&& apt-get install -y --force-yes wkhtmltox
    && apt-get install -y curl \
    && curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb \
    && echo '40e8b906de658a2221b15e4e8cd82565a47d7ee8 wkhtmltox.deb' | sha1sum -c - \
    && dpkg --force-depends -i wkhtmltox.deb

# nodejs 8 (will not be setup by gp.recipe.node)
RUN wget https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
    && apt-key add /tmp/nodesource.gpg.key \
    && echo "deb https://deb.nodesource.com/node_8.x jessie main" > /etc/apt/sources.list.d/nodesource.list \
    && echo "deb-src https://deb.nodesource.com/node_8.x jessie main" >> /etc/apt/sources.list.d/nodesource.list \
    && apt-get update && apt install -y nodejs \
    && apt-get install node-clean-css \
    && apt-get install node-less

# python 3.5
RUN apt-get update \
    && apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev  libncursesw5-dev xz-utils tk-dev \
    && cd /tmp \
    && wget https://www.python.org/ftp/python/3.5.5/Python-3.5.5.tgz \
    && tar xvf Python-3.5.5.tgz \
    && cd Python-3.5.5 \
    && ./configure --with-ensurepip=install \
    && make \
    && make altinstall \
    && rm -rf /tmp/Python-3.5.5

RUN apt-get install -y \
    nano \
    vim \
    hgview \
    python3-pip \
    python3-venv

RUN apt-get -y autoremove

USER performist
RUN pyvenv /home/performist/env3
EXPOSE 8069
WORKDIR /home/performist/project

CMD [ "/bin/bash" ]
