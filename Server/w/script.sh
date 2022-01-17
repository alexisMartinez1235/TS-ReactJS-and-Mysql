#!/bin/bash
if [ ! -d "src" ]; then
    npm install cra-template-pwa-typescript
    npm init
    npx create-react-app . --template pwa-typescript
    npm install nodemon
fi

