ARG node_version

FROM node:$node_version as debug
# ADD ./TodoApp/ /var/app/ 
VOLUME ./w /var/app/server
# ADD ./Mysql/Installation/client-cert.pem /certs/client-cert.pem 

WORKDIR /var/app/server

ADD ./w/script.sh /var/app/server
RUN [ -f script.sh ] && sh script.sh 

RUN npm install
CMD npm test
# RUN chown node:node -R /var/app/*

# USER node

FROM node:$node_version as prod
VOLUME ./w /var/app/server

WORKDIR /var/app/server

ADD ./w/script.sh /var/app/server
RUN [ -f script.sh ] && sh script.sh 


RUN npm install
CMD npm start