FROM node:lts-alpine
WORKDIR /client_web
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8081
RUN ln -s /var/client/client.apk public/clientt.apk
CMD ["npm", "run", "serve"]