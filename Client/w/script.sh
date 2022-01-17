#!/bin/bash

if [ ! -d "src" ]; then
    npm install create-react-app
    npm install cra-template-pwa-typescript
    npx create-react-app . --template pwa-typescript
    npm install nodemon
fi

