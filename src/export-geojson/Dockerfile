FROM node:5
MAINTAINER Axel Utech <axel@brasshack.de>

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app/
RUN npm install --production

VOLUME /data/export

CMD ["/usr/src/app/export-geojson.sh"]
