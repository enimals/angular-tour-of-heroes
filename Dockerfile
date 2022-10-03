FROM node:10 AS build

USER root

WORKDIR /app

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list 

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install python google-chrome-stable -y

COPY . /app

RUN npm install

RUN npm run postinstall

ENV CHROME_BIN='/usr/bin/google-chrome-stable'

RUN npm run e2e

RUN npm run build --prod

FROM nginx:1.23.1

COPY --from=build /app/dist /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]