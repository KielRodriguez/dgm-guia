# Imagen de NGINX
FROM ruby:2.2-slim

#Actualizacion del sistem e instalacion de requerimientos
RUN apt-get update -y
RUN apt-get install -y gcc make nginx curl git-core

#Instalcion nodejs (bower)
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

#Configuración para nginx
COPY default.conf /etc/nginx/conf.d

# Directorio proyecto /dgm-guia
ADD ./ /dgm-guia
WORKDIR /dgm-guia

# Instalción jekyll
RUN gem update --system
RUN gem install bundler
RUN bundle install

# Instalación bower
RUN npm install bower -g
RUN bower install --allow-root

ARG GUIA_ENV=_config.yml

RUN rm /usr/share/nginx/html/*
RUN jekyll build --config $GUIA_CONF --destination /usr/share/nginx/html/guia/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]