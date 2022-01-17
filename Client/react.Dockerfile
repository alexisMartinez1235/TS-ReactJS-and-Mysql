ARG node_version

FROM node:$node_version AS debug
# ADD ./TodoApp/ /var/app/ 
VOLUME ./w /var/app/client
# ADD ./Mysql/Installation/client-cert.pem /certs/client-cert.pem 

WORKDIR /var/app/client

ADD ./w/script.sh /var/app/client
RUN [ -f script.sh ] && sh script.sh 

RUN npm install
CMD npm start
# USER node

FROM node:$node_version AS prod
# VOLUME ./w /var/app/client

WORKDIR /var/app/client

ADD ./w/script.sh /var/app/client
RUN [ -f script.sh ] && sh script.sh 

RUN npm install
CMD npm start
